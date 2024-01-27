    function [bits_left,bit_count] = coarse_decrease(N_bits,bit_count,obj,varargin)
        if ~isempty(varargin)
            bit_count = get_buffer_length(obj);
        end
        bit_count = max(0,bit_count-N_bits);
        bits_left = obj.bit_count;
    end