function retrieved_feedback = get_feedback(obj,TTI_counter)
           last_feedback = obj.feedback_buffer(obj.retrieve_index);
           current_tti = TTI_counter;
           if (current_tti==last_feedback.TTI_idx+obj.feedback_delay)&&(last_feedback.TTI_idx~=0)
               retrieved_feedback = last_feedback;
           else
               retrieved_feedback = [];
           end
end