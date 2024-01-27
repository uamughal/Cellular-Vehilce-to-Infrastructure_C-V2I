       function [ff_trace,starting_point,interfering_starting_points] = fastFadingWrapper(pregenerated_ff,starting_point,num_eNodeBs)
           switch starting_point
               case 'random'
                   start_point_t             = rand * pregenerated_ff.trace_length_s;
                   interferer_start_points_t = rand(1,num_eNodeBs) * pregenerated_ff.trace_length_s;
                   start_point_idx           = floor(start_point_t / pregenerated_ff.t_step) + 1;
                   start_points_idx_interf   = floor(interferer_start_points_t / pregenerated_ff.t_step) + 1;
               otherwise
                   error('Only a random starting point is now allowed');
           end
           ff_trace = pregenerated_ff;
           starting_point = start_point_idx;
           interfering_starting_points = start_points_idx_interf;
       end