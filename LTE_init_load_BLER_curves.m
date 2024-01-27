function [ the_BLER_curves  ] = LTE_init_load_BLER_curves(CQI_mapper)

initial_cqi = 1;
final_cqi = 15;

% CQI range
min_CQI = 0; % 0 is reserved for "out of range"
max_CQI = 15;
BLER_curves = LTE_load_params_dependant();
BLER_threshold_points = zeros(length(initial_cqi:final_cqi),2);
for cqi_idx=initial_cqi:final_cqi
    
    warning off MATLAB:load:variableNotFound; % To disable Matlab's complaining about missing variables/classes
    BLER_data = load(BLER_curves.filenames{cqi_idx},'simulation_results','BLER','SNR');
    warning on MATLAB:load:variableNotFound;
    
    % Code needed to ascertain whether loaded .mat file is a result file
    % from the LTE LL simulator or just a SNR-BLER curve
    if isfield(BLER_data,'simulation_results')
        % LTE-LL results file
        SNR_vector{cqi_idx}  = BLER_data.simulation_results.SNR_vector;
        BLER_vector{cqi_idx} = BLER_data.simulation_results.cell_specific.BLER_overall;
    else
        % SNR-BLER .mat file
        SNR_vector{cqi_idx}  = BLER_data.SNR;
        BLER_vector{cqi_idx} = BLER_data.BLER;
    end
    % Calculate curve shifts (at 10% BLER)
    BLER_threshold = 0.1;
    SINR_idx = find(BLER_vector{cqi_idx}<=BLER_threshold,1,'first');
    BLER_threshold_points(cqi_idx,:) = [SNR_vector{cqi_idx}(SINR_idx) BLER_vector{cqi_idx}(SINR_idx)];
end


%% Create the objects that will hold the BLER interpolation
%the_BLER_curves = utils.blerCurves(BLER_vector,SNR_vector);
the_BLER_curves = blerCurvesFast(BLER_vector,SNR_vector);
the_BLER_curves.BLER_vector = BLER_vector;
the_BLER_curves.SNR_vector = SNR_vector;
%% Plot CQIs
plot_BER(the_BLER_curves.BLER_data,the_BLER_curves.SNR_data);


%% Calculate CQI mappings
% The SNRs at 10% BLER (well, the value that more closeley approximates
% that with BLER<=0.1
X1 = BLER_threshold_points(:,1);
% The 15 possible CQI values
Y1 = 1:15;
X_pol = -15:0.05:25;
pop_fit = SINR_to_CQI(X_pol,CQI_mapper);

%% Plot CQI mapping
    figure1 = figure(3);
    hold('all');
    
    subplot1 = subplot(1,2,1,'Parent',figure1,...
        'YTick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
    box('on');
    grid('on');
    hold('all');
    plot(X1,Y1,'MarkerFaceColor',[0 0 0],'Marker','o',...
        'DisplayName','BLER 10%',...
        'Color',[0 0 0]);
    ylim([-0.2 16]);
    xlim([X_pol(1)-5 X_pol(end)+5]);
    title('SNR-CQI measured mapping (10% BLER)');
    xlabel('SNR [dB]');
    ylabel('CQI');
    
    subplot2 = subplot(1,2,2,'Parent',figure1,...
        'YTick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]);
    box('on');
    grid('on');
    hold('all');
    plot(X_pol,pop_fit,...
        'DisplayName','Linear fit',...
        'Color',[0 0 0]);
    ylim([-0.2 16]);
    xlim([X_pol(1)-5 X_pol(end)+5]);
    title('SNR-CQI mapping model');
    xlabel('SNR [dB]');
    ylabel('CQI');
end

