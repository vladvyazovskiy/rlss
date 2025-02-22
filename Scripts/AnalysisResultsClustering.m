% Analysis of results clustering - Defining threshold

clear all
close all

Filename_In='Qu_200318_L_BasicCluster.mat';
%Filename_Out='First_Local_Min_Qu_210318_L';
load(Filename_In);

%%%%%%

StartON=OFFDATA.EndOP; % There is a one at the indexes where an OFF period ends,i.e. an ON period starts. 
EndON=OFFDATA.StartOP; % There is a one at the indexes where an OFF periods starts, i.e. an ON period ends.
%Test=nonzeros(StartON);
%Test2=find(StartON);

StartON_indexes=find(StartON(:,1)); StartON_indexes(end)=[];
EndON_indexes=find(EndON(:,1)); EndON_indexes(1)=[];

ON_Durations=EndON_indexes-StartON_indexes;


%%%Plot ON periods histogram
First_Local_Min=zeros(16,1);
figure()
for i=1:16

    clear oldON oldBins 
    
    if length(find(OFFDATA.StartOP(:,i)))-1>0
        [oldON,oldBins]=histcounts((find(OFFDATA.StartOP(:,i),length(find(OFFDATA.StartOP(:,i)))-1,'last')-...
            find(OFFDATA.EndOP(:,i),length(find(OFFDATA.EndOP(:,i)))-1)-1)*1000/OFFDATA.PNEfs,0:1000/OFFDATA.PNEfs:200);
        %[newON,newBins]=histcounts((adjOFFStarts(2:end)-adjOFFEnds(1:end-1)-1)*1000/OFFDATA.PNEfs,0:1000/OFFDATA.PNEfs:200);
        subplot(4,4,i)
        cla
        a1=area(oldBins(1:end-1)+diff(oldBins)/2,oldON,'LineStyle','none');
        a1.FaceAlpha = 0.8;
        hold on
        %a2=area(newBins(1:end-1)+diff(newBins)/2,newON,'LineStyle','none');
        %a2.FaceAlpha = 0.8;
        ylabel('Count')
        xlabel('Duration (ms)')
        ax=gca;
        ax.YScale='log';
        Xvalues_ms=oldBins(1:end-1)+diff(oldBins)/2;
        Indexes_Local_Minima=find(islocalmin(oldON));
        First_Local_Min(i,1)=Xvalues_ms(Indexes_Local_Minima(1));
    end
end

%save(Filename_Out, 'First_Local_Min');

%Threshold_ON=median(First_Local_Min);