        function process_packet_parts(packet_buffer,nCodewords,traffic_model)
         packet_parts = packet_buffer.packet_parts;
         ids = zeros(1,length(packet_buffer));
            for cw_ = 1:nCodewords
                    if strcmp(traffic_model.type,'CAM') || strcmp(traffic_model.type,'video') || strcmp(traffic_model.type,'gaming')
                        for pp = 1:length(packet_parts) % acknowledge all packet parts and remove them from the buffer
                            if packet_parts(pp).data_packet_id                     
                                for i = 1:length(packet_buffer)
                                    ids(i) = packet_buffer(i).id;
                                 end
%                                 packet_ind = traffic_model.get_packet_ids == packet_parts(pp).data_packet_id;
%                                 if sum(packet_ind)
%                                     [packet_done,packet_id] = obj.traffic_model.packet_buffer(packet_ind).acknowledge_packet_part(packet_parts{cw_}(pp).id,true);
%                                     if packet_done && packet_id
%                                         obj.traffic_model.remove_packet(packet_id,true);
%                                     end
                                end
                            end
                        end
                    end
                end
%         end