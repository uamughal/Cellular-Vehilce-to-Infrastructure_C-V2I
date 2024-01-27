
function model= CAM_traffic(UE,HARQ_delay)

    model.packet_buffer= generic_tm(UE,HARQ_delay,'CAM');    
    model.is_fullbuffer = false;
    
    model.type = 'CAM';
    packet_mean= 500;
    model.packet_max = 300*8;    % max slice size in bits. 1 byte ->8 bits
    model.packet_min = 190*8;    % min slice size
    model.inter_time = 100;      % mean slice interarrival time (encoder delay),message generation period 100 ms
    model.c = 0.6;  % data according to RAN R1-070674
    model.d = 0.4;
%     model.state;
    model.iit_offset = 1; %randi(10)-1; 
    model.packet_counter=0;
 %  model.counter = 1;
    model.delay_constraint = 500; % in ms, mean arrival time for all slices in a frame is 500ms, interarrival between frames is 500ms
    model.arrival_rate = packet_mean*8*5/0.5; % first 8: byte->bit second 5: 5 slices per frame
end