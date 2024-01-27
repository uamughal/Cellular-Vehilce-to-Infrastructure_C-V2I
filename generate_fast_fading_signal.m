 function [zeta,chi,psi] = generate_fast_fading_signal(t,tx_mode,ff_trace,starting_point,interfering_starting_points)
           % Index for the target and interfering channels
           [index_position_mod,~] = get_index_positions(t,[],ff_trace,starting_point,interfering_starting_points);
           
           switch tx_mode
               case 1
                   % SISO trace
                   zeta  = ff_trace.traces{1}.trace.zeta(:,index_position_mod);
                   chi   = [];
                   psi   = ff_trace.traces{1}.trace.psi(:,index_position_mod);
               case 2
                   % TxD trace
                   zeta  = ff_trace.traces{2}.trace.zeta(:,:,index_position_mod);
                   chi   = ff_trace.traces{2}.trace.chi(:,:,index_position_mod);
                   psi   = ff_trace.traces{2}.trace.psi(:,:,index_position_mod);
               case {3,4}
                   % OLSM and CLSM trace
                   tmp_trace = obj.ff_trace.traces{tx_mode};
                   size_psi  = size(tmp_trace{end}.trace.psi);
                   max_rank  = length(tmp_trace);
                   zeta  = zeros([size_psi(1) size_psi(2) max_rank]);
                   chi   = zeros([size_psi(1) size_psi(2) max_rank]);
                   psi   = zeros([size_psi(1) size_psi(2) max_rank]);
                   for rank_idx = 1:max_rank % trace for each rank
                       current_trace = tmp_trace{rank_idx}.trace;
                       if ~isempty(current_trace.zeta)
                           zeta(1:rank_idx,:,rank_idx) = current_trace.zeta(:,:,index_position_mod);
                       else
                           zeta(1:rank_idx,:,rank_idx) = 1;
                       end
                       if ~isempty(current_trace.chi)
                           chi(1:rank_idx,:,rank_idx) = current_trace.chi(:,:,index_position_mod);
                       else
                           chi(1:rank_idx,:,rank_idx) = 0;
                       end
                       psi(1:rank_idx,:,rank_idx)     = current_trace.psi(:,:,index_position_mod);
                   end
               otherwise
                   error('tx_mode %d not yet implemented',tx_mode);
           end
       end