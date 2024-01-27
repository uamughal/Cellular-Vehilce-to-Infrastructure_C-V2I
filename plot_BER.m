       function plot_BER(BLER_data,SNR_data)
           cqi_figure = figure(2);
           axes('Parent',cqi_figure,'YScale','log','YMinorTick','on');
           hold all;
           box on;
           initial_cqi = 1;
           final_cqi = size(BLER_data,2);
           for cqi=initial_cqi:final_cqi
               semilogy(SNR_data,BLER_data(:,cqi),'DisplayName',['CQI ' num2str(cqi)]);
               ylim([1e-3,1]);
           end
           grid on;
           xlabel('SNR [dB]');
           ylabel('BLER');
           title(['LTE BLER for CQIs ' num2str(initial_cqi) ' to ' num2str(final_cqi)]);
           legend('Location','SouthEastOutside');
       end