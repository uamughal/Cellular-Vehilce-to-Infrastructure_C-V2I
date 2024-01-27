function [attached_UEs, the_RB_grid,TB_size_bit,num_assigned_RB,assigned_RB] = schedule_users_common(attached_UEs,UE_feedback,current_TTI,tx_mode,RBGrid,scheduler)
            % NOTE: since for the zero-delay case, RI and nLayers of the
            % transmission may not match, nCodewords is not used here
            
            % Common tasks for all schedulers
            the_RB_grid            = RBGrid;
            RB_grid_size_bits  = 0;
            max_codewords      = 1;
            predicted_UE_BLERs = NaN(max_codewords,length(attached_UEs));
            nRBs               = the_RB_grid.n_RB;
            nCodewords = 1;
            % Homogeneous power allocation
            if ~isempty(length(attached_UEs))
                the_RB_grid.power_allocation(:) = scheduler.max_power / the_RB_grid.n_RB;
            end
            
            % Continue UE common scheduling procedures
            for u_=1:length(attached_UEs)
                current_UE = attached_UEs(u_);
                
                % If the feedback is present: process normally
                total_RB_power = the_RB_grid.power_allocation + the_RB_grid.power_allocation_signaling;
                if UE_feedback.feedback_received(u_)
                    
                    tx_mode = 1;
                    
                    UE_CQI_feedback = UE_feedback.CQI(:,1:nCodewords,u_);
                    
                    % Do not use RBs with a CQI of 0 (they are lost).
                    % This function also averages the CQIs and assigns an overall TB CQI with predicted BLER < 10%
                    [num_assigned_RB, CQIs_to_average_all, UE_scheduled, RB_map] = filter_out_zero_RBs_and_get_CQIs(the_RB_grid,nCodewords,UE_CQI_feedback,current_UE);
                    
                    if UE_scheduled
                        % Simplified this piece of code by using the superclass, as all types of scheduler will to make use of it.
                        [assigned_CQI, predicted_UE_BLERs(1:nCodewords,u_), estimated_TB_SINR, Is, I_min] = get_optimum_CQIs_X(CQIs_to_average_all,scheduler.CQI_mapper,scheduler.SINR_averager,scheduler);
                        % Signal down the user CQI assignment
                        attached_UEs(u_).eNodeB_signaling.assigned_RB_map = RB_map;

                        attached_UEs(u_).eNodeB_signaling.assigned_power               = sum(total_RB_power(RB_map));
                        attached_UEs(u_).eNodeB_signaling.tx_mode                      = tx_mode;
                        attached_UEs(u_).eNodeB_signaling.TB_CQI                       = assigned_CQI;
                        attached_UEs(u_).eNodeB_signaling.nCodewords                   = nCodewords;
                        attached_UEs(u_).eNodeB_signaling.genie_TB_SINR                = estimated_TB_SINR;
                        attached_UEs(u_).eNodeB_signaling.adaptive_RI.avg_MI           = Is;
                        attached_UEs(u_).eNodeB_signaling.adaptive_RI.min_MI           = I_min;
                        attached_UEs(u_).eNodeB_signaling.adaptive_RI.RBs_for_feedback = true(1,nRBs);
                    else
                        attached_UEs(u_).eNodeB_signaling.assigned_RB_map              = [];
                        attached_UEs(u_).eNodeB_signaling.assigned_power               = 0;
                        attached_UEs(u_).eNodeB_signaling.tx_mode                      = 0;
                        attached_UEs(u_).eNodeB_signaling.TB_CQI                       = 0;
                        attached_UEs(u_).eNodeB_signaling.nCodewords                   = 0;
                        attached_UEs(u_).eNodeB_signaling.nLayers                      = 0;
                        attached_UEs(u_).eNodeB_signaling.genie_TB_SINR                = NaN;
                        attached_UEs(u_).eNodeB_signaling.adaptive_RI.avg_MI           = [];
                        attached_UEs(u_).eNodeB_signaling.adaptive_RI.std_MI           = [];
                        attached_UEs(u_).eNodeB_signaling.adaptive_RI.RBs_for_feedback = true(1,nRBs);
                    end
                    
                else
                    % If the feedback is not present: assign a default CQI value of 1 with rank one.
                    UE_scheduled    = true;
                    RB_map          = the_RB_grid.user_allocation==current_UE.UE_ID;
                    num_assigned_RB = sum(RB_map);
                    nCodewords      = 1;
                    nLayers         = 1;
                    the_RB_grid.PMI(RB_map) = NaN; % Reset the PMI values (just in case)
                    % Signal down the user CQI assignment
                    attached_UEs(u_).eNodeB_signaling.assigned_RB_map = RB_map;

                    attached_UEs(u_).eNodeB_signaling.assigned_power               = sum(total_RB_power(RB_map));
                    attached_UEs(u_).eNodeB_signaling.tx_mode                      = tx_mode;
                    attached_UEs(u_).eNodeB_signaling.TB_CQI(1:nCodewords)         = 5;
                    attached_UEs(u_).eNodeB_signaling.nCodewords                   = nCodewords;
                    attached_UEs(u_).eNodeB_signaling.genie_TB_SINR                = NaN;
                    attached_UEs(u_).eNodeB_signaling.adaptive_RI.avg_MI           = [];
                    attached_UEs(u_).eNodeB_signaling.adaptive_RI.std_MI           = [];
                    attached_UEs(u_).eNodeB_signaling.adaptive_RI.RBs_for_feedback = true(1,nRBs);
                    predicted_UE_BLERs(u_) = 0; % Dummy value to avoid a NaN
                end
                
                % Calculate TB size
                if UE_scheduled
                    TB_CQI_params    = scheduler.CQI_tables(attached_UEs(u_).eNodeB_signaling.TB_CQI);
                    modulation_order = [TB_CQI_params.modulation_order];
                    coding_rate      = [TB_CQI_params.coding_rate_x_1024]/1024;
                    
                    if mod(current_TTI-1,5) % TB without sync symbols. Solution (for now) for FFR
                        % The factor of two is because there are two time slots per subframe, 24 CRC bits are attached
                        % Segmentation prior to channel coding NOT taken into account.
                        TB_size_bits = max(8*round(1/8*(the_RB_grid.sym_per_RB_nosync .* num_assigned_RB .* modulation_order .* coding_rate*2))-24,0);
                    else % TB with sync symbols
                        sync_pos = false(size(the_RB_grid.user_allocation));
                        sync_pos(floor(length(sync_pos)/2)-2:floor(length(sync_pos)/2)+3) = true;
                        sync_RBs = sum((the_RB_grid.user_allocation==attached_UEs(u_).UE_ID) .* sync_pos);
                        non_sync_RBs = sum(the_RB_grid.user_allocation==attached_UEs(u_).UE_ID)-sync_RBs;
                        TB_size_bits = max(8*round(1/8*(the_RB_grid.sym_per_RB_sync .* sync_RBs + the_RB_grid.sym_per_RB_nosync * non_sync_RBs) .* modulation_order .* coding_rate*2)-24,0);
                    end
                    
                else
                    num_assigned_RB = 0;
                    TB_size_bits = 0;
                end
                TB_size_bit(u_) = TB_size_bits;
                % Update accumulated RB size (bits)
                RB_grid_size_bits = RB_grid_size_bits + TB_size_bits;

                % Fill the UE-specific signaling
                attached_UEs(u_).eNodeB_signaling.num_assigned_RBs = num_assigned_RB;
                attached_UEs(u_).eNodeB_signaling.TB_size          = TB_size_bits;
                attached_UEs(u_).eNodeB_signaling.rv_idx           = 0;
                assigned_RB(current_TTI,u_) = num_assigned_RB;
                % attached_UEs(u_).eNodeB_signaling.
                
                % Traffic model-related code (packet parts)
                for cw_ = 1:length(TB_size_bits)
                    if TB_size_bits(cw_) ~= 0
                        if (~attached_UEs(u_).traffic_model.is_fullbuffer) && (strcmp(attached_UEs(u_).traffic_model.type,'voip') || strcmp(attached_UEs(u_).traffic_model.type,'video') || strcmp(attached_UEs(u_).traffic_model.type,'gaming') || strcmp(attached_UEs(u_).traffic_model.type,'MLaner'))
 
                            if strcmp(attached_UEs(u_).traffic_model.type,'CAM')
                               [packe_obj,packet_parts, bit_count] = decrease_packets_CAM(attached_UEs(u_).traffic_model,TB_size_bits(cw_));
                               attached_UEs(u_).traffic_model.bit_count = bit_count;
                            end
                            if ~isempty(packet_parts)
                                attached_UEs(u_).eNodeB_signaling.N_used_bits(cw_) = sum(packet_parts.part_size);
                            else
                                attached_UEs(u_).eNodeB_signaling.N_used_bits(cw_) = 0;
                            end
                            attached_UEs(u_).eNodeB_signaling.packet_parts{cw_} = packet_parts;
                        else
                            [packe_obj,packet_parts, bit_count] = decrease_packets_CAM(attached_UEs(u_).traffic_model,TB_size_bits(cw_));
                            attached_UEs(u_).traffic_model.bit_count = bit_count;
                        end
                      else
                        attached_UEs(u_).eNodeB_signaling.N_used_bits(cw_) =  0;
                        attached_UEs(u_).eNodeB_signaling.packet_parts{cw_} = [];
                    end
                end
            end
            
            % Total size in bits of the RB grid
            the_RB_grid.size_bits = RB_grid_size_bits;
            
            % TODO: HARQ handling, #streams decision and tx_mode decision.
        end