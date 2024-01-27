function BLER_curves = LTE_load_params_dependant()
BLER_curves.folder = fullfile(pwd,'AWGN_BLERs');
BLER_curves.filenames = {
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi1.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi2.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi3.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi4.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi5.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi6.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi7.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi8.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi9.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi10.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi11.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi12.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi13.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi14.mat')
    fullfile(BLER_curves.folder,'AWGN_1.4MHz_SISO_cqi15.mat')
};