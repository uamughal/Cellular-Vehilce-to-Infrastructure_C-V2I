function [obj, link_quality_model_out,wide_interference,cooperation_rules,SNIR_wide] = link_quality_model(cooperation_rules,attached_eNodeB,time,user_shadow_fading_loss_dB,user_macroscopic_pathloss_dB,UE,RB_grid,ff_trace,starting_point,interfering_starting_points,thermal_noise_W_RB,CQI_mapper,interfering_shadow_fading_loss_dB,interfering_macroscopic_pathloss_eNodeB_dB,interfering_enodeB_id,TTI_counter,CoMP,comp_sites)
           
            ICIC = 1;
            % Get current time
            t = time;
            there_are_interferers = 1;
            % Get map-dependant parameters for the current user
            feedback_channel_delay = 1;
            user_macroscopic_pathloss_linear = 10^(0.1*user_macroscopic_pathloss_dB);
            user_shadow_fading_loss_linear   = 10^(0.1*user_shadow_fading_loss_dB);

            % Number of codewords, layers, power etc. assigned to this user
            DL_signaling = UE.eNodeB_signaling;
            tx_mode      = 1;         % Fixed tx mode according to LTE_config
            the_RB_grid  = RB_grid;
            nRB          = the_RB_grid.n_RB;
            nSC          = nRB*2;
            deactivate_UE = 0;
            % Get the RX power (power allocation) from the target eNodeB
            TX_power_data      = the_RB_grid.power_allocation';
            TX_power_signaling = the_RB_grid.power_allocation_signaling';
            RX_total_RB        = (TX_power_data+TX_power_signaling)./user_macroscopic_pathloss_linear./user_shadow_fading_loss_linear;
            RX_total           = reshape([RX_total_RB; RX_total_RB],1,[])/(2);
            
            % Get fast fading trace for this subframe
            [zeta,chi,psi] = generate_fast_fading_signal(t,1,ff_trace,starting_point,interfering_starting_points);

            %% The SINR calculation is done under the following circumstances:
            % Power allocation is done on a per-subframe (1 ms) and RB basis
            % The fast fading trace is given for every 6 subcarriers (every
            % 90 KHz), so as to provide enough samples related to a
            % worst-case-scenario channel length
            
            % TX_power_signaling_half_RB =  TODO: add signaling interference in better-modeled way
            S_dims = size(zeta);
            S_dims(2) = 1; % All MATLAB variables have at least 2 dimensions, so not a problem.
            
            % RX power
                    RX_power = RX_total.*(zeta.');
            number_of_end = 20;
               % Get interfering eNodeBs
            if there_are_interferers % no interfering eNodeBs present (single eNodeB simulation)
%                 parent_sites                            = [interfering_eNodeBs.parent_eNodeB];
%                 parent_sites_id                         = [parent_sites.id];
%                 interfering_eNodeB_ids                  = [interfering_eNodeBs.eNodeB_id];
                interfering_RB_grids                    = [RB_grid];
                interfering_power_allocations_data = zeros(interfering_RB_grids.n_RB,number_of_end);
                interfering_power_allocations_signaling = zeros(interfering_RB_grids.n_RB,number_of_end);
                for i_=1:number_of_end
                interfering_power_allocations_data(:,i_)      = [interfering_RB_grids.power_allocation];
                interfering_power_allocations_signaling(:,i_) = [interfering_RB_grids.power_allocation_signaling];
                end
                % Get macroscopic pathloss and shadow fading values
       
                ind = (interfering_macroscopic_pathloss_eNodeB_dB ~= 0);
                interfering_macroscopic_pathloss_eNodeB_dB = interfering_macroscopic_pathloss_eNodeB_dB(ind);
                
                ind = (interfering_shadow_fading_loss_dB ~= 0);
                interfering_shadow_fading_loss_dB = interfering_shadow_fading_loss_dB(ind);
                
                interfering_macroscopic_pathloss_eNodeB_linear = 10.^(0.1*interfering_macroscopic_pathloss_eNodeB_dB)';
                interfering_shadow_fading_loss_linear          = 10.^(0.1*interfering_shadow_fading_loss_dB)';
                
                % Total power allocations
                interfering_power_allocations = interfering_power_allocations_data + interfering_power_allocations_signaling;
                
                total_RX_Power   = 10*log10(sum(RX_total_RB));
                totalInterfPower = 10*log10(reshape(sum(interfering_power_allocations(:,1:length(interfering_macroscopic_pathloss_eNodeB_dB)),1),[],1))-interfering_macroscopic_pathloss_eNodeB_dB'-interfering_shadow_fading_loss_dB';
                CI_dB            = total_RX_Power-totalInterfPower;
                
                % Overwrite variables to take into consideration just the interferers up to 45dB below our signal
                interfererIdxs = CI_dB < 45;
                if sum(interfererIdxs)==0 % Just to avoid a crash
                    interfererIdxs(1) = true;
                end
                interfering_eNodeB_ids                         = interfering_enodeB_id(interfererIdxs);
                interfering_macroscopic_pathloss_eNodeB_linear = interfering_macroscopic_pathloss_eNodeB_linear(interfererIdxs);
                interfering_power_allocations                  = interfering_power_allocations(:,interfererIdxs);
%                 interfering_eNodeBs                            = interfering_eNodeBs(interfererIdxs);
                if ~isscalar(interfering_shadow_fading_loss_linear)
                    % Only if the shadow fading is not a scalar (i.e., there is shadow fading)
                    interfering_shadow_fading_loss_linear = interfering_shadow_fading_loss_linear(interfererIdxs);
                else
                    interfering_shadow_fading_loss_linear = ones(length(interfering_macroscopic_pathloss_eNodeB_linear),1);
                end
                
                ind = (interfering_eNodeB_ids ~= 0);
                interfering_enodeB_id_in = interfering_eNodeB_ids(ind);
                % Get interfering channel fading parameters
                theta = generate_fast_fading_interference(t,1,interfering_enodeB_id_in,ff_trace,starting_point,interfering_starting_points);
                SINR_interf_dims = size(theta);
                
                % Get assigned interfering power on a per-half-RB-basis
                if feedback_channel_delay~=0
                    interfering_power_allocations_temp = interfering_power_allocations/2;
                    interf_power_all_RB = reshape([interfering_power_allocations_temp(:) interfering_power_allocations_temp(:)]',2*size(interfering_power_allocations_temp,1),[]); % Take scheduled power
                else
                    if ndims(SINR_interf_dims)==2 %#ok<ISMAT>
                        TX_power_interferers = [interfering_eNodeBs.max_power]/SINR_interf_dims(2);
                        interf_power_all_RB  = TX_power_interferers(ones(1,SINR_interf_dims(2)),:);
                    else
                        interf_power_all_RB = repmat([interfering_eNodeBs.max_power]/SINR_interf_dims(2),[SINR_interf_dims(2) 1]); % Turn on all interferers
                    end
                end
                
                temp_macro_mat      = interfering_macroscopic_pathloss_eNodeB_linear';
                temp_macro_mat      = temp_macro_mat(ones(SINR_interf_dims(2),1),:); 
                temp_shadow_mat     = interfering_shadow_fading_loss_linear';
                temp_shadow_mat     = temp_shadow_mat(ones(SINR_interf_dims(2),1),:);
                interf_power_all_RB = interf_power_all_RB./temp_macro_mat./temp_shadow_mat; % Add macro and shadow fading
                
                % Temporarily safe interference power on per RB block basis; For tracing and statistical evaluation
                % of interference.
                
                interference_structure_debug = false;
                if interference_structure_debug
                    if (TTI_counter==1)&&(~deactivate_UE) %#ok<UNRCH>
                        % Assume unit power, i.e. transmit power per RB = 1
                        % Take only taps from first RB as representative
                        % Reason: Shadow fading is constant for all RBs.
                        microscale_fading_taps_temp  = theta(:,1);
                        shadow_fading_taps_temp      = interfering_shadow_fading_loss_linear;
                        composite_fading_taps_temp   = microscale_fading_taps_temp.*shadow_fading_taps_temp;
                        aggregated_interference_temp = sum(theta./temp_macro_mat'./temp_shadow_mat',1);
                        if (exist('Interference Statistics.mat','file'))
                            load('Interference Statistics.mat', 'microscale_fading_taps', 'shadow_fading_taps', 'composite_fading_taps', 'aggregated_interference_taps');
                            microscale_fading_taps       = [microscale_fading_taps;       microscale_fading_taps_temp];
                            shadow_fading_taps           = [shadow_fading_taps;           shadow_fading_taps_temp];
                            composite_fading_taps        = [composite_fading_taps;        composite_fading_taps_temp];
                            aggregated_interference_taps = [aggregated_interference_taps; aggregated_interference_temp(1)];
                            save('Interference Statistics.mat', 'microscale_fading_taps', 'shadow_fading_taps','composite_fading_taps','aggregated_interference_taps');
                        else
                            microscale_fading_taps       = microscale_fading_taps_temp;
                            shadow_fading_taps           = shadow_fading_taps_temp;
                            composite_fading_taps_temp   = composite_fading_taps_temp;
                            aggregated_interference_taps = aggregated_interference_temp(1);
                            save('Interference Statistics.mat', 'microscale_fading_taps', 'shadow_fading_taps','composite_fading_taps','aggregated_interference_taps');
                        end
                    end
                end
                
                obj.rx_power_tb_in_current_tti = mean(RX_total_RB,2); % linear scale !
                
                % To avoid errors. This trace is thought for SISO
                obj.rx_power_interferers_in_current_tti = zeros(2,size(interf_power_all_RB,2));
                if length(size(interf_power_all_RB))==2
                    obj.rx_power_interferers_in_current_tti(1,:) = 2*mean(interf_power_all_RB(:,:),1); % linear scale !
                    % Add eNodeB ID of interferer as second line to rx power (in order to identify interferer tiers)
                    obj.rx_power_interferers_in_current_tti(2,:) = interfering_eNodeB_ids;
                else
                    obj.rx_power_interferers_in_current_tti(1,:) = NaN;
                    obj.rx_power_interferers_in_current_tti(2,:) = NaN;
                end
                
                max_Layers = SINR_interf_dims(1);
                if length(SINR_interf_dims) > 3
                    N_RI = SINR_interf_dims(4);
                else
                    N_RI = 1;
                end
                
                        interf_power_all_RB_repmat = interf_power_all_RB.';

                        
                        % This line is totally incorrect!!!
                        % interf_power_all_RB_repmat = reshape(repmat(interf_power_all_RB,SINR_interf_dims_repmat),SINR_interf_dims); % Also valid for the case where more than one rank is used
            else
                obj.rx_power_interferers_in_current_tti = 0;
            end
            
            % Calculate thermal noise
            thermal_noise_watts_per_half_RB = thermal_noise_W_RB/2;
            
            % Calculate average preequalization SNR
            % This is a total SNR, the same as in the Link Level Simulator
            obj.SNR_avg_preequal = 10*log10(mean(RX_total)./thermal_noise_watts_per_half_RB); % mean over the subcarriers
            

                    % SINR calculation (SISO)
                    noise_plus_inter_layer_power = psi.*thermal_noise_watts_per_half_RB;
                    interfering_rx_power = squeeze(sum(interf_power_all_RB_repmat.*theta,1));
                    Interference_plus_noise_power = noise_plus_inter_layer_power + interfering_rx_power.';
                    SINR_linear = RX_power ./ (Interference_plus_noise_power.'); % Divide thermal noise by 2: Half-RB frequency bins
                    

            % Calculation of the wideband SINR
          if there_are_interferers
                obj.wideband_SINR = 10*log10(sum(RX_total(:))/(sum(interf_power_all_RB(:))+thermal_noise_watts_per_half_RB*nSC));
                wide_interference=10*log10((sum(interf_power_all_RB(:))+thermal_noise_watts_per_half_RB*nSC));
                else
                obj.wideband_SINR = 10*log10(sum(RX_total(:))/(thermal_noise_watts_per_half_RB*nSC));
                 wide_interference=10*log10(thermal_noise_watts_per_half_RB*nSC);
          end
            % Calculation of the post-equalization symbols SINR
            SINR_dB = 10*log10(SINR_linear);
            % SIR_dB  = 10*log10(SIR_linear);
            
            
           
%% For CS CoMP
         SIR_threshold = 10; 
           
         if CoMP
                n_interferer=length(comp_sites); %intererence eNodeB
                wideband_SIR=zeros(1,n_interferer);
                for ii_=1:n_interferer
                     wideband_SIR(ii_)=10*log10(sum(RX_total(:))/sum(interf_power_all_RB(:,ii_)));
                end
            cooperation_rules = feedback_wideband_SIR(cooperation_rules,attached_eNodeB, wideband_SIR, comp_sites);
            kk=wideband_SIR<SIR_threshold;
          if sum(kk)~=0
              if there_are_interferers
                 interf_power_all_RB_new=interf_power_all_RB(:,~kk);
                obj.wideband_SINR = 10*log10(sum(RX_total(:))/(sum(interf_power_all_RB_new(:))+thermal_noise_watts_per_half_RB*nSC));
                wide_interference=10*log10((sum(interf_power_all_RB_new(:))+thermal_noise_watts_per_half_RB*nSC));
              end
               int_power = interf_power_all_RB_repmat(~kk,:);
               theta_new = theta(~kk,:);
               noise_plus_inter_layer_power = psi.*thermal_noise_watts_per_half_RB;
               interfering_rx_power = squeeze(sum(int_power.*theta_new,1));
               Interference_plus_noise_power = noise_plus_inter_layer_power + interfering_rx_power.';
               SINR_linear = RX_power ./ (Interference_plus_noise_power.'); % Divide thermal noise by 2: Half-RB frequency bins
               SINR_dB = 10*log10(SINR_linear);
          end
        end
              
            
            
%% For ICIC
            
           SNR_threshold = 13;
         
            
           if ICIC
               
                n_interferer=length(comp_sites); %intererence eNodeB
                wideband_SIR=zeros(1,n_interferer);
                for ii_=1:n_interferer
                     wideband_SIR(ii_)=10*log10(sum(RX_total(:))/sum(interf_power_all_RB(:,ii_)));
                end
                    kk=wideband_SIR<SNR_threshold;
               if sum(kk)~=0
                 if there_are_interferers
                   interf_power_all_RB_new=interf_power_all_RB(:,~kk);
                   obj.wideband_SINR = 10*log10(sum(RX_total(:))/(sum(interf_power_all_RB_new(:))+thermal_noise_watts_per_half_RB*nSC));
                   wide_interference=10*log10((sum(interf_power_all_RB_new(:))+thermal_noise_watts_per_half_RB*nSC));
                 end
               end
           end
             
            
            %%
            SNIR_wide = obj.wideband_SINR;
            interference=fopen('interference.txt','at');
            fprintf(interference,'%f\n',wide_interference);
            fclose(interference);
            
             wideband_snir=fopen('wide_snir.txt','at');
            fprintf(wideband_snir,'%f\n',obj.wideband_SINR);
            fclose(wideband_snir);
            
            % Calculate and save feedback, as well as the measured SINRs
           link_quality_model_out = calculate_feedback(1,SINR_linear,SINR_dB,nRB,[],DL_signaling,CQI_mapper);
        end