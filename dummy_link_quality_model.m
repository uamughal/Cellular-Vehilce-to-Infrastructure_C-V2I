        % Dummy functions
function obj = dummy_link_quality_model(N_RB)
            
            obj.SNR_avg_preequal      = NaN;
            obj.wideband_SINR         = NaN;
            obj.feedback.CQI          = zeros(1,N_RB);
            obj.feedback.PMI          = ones(1,N_RB);
            obj.feedback.RI           = 1;
            obj.feedback.tx_mode      = 4;
            obj.feedback.UE_scheduled = false;
            obj.feedback.nCodewords   = 1;
            obj.feedback.TB_size      = 0;
            obj.feedback.BLER         = 0;
            obj.feedback.ACK          = false;
end