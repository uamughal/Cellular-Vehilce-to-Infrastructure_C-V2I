       function obj = ffrScheduler(scheduler,beta_FR,RBGrid)
           % Fill in basic parameters (handled by the superclass constructor)
           obj      = scheduler;
           obj.name = 'FFR scheduler';
           reuse_factor = 3;
           PR_band = 1;
           % Create the two children schedulers: This structure allows for
           % any arbitrary scheduler to be added, as well as with any
           % arbitrary number/list of parameters
%            scheduler_params_fieldlist = fieldnames(scheduler_params);
%            child_scheduler_list = {'FR_scheduler' 'PR_scheduler'};
%            for child_scheduler_idx = 1:length(child_scheduler_list)
%                child_scheduler = child_scheduler_list{child_scheduler_idx};
%                % Copy common parameters
%                for field_idx = 1:length(scheduler_params_fieldlist)
%                    current_fieldname = scheduler_params_fieldlist{field_idx};
%                    switch current_fieldname
%                        case 'FR_scheduler'
%                            % Do not copy
%                        case 'PR_scheduler'
%                            % Do not copy
%                        otherwise
%                            full_scheduler_params.(child_scheduler).(current_fieldname) = scheduler_params.(current_fieldname);
%                    end
%                end
%                
%                % Copy scheduler-specific parameters (will overwrite the previous ones in case of conflict)
%                current_child_scheduler_params = scheduler_params.(child_scheduler);
%                current_scheduler_params_fieldlist = fieldnames(current_child_scheduler_params);
%                for field_idx = 1:length(current_scheduler_params_fieldlist)
%                    current_fieldname = current_scheduler_params_fieldlist{field_idx};
%                    full_scheduler_params.(child_scheduler).(current_fieldname) = scheduler_params.(child_scheduler).(current_fieldname);
%                end
%            end
           
           % FFR-related config
           RBs_FR            = round(obj.RBGrid.n_RB*beta_FR);
           if round(obj.RBGrid.n_RB*beta_FR) ~= (obj.RBGrid.n_RB*beta_FR)
               warning('Optimum B_FR set to %g, but rounded to %g (%g RBs). Non-integer assignment of RBs is not allowed.',beta_FR,RBs_FR/obj.RBGrid.n_RB,RBs_FR);
           end
           RBs_PR_full       = obj.RBGrid.n_RB-RBs_FR;
           mod_reuse         = mod(RBs_PR_full,reuse_factor);
           obj.beta_FR       = beta_FR;
 %          obj.beta_FR_initial= scheduler_params.beta_FR;
           
           % Handle extreme cases
           if obj.beta_FR == 0
               obj.use_FR = false;
           else
               obj.use_FR = true;
           end
           
           if obj.beta_FR==1 && mod(obj.RBGrid.n_RB-RBs_FR,reuse_factor)==0
               obj.use_PR = false;
           else
               obj.use_PR = true;
           end

          %%  original enabled, initialization for the band partitioning
           if obj.beta_FR>1 || obj.beta_FR<0
               error('beta_FR has to be between 0 and 1: %d found',obj.beta_FR);
           end
     
           % Always take out from the FR zone: very slight (almost unnoticeable) degradation of peak and mean but increase in edge (according to theory)
           if mod_reuse~=0
               if RBs_FR>0
                   RBs_FR = RBs_FR - (reuse_factor-mod_reuse);
               else
                   % Safeguard for the case where no FR are present
                   RBs_FR = RBs_FR + mod_reuse;
               end
           end
           
           RBs_PR_full = obj.RBGrid.n_RB-RBs_FR;
           RBs_PR      = RBs_PR_full/reuse_factor;
           
           obj.RBs_FR_original=RBs_FR;
           
           obj.FR_assignment           = false(1,obj.RBGrid.n_RB);
           obj.FR_assignment(1:RBs_FR) = true;
           
           PR_offset                                         = RBs_FR+(PR_band-1)*RBs_PR+1;
           obj.PR_assignment                                 = false(1,obj.RBGrid.n_RB);
           obj.PR_assignment(PR_offset:(PR_offset+RBs_PR-1)) = true;
           
           obj.FR_scheduler.fractional_BW_allocation = true;
           obj.FR_scheduler.fractional_allocation    = obj.FR_assignment;
           obj.PR_scheduler.fractional_BW_allocation = true;
           obj.PR_scheduler.fractional_allocation    = obj.PR_assignment;
                      RBGrid_FR = resourceBlockGrid(RBs_FR,RBGrid.sym_per_RB_nosync,RBGrid.sym_per_RB_sync);
           RBGrid_PR = resourceBlockGrid(RBs_PR,RBGrid.sym_per_RB_nosync,RBGrid.sym_per_RB_sync);
           % Create FR and PR schedulers
           obj.FR_scheduler = PropFair_Traffic(RBGrid_FR);
           obj.PR_scheduler = PropFair_Traffic(RBGrid_PR);
       end