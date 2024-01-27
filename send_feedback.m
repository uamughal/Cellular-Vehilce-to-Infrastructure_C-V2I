       function uplink_channel = send_feedback(feedback_struct,uplink_channel,TTI_counter) 
           % Index where to insert the feedback (circular delay buffer)
           uplink_channel.insert_index   = uplink_channel.insert_index + 1;
           if uplink_channel.insert_index==length(uplink_channel.feedback_buffer)+1
               uplink_channel.insert_index = 1;
           end
           
           % Retrieval index
           uplink_channel.retrieve_index = uplink_channel.retrieve_index + 1;
           if uplink_channel.retrieve_index==length(uplink_channel.feedback_buffer)+1
               uplink_channel.retrieve_index = 1;
           end
           
           % Send feedback
           the_insert_idx = uplink_channel.insert_index;
           uplink_channel.feedback_buffer(the_insert_idx).TTI_idx      = TTI_counter;
           uplink_channel.feedback_buffer(the_insert_idx).tx_mode      = feedback_struct.tx_mode;
           uplink_channel.feedback_buffer(the_insert_idx).nCodewords   = feedback_struct.DL_signaling.nCodewords;
           uplink_channel.feedback_buffer(the_insert_idx).CQI          = feedback_struct.CQI;
           uplink_channel.feedback_buffer(the_insert_idx).PMI          = feedback_struct.PMI;
           uplink_channel.feedback_buffer(the_insert_idx).RI           = feedback_struct.RI;
           uplink_channel.feedback_buffer(the_insert_idx).TB_size      = feedback_struct.DL_signaling.TB_size;
%            feedback_buffer(the_insert_idx).UE_scheduled = feedback_struct.UE_scheduled;
       end