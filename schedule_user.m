function [Bs,TB_size_bits,num_assigned_RB,assigned_RB] = schedule_user(Bs,RBGrid,TTI_counter,scheduler,TTI_MAX,UE__total)
           RBGrid.size_bits = 0;
           tx_mode = 1;
           current_TTI = TTI_counter;
           N_UE = length(UE__total);
           N_RB = RBGrid.n_RB;
           UE_id_list = zeros(N_RB,1);
           feedback_delay_TTIs = 1;
           maxStreams = 2;
           avg_throughput = zeros(maxStreams,TTI_MAX);
  if ~isempty(Bs.UEs)
      for u_ = 1:N_UE
          
          % Give a percentage to the broadcast UEs, not all the UEs
                  % send CAM traffic simutaneously
                %  if attached_UEs(u_).id==2 || attached_UEs(u_).id==12 || attached_UEs(u_).id==22 || attached_UEs(u_).id==34 || attached_UEs(u_).id==52 || attached_UEs(u_).id==67 || attached_UEs(u_).id==77
                 %     attached_UEs(u_).traffic_model.check_TTI;
                %  else
%                 
                    broadcast_UEs_percentage= 0.4;

                    coin_toss = rand;
                     if coin_toss < broadcast_UEs_percentage
                        state = true;
                     else
                        state = false;
                     end                 
                     if state == true          
                        Bs.UEs(u_) = check_TTI(Bs.UEs(u_),current_TTI);
                     end
      end
      %% compute efficiency 
      [c,user_ind,N_UE] = get_efficiency(N_RB,Bs.last_received_feedback,scheduler.k,scheduler.d);          
      c = c';   
      
     %% update average throughput
      TTI_to_read = max(current_TTI-feedback_delay_TTIs-1,1); % Realistically read the ACKed throughput
      for uu = 1:N_UE
        av_throughput(uu) = compute_av_throughput(Bs.UEs(uu),TTI_to_read,avg_throughput);
      end 
               
     %% Proportional fair traffic scheduler
      RBs = Propfair_Traffic_scheduler(N_UE,N_RB,c,user_ind,Bs.UEs,current_TTI,scheduler,av_throughput);
      
      for r_ = 1:N_RB
        RB_tmp = RBs((r_-1)*N_UE+1:r_*N_UE);
        ind = find(RB_tmp == 1);
        if ~isempty(ind)
            UE_id_list(r_) = Bs.UEs(user_ind(ind)).UE_ID;
        end
        RBGrid.user_allocation(:) = UE_id_list;
        [Bs.UEs, the_RB_grid,TB_size_bits,num_assigned_RB,assigned_RB] = schedule_users_common(Bs.UEs,Bs.last_received_feedback,current_TTI,tx_mode,RBGrid,scheduler);
      end  
  end
end