
%Initialization of Parameters
drops=5;
for ii=1:drops
        ii
clc;
clear all;
close all;

debug_level          = 1;
ISD                  = 500;      %inter-site distance and in measure in meter
n_rings              = 1;        % number of rings around central cell i.e 1st tier
eNB_height           = 32;       % eNodeB (macro) Tx height in [meter].According to 3GPP 36.814 Table A.2.1.1-2. The transmitter height
SM_resolution        = 3;        % spatial resolution in simulation
VUE                  = 82;       % NO. of Vehicle UEs per cell
Lane_width           = 3.5;      % in meter
Vehicle_UE_speed     = 16.667;
Vehicle_UE_direction = 90;
type = 'prop fair traffic';
load('./winner+_1x1_SIXO_10MHz_5.0Kmph_5s_delay_1_v1.mat','pregenerated_ff');
TTI_resolution       = 10;
sym_per_RB_nosync    = 80;
sym_per_RB_sync      = 68;
target_BLER          = 0.01;
TTI_MAX              = 5;
eNB_tx_dBm           = 46;              % eNBs tx power 46dBm
max_streams          = 2;
nCodewords           = 2;
CoMP_configuration1  = 1;
SIR_threshold        = 5;
traffic_models_use   = 1;
DEBUG_LEVEL          = 1;
time                 = 1e-3;
TTI_time_s           = 1e-3;
CoMP                 = 1;

% eNB_tx_power         = 23;            % eNB tx power 23dBm

%% FFR Schedular parameters
    
   beta_FR = 0.8;     % Band for FR(reuse 1), PR(reuse 3)
   SINR_threshold     = 5;       % If UE_SINR<SIRN_threshold, this UE is a PR UE

%% Bhaiya

UE_Th_ND             = -174;          % UE Thermal noise density in dBm/Hz (-174 dBm/Hz is the typical value)
RB_BW                = 180e3;         % RB spectrum width
N_figure             = 7;             % UE Noise figure dB
N_power=10^(UE_Th_ND./10.)/1000*RB_BW*10^(N_figure/10);   % noise power



antenna_configuration= 1;  
runtime_precoding    = 0;
deactivate_UE        = false;
N_PRBs=50;                      % number of physical resource block 100, 20MHz
N_block=1;                      % number of simulated signal block, constant PL per block
PBS_ant_type='3GPP_Azimuth';
SFsig=[8 4];                    % [others dev, own BS links shadowing dev]
MBS_corr=0.7;                   % shadow fading correlation between PBSs
M= 1;


%% Moved from the "do not touch" section

RB_BW           = 180e3;       % Frequency in Hz
TTI_time        = 1e-3;        % Length of a TTI (subframe), in seconds.
cyclic_prefix   = 'normal';    % 'normal' or 'extended' cyclic prefix. Not working for values other that 'normal'
codewords       = 2;           % Maximum number of codewords per TTI. For LTE, that's 2. If you change it, the simulator will 100% sure crash.
                               % I took the name from HSDPA. In the LTE standard is actually referred as 'codewords'

%% Frequencies

frequency       = 2e9;         % Frequency in Hz
frequency1      = 6e9;         % Frequency in Hz         
bandwidth       = 10e6;        % Frequency in Hz

%% eNBs parameters
map_resolution  = 5;
ISD_Urban       = 500;         % inter-site distance in Urban Scenario & in meter
ISD_freeway     = 1732;        % inter-site distance in freeway Scenario

minimum_coupling_loss  = 70;   % Minimum Coupling Loss: the parameter describing the minimum

% loss in signal [dB] between BS and UE or UE and UE in the worst case and is defined as the minimum distance loss including
% antenna gains measured between antenna connectors.
% Recommended in TS 36.942 are 70 dB for urban areas, 80 dB for rural.

macroscopic_pathloss_model = 'Urban macro-cell';        % I need to change to winner II pathloss model
macroscopic_pathloss_model_settings_environment = 'LOS';

% eNodeB TX power settings
eNodeB_tx_power = 10^(46/10)*1/1000; % macro eNodeB's transmit power, in Watts.

%% Options for adding eNodeB Proporties to each Vehicle UEs

eNB_distribution                     = 'four_side_of_lane';   %'four_side_of_road_line'
inter_eNodeB_distance                = 100;                   % Femtocell density in macro cell sector
tx_power_W                           = 10^(23/10)*1/1000;     % Power in Watts 23dBm
sector_azimuths                      = [0 120 240];
UE_tx_height                         = 1.5;                   % 1.5m
UE_rx_height                         = 1.5;                   % Receiver height [m]
nTX                                  = 1;                     % default
  
%% UE (users) settings
% note that for reducing trace sizes, the UE_id is stored as a uint16, so
% up to 65535 users in total are supported. To change that, modify the scheduler class.
            
N_figure                 = 9;    % UE_receiver_noise_figure dB
UE_Th_ND                 = -174; % UE Thermal noise density in dBm/Hz (-174 dBm/Hz is the typical value)
UE_distribution = 'LTE_V UEs';
   
%UE_per_eNodeB   = 2;            % number of users per eNodeB sector (calculates it for the center sector and applies this user density to the other sectors)
UE_speed         = 60/3.6;       % Speed at which the UEs move. In meters/second: 5 Km/h = 1.38 m/s
keep_UEs_still   = false;
   
%% eNodeB options
antenna_gain_pattern = 'TS 36.942 3D'; % As defined in TS 36.942. Identical to Berger, but with a 65¡ã 3dB lobe       
max_antenna_gain = 15; % LTE antenna, urban area (2000 MHz)

%% Additional parameters needed when using 'kathreinTSAntenna' and partially by the 'TS 36.942 3D' anntennas

% Default values used for each site

site_altitude               = 0;    % Altiude of site [m] (doesn't make sense if you use an elevation map, thought)
tx_height                   = 18;   % Height of transmitter  [m]
antenna_mechanical_downtilt = 0;    % [°]
antenna_electrical_downtilt = 8;    % [°]

%% Values that should not be changed
antenna_azimuth_offsett = 30;       % This controls the antenna layout that will be generated. 0 degrees generates hexagonal cells,
                                    % while 30 degrees hexagonal sectors.
                                    
isplot  = 1; 


%% eNBs Layout
% BS coordination and antenna parameters
[eNBs_layout,VUE_grid,grid_cell_ind,coordinate_origin,roi_x,roi_y]=eNBs_Layout(ISD,n_rings,eNB_height,isplot,SM_resolution,VUE);

%% New Parameters

thermal_noise_density = -174;
receiver_noise_figure = 9;            % UE_receiver_noise_figure dB
RB_bandwidth    = 180e3;
thermal_noise_W_RB = 10^(0.1*thermal_noise_density)/1000 * RB_bandwidth * 10^(receiver_noise_figure/10);   % noise Power

area_grid=VUE_grid;
cell_ind=grid_cell_ind;
ticID_start_sim_begin = tic; 


%% Vehicle UE (VUE) Layout

% [VUE_layout]=UE_Layout(isplot,area_grid,cell_ind,VUE,ps_ISD,Lane_width);

 [VUE_layout]= VUE_Layout(isplot,area_grid,cell_ind,VUE,Lane_width); 
 
 %% Add mobility model
 
  for z_ = 1:size(VUE_layout,1)
  % General UE settings that can be saved and re-used
  UEs(z_).id  = z_;
  UEs(z_).position = [VUE_layout(z_,1) VUE_layout(z_,2)];
  
  % Add UE move model. UEs are move with fixed speed and angle
  UEs(z_).walking_model = straightWalkingModel(Vehicle_UE_speed*TTI_time,Vehicle_UE_direction);
  
  % Add UEs moving direction
  UEs(z_).walking_model.direction= VUE_layout(z_,3);
%   UE(z_).trace_UE = false; 
  end
  
%% Vehicle UEs and eNBs Association

[ALL_VUEs_layout,ALL_eNBs_layout]=VUEs_eNBs_Association(VUE_layout,eNBs_layout);

%% adding antenna

antenna_gain=Antenna_Gain(PBS_ant_type,ALL_eNBs_layout,ALL_VUEs_layout,N_block,N_PRBs);

%% Adding Pathloss

pl_avg=Path_Loss(ALL_eNBs_layout,ALL_VUEs_layout);    

 %%  Initialize Resource Block
 
 RBGrid = resourceBlockGrid(N_PRBs,sym_per_RB_nosync,sym_per_RB_sync);
 
 switch type
    case 'prop fair traffic'
       scheduler = PropFair_Traffic(RBGrid); 
       scheduler.BLER_curves.target_BLER = target_BLER;
       scheduler.type = 'prop fair traffic';
    otherwise
       error('Scheduler %s not defined',scheduler_type_string);  
 end
              
[ff_trace,starting_point,interfering_starting_points] = fastFadingWrapper(pregenerated_ff,'random',size(ALL_eNBs_layout,1));
avg_theta_ff = mean(mean(pregenerated_ff.traces{1, 1}.trace.theta))
avg_psi_ff = mean(mean(pregenerated_ff.traces{1, 1}.trace.psi))
avg_zeta_ff = mean(mean(pregenerated_ff.traces{1, 1}.trace.zeta))

scheduler = ffrScheduler(scheduler,beta_FR,RBGrid);

% Inititialize timer
 ticID_start_sim_loop = tic;
 starting_time = toc(ticID_start_sim_loop);
 num_markers = 5;
 s_markings  = round(linspace(1,size(ALL_eNBs_layout,1),num_markers));
 u_markings  = round(linspace(1,size(ALL_eNBs_layout,1),num_markers));
 
 
BS_Attached_UEs = zeros(size(ALL_VUEs_layout,1),size(ALL_eNBs_layout,1));
ue_bs = zeros(size(ALL_VUEs_layout,1),size(ALL_eNBs_layout,1));
[shadow]=Shadowing(ALL_eNBs_layout,ALL_VUEs_layout,SFsig,MBS_corr,M,N_block,N_PRBs,0);
pl_new = pl_avg-antenna_gain;
out_shad = mean(mean(shadow))


%% Apped Traffic Model
       [UE_Idx] = find (ALL_VUEs_layout(1:end,1));      
    for u_=1:size(UE_Idx,1)
        UEs(u_).traffic_model = LTE_trafficmodel(traffic_models_use,UE_Idx(u_),max(scheduler.feedback_channel_delay,0));
        UEs(u_).scheduler = scheduler;        
    end
    
out_tb(size(ue_bs,2),length(UEs),TTI_MAX) = 0; % if you want to place your VUEs than replace 40 with 'nue'.  

for TTI_counter=1:TTI_MAX
    TTI_number = TTI_counter
    nue=size(ALL_VUEs_layout,1);
    nbs=size(ALL_eNBs_layout,1);
    [ue_bs_Rx]=UE_BS_Rx(ALL_VUEs_layout,ALL_eNBs_layout,eNB_tx_dBm,N_PRBs,N_block,pl_new); 
    true_vue_ind=find(ALL_VUEs_layout(:,1)~=0); % it finds the UE in column 1 having not equal to zero value, it is just to cearte matrix for UE indexes.
    true_vue= size(true_vue_ind,1); % vue without extra 15 last UEs having zero values, which doesn't paricipate in VUE_layout. 
    
    
    [val,serving_eNB]=max(ue_bs_Rx(true_vue_ind,:),[],2); % serving eNB: max command finds the largest value in each row. For column can also b adjusted. Here it finds the UEs in each row and it runs
     % upto vue_indexes and gives eNB of that UE. if we put 43 instead of vue_indexes, it finds serving eNB of 43 no. UE i.e in 43 row. % val: returns that largest value in row. for column can also used. 
   
     mpbs_ind=sub2ind(size(ue_bs),true_vue_ind,serving_eNB);
     ue_bs(mpbs_ind)=1;
    
    
%     for c_=1:size(ALL_VUEs_layout,1)
%     out_UE(c_) = (find(ue_bs(c_,:))>3);
%     end
%     UE_idx = find(out_UE==1);
     for i=1:length(ALL_eNBs_layout)
       [UE_ID] = find(ue_bs(:,i)==1); % it finds value (which is equal to 1 i.e ==1) in each column depends on i, if i=1, it finds all values in column one and so on
       
     end
     
     for i=1:length(ALL_eNBs_layout)
       [UE_ID] = find(ue_bs(:,i)==1); % it finds value in each column depends on i, if i=1, it finds all values in column one and so on.
       if (isempty(UE_ID))
             Bs(i).UEs = [];
       else
          
           for i_=1:length(UE_ID)             
             Bs(i).UEs(i_).UE_ID = UE_ID(i_);
             Bs(i).UEs(i_).walking_model= UEs(UE_ID(i_)).walking_model;
             Bs(i).UEs(i_).traffic_model = UEs(UE_ID(i_)).traffic_model;
             Bs(i).UEs(i_).traffic_model.bit_count = 0;
             if(TTI_counter>1)
                 Bs(i).UEs(i_).uplink_channel = UEs(i_).uplink_channel;
             else
                 Bs(i).UEs(i_).uplink_channel = uplink_channel(UE_ID(i_),N_PRBs,max_streams,scheduler.feedback_channel_delay);
             end
              Bs(i).assigned_CQI(i_) = 1;
             if ~Bs(i).UEs(i_).traffic_model.is_fullbuffer
                process_packet_parts(Bs(i).UEs(i_).traffic_model.packet_buffer,nCodewords,Bs(i).UEs(i_).traffic_model);
             end
           end
           
            if(TTI_counter>1)
             if ~isempty(cooperation_rules{UE_ID(i_)+1, 1}.dont_schedule)
                 Bs(i).UEs(i_).interferring_enodeB = cooperation_rules{UE_ID(i_)+1, 1}.dont_schedule;
             else 
                 Bs(i).UEs(i_).interferring_enodeB = 0;
             end
           end

             Bs(i).last_received_feedback = receive_UE_feedback(length(Bs(i).UEs),RBGrid,Bs(i).UEs,TTI_counter );
             [Bs(i),TB_size_bits,num_assigned_RB(TTI_counter,i),assigned_RB] = schedule_user(Bs(i),RBGrid,TTI_counter,scheduler,TTI_MAX,UE_ID);
                if ~isempty(find(i==s_markings,1))
                  if DEBUG_LEVEL>=1
                     fprintf('*');
                  end
                end
       end
       
      if (isempty(UE_ID))
        out_tb(i,1:length(UE_ID),TTI_counter) = 0;
      else
        out_tb(i,1:length(UE_ID),TTI_counter) = TB_size_bits;
      end
        RB(i,:).assign_rb = assigned_RB;
     end
     
        cooperation_rules = cell(1, 1);
     
 for k_=1:length(ALL_eNBs_layout)
   if ~isempty(Bs(k_).UEs)
       [UE_ID] = find(ue_bs(:,k_)==1);
     for j_=1:length(UE_ID)
       UEs(UE_ID(j_)).eNodeB_signaling = Bs(k_).UEs(j_).eNodeB_signaling;
       UEs(UE_ID(j_)).uplink_channel = Bs(k_).UEs(j_).uplink_channel;
     end
   end
 end
 
        x=1;
   for k_=1:length(ALL_eNBs_layout)
      if ~isempty(RB(k_,:).assign_rb)
        [UE_ID] = find(ue_bs(:,k_)==1);
            for j_=1:length(UE_ID)
                RB_UE(TTI_counter,UE_ID(j_)) = RB(k_,:).assign_rb(j_);
            end
                            x=x+1;
          
      end
    end
    
   for j_=1:length(true_vue_ind)          
       [BS_ID(j_)] = find(ue_bs(j_,:)==1);
   end
   
 comp_sites = [];  
 
 inter_enodeB = [];
 RB_grid_downlink = resourceBlockGrid_downlink(N_PRBs,sym_per_RB_nosync,sym_per_RB_sync);
  if scheduler.feedback_channel_delay ~= 0
      for u_ = 1:length(true_vue_ind)
           clear interfering_enodeB_id
        if ~deactivate_UE
           BS_id = BS_ID(u_);            
            comp_sites = [1:3];
            
            for h_ = 1:length(ALL_eNBs_layout)
             if h_ == BS_id
                 shadow_bs(u_,h_) = 0;
                 pl_avg_bs(u_,h_) = 0;
                 interfering_enodeB_id(h_) = 0;
              elseif any(h_==inter_enodeB(:))
                 shadow_bs(u_,h_) = 0;
                 pl_avg_bs(u_,h_) = 0;
                 interfering_enodeB_id(h_) = 0;
             else                               
               shadow_bs(u_,h_) = shadow(u_,h_);
               pl_avg_bs(u_,h_) = pl_new(u_,h_);
               interfering_enodeB_id(h_) = h_;
             end
            end
%              else
%                comp_sites = [1:3];
%              for h_ = 1:length(ALL_eNBs_layout)
%               if h_ == BS_id 
%                  shadow_bs(u_,h_) = 0;
%                  pl_avg_bs(u_,h_) = 0;
%                  interfering_enodeB_id(h_) = 0;
%               else 
%                  shadow_bs(u_,h_) = shadow(u_,h_);
%                  pl_avg_bs(u_,h_) = pl_new(u_,h_);
%                  interfering_enodeB_id(h_) = h_;
%               end
%              end
            
          [UE_ID] = find(ue_bs(:,BS_id)==1);

          ind = (interfering_enodeB_id ~= 0);
          interfering_enodeB_id = interfering_enodeB_id(ind);
          [interference_model, link_quality_model_out,wide_interference,cooperation_rules,SNIR_wide] = link_quality_model(cooperation_rules,BS_id,time,shadow(u_,BS_ID(u_)),pl_new(u_,BS_ID(u_)),UEs(u_),RB_grid_downlink,ff_trace,starting_point,interfering_starting_points,thermal_noise_W_RB,scheduler.CQI_mapper,shadow_bs(u_,:),pl_avg_bs(u_,:),interfering_enodeB_id,time,CoMP,comp_sites);  
           UEs(u_).link_quality_model = link_quality_model_out;
           UEs(u_).interference_model = interference_model;
           UEs(u_).wideband_SINR       = SNIR_wide;
           TB_size(TTI_counter,u_)  = UEs(u_).eNodeB_signaling.TB_size;
           UEs(u_).uplink_channel = send_feedback(link_quality_model_out.feedback,UEs(u_).uplink_channel,TTI_counter);
           wideband_SNIR(u_) = UEs(u_).interference_model.wideband_SINR;
           wide_interference_x(u_) = wide_interference;
           
             if(UEs(u_).wideband_SINR>SINR_threshold)
                    UEs(u_).scheduler = scheduler.FR_scheduler;
             else
                     UEs(u_).scheduler = scheduler.PR_scheduler;
             end
        else
            
          UEs(u_).dummy_link_quality_model = dummy_link_quality_model(N_PRBs);
       end
        
        if ~isempty(find(u_==u_markings,1))
           if DEBUG_LEVEL>=1
               fprintf('+');
           end
        end
      end
  end
  
for u_ = 1:length(true_vue_ind)
  if ~deactivate_UE
%     UEs(u_).link_performance_model = link_performance_model();
  else
    UEs(u_).dummy_link_performance_model = dummy_link_performance_model(TTI_counter);
  end
end

  if mod(TTI_counter,10)==0
    elapsed_time = toc(ticID_start_sim_loop);
    time_per_iteration = elapsed_time / TTI_counter;
    estimated_time_to_finish = (TTI_MAX - TTI_counter)*time_per_iteration;
    estimated_time_to_finish_h = floor(estimated_time_to_finish/3600);
    estimated_time_to_finish_m = estimated_time_to_finish/60 - estimated_time_to_finish_h*60;
    fprintf('Time to finish: %3.0f hours and %3.2f minutes\n',estimated_time_to_finish_h,estimated_time_to_finish_m);
  end 
  
    time = time + TTI_time_s;
end

ind = [];
len = 0;
 for b_ = 1:length(ALL_eNBs_layout)  
      if ~isempty(Bs(b_).UEs)
          ind = [ind;b_];
         len = len+1;
      end
 end

l_=1;

 for b_ = 1:len 
   for u_ = 1:length(Bs(ind(b_)).UEs)
    average_throughput(l_) = cal_avg_throuput(out_tb(:,u_,:) ,Bs(ind(b_)).UEs(u_).eNodeB_signaling.num_assigned_RBs,TTI_time_s,TTI_MAX);
    l_=l_+1;
   end
 end

    avg_throuput=fopen('avg_throughput_Mbps.txt','at');
    fprintf(avg_throuput,'%f\n',average_throughput);
    fclose(avg_throuput);
    
    
    finish_time_s_full = toc(ticID_start_sim_begin);
    finish_time_m = floor(finish_time_s_full/60);
    finish_time_s = finish_time_s_full-finish_time_m*60;
    if DEBUG_LEVEL>=1
        fprintf('Simulation finished\n');
        fprintf(' Total elapsed time: %.0fm, %.0fs\n',finish_time_m,finish_time_s);
    end
    
end
plot_wideband_SINR()
plot_throughput()   
