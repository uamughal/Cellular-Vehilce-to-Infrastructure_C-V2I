    function [packet,packet_parts,bit_count] = decrease_packets_CAM(obj,N_data_bits)
        packet_parts = [];
        read_start=1;
        for bb = 1:length(obj.packet_buffer)
            read_temp = read_start+bb-1;
            if read_temp > length(obj.packet_buffer)
                read_temp = mod(read_temp,length(obj.packet_buffer));
            end
            if ~isempty(obj.packet_buffer(read_temp))
                [packet,N_data_bits,part] = send_data(obj,N_data_bits);
                packet_parts = [packet_parts,part];
                if N_data_bits <= 0
                    break;
                end
            end
        end
        bit_count = get_buffer_length(obj);
    end