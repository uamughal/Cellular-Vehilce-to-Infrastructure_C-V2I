        function ecdf_data = ecdf_x(input_vector)
            % Filter-out NaNs and Infs
            input_vector_finite = input_vector(isfinite(input_vector));
            
            % ECDF plot plus some extras (percentiles)
            [ecdf_data.f, ecdf_data.x, ecdf_data.flo, ecdf_data.fup,D] = ecdf(input_vector_finite);
            
            % To allow for inverse mappings
            [unique_x m n] = unique(ecdf_data.x);
            unique_y = ecdf_data.f(m);
            
            mean_data = mean(input_vector_finite);
            min_data  = min(input_vector_finite);
            max_data  = max(input_vector_finite);
            
            ecdf_data.min        = min_data;
            ecdf_data.max        = max_data;
            ecdf_data.mean_x     = mean_data;
            ecdf_data.mean_f     = interp1(unique_x,unique_y,mean_data);
            ecdf_data.mean_log   = mean(log(input_vector_finite));
            ecdf_data.fairness   = (sum(input_vector_finite)^2)/(length(input_vector_finite)*sum(input_vector_finite.^2));
            ecdf_data.p05        = ecdf_data.x(find(ecdf_data.f>=0.05,1,'first'));
            ecdf_data.p50        = ecdf_data.x(find(ecdf_data.f>=0.5,1,'first'));
            ecdf_data.p95        = ecdf_data.x(find(ecdf_data.f>=0.95,1,'first'));
            ecdf_data.input_data = input_vector;
            ecdf_data.what       = []; % To be filled outside of this function (this avoids runtime errors)
            ecdf_data.unit       = []; % To be filled outside of this function (this avoids runtime errors)
        end