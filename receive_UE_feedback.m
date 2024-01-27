function last_received_feedback = receive_UE_feedback(attached_UEs,RB_grid,UE_all,TTI_counter)
            max_streams  = 2;
            last_received_feedback.UE_id             = zeros(attached_UEs,1);
            last_received_feedback.tx_mode           = zeros(attached_UEs,1); % From what mode the CQI and RI was taken
            last_received_feedback.nCodewords        = zeros(attached_UEs,1); % Relates to the ACK/NACK report. For the 0-delay case, this and tx_mode could differ (ACK is always delayed)
            last_received_feedback.CQI               = zeros(RB_grid.n_RB,max_streams,attached_UEs);
            last_received_feedback.RI                = zeros(attached_UEs,1);
            last_received_feedback.PMI               = nan(RB_grid.n_RB,attached_UEs);
            last_received_feedback.feedback_received = false(attached_UEs,1);
            UE_feedback_idx = 1;

            for i_=1:attached_UEs
                
                % Receive the feedback from each user
                UE_id       = UE_all(i_).UE_ID;
                feedback_u_ = get_feedback(UE_all(i_).uplink_channel,TTI_counter);
                % The first TTI, even with 0 delay there is no feedback, as no ACKs are available
                if ~isempty(feedback_u_)
                    
                    % Store the last received feedback for all of the attached
                    % users, as it will be needed by the scheduler.
                    % More refined schedulers may need longer "historical" information
                    last_received_feedback.feedback_received(UE_feedback_idx)               = true;
                    last_received_feedback.UE_id(UE_feedback_idx)                           = UE_id;
                    last_received_feedback.tx_mode(UE_feedback_idx)                         = feedback_u_.tx_mode;
                    last_received_feedback.nCodewords(UE_feedback_idx)                      = feedback_u_.nCodewords;
                    last_received_feedback.CQI(:,1:size(feedback_u_.CQI,1),UE_feedback_idx) = feedback_u_.CQI';
                else
                    last_received_feedback.feedback_received(UE_feedback_idx) = false;
                end
                UE_feedback_idx = UE_feedback_idx + 1;
            end            
        end