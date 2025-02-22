clear all
close all

%path2017='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/';
%path2018='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/';

pathin2017='Auditory_Analysis_TrialResults_2017/';
pathin2018='Auditory_Analysis_TrialResults_2018/';

An_2017=char('Ed','Fe','He','Ju','Le');
An_2018=char('Ne','Oc','Ph','Qu');

HOMs=char('Ju','Ne','Oc','Ph');
WTs=char('Ed','Fe','He','Le','Qu');

day_2017='201117';
day_2018='280318';

phases=char('L','D');
sessions=char('1','2');

Results_2017=zeros(370,4,5);
Results_2018=zeros(370,4,4);
Results_WTs=zeros(370,4,5);
Results_HOMs=zeros(370,4,4);


%load auditory trials results 2017
for An=1:size(An_2017(:,1),1)
    TrialsResults_conc=[];
    
    for phase=1:2
        for session=1:2
            aud_results=[An_2017(An,:),'-',day_2017,'_',phases(phase),'-TrialsScreening-Session-',sessions(session)];
            eval(['load ',pathin2017,aud_results,'.mat TrialsResults -mat']);
            TrialsResults_conc=[TrialsResults_conc;TrialsResults];
        end
    end
    
    Results_2017(1:size(TrialsResults_conc(:,1)),:,An)=TrialsResults_conc;
end

%load auditory trials results 2018
for An=1:size(An_2018(:,1),1)
    TrialsResults_conc=[];
    
    for phase=1:2
        for session=1:2
            aud_results=[An_2018(An,:),'-',day_2018,'_',phases(phase),'-TrialsScreening-Session-',sessions(session)];
            eval(['load ',pathin2018,aud_results,'.mat TrialsResults -mat']);
            TrialsResults_conc=[TrialsResults_conc;TrialsResults];
        end
    end
    
    Results_2018(1:size(TrialsResults_conc(:,1)),:,An)=TrialsResults_conc;
end


%Pool data in WTs and HOMs

Results_WTs(:,:,1:3)=Results_2017(:,:,1:3);%Ed, Fe, He
Results_WTs(:,:,4)=Results_2017(:,:,5);%Le
Results_WTs(:,:,5)=Results_2018(:,:,4);%Qu

Results_HOMs(:,:,1)=Results_2017(:,:,4);%Ju
Results_HOMs(:,:,2:4)=Results_2018(:,:,1:3);%Ne,Oc,Ph

%Code of scoring: Column 1 =before sound, column 2 = during sound, column 3
%= after sound, column 4=artefact.
%For columns 1 to 3: 1=W, 2=NR, 3=R, 4=not a sound
%For column 4: 0= no artefact, 1= LFP artefactual, 2= LFP and EEG
%artefactual, 3= muscle twitch when sound starts


Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

%Plotting number of trials occuring while the mouse is in ecah state
Values_forSPSS=nan(9,2*3); % 1 line per animal, WT first, 1st column before, 2nd column after, Wake (col 1,2), NREM (col 3,4), REM(col 5,6)
figure()
for vs=1:3
    subplot(2,3,vs)
    perc_trials_starting_in_vs_WTs=sum(Results_WTs(:,1,:)==vs)/360;
    perc_trials_starting_in_vs_Rlss=sum(Results_HOMs(:,1,:)==vs)/360;
    
    errorbar(1,100*mean(perc_trials_starting_in_vs_WTs,3,'omitnan'),100*std(perc_trials_starting_in_vs_WTs,[],3,'omitnan')/sqrt(5),'o','Color',Colours(1,:),'LineWidth',2)
    hold on
    for i=1:5
        plot(1,100*perc_trials_starting_in_vs_WTs(1,1,i),'.k')
        Values_forSPSS(i,1+(vs-1)*2)=100*perc_trials_starting_in_vs_WTs(1,1,i);
        hold on
    end
    errorbar(2,100*mean(perc_trials_starting_in_vs_Rlss,3,'omitnan'),100*std(perc_trials_starting_in_vs_Rlss,[],3,'omitnan')/sqrt(4),'o','Color',Colours(2,:),'LineWidth',2)
    hold on
    for j=1:4
        plot(2,100*perc_trials_starting_in_vs_Rlss(1,1,j),'.k')
        Values_forSPSS(5+j,1+(vs-1)*2)=100*perc_trials_starting_in_vs_Rlss(1,1,j);
        hold on
    end
    if vs==1
        title('Wake before');
    elseif vs==2
        title('NREM before');
    elseif vs==3
        title('REM before');
    end
    xlim([0 3])
    xticks(1:2)
    xticklabels({'WT','rlss'})
    box off
    ax=gca;
    ax.LineWidth=1.5;
    ax.TickDir = 'out';
    ylabel('% of trials')
    
    % After sound
    subplot(2,3,vs+3)
    
    perc_trials_starting_in_vs_WTs=sum(Results_WTs(:,3,:)==vs)/360;
    perc_trials_starting_in_vs_Rlss=sum(Results_HOMs(:,3,:)==vs)/360;
    
    errorbar(1,100*mean(perc_trials_starting_in_vs_WTs,3,'omitnan'),100*std(perc_trials_starting_in_vs_WTs,[],3,'omitnan')/sqrt(5),'o','Color',Colours(1,:),'LineWidth',2)
    hold on
    for i=1:5
        plot(1,100*perc_trials_starting_in_vs_WTs(1,1,i),'.k')
        Values_forSPSS(i,2+(vs-1)*2)=100*perc_trials_starting_in_vs_WTs(1,1,i);
        hold on
    end
    errorbar(2,100*mean(perc_trials_starting_in_vs_Rlss,3,'omitnan'),100*std(perc_trials_starting_in_vs_Rlss,[],3,'omitnan')/sqrt(4),'o','Color',Colours(2,:),'LineWidth',2)
    hold on
    for j=1:4
        plot(2,100*perc_trials_starting_in_vs_Rlss(1,1,j),'.k')
        Values_forSPSS(5+j,2+(vs-1)*2)=100*perc_trials_starting_in_vs_Rlss(1,1,j);
        hold on
    end
    if vs==1
        title('Wake after');
    elseif vs==2
        title('NREM after');
    elseif vs==3
        title('REM after');
    end
    xlim([0 3])
    xticks(1:2)
    xticklabels({'WT','rlss'})
    box off
    ax=gca;
    ax.LineWidth=1.5;
    ax.TickDir = 'out';
    ylabel('% of trials')
    
end

%Assesing number of full arousals (i.e. 2 1 1 X)
Full_arousals_WTs=zeros(1,size(WTs(:,1),1));
Full_arousals_HOMs=zeros(1,size(HOMs(:,1),1));

Proportion_full_arousals_WTs=zeros(1,size(WTs(:,1),1));
Proportion_full_arousals_HOMs=zeros(1,size(HOMs(:,1),1));

for An=1:size(WTs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_WTs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_WTs(NR_trials_indices,:,An);
    
    Full_arousals=find(NR_trials(:,2)==1 & NR_trials(:,3)==1);
    Full_arousals_WTs(1,An)=size(Full_arousals,1);
    
    Proportion_full_arousals_WTs(1,An)=Full_arousals_WTs(1,An)/size(NR_trials_indices,1);
    %Proportion_full_arousals_WTs=Proportion_full_arousals_WTs';
end
for An=1:size(HOMs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_HOMs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_HOMs(NR_trials_indices,:,An);
    
    Full_arousals=find(NR_trials(:,2)==1 & NR_trials(:,3)==1);
    Full_arousals_HOMs(1,An)=size(Full_arousals,1);
    
    Proportion_full_arousals_HOMs(1,An)=Full_arousals_HOMs(1,An)/size(NR_trials_indices,1);
    %Proportion_full_arousals_HOMs=Proportion_full_arousals_HOMs';
    
end

%Assesing number of all arousals (i.e. 2 1 X X)
All_arousals_WTs=zeros(1,size(WTs(:,1),1));
All_arousals_HOMs=zeros(1,size(HOMs(:,1),1));

Proportion_All_arousals_WTs=zeros(1,size(WTs(:,1),1));
Proportion_All_arousals_HOMs=zeros(1,size(HOMs(:,1),1));

for An=1:size(WTs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_WTs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_WTs(NR_trials_indices,:,An);
    
    All_arousals=find(NR_trials(:,2)==1);
    All_arousals_WTs(1,An)=size(All_arousals,1);
    
    Proportion_All_arousals_WTs(1,An)=All_arousals_WTs(1,An)/size(NR_trials_indices,1);
    %Proportion_Brief_arousals_WTs=Proportion_Brief_arousals_WTs';
end
for An=1:size(HOMs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_HOMs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_HOMs(NR_trials_indices,:,An);
    
    All_arousals=find(NR_trials(:,2)==1);
    All_arousals_HOMs(1,An)=size(All_arousals,1);
    
    Proportion_All_arousals_HOMs(1,An)=All_arousals_HOMs(1,An)/size(NR_trials_indices,1);
    %Proportion_Brief_arousals_HOMs=Proportion_Brief_arousals_HOMs';
end

%Assesing number of brief arousals (i.e. 2 1 2 X)
Brief_arousals_WTs=zeros(1,size(WTs(:,1),1));
Brief_arousals_HOMs=zeros(1,size(HOMs(:,1),1));

Proportion_Brief_arousals_WTs=zeros(1,size(WTs(:,1),1));
Proportion_Brief_arousals_HOMs=zeros(1,size(HOMs(:,1),1));

for An=1:size(WTs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_WTs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_WTs(NR_trials_indices,:,An);
    
    Brief_arousals=find(NR_trials(:,2)==1 & NR_trials(:,3)==2);
    Brief_arousals_WTs(1,An)=size(Brief_arousals,1);
    
    Proportion_Brief_arousals_WTs(1,An)=Brief_arousals_WTs(1,An)/size(NR_trials_indices,1);
    %Proportion_Brief_arousals_WTs=Proportion_Brief_arousals_WTs';
end
for An=1:size(HOMs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_HOMs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_HOMs(NR_trials_indices,:,An);
    
    Brief_arousals=find(NR_trials(:,2)==1  & NR_trials(:,3)==2);
    Brief_arousals_HOMs(1,An)=size(Brief_arousals,1);
    
    Proportion_Brief_arousals_HOMs(1,An)=Brief_arousals_HOMs(1,An)/size(NR_trials_indices,1);
    %Proportion_Brief_arousals_HOMs=Proportion_Brief_arousals_HOMs';
end


%Assesing number of twitches during NR (i.e. 2 X X 3)
NR_twitches_WTs=zeros(1,size(WTs(:,1),1));
NR_twitches_HOMs=zeros(1,size(HOMs(:,1),1));

Proportion_NR_twitches_WTs=zeros(1,size(WTs(:,1),1));
Proportion_NR_twitches_HOMs=zeros(1,size(HOMs(:,1),1));

for An=1:size(WTs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_WTs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_WTs(NR_trials_indices,:,An);
    
    NR_twitches=find(NR_trials(:,4)==3);
    NR_twitches_WTs(1,An)=size(NR_twitches,1);
    
    Proportion_NR_twitches_WTs(1,An)=NR_twitches_WTs(1,An)/size(NR_trials_indices,1);
    %Proportion_NR_twitches_WTs=Proportion_NR_twitches_WTs';
end
for An=1:size(HOMs(:,1),1)
    NR_trials=[];NR_trials_indices=[];
    NR_trials_indices=find(Results_HOMs(:,1,An)==2);
    NR_trials(1:size(NR_trials_indices,1),1:4)=Results_HOMs(NR_trials_indices,:,An);
    
    NR_twitches=find(NR_trials(:,4)==3);
    NR_twitches_HOMs(1,An)=size(NR_twitches,1);
    
    Proportion_NR_twitches_HOMs(1,An)=NR_twitches_HOMs(1,An)/size(NR_trials_indices,1);
    %Proportion_NR_twitches_HOMs=Proportion_NR_twitches_HOMs';
end

figure()

subplot(1,4,1)
notBoxPlot(Proportion_full_arousals_WTs,0.5)
hold on
notBoxPlot(Proportion_full_arousals_HOMs,1.5)
title('Full arousals')
xlim([0 2])
ax=gca;
ax.LineWidth=3;
xticks([0.5 1.5])
xticklabels({'WT','Rlss'});

subplot(1,4,2)
notBoxPlot(Proportion_All_arousals_WTs,0.5)
hold on
notBoxPlot(Proportion_All_arousals_HOMs,1.5)
title('All arousals')
xlim([0 2])
ax=gca;
ax.LineWidth=3;
xticks([0.5 1.5])
xticklabels({'WT','Rlss'});

subplot(1,4,3)
notBoxPlot(Proportion_Brief_arousals_WTs,0.5)
hold on
notBoxPlot(Proportion_Brief_arousals_HOMs,1.5)
title('Brief arousals')
xlim([0 2])
ax=gca;
ax.LineWidth=3;
xticks([0.5 1.5])
xticklabels({'WT','Rlss'});

subplot(1,4,4)
notBoxPlot(Proportion_NR_twitches_WTs,0.5)
hold on
notBoxPlot(Proportion_NR_twitches_HOMs,1.5)
title('Twitches')
xlim([0 2])
ax=gca;
ax.LineWidth=3;
xticks([0.5 1.5])
xticklabels({'WT','Rlss'});




figure()
% Full arousals
subplot(1,3,1)
errorbar(1,mean(100*Proportion_full_arousals_WTs,'omitnan'),std(100*Proportion_full_arousals_WTs,'omitnan')/sqrt(length(100*Proportion_full_arousals_WTs)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,100*Proportion_full_arousals_WTs,'.k')
hold on
errorbar(2,mean(100*Proportion_full_arousals_HOMs,'omitnan'),std(100*Proportion_full_arousals_HOMs,'omitnan')/sqrt(length(100*Proportion_full_arousals_HOMs)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,100*Proportion_full_arousals_HOMs,'.k')
title('Full arousals')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';
ylabel('% of trials')


%Brief arousals
subplot(1,3,2)
errorbar(1,mean(100*Proportion_Brief_arousals_WTs,'omitnan'),std(100*Proportion_Brief_arousals_WTs,'omitnan')/sqrt(length(100*Proportion_Brief_arousals_WTs)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,100*Proportion_Brief_arousals_WTs,'.k')
hold on
errorbar(2,mean(100*Proportion_Brief_arousals_HOMs,'omitnan'),std(100*Proportion_Brief_arousals_HOMs,'omitnan')/sqrt(length(100*Proportion_Brief_arousals_HOMs)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,100*Proportion_Brief_arousals_HOMs,'.k')
title('Brief arousals')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';
ylabel('% of trials')

%NR Twitches
subplot(1,3,3)
errorbar(1,mean(100*Proportion_NR_twitches_WTs,'omitnan'),std(100*Proportion_NR_twitches_WTs,'omitnan')/sqrt(length(100*Proportion_NR_twitches_WTs)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,100*Proportion_NR_twitches_WTs,'.k')
hold on
errorbar(2,mean(100*Proportion_NR_twitches_HOMs,'omitnan'),std(100*Proportion_NR_twitches_HOMs,'omitnan')/sqrt(length(100*Proportion_NR_twitches_HOMs)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,100*Proportion_NR_twitches_HOMs,'.k')
title('Twitches')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';
ylabel('% of trials')


