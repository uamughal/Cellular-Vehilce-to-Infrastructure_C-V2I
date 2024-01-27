function BS_UE = check_TTI(BS_UE,current_TTI)
type = BS_UE.traffic_model.type;
if strcmp(type,'CAM')
    
     if ~mod(current_TTI-1 - BS_UE.traffic_model.iit_offset,500) && current_TTI > BS_UE.traffic_model.iit_offset
          
            
                BS_UE.traffic_model.packet = generate_packet(BS_UE.traffic_model.packet_max,current_TTI,type);
                BS_UE.traffic_model.packet_counter = 1;
                BS_UE.traffic_model.packet_buffer = BS_UE.traffic_model.packet;
     end
     
     if current_TTI > BS_UE.traffic_model.iit_offset +1
            if ~mod(current_TTI-1-BS_UE.traffic_model.iit_offset,100) && BS_UE.traffic_model.packet_counter <=5         
                  BS_UE.traffic_model.packet = generate_packet(BS_UE.traffic_model.packet_min,current_TTI,type);
                   BS_UE.traffic_model.packet_counter =  BS_UE.traffic_model.packet_counter+1;
                  BS_UE.traffic_model.packet_buffer = BS_UE.traffic_model.packet;
            end
     end
            BS_UE.traffic_model.bit_count = get_buffer_length(BS_UE.traffic_model);
end  
           
end