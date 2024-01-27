    function size = get_buffer_length(obj)
        if strcmp(obj.type,'fullbuffer')
            size = Inf;
        else
            size = 0;
            for pp = 1:length(obj.packet_buffer)
                size = size + sum(obj.packet_buffer(pp).size);
            end
        end
    end