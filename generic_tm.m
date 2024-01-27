   
function packet_buffer = generic_tm(UE,HARQ_delay, type) 

        packet_buffer.UE = UE;
        packet.buffer.HARQ_delay = HARQ_delay;
        
       switch type
            case {'ftp','http'}
                temp = data_packet(0,0,0);
            otherwise
                temp(1:100) = data_packet(0,0,0);
        end
        packet_buffer = temp;
    end