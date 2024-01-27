 function RBs = Propfair_Traffic_scheduler(N_UE,N_RB,c,user_ind,attached_UEs,current_TTI,scheduler,av_throughput)
           % core scheduling function (same in LL and SL)
           
           if ~mod(current_TTI-1,5)
               overhead = scheduler.overhead_ref+scheduler.overhead_sync;
           else
               overhead = scheduler.overhead_ref;
           end
           alpha_temp   = 1;
           RBs          = zeros(N_RB*N_UE,1);
           RB_UEs       = zeros(N_RB,N_UE);
           true_RB_UEs  = RB_UEs;
           rb_vect      = zeros(N_UE,1)';
           bits_left    = zeros(N_UE,1);
           isbits       = false(N_UE,1);
           metric       = ones(N_RB,N_UE)*-Inf;
           RB_set     = true(N_RB,1);
           RB_UEs     = false(N_RB,N_UE);
           
           for ii = 1:N_UE         % Check if data is available
                if strcmp(attached_UEs((ii)).traffic_model.type,'fullbuffer')
                    bits_left(user_ind(ii)) = 1;
                else
                    bits_left((ii)) = attached_UEs((ii)).traffic_model.bit_count;
                end
                isbits = logical(bits_left);
           end          
           
           % Precalculated values taken out from the loop (speeds up simulations)
           cleaned_c_log_matrix = log10(max(c,eps)*2*12*7);
           avgd_UE_throughputs  = (scheduler.av_window-1)*av_throughput(user_ind);
           
           % Calculate metric for each RB and attached user
           
           for rr = 1:N_RB
               if sum(bits_left) 
                   
                   res                    = find(RB_set);
                   metric                 = -Inf(N_RB,N_UE);
                   UE_avgd_pre_metric     = -alpha_temp*log10(max(avgd_UE_throughputs+sum(RB_UEs.*c,1)*2*12*7,eps));
                   UE_avgd_pre_metric_mat = UE_avgd_pre_metric(ones(1,N_RB),:);
                   
                   metric(res(1:sum(RB_set)),:) = cleaned_c_log_matrix(res(1:sum(RB_set)),:)+UE_avgd_pre_metric_mat(res(1:sum(RB_set)),:);
                  
                   % for u_ = 1:N_UE
                   % for r_ = 1:N_RB
                   % metric(res(r_),u_) = c(res(r_),u_)*12*7/((obj.av_const-1)*obj.av_throughput(user_ind(u_))+RB_UEs(:,u_).'*c(:,u_)*12*7);      % 12*7 equals the number of elements in a RB
                   % metric(res(r_),u_) = log10(max(c(res(r_),u_),eps)*12*7)-alpha_temp*log10(max((obj.av_const-1)*obj.av_throughput(user_ind(u_))+RB_UEs(:,u_).'*c(:,u_)*12*7,eps)); % Old implementation
                   % metric(res(r_),u_) = log10(max(c(res(r_),u_)*12*7,eps))-alpha_temp*log10(max(obj.av_throughput(user_ind(u_)),eps));
                   % end
                   % end                 
                                             
                   metric(:,~isbits(user_ind)) = -Inf;          % if there are no bits left, set metric to -Inf% only set the metirc -inf ii instead of users_ind(ii)
                   
                   maxi            = max(metric(:));
                   [RB_idx UE_idx] = find(metric == maxi);
                   ind             = randi(length(RB_idx));
                   
                   tmp_UE          = UE_idx(ind);
                   tmp_RB          = RB_idx(ind);
                   
                   RB_set(tmp_RB)               = false;
                   RB_UEs(tmp_RB,tmp_UE)        = true;
                   
                   % coarse decrease for UE who got the current RB and check if there are still bits left
%                    if ~strcmp(attached_UEs(tmp_UE).traffic_model.type,'fullbuffer')
%                        
%                        if sum(RB_UEs(:,tmp_UE)) <= 1       %coarse decrease with crc-bits subtracted (only for non-fullbuffer)
%                            attached_UEs(tmp_UE).traffic_model.coarse_decrease(c(tmp_RB,tmp_UE)*(2*12*7-overhead-24));
%                        else                                     %crc is subtracted only once
%                            attached_UEs(tmp_UE).traffic_model.coarse_decrease(c(tmp_RB,tmp_UE)*(2*12*7-overhead));
%                        end
%                        bits_left(tmp_UE) = attached_UEs(tmp_UE).traffic_model.bit_count;
%                        isbits(tmp_UE)    = logical(bits_left(tmp_UE));
%                    end
                   if ~strcmp(attached_UEs(user_ind(tmp_UE)).traffic_model.type,'fullbuffer')
                       
                       if sum(RB_UEs(:,tmp_UE)) <= 1       %coarse decrease with crc-bits subtracted (only for non-fullbuffer)
                           [bits_left_x,bit_count] = coarse_decrease(c(tmp_RB,user_ind(tmp_UE))*(2*12*7-overhead-24),attached_UEs(user_ind(tmp_UE)).traffic_model.bit_count,attached_UEs(user_ind(tmp_UE)).traffic_model);
                           attached_UEs(user_ind(tmp_UE)).traffic_model.bit_count = bit_count;
                           attached_UEs(user_ind(tmp_UE)).traffic_model.coarse_decrease = bits_left_x;
                       else                                     %crc is subtracted only once
                           [bits_left_x,bit_count] = coarse_decrease(c(tmp_RB,user_ind(tmp_UE))*(2*12*7-overhead),attached_UEs(user_ind(tmp_UE)).traffic_model.bit_count,attached_UEs(user_ind(tmp_UE)).traffic_model);
                           attached_UEs(user_ind(tmp_UE)).traffic_model.bit_count = bit_count;
                           attached_UEs(user_ind(tmp_UE)).traffic_model.coarse_decrease = bits_left_x;
                       end
                       bits_left(user_ind(tmp_UE)) = attached_UEs(user_ind(tmp_UE)).traffic_model.bit_count;
                       isbits(user_ind(tmp_UE))    = logical(bits_left(user_ind(tmp_UE)));
                   end
               end
           end
           RB_UEs = RB_UEs';
           RBs = RB_UEs(:);           
       end