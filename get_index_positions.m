       function [index_position_mod, index_position_interf_mod] = get_index_positions(t,interfering_eNodeB_ids,ff_trace,starting_point,interfering_starting_points)
           
           % Index for the target channel
           index_position            = floor(t/ff_trace.t_step);
           index_position_plus_start = index_position + starting_point;
           index_position_mod        = (mod(index_position_plus_start,ff_trace.trace_length_samples))+1;
           
           % Get the indexes for the interfering channels
           if ~isempty(interfering_eNodeB_ids)
               index_position_plus_start_interf = index_position + interfering_starting_points(interfering_eNodeB_ids);
               index_position_interf_mod        = (mod(index_position_plus_start_interf,ff_trace.trace_length_samples))+1;
           else
               index_position_interf_mod        = [];
           end
       end