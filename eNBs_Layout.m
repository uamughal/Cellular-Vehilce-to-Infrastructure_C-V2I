function [eNBs_layout area_grid grid_cell_ind,coordinate_origin,roi_x,roi_y] = eNBs_Layout( isd,n_tier,tower_height,isplot,sim_res,VUE_free )
%BS_CONFIGURATION Summary of this function goes here
%   Detailed explanation goes here
ROI_increase_factor = 0.1;        % Region of interest
number_of_eNodeB_sites = 7;
r=2/3*isd;
BS_coordinate(1:3)=0;
n_cells=1;
if n_tier>=1
% first ring
n_cells=7;
BS_coordinate(4:6)=BS_coordinate(1:3)+isd;
BS_coordinate(7:9)=BS_coordinate(1:3)+isd/2+1j*isd*sqrt(3)/2;
BS_coordinate(10:12)=BS_coordinate(1:3)-isd/2+1j*isd*sqrt(3)/2;
BS_coordinate(13:15)=BS_coordinate(1:3)-isd;
BS_coordinate(16:18)=BS_coordinate(1:3)-isd/2-1j*isd*sqrt(3)/2;
BS_coordinate(19:21)=BS_coordinate(1:3)+isd/2-1j*isd*sqrt(3)/2;
end
if n_tier>=2
% second ring
n_cells=19;
BS_coordinate(22:24)=BS_coordinate(4:6)+isd;
BS_coordinate(25:27)=BS_coordinate(4:6)+isd/2+1j*isd*sqrt(3)/2;
BS_coordinate(28:30)=BS_coordinate(7:9)+isd/2+1j*isd*sqrt(3)/2;
BS_coordinate(31:33)=BS_coordinate(7:9)-isd/2+1j*isd*sqrt(3)/2;
BS_coordinate(34:36)=BS_coordinate(10:12)-isd/2+1j*isd*sqrt(3)/2;
BS_coordinate(37:39)=BS_coordinate(10:12)-isd;
BS_coordinate(40:42)=BS_coordinate(13:15)-isd;
BS_coordinate(43:45)=BS_coordinate(13:15)-isd/2-1j*isd*sqrt(3)/2;
BS_coordinate(46:48)=BS_coordinate(16:18)-isd/2-1j*isd*sqrt(3)/2;
BS_coordinate(49:51)=BS_coordinate(16:18)+isd/2-1j*isd*sqrt(3)/2;
BS_coordinate(52:54)=BS_coordinate(19:21)+isd/2-1j*isd*sqrt(3)/2;
BS_coordinate(55:57)=BS_coordinate(19:21)+isd;
end
BS_antenna_normal=repmat(exp(1j*[0,2*pi/3,-2*pi/3]),1,n_cells);

eNBs_layout=zeros(n_cells*3,8);
eNBs_layout(:,1)=real(BS_coordinate);
eNBs_layout(:,2)=imag(BS_coordinate);
eNBs_layout(:,3)=tower_height;
eNBs_layout(:,4)=BS_antenna_normal;

% generate area grid
ag_x=-r/2:sim_res:r/2;
ag_y=-r*sqrt(3)/4:sim_res:r*sqrt(3)/4;
N_x=length(ag_x);
N_y=length(ag_y);
ag_pos=[reshape(repmat(ag_x,N_y,1),N_x*N_y,1),repmat(ag_y',N_x,1)];
ind=(ag_pos(:,2)-sqrt(3)*(ag_pos(:,1)-r/2)>0)&...
    (ag_pos(:,2)-sqrt(3)*(ag_pos(:,1)+r/2)<0)&(ag_pos(:,2)-sqrt(3)*...
    (r/2-ag_pos(:,1))<0)&(ag_pos(:,2)+sqrt(3)*(ag_pos(:,1)+r/2)>0);
ag_pos=ag_pos(ind,:);
ag_pos=[ag_pos;ag_pos(:,1)-3/4*r,ag_pos(:,2)+sqrt(3)/4*r;...
    ag_pos(:,1)-3/4*r,ag_pos(:,2)-sqrt(3)/4*r];
cell_ind=reshape(repmat([1 2 3],size(ag_pos,1)/3,1),size(ag_pos,1),1);
ind= abs(ag_pos(:,1)+1j*ag_pos(:,2)+r/2)>=VUE_free;
ag_pos=ag_pos(ind,:);
cell_ind=cell_ind(ind);
ag_pos=ag_pos(:,1)+1j*ag_pos(:,2);
area_grid=repmat(ag_pos,n_cells,1)+reshape(repmat(BS_coordinate(1:3:end),length(ag_pos),1),n_cells*length(ag_pos),1)+r/2;
grid_cell_ind=[cell_ind;cell_ind+3;cell_ind+6;cell_ind+9;cell_ind+12;cell_ind+15;cell_ind+18];

for i_=1:number_of_eNodeB_sites
tx_pos_x(i_) = BS_coordinate(i_*3);
end
tx_pos_x = tx_pos_x.';
tx_pos(:,1) = real(tx_pos_x);
tx_pos(:,2) = imag(tx_pos_x);
% Calculate ROI border points in ABSOLUTE coordinates
roi_x = [min(tx_pos(:,1)),max(tx_pos(:,1))];
roi_y = [min(tx_pos(:,2)),max(tx_pos(:,2))];
%% Define an area of the ROI to map
% roi_reduction_factor times smaller and draw it. ABSOLUTE COORDINATES
roi_x = roi_x + ROI_increase_factor*abs(roi_x(2)-roi_x(1))*[-1,1];
roi_y = roi_y + ROI_increase_factor*abs(roi_y(2)-roi_y(1))*[-1,1];
coordinate_origin      =[roi_x(1) roi_y(1)];  


% plot hexagonal grid for illustration
if isplot==1
    X=[];
    Y=[];
    Ax=[];
    Ay=[];
    figure
    hold on
    grid on
    X_base=[-r/2,-r/4,r/4,r/2,r/4,-r/4;
        -r/4,r/4,r/2,r/4,-r/4,-r/2];
    Y_base=[0,   r/2, r/2, 0,    -r/2, -r/2;
       r/2, r/2, 0,   -r/2, -r/2, 0]*sqrt(3)/2;
    Ax_base=[0,     0,       0;
             1,   -1/2,     -1/2]*r/3;
    Ay_base=[0,     0,        0;
             0,     sqrt(3)/2,-sqrt(3)/2]*r/3;
   for ii=1:n_cells
        X=[X,X_base+real(BS_coordinate(ii*3))+r/2];
        Y=[Y,Y_base+imag(BS_coordinate(ii*3))];
        X=[X,X_base+real(BS_coordinate(ii*3))-1/2*r/2];
        Y=[Y,Y_base+imag(BS_coordinate(ii*3))+sqrt(3)/2*r/2];
        X=[X,X_base+real(BS_coordinate(ii*3))-1/2*r/2];
        Y=[Y,Y_base+imag(BS_coordinate(ii*3))-sqrt(3)/2*r/2];
        Ax=[Ax,Ax_base+real(BS_coordinate(ii*3))];
        Ay=[Ay,Ay_base+imag(BS_coordinate(ii*3))];
   end
  
   line(X,Y,'Color','k','LineWidth',2);
   line(Ax,Ay,'Color','b','LineWidth',2);
   plot(real(BS_coordinate),imag(BS_coordinate),'bs','MarkerFaceColor','b');

end
