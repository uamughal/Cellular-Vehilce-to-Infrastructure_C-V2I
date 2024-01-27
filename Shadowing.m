function [shadow]= Shadowing(enbsl,uel,SFsig,MBS_corr,M,N_block,N_prb,is_fast_fading)
nue=size(uel,1);
nbs=size(enbsl,1);

% nmsite=(nbs)/3;
nsite=7;
% LTR_sites = 4;
% PSLTE_sites = 7*3;
% PS = 7;
% Envelop=0;
                    
corr_matrix=MBS_corr*ones(nsite)+(1-MBS_corr)*eye(nsite);
% alpha=0.05;
% d=1;
% corr_matrix = exp(-alpha*sqrt(R_alpha_sq(1:nsite,1:nsite))*d);
shadow=zeros(nue,nbs);


shadow_uncorr=randn(nue,nsite);
shadow_corr=shadow_uncorr*corr_matrix;

for ii=1:nsite
     shadow(1:end,(ii-1)*3+(1:3))=repmat(shadow_corr(:,ii),1,3);% all users are outdoor
end
% kk = 0;
% for ii=1:LTR_sites
%      shadow(1:end,(PSLTE_sites+kk)+(1:2))=repmat(shadow_corr(:,PS),1,2);% all users are outdoor
%      PS=PS+1;
%      kk=kk+2;
% end
% %  
% Envelop = abs (shadow);
% Phase = abs (shadow);
% CarrierFrq=300; 
% VehicSpd=16.33; 
% C=3e8; 
% fm=VehicSpd*CarrierFrq/C; 
% Tc=1/fm;              %Correlation Time 
% P=10;      %correlation factor      
% T=Tc/P;   % correlation time
% Time = T*(1:length(shadow)); 
% 
% figure (4);
% plot(Time, 10*log10(Envelop)); 
% title('Envelop Generated');
% xlabel('Time(second)'); 
% ylabel('Received signal power (dB)'); 
% grid on; 
% hold on;
% 
% figure (5);
% plot(Time,Phase);
% title('Phase Generated'); 
% xlabel('Time[s]'); 
% ylabel('Phase   (Pi)'); 
% grid on;
% hold on;

end

