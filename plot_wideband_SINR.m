function plot_wideband_SINR()
  a_figure = figure(4);
  wideband_SNIR = load('wide_snir.txt');
  wideband_SINR_ecdf = ecdf_x(wideband_SNIR);
  UE_wideband_SINR_axes        = axes('Parent',a_figure);
      % Wideband SINR ECDF
    hold(UE_wideband_SINR_axes,'all');
    plot(UE_wideband_SINR_axes,wideband_SINR_ecdf.x,wideband_SINR_ecdf.f,'blue');
    grid(UE_wideband_SINR_axes,'on');
    title(UE_wideband_SINR_axes,'UE wideband SINR');
    xlabel(UE_wideband_SINR_axes,'UE wideband SINR [dB]');
    ylabel(UE_wideband_SINR_axes,'F(x)');
    

    a_figure = figure(6);
    wide_interference = load('interference.txt');
    inter_mat_ecdf = ecdf_x(wide_interference);
    UE_int_SINR_axes        = axes('Parent',a_figure);
    hold(UE_int_SINR_axes,'all');
    plot(UE_int_SINR_axes,inter_mat_ecdf.x,inter_mat_ecdf.f,'blue');
    grid(UE_int_SINR_axes,'on');
    title(UE_int_SINR_axes,'UE inter SINR');
    xlabel(UE_int_SINR_axes,'UE inter SINR [dB]');
    ylabel(UE_int_SINR_axes,'F(x)');
    end