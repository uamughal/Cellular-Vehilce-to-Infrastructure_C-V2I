    function obj = packet_part(data_packet_id,size,part_id)
        obj.part_size = size; 
        obj.data_packet_id = data_packet_id;
        obj.id = part_id;
    end