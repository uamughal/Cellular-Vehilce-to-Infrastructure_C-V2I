        function obj = dummy_link_performance_model(current_TTI)           
            % Store trace of the relevant information
            tti_idx = current_TTI;
            
            % Store trace
            extra_traces{1} = [];
            extra_traces{2} = [];
            obj.feedback = [];
            obj. pos = [];
            obj.tti_idx = tti_idx;
            obj.wideband_SINR = [];
            obj.extra_traces = extra_traces;
        end