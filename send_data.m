    function [obj,back_size,part] = send_data(obj,send_size)
        stop_packet = false;
        part_id = 1;
        if ~stop_packet
            part = packet_part(obj.packet.id,min(obj.packet.size,send_size),part_id);
%             obj.packet_parts = [obj.packet_parts,part];
            obj.packet.packet_parts(part_id) = part;
            back_size = max(0,send_size-obj.packet.size);
            obj.packet.size = max(obj.packet.size-send_size,0);
%             obj.part_id = obj.part_id + 1;
            obj.packet.part_id = mod(part_id,100) + 1;
%             obj.size
        else
            obj.size = 0;
            back_size = send_size;
            part = [];
        end
    end