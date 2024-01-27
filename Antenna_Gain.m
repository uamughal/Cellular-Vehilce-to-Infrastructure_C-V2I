function ant_gain = Antenna_Gain(antenna_type,eNBs_layout,VUEs_layout,N_block,N_PRBs)

nbs=size(eNBs_layout,1);
nue=size(VUEs_layout,1);
n_block=N_block;
n_prb=N_PRBs;

% find UE-MBS link DOA
comp_sep=repmat(VUEs_layout(:,1)+1j*VUEs_layout(:,2),1,nbs)-repmat((eNBs_layout(1:end,1)+1j*eNBs_layout(1:end,2)).',nue,1);
ue_doa=angle(comp_sep)-angle(repmat(eNBs_layout(1:end,4).',nue,1));
[index1,index2]=find(ue_doa>pi);
ue_doa=ue_doa+sparse(index1,index2,-2*pi,nue,nbs);
[index1,index2]=find(ue_doa<-pi);
ue_doa=ue_doa+sparse(index1,index2,2*pi,nue,nbs);
ue_doa=180/pi*ue_doa;

% calculate UE-MBS antenna gain
ant_gain=zeros(nue,nbs);
if strcmp(antenna_type,'3GPP_Azimuth')
    ant_gain(:,1:nbs)=reshape(repmat(14-min(12*(ue_doa(:)/65).^2,25),n_block,1),nue,nbs);
end

% % calculate UE-FBS antenna gain
% if strcmp(HBS_ant,'Omi') && ~isempty(fbs_ff)
%     % find optimal antenna weight for HBSs (only used when HBS have one serving UE)
%     ue_bs_b_p=reshape(repmat(ue_bs(hue_ind,1:nhbs),1,n_block*n_prb*n_ant),sum(hue_ind),n_prb,n_block,n_ant);
%     ff=reshape(sum(fbs_ff(hue_ind,1:nhbs,:,:,:).*double(ue_bs_b_p),1),n_block*n_prb,n_ant);% fast fading of serving henb
%     [val bf_weight_ind]=max(ff*w_pha.',[],2);
%     bf_weight=reshape(repmat(reshape(w_pha(bf_weight_ind,:),1,length(bf_weight_ind)*n_ant),nue,1),nue,nhbs,n_prb,n_block,n_ant);
%     
%     % apply HBS antenna weight and generate antenna gain for each UE-HBS
%     % pair
%     ant_gain(:,1:nhbs,:,:)=10*log10(abs(sum(fbs_ff.*bf_weight,5)).^2);
% end
% % calculate UE-PiBS antenna gain
% if strcmp(PiBS_ant,'Omi')
%     ant_gain(:,nhbs+1:nhbs+npibs,:,:)=reshape(repmat(5,n_block*n_prb*nue*npibs,1),nue,npibs,n_prb,n_block);
% end
end