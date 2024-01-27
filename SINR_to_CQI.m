       function CQIs = SINR_to_CQI(SINRs,CQI_mapper)
           % Clipped CQI feedback (from obj.min_CQI to obj.max_CQI)
           CQIs = CQI_mapper.p(1)*SINRs + CQI_mapper.p(2);
           min_CQI = CQI_mapper.min_CQI;
           max_CQI = CQI_mapper.max_CQI;
           CQIs((~isfinite(CQIs))|CQIs<min_CQI) = min_CQI;
           CQIs(CQIs>max_CQI)                   = max_CQI;
       end