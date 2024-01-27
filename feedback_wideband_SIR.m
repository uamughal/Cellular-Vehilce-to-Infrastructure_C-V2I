        function cooperation_rules = feedback_wideband_SIR(cooperation_rules,eNodeB, SIR, i_eNodeBs,comp_sites)
            SIR = SIR(eNodeB ~= i_eNodeBs);
            rules.dont_schedule =[];
            
            check_matrix = SIR < 10;
            rules.dont_schedule = i_eNodeBs ( check_matrix);
%               h=i_eNodeBs ( check_matrix);
%               i=1;
%             for h_=1:length(h)
%                 for i_=1:length(comp_sites)
%               if h_==comp_sites(i_)
%                   rules.dont_schedule = comp_sites(i_);
%               end
%                 end
%             end
            coop_rules = cooperation_rules;
            if ~isempty(coop_rules{1})
                cooperation_rules([coop_rules.UE_id] == UE.id).dont_schedule = rules.dont_schedule;
            else
                cooperation_rules = [cooperation_rules; rules];
            end
            
        end