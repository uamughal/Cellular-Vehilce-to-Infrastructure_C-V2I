 function obj = miesmAveragerFast(varargin)
           % Create the inverse I curve (the same as with the previous implementation)
           load('BICM_capacity_tables_20000_realizations.mat');
           betas = [3.07000000000000	4.41000000000000	0.600000000000000	1.16000000000000	1.06000000000000	1.06000000000000	0.870000000000000	1.01000000000000	1.04000000000000	1.03000000000000	1.11000000000000	1.01000000000000	1.07000000000000	1	1.05000000000000];
           resolution = 0.01;
           % Upsample the BICM curves
           SNR_vector = BICM_capacity_tables(1).SNR(1):resolution:BICM_capacity_tables(1).SNR(end);
           
           CQI_range  = LTE_common_get_CQI_params('range');
           for i_ = CQI_range(1):CQI_range(2)
           CQI_tables(i_) = LTE_common_get_CQI_params(i_);
           end
           n_CQIs     = length(CQI_tables);
           mod_orders = [CQI_tables.modulation_order];
           
           for i_=1:length(BICM_capacity_tables)
               % Overwrite loaded values with upsampled ones
               BICM_capacity_tables(i_).I   = interp1(BICM_capacity_tables(i_).SNR,BICM_capacity_tables(i_).I,SNR_vector);
               BICM_capacity_tables(i_).SNR = SNR_vector;
               
               % Generate the inverse mapping
               BICM_capacity_tables(i_).I(1) = 0;
               BICM_capacity_tables(i_).I(end) = ceil(BICM_capacity_tables(i_).I(end));
               [b,m,n]=unique(BICM_capacity_tables(i_).I,'first');
               
               % To have only unique values
               BICM_capacity_tables(i_).I_inv = b;
               BICM_capacity_tables(i_).SNR_inv = BICM_capacity_tables(i_).SNR(m);
           end
           
           % Assume that the SNR is the same one for all data. It should be
           % automaticallythe case if the BICM capacity script of this
           % simulator was used.
           min_C = 0;
           max_C = max([BICM_capacity_tables.I]);
           BICM_matrix_x     = SNR_vector;
           BICM_matrix_y     = zeros(length(BICM_matrix_x),n_CQIs);
           BICM_matrix_inv_x = linspace(min_C,max_C,length(BICM_matrix_x));
           BICM_matrix_inv_y = zeros(length(BICM_matrix_inv_x),n_CQIs);

           obj.nCQIs = length(CQI_range(1):CQI_range(2));
           if length(betas)~=obj.nCQIs
               error('length of beta calibration parameters must be %d',obj.nCQIs);
           end
           
           betas        = betas(:);        % Store in column format
           obj.betas    = betas;
           obj.betas_dB = 10*log10(betas); % Precalculate also the value in dB
           
           for cqi_ = CQI_range(1):CQI_range(2)
               m_j          = CQI_tables(cqi_).modulation_order;
               struct_index = find([BICM_capacity_tables.m_j]==m_j,1,'first');
               BICM_matrix_y(:,cqi_)     = BICM_capacity_tables(struct_index).I;
               BICM_matrix_inv_y(:,cqi_) = interp1(BICM_capacity_tables(struct_index).I_inv,BICM_capacity_tables(struct_index).SNR_inv,BICM_matrix_inv_x);
               
               % Small fix not to have a NaN at the maximum capacity point
               max_capacity = max(BICM_capacity_tables(struct_index).I);
               [C,I] = min(abs(BICM_matrix_inv_x-max_capacity));
               BICM_matrix_inv_y(I,cqi_) = interp1(BICM_matrix_inv_x(1:(I-1)),BICM_matrix_inv_y(1:(I-1),cqi_),BICM_matrix_inv_x(I),'linear','extrap');
           end
           
           obj.length            = length(BICM_matrix_x);
           obj.BICM_matrix_x     = BICM_matrix_x;
           obj.BICM_matrix_y     = BICM_matrix_y;
           obj.BICM_matrix_inv_x = BICM_matrix_inv_x;
           obj.BICM_matrix_inv_y = BICM_matrix_inv_y;
           obj.multipliers       = reshape(0:length(BICM_matrix_x):length(BICM_matrix_x)*(n_CQIs-1),[],1);
           
           % Assume equally-spaced SNRs
           obj.resolution     = (BICM_matrix_x(2)-BICM_matrix_x(1));
           obj.resolution_inv = (BICM_matrix_inv_x(2)-BICM_matrix_inv_x(1));
           
           obj.SINR_range = [min(BICM_matrix_x) max(BICM_matrix_x)];
           obj.BICM_range = [min(BICM_matrix_inv_x) max(BICM_matrix_inv_x)];
           
           % Some (optional) plotting
           if isempty(varargin)
               plot_capacity = false;
           else
               plot_capacity = varargin{1};
           end
           if plot_capacity
               for m_j_idx=1:length(BICM_capacity_tables)
                   BICM_capacity_tables_all(m_j_idx,:) = BICM_capacity_tables(m_j_idx).I;
                   displaynames{m_j_idx} = sprintf('BICM capacity, %d-QAM',2^BICM_capacity_tables(m_j_idx).m_j);
               end
               figure;
               % Assume that all BICM capacities are calcualted over the same
               % SNR range (so I can plot it like this and Matlab automatically
               % puts the colors there)
               plot(BICM_capacity_tables(m_j_idx).SNR,BICM_capacity_tables_all);
               legend(displaynames,'Location','Best');
               xlabel('SNR [dB]');
               ylabel('BICM Capacity I_{m_j}(\gamma)');
               title('BICM capacity');
               grid on;
           end
       end