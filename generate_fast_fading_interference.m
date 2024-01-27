       function [theta] = generate_fast_fading_interference(t,tx_mode,interfering_eNodeB_ids,ff_trace,starting_point,interfering_starting_points)
           % Index for the target and interfering channels
           [~,index_position_interf_mod] = get_index_positions(t,interfering_eNodeB_ids,ff_trace,starting_point,interfering_starting_points);
           
           switch tx_mode
               case 1
                   % SISO trace
                   theta = ff_trace.traces{1}.trace.theta(:,index_position_interf_mod).';
               case 2
                   % TxD trace
                   theta = obj.ff_trace.traces{2}.trace.theta(:,:,index_position_interf_mod);
               case {3,4}
                   % OLSM and CLSM trace
                   tmp_trace = obj.ff_trace.traces{tx_mode};
                   size_psi  = size(tmp_trace{end}.trace.psi);
                   max_rank  = length(tmp_trace);
                   theta = zeros([size_psi(1) size_psi(2) numel(index_position_interf_mod) max_rank]);
                   for rank_idx = 1:max_rank % trace for each rank
                       current_trace = tmp_trace{rank_idx}.trace;
                       theta(1:rank_idx,:,:,rank_idx) = current_trace.theta(:,:,index_position_interf_mod);
                   end
               otherwise
                   error('tx_mode %d not yet implemented',tx_mode);
           end
       end