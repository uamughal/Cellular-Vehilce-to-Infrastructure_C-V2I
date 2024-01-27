function I_MCSs = SINR_to_I(SINR_dB,MCSs,SINR_averager)
           SINR_dims             = size(SINR_dB);
           SINR_dims_numel       = length(SINR_dims);
           SINR_dB_vect          = reshape(SINR_dB(:),1,[]);
           SINR_dB_vect_idxs     = isfinite(SINR_dB_vect);
           SINR_dB_vect_filtered = SINR_dB_vect(SINR_dB_vect_idxs);
           I_MCSs                = zeros([SINR_dims length(MCSs)]);
           
           % Data needed beforehand
           SNR_length      = length(SINR_averager.BICM_matrix_x);
           multipliers     = SINR_averager.multipliers(MCSs);
           multipliers_mat = multipliers(:,ones(length(SINR_dB_vect_filtered),1));
           
           % Convert to BICM capacity
           MC_betas_vect_dB    = SINR_averager.betas_dB(MCSs);
           SINR_vector_mat_dB  = SINR_dB_vect_filtered(ones(length(MCSs),1),:);
           MCS_betas_dB        = MC_betas_vect_dB(:,ones(length(SINR_dB_vect_filtered),1));
           SINR_vector_mat_log = SINR_vector_mat_dB - MCS_betas_dB;
           
           SNR_idxs_mat        = round((SINR_vector_mat_log-SINR_averager.SINR_range(1))/SINR_averager.resolution + 1);
           SNR_idxs_mat(SNR_idxs_mat<1) = 1;
           SNR_idxs_mat(SNR_idxs_mat>SNR_length) = SNR_length;
           
           % BICM capacity table lookup
           Is_mat  = SINR_averager.BICM_matrix_y(SNR_idxs_mat+multipliers_mat);
           
           I_out_vect = NaN(size(Is_mat,1),length(SINR_dB_vect));
           I_out_vect(:,SINR_dB_vect_idxs) = Is_mat;
           
           % Fill in the output
           for MCS_idx = 1:length(MCSs)
               current_MCS_Is = reshape(I_out_vect(MCS_idx,:),SINR_dims);
               switch SINR_dims_numel
                   case 2
                       I_MCSs(:,:,MCS_idx) = current_MCS_Is;
                   case 3
                       I_MCSs(:,:,:,MCS_idx) = current_MCS_Is;
                   otherwise
                       error('I still didnt manage to learn how to handle arbitrary dimension numbers... sorry!');
               end
           end
       end