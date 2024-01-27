       function SINRs = CQI_to_SINR(obj,CQIs)
           if obj.lesscons
               SINR_1 = (CQIs-obj.p(2)) / obj.p(1);
               SINR_2 = (CQIs+1-obj.p(2)) / obj.p(1);
               SINRs  = SINR_1+(SINR_2-SINR_1)/2.5; % output in dB
           else
               SINRs = (CQIs-obj.p(2)) / obj.p(1); % output in dB
           end
       end