function [N_assigned_RBs CQIs_to_average_all UE_scheduled new_UE_RB_map] = filter_out_zero_RBs_and_get_CQIs(RB_grid,nCodewords,UE_CQI_feedback,current_UE)  
% Do not use RBs with a CQI of 0 (they are lost)
           skip_null_CQIs = true; 
           UE_RBs = RB_grid.user_allocation==current_UE.UE_ID;
            if skip_null_CQIs
                if nCodewords == 1
                    if (size(UE_CQI_feedback,1)==1) % SISO case, to ensure correct dimensions
                        UE_CQI_feedback = reshape(UE_CQI_feedback,[],1);
                    end
                    zero_CQIs     = (UE_CQI_feedback(:,1)<1);
                    non_valid_RBs = UE_RBs & zero_CQIs;  % RBs to filter out
                    valid_RBs     = UE_RBs & ~zero_CQIs; % CQIs that will be averaged
                    RB_grid.user_allocation(non_valid_RBs) = 0;
                    CQIs_to_average_all = UE_CQI_feedback(valid_RBs);
                else
                    % For the case where more than 1 codewords are sent, all CWs must have a CQI >0
                    zero_CQIs     = sum(UE_CQI_feedback<1,2)>=1;
                    non_valid_RBs = UE_RBs & zero_CQIs; % RBs to filter out
                    valid_RBs     = UE_RBs & ~zero_CQIs; % CQIs that will be averaged
                    RB_grid.user_allocation(non_valid_RBs) = 0;
                    CQIs_to_average_all = UE_CQI_feedback(valid_RBs,:);
                end
                new_UE_RB_map  = valid_RBs;
                N_assigned_RBs = sum(valid_RBs);
            else
                if nCodewords == 1
                    CQIs_to_average_all = UE_CQI_feedback(UE_RBs);
                else
                    CQIs_to_average_all = UE_CQI_feedback(UE_RBs,:);
                end
                new_UE_RB_map  = UE_RBs;
                N_assigned_RBs = sum(UE_RBs);
            end
            
            if isempty(CQIs_to_average_all)
                UE_scheduled   = false;
            else
                UE_scheduled = true;
            end
end