function plot_throughput()
           a_figure                     = figure(5);
           UE_throughput_axes           = axes('Parent',a_figure);
           average_throughput_Mbps = load('avg_throughput_Mbps.txt');
%            average_throughput_Mbps = average_throughput_Mbps(1:3,:);
%            average_throughput_Mbps = reshape(average_throughput_Mbps,size(average_throughput_Mbps,1)*size(average_throughput_Mbps,2),1);
            ind = find(average_throughput_Mbps ~= 0);
            out = average_throughput_Mbps(ind);
            out = [out;0];
             throughput_Mbps_ecdf = ecdf_x(out);  
%            [x,f] = ecdf(average_throughput_Mbps);
%            fairness_index       = sum(throughput_Mbps_ecdf.input_data).^2 / sum(throughput_Mbps_ecdf.input_data.^2) / sum(isfinite(throughput_Mbps_ecdf.input_data));
%            throughput_vector                          = throughput_Mbps_ecdf.input_data;
            % Throughput ECDF
           hold(UE_throughput_axes,'all');
           plot(UE_throughput_axes,throughput_Mbps_ecdf.x,throughput_Mbps_ecdf.f,'blue');
           grid(UE_throughput_axes,'on');
           title(UE_throughput_axes,'UE average throughput');
           xlabel(UE_throughput_axes,'average UE throughput [Mb/s]');
           ylabel(UE_throughput_axes,'F(x)');
    end