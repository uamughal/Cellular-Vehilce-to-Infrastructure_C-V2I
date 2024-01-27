function obj = calculate_feedback(tx_mode,SINR_linear,SINR_dB,nRB,PMI_suggestion,DL_signaling,CQI_mapper)
            % Take a subset of the SINRs for feedback calculation
            % For SM we send 2 CQIs, one for each of the codewords (which in the 2x2
            % case are also the layers). For TxD, both layers have the same SINR
            % The CQI is calculated as a linear averaging of the SINRs in
            % dB. This is done because like this the Tx has an "overall
            % idea" of the state of the RB, not just a sample of it.
            switch tx_mode
                case 1 % SISO
                    SINRs_to_map_to_CQI = (SINR_dB(1:2:end)+SINR_dB(2:2:end))/2;
                    obj.link_quality_model_output.SINR_dB     = SINR_dB;
                    obj.link_quality_model_output.SINR_linear = SINR_linear;
                case 2 % TxD
                    % Both layers have the same SINR
                    SINRs_to_map_to_CQI = (SINR_dB(1,1:2:end)+SINR_dB(1,2:2:end))/2;
                    obj.link_quality_model_output.SINR_dB     = SINR_dB(1,:);
                    obj.link_quality_model_output.SINR_linear = SINR_linear(1,:);
                case {3,4} % OLSM, CLSM
                    SINRs_to_map_to_CQI = (SINR_dB(:,1:2:end,:)+SINR_dB(:,2:2:end,:))/2;
                    obj.link_quality_model_output.SINR_dB     = SINR_dB;
                    obj.link_quality_model_output.SINR_linear = SINR_linear;
                otherwise
                    error('TX mode not yet supported');
            end
            
            max_rank   = size(SINRs_to_map_to_CQI,3);
            obj.feedback.RI  = 1;
            SINRs_to_CQI_CWs = SINRs_to_map_to_CQI;  
            obj.feedback.PMI = nan(nRB,1);
            % Send as feedback the CQI for each RB.
            % Flooring the CQI provides much better results than
            % rounding it, as by rounding it to a higher CQI you will
            % very easily jump the BLER to 1. The other way around it
            % will jump to 0.
            CQIs_temp = SINR_to_CQI(SINRs_to_CQI_CWs,CQI_mapper);
            CQIs = floor(CQIs_temp);
            obj.feedback.CQI = CQIs;
            obj.feedback.tx_mode = tx_mode;
            obj.feedback.DL_signaling = DL_signaling;
        end