    function obj = data_packet(size,origin,id)
        obj.size = size;
        obj.origin_TTI = origin;
        obj.id = id;
        temp(1:100) = packet_part(obj.id,0,0);
        obj.packet_parts = temp;
    end