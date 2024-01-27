function scheduler = PropFair_Traffic(RBGrid)
%Load the linear approximations to the BICM curves (necessary for scheduling)
CQI_mapper.max_CQI = 15;
CQI_mapper.min_CQI = 0;
CQI_mapper.p = [0.5223,4.6188];
CQI_mapper.lesscons = 1;
[ the_BLER_curves  ] = LTE_init_load_BLER_curves(CQI_mapper);
load('./BICM_k_d_MSE.mat','k','d');
CQI = 'range';
CQI_ini_1 = LTE_common_get_CQI_params(CQI);
CQI_tables = LTE_common_get_CQI_params(CQI_ini_1(1));

for i_= CQI_ini_1(1):CQI_ini_1(2)
     scheduler.CQI_tables(i_) = LTE_common_get_CQI_params(i_);
end

scheduler.CQI_range = CQI_ini_1(1):CQI_ini_1(2);
scheduler.CQI_efficiency = [0 [CQI_tables.efficiency]];
scheduler.max_power = 39.810717055349690;
scheduler.fariness = 0.5;
scheduler.av_window = 25;
scheduler.overhead_ref = 4;
scheduler.overhead_sync = 16;
scheduler.k = k;
scheduler.d = d;
scheduler.RBGrid = RBGrid;
the_SINR_averager = miesmAveragerFast();
scheduler.SINR_averager = the_SINR_averager;
scheduler.CQI_mapper = CQI_mapper;
scheduler.feedback_channel_delay = 1;
scheduler.BLER_curves = the_BLER_curves;
end