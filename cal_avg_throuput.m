function average_throughput_Mbps = cal_avg_throuput(TB_size_bits,num_assigned_RB,TTI_time_s,TTI_MAX)
           TTIs_to_ignore                           = 0;
           len = sum(TTI_MAX);
           UE_was_disabled =true(1,length(len));
           indx = find(TB_size_bits ~= 0);
           if indx ~= 0
%               indx = find(TB_size_bits ~= 0);
%               UE_was_disabled(indx) = 1;  
              UE_was_disabled =false(1,len);  
           end
           total_bits                               = sum(TB_size_bits);
           TTIs_to_account_for                      = true(1,len);
           TTIs_to_account_for(1:TTIs_to_ignore)    = false; % Ignore TTIs where no feedback information was available
           TTIs_to_account_for(UE_was_disabled) = false;

           sum_total_bits              = sum(total_bits);
           accounted_TTIs              = sum(TTIs_to_account_for);
           average_throughput_Mbps = sum(sum_total_bits) / (5*TTI_time_s) / 1e6;
end