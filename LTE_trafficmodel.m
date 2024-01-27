function model = LTE_trafficmodel(trafficmodel_use,UE,HARQ_delay,varargin)
% This function chooses the actual traffic model for the user
% Stefan Schwarz, sschwarz@nt.tuwien.ac.at
% (c) 2010 by INTHFT

%aPrioriPdf = [0.1,0.2,0.2,0.3,0.2]; % a priori pdf according to which a traffic model is picked (defined in RAN R1-070674); just use single digit numbers for this, otherwise set will not work
aPrioriPdf = [0.0,0.0,1,0.0,0.0]; 
% it means only Cam_traffic model will use be 100% and other models have 0%
% prioity given.

% [ftp,http,video,voip,gaming]
% aPrioriPdf = [1,0,0,0,0,0];
if trafficmodel_use % if the traffic models shall be used
    if isempty(varargin)
        set = [];
        for i = 1:length(aPrioriPdf)
            set = [set,i*ones(1,aPrioriPdf(i)*10)];
        end
        index = randi([1,length(set)]);
    else
        index = 1;
        set = varargin{1};
    end
    switch set(index)   % randomly pack one of the traffic models according to the aPrioriPdf
        case 1
            model = ftp_traffic(UE,HARQ_delay);
        case 2
            model = http_traffic(UE,HARQ_delay);
        case 3
            model = CAM_traffic (UE,HARQ_delay);
        case 4
            model = video_traffic(UE,HARQ_delay);
        case 5
            model = voip_traffic(UE,HARQ_delay);
        case 6
            model = gaming_traffic(UE,HARQ_delay);
        
    end
               
else
    model = fullbuffer(UE,HARQ_delay);
end
end
