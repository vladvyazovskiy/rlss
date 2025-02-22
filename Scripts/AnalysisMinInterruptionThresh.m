%%% Analysis of min interruption thresholds

clear all
close all

WT_names=['Ed';'Fe'; 'He'; 'Le'; 'Qu'];
Hom_names=['Ju';'Me';'Ne';'Oc';'Ph'];

WT_BLday=['091117';'091117';'161117';'161117';'200318'];
Hom_BLday=['161117';'200318';'200318';'200318';'200318'];

Median_thresh_WT=zeros(5,1);
Median_thresh_Hom=zeros(5,1);



for an=1:5
    
    load(['First_Local_Min_',WT_names(an,:),'_',WT_BLday(an,:),'_L']);
    Median_thresh_WT(an)=median(First_Local_Min);
 
    load(['First_Local_Min_',Hom_names(an,:),'_',Hom_BLday(an,:),'_L']);
    Median_thresh_Hom(an)=median(First_Local_Min);
    
    
end

figure()

notBoxPlot([Median_thresh_WT Median_thresh_Hom])
xticks([1 2])
xticklabels({'WT','Rstl'})
ylabel('Median of min interruption threshold (ms)');

figure()

notBoxPlot([Median_thresh_WT Median_thresh_Hom])
xticks([1 2])
xticklabels({'WT','Rstl'})
ylabel('Median of min interruption threshold (ms)');

hold on

for an=1:5
    
    load(['First_Local_Min_',WT_names(an,:),'_',WT_BLday(an,:),'_L']);
    plot(((an-3)*0.05+1)*ones(16,1),First_Local_Min,'linestyle','none','marker','.');
    hold on
    load(['First_Local_Min_',Hom_names(an,:),'_',Hom_BLday(an,:),'_L']);
    plot(((an-3)*0.05+2)*ones(16,1),First_Local_Min,'linestyle','none','marker','.');
    hold on
    
end

