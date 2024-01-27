  function [assigned_CQI predicted_BLER predicted_SINR_dB predicted_Is predicted_Is_min] = get_optimum_CQIs_X(CQIs_to_average_all,CQI_mapper,SINR_averager,scheduler)
            % Preallocation
            nCodewords        = size(CQIs_to_average_all,2);
            assigned_CQI      = zeros(nCodewords,1);
            predicted_BLER    = zeros(nCodewords,1);
            predicted_SINR_dB = zeros(nCodewords,1);
            target_BLER = 0.0001;
            UE_estimated_SINR_dB_all = CQI_to_SINR(CQI_mapper,CQIs_to_average_all);
            UE_estimated_MI_all      = SINR_to_I(UE_estimated_SINR_dB_all,scheduler.CQI_range,SINR_averager);
            sum_UE_estimated_MI_all  = sum(UE_estimated_MI_all,2);
            
            % Don't use the SINR value on the lower bound of a CQI interval
            % but something inbetween (otherwise this is too conservative)
            % - as in the Link Level Simulator (heuristically optimized)
            % SINR_temp1 = obj.CQI_mapper.CQI_to_SINR(CQIs_to_average);
            % SINR_temp2 = obj.CQI_mapper.CQI_to_SINR(CQIs_to_average+1);
             
            % UE_estimated_SINR_dB = SINR_temp1+(SINR_temp2-SINR_temp1)/2.5;
            % UE_estimated_SINR_linear = 10.^(0.1*UE_estimated_SINR_dB);
            effective_SINR_dB_output = average_I(UE_estimated_MI_all,1,scheduler.CQI_range,SINR_averager);
            SINR_MCS_dependent_dB = reshape(effective_SINR_dB_output,[nCodewords length(scheduler.CQI_range)])';
            
            for cw_=1:nCodewords
                predicted_BLERs = get_BLER_CQI(scheduler.CQI_range,SINR_MCS_dependent_dB(:,cw_),scheduler.BLER_curves);
                
                % Objective is the closest smaller or equal to 10% BLER (BLER 0 is preferred to BLER 1)
                if predicted_BLERs(end) == 0
                    % Case of a very good channel
                    cw_assigned_CQI = 15;
                elseif predicted_BLERs(1) >= target_BLER
                    % Case of a bad channel
                    cw_assigned_CQI = 1;
                else
                    % Case in the middle
                    abs_diffs = predicted_BLERs-target_BLER;
                    abs_diffs = round(abs_diffs*1000)/1000; % To avoid small statistical mistakes in the BLER plots. No change assuming that the target BLER is in the order of 10%
                    cw_assigned_CQI = find(abs_diffs<=0,1,'last');
                end
                assigned_CQI(cw_)      = cw_assigned_CQI;
                predicted_BLER(cw_)    = predicted_BLERs(cw_assigned_CQI);
                predicted_SINR_dB(cw_) = SINR_MCS_dependent_dB(cw_assigned_CQI,cw_);     % effective logarithmic SINR
            end
            predicted_Is     = mean(sum_UE_estimated_MI_all(:,1,cw_assigned_CQI));
            predicted_Is_min = min(sum_UE_estimated_MI_all(:,1,cw_assigned_CQI));
        end