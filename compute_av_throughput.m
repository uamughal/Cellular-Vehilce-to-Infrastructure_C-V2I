            function TP = compute_av_throughput(UE_ID,TTI_to_read,avg_throughput)
                UE_id = UE_ID.UE_ID;
            if UE_id
                TP = sum(avg_throughput(:,TTI_to_read))*10^-3; % Mean throughput, averaged with an exponential window
            else
                TP = 0;
            end
        end