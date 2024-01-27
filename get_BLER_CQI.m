       function BLER = get_BLER_CQI(CQI,SNR,BLER_curves)
           BLER = zeros(length(CQI),1);
           
           for CQI_idx = 1:length(CQI)
               current_SNR = SNR(CQI_idx);
               minimum_SNR = BLER_curves.SNR_vector{CQI(CQI_idx)}(1);
               maximum_SNR = BLER_curves.SNR_vector{CQI(CQI_idx)}(end);
               current_SNR(current_SNR < minimum_SNR) = minimum_SNR;
               current_SNR(current_SNR > maximum_SNR) = maximum_SNR;
               BLER(CQI_idx) = interp1(BLER_curves.SNR_vector{CQI(CQI_idx)},BLER_curves.BLER_vector{CQI(CQI_idx)},current_SNR);
           end
       end