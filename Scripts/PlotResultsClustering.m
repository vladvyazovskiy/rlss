%close all


load('/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/Ph_200318_L_clustering.mat')
MeanDuration_6channels_Ph_BL_SD(:,1)=OFFDATA.StatsOP.MeanDuration;
OPnumber_6channels_Ph_BL_SD(:,1)=OFFDATA.StatsOP.OPnumber;
load('/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/Ph_210318_L_clustering_NoPresets.mat')
MeanDuration_6channels_Ph_BL_SD(:,2)=OFFDATA.StatsOP.MeanDuration;
OPnumber_6channels_Ph_BL_SD(:,2)=OFFDATA.StatsOP.OPnumber;

% load('/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/Ed_091117L_NewClustering.mat')
% MeanDuration_6channels_Qu_BL_SD(:,1)=OFFDATA.StatsOP.MeanDuration;
% OPnumber_6channels_Qu_BL_SD(:,1)=OFFDATA.StatsOP.OPnumber;
% load('/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/Ed_091117D_NewClustering_wPresets.mat')
% MeanDuration_6channels_Qu_BL_SD(:,2)=OFFDATA.StatsOP.MeanDuration;
% OPnumber_6channels_Qu_BL_SD(:,2)=OFFDATA.StatsOP.OPnumber;

load('/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/Qu_200318_L_clustering.mat')
MeanDuration_6channels_Qu_BL_SD(:,1)=OFFDATA.StatsOP.MeanDuration;
OPnumber_6channels_Qu_BL_SD(:,1)=OFFDATA.StatsOP.OPnumber;
load('/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/Qu_210318_L_clustering_NoPresets.mat')
MeanDuration_6channels_Qu_BL_SD(:,2)=OFFDATA.StatsOP.MeanDuration;
OPnumber_6channels_Qu_BL_SD(:,2)=OFFDATA.StatsOP.OPnumber;

figure()
h_WT=notBoxPlot(MeanDuration_6channels_Qu_BL_SD/OFFDATA.PNEfs*1000,[0.9 1.9],'jitter',0.2);
hold on
h_Hom=notBoxPlot(MeanDuration_6channels_Ph_BL_SD/OFFDATA.PNEfs*1000,[1.1 2.1],'jitter',0.2);
d_WT=[h_WT.data];
d_Hom=[h_Hom.data];
set(d_WT,'markerfacecolor',[0.2,0.4,1],'color',[0,0.4,0])
set(d_Hom,'markerfacecolor',[1,0.4,0.2],'color',[0,0.4,0])
title('Mean OFF period duration')
xticks([1 2])
xticklabels({'BL','SD'})
ylabel('Duration (ms)')

figure()
h_WT_OPn=notBoxPlot(OPnumber_6channels_Qu_BL_SD,[0.9 1.9],'jitter',0.2);
hold on
h_Hom_OPn=notBoxPlot(OPnumber_6channels_Ph_BL_SD,[1.1 2.1],'jitter',0.2);
d_WT_OPn=[h_WT_OPn.data];
d_Hom_OPn=[h_Hom_OPn.data];
set(d_WT_OPn,'markerfacecolor',[0.2,0.4,1],'color',[0,0.4,0])
set(d_Hom_OPn,'markerfacecolor',[1,0.4,0.2],'color',[0,0.4,0])
title('OFF period number')
xticks([1 2])
xticklabels({'BL','SD'})