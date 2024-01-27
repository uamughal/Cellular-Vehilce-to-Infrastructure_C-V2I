function CQI_params = CQI_params_func(CQI)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 78;
   efficiency = 0.1523;
if (CQI==1)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 78;
   efficiency = 0.1523;
elseif (CQI==2)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 120;
   efficiency = 0.2344;  
elseif (CQI==3)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 193;
   efficiency = 0.3770; 
elseif (CQI==4)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 308;
   efficiency = 0.6016;     
elseif (CQI==5)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 449;
   efficiency = 0.8770;
elseif (CQI==6)
   modulation = 'QPSK';
   modulation_order = 2;
   coding_rate_x_1024 = 602;
   efficiency = 1.1758; 
elseif (CQI==7)
   modulation = '16QAM';
   modulation_order = 4;
   coding_rate_x_1024 = 378;
   efficiency = 1.4766; 
elseif (CQI==8)
   modulation = '16QAM';
   modulation_order = 4;
   coding_rate_x_1024 = 490;
   efficiency = 1.9141;
elseif (CQI==9)
   modulation = '16QAM';
   modulation_order = 4;
   coding_rate_x_1024 = 616;
   efficiency = 2.4063;
elseif (CQI==10)
   modulation = '64QAM';
   modulation_order = 6;
   coding_rate_x_1024 = 466;
   efficiency = 2.7305;
elseif (CQI==11)
   modulation = '64QAM';
   modulation_order = 6;
   coding_rate_x_1024 = 567;
   efficiency = 3.3223; 
elseif (CQI==12)
   modulation = '64QAM';
   modulation_order = 6;
   coding_rate_x_1024 = 666;
   efficiency = 3.9023;
elseif (CQI==13)
   modulation = '64QAM';
   modulation_order = 6;
   coding_rate_x_1024 = 772;
   efficiency = 4.5234; 
elseif (CQI==14)
   modulation = '64QAM';
   modulation_order = 6;
   coding_rate_x_1024 = 873;
   efficiency = 5.1152;
elseif (CQI==15)
   modulation = '64QAM';
   modulation_order = 6;
   coding_rate_x_1024 = 948;
   efficiency = 5.5547; 
end
CQI_params.modulation = modulation;
CQI_params.modulation_order = modulation_order;
CQI_params.coding_rate_x_1024 = coding_rate_x_1024;
CQI_params.efficiency = efficiency;
end