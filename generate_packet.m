function packet = generate_packet(dat_size,current_TTI,type,varargin)
         id_counter = 1;  
     switch type
            case {'voip','gaming','MLaner', 'CAM'}
                packet = data_packet(dat_size,current_TTI,id_counter);
            case {'ftp','http','video'}
                packet_size = eval_cmf(dat_size,varargin{1});
                packet = data_packet(packet_size,current_TTI,id_counter);
     end
        
end