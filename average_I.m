       function effective_SINR_dB_output = average_I(Is,dim,MCSs,SINR_averager)
           Is_mean          = mean(Is,dim);
           Is_mean_dims     = size(Is_mean);
           if Is_mean_dims(end)~=length(MCSs)
               error('dimensions do not match! length(MCSs) has to be equal to the size of the last dimension');
           end
           Is_mean_vect     = Is_mean(:);
           multipliers      = kron(SINR_averager.multipliers(MCSs),ones(prod(Is_mean_dims(1:(end-1))),1));
           MC_betas_vect_dB = kron(SINR_averager.betas_dB(MCSs)   ,ones(prod(Is_mean_dims(1:(end-1))),1));
           
           % Inverse mapping
           Is_idxs = round((Is_mean_vect-SINR_averager.BICM_range(1))/SINR_averager.resolution_inv + 1);
           Is_idxs(Is_idxs<1) = 1; % Safeguard agains negative indices
           obj_length = SINR_averager.length;
           Is_idxs(Is_idxs>obj_length) = obj_length;
           effective_SINR_dB = SINR_averager.BICM_matrix_inv_y(Is_idxs+multipliers)+MC_betas_vect_dB; % Version with scaling
           
           effective_SINR_dB_output = reshape(effective_SINR_dB,Is_mean_dims);
       end