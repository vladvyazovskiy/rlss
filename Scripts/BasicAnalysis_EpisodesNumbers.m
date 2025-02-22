% Calculate number of episodes of each vigilance state
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


der='fro';
n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);


% To record episode numbers - 1st column: Light, 2nd column: dark, 3rd
% column L&D combined.
WT_NR=zeros(5,3);WT_R=zeros(5,3);WT_W=zeros(5,3);WT_ba=zeros(5,3);
HOM_NR=zeros(5,3);HOM_R=zeros(5,3);HOM_W=zeros(5,3);HOM_ba=zeros(5,3);
WT_W_L=cell(5,1);WT_W_D=cell(5,1); % To record lengths of all episodes
HOM_W_L=cell(5,1);HOM_W_D=cell(5,1); % To record lengths of all episodes


%%%%%PARAMETERS
mindur_W=14;%14 This means that episodes of at least 1 min (15 epochs or more) will be included.
mindur_NR=14;%14
mindur_R=1;
ba=4;% works for both wake and NR
ba_R=1;
%For brief awakenings, a minimum duration of 1 is chosen and no
%interruptions allowed.
edges_W=[0:30:2000];
edges_NR=[0:50:300];%edges_NR=[4 8 16 32 64 128 256 2000];edges_NR_sec=[16 32 64 128 256 512 1024 8000];%edges_NR=[0:50:450];edges_NR_sec=[0:4*50:4*450];%edges_NR=[0:50:300];
edges_R=[0:10:60];%edges_R=[0 5 10 15 20 25 30 35 125];edges_R_sec=[0 20 40 60 80 100 120 140 500];%edges_R=[0:10:70];edges_R_sec=[0:4*10:4*70];%edges_R=[0:10:60];

Ep_Dur_all_WT_NR_L=zeros(n_WT,length(edges_NR)-1);Ep_Dur_all_WT_R_L=zeros(n_WT,length(edges_R)-1);Ep_Dur_all_WT_W_L=zeros(n_WT,length(edges_W)-1);
Ep_Dur_all_HOM_NR_L=zeros(n_HOM,length(edges_NR)-1);Ep_Dur_all_HOM_R_L=zeros(n_HOM,length(edges_R)-1);Ep_Dur_all_HOM_W_L=zeros(n_HOM,length(edges_W)-1);


Ep_Dur_all_WT_NR_D=zeros(n_WT,length(edges_NR)-1);Ep_Dur_all_WT_R_D=zeros(n_WT,length(edges_R)-1);Ep_Dur_all_WT_W_D=zeros(n_WT,length(edges_W)-1);
Ep_Dur_all_HOM_NR_D=zeros(n_HOM,length(edges_NR)-1);Ep_Dur_all_HOM_R_D=zeros(n_HOM,length(edges_R)-1);Ep_Dur_all_HOM_W_D=zeros(n_HOM,length(edges_W)-1);


%WT animals
figure(1)
for n=1:5
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            WT_W(n,1)=length(EpDur_W);WT_NR(n,1)=length(EpDur_NR);WT_R(n,1)=length(EpDur_R);WT_ba(n,1)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_WT_NR_L(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_WT_R_L(n,:)=histcounts(EpDur_R,edges_R);Ep_Dur_all_WT_W_L(n,:)=histcounts(EpDur_W,edges_W);
            WT_W_L{n,1}=EpDur_W;
%             figure(1)
%             subplot(2,10,2*n-1)
%             histogram(EpDur_W,edges_W);
%             title('Wake-WT-Light')
%             ylim([0 30])
%             
%             figure(2)
%             subplot(2,10,2*n-1)
%             histogram(EpDur_NR,edges_NR);
%             title('NR-WT-Light')
%             ylim([0 50])
%             
%             figure(3)
%             subplot(2,10,2*n-1)
%             histogram(EpDur_R,edges_R);
%             title('R-WT-Light')
%             ylim([0 30])
            
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
%             NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
%             R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
%             Spectr=vertcat(Spectr_L,spectr);
%             art=[W1;NR2;R3;MT];
%             Spectr(art,:)=NaN;
%             
            
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            WT_W(n,2)=length(EpDur_W);WT_NR(n,2)=length(EpDur_NR);WT_R(n,2)=length(EpDur_R);WT_ba(n,2)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_WT_NR_D(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_WT_R_D(n,:)=histcounts(EpDur_R,edges_R);Ep_Dur_all_WT_W_D(n,:)=histcounts(EpDur_W,edges_W);
            WT_W_D{n,1}=EpDur_W;
            
%             figure(1)
%             subplot(2,10,2*n)
%             histogram(EpDur_W,edges_W);
%             title('Wake-WT-Dark')
%             set(gca,'Color',[0.4 0.4 0.4]);
%             ylim([0 30])
%             
%             figure(2)
%             subplot(2,10,2*n)
%             histogram(EpDur_NR,edges_NR);
%             title('NR-WT-Dark')
%             set(gca,'Color',[0.4 0.4 0.4]);
%             ylim([0 50])
%             
%             figure(3)
%             subplot(2,10,2*n)
%             histogram(EpDur_R,edges_R);
%             title('R-WT-Dark')
%             set(gca,'Color',[0.4 0.4 0.4]);
%             ylim([0 30])
        end
        
    end


end


%HOM animals
figure(2)
for n=1:5
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
   for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            HOM_W(n,1)=length(EpDur_W);HOM_NR(n,1)=length(EpDur_NR);HOM_R(n,1)=length(EpDur_R);HOM_ba(n,1)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_HOM_NR_L(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_HOM_R_L(n,:)=histcounts(EpDur_R,edges_R);Ep_Dur_all_HOM_W_L(n,:)=histcounts(EpDur_W,edges_W);
            HOM_W_L{n,1}=EpDur_W;
%             figure(1)
%             subplot(2,10,2*n-1+10)
%             histogram(EpDur_W,edges_W);
%             title('Wake-WT-Light')
%             ylim([0 30])
%             
%             figure(2)
%             subplot(2,10,2*n-1+10)
%             histogram(EpDur_NR,edges_NR);
%             title('NR-WT-Light')
%             ylim([0 50])
%             
%             figure(3)
%             subplot(2,10,2*n-1+10)
%             histogram(EpDur_R,edges_R);
%             title('R-WT-Light')
%             ylim([0 30])
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
%             NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
%             R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
%             Spectr=vertcat(Spectr_L,spectr);
%             art=[W1;NR2;R3;MT];
%             Spectr(art,:)=NaN;
%             
            
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            HOM_W(n,2)=length(EpDur_W);HOM_NR(n,2)=length(EpDur_NR);HOM_R(n,2)=length(EpDur_R);HOM_ba(n,2)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_HOM_NR_D(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_HOM_R_D(n,:)=histcounts(EpDur_R,edges_R);Ep_Dur_all_HOM_W_D(n,:)=histcounts(EpDur_W,edges_W);
            HOM_W_D{n,1}=EpDur_W;
            
%             figure(1)
%             subplot(2,10,2*n+10)
%             histogram(EpDur_W,edges_W);
%             title('Wake-WT-Dark')
%             set(gca,'Color',[0.4 0.4 0.4]);
%             ylim([0 30])
%             
%             figure(2)
%             subplot(2,10,2*n+10)
%             histogram(EpDur_NR,edges_NR);
%             title('NR-WT-Dark')
%             set(gca,'Color',[0.4 0.4 0.4]);
%             ylim([0 50])
%             
%             figure(3)
%             subplot(2,10,2*n+10)
%             histogram(EpDur_R,edges_R);
%             title('R-WT-Dark')
%             set(gca,'Color',[0.4 0.4 0.4]);
%             ylim([0 30])
        end
        
    end
   

end

figure(4)
%Wake 
subplot(1,2,1)
notBoxPlot([WT_W(:,1) HOM_W(:,1)])
title('Wake - Light');
ylabel('Number of episodes'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_W(:,2) HOM_W(:,2)])
title('Wake - Dark');
ylabel('Number of episodes');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});

figure(5)
%NREM 
subplot(1,2,1)
notBoxPlot([WT_NR(:,1) HOM_NR(:,1)])
title('NREM - Light');
ylabel('Number of episodes'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_NR(:,2) HOM_NR(:,2)])
title('NREM - Dark');
ylabel('Number of episodes');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});

figure(6)
%REM 
subplot(1,2,1)
notBoxPlot([WT_R(:,1) HOM_R(:,1)])
title('REM - Light');
ylabel('Number of episodes'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_R(:,2) HOM_R(:,2)])
title('REM - Dark');
ylabel('Number of episodes');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});

figure(7)
%Brief awakenings 
subplot(1,2,1)
notBoxPlot([WT_ba(:,1) HOM_ba(:,1)])
title('Brief Aw. - Light');
ylabel('Number of episodes per min of NREM sleep'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_ba(:,2) HOM_ba(:,2)])
title('Brief Aw. - Dark');
ylabel('Number of episodes per min of NREM sleep');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});


%Brief awakenings - better aesthetics

Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

figure()
subplot(1,2,1)
errorbar(1,mean(WT_ba(:,1),'omitnan'),std(WT_ba(:,1),'omitnan')/sqrt(length(WT_ba(:,1))),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_ba(:,1),'.k')
hold on
errorbar(2,mean(HOM_ba(:,1),'omitnan'),std(HOM_ba(:,1),'omitnan')/sqrt(length(HOM_ba(:,1))),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_ba(:,1),'.k')
title('Brief Aw. - Light');
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';
ylabel('Number of episodes per min of NREM sleep'); 
set(gca,'Color',[1 1 0.8]);

subplot(1,2,2)
errorbar(1,mean(WT_ba(:,2),'omitnan'),std(WT_ba(:,2),'omitnan')/sqrt(length(WT_ba(:,2))),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_ba(:,2),'.k')
hold on
errorbar(2,mean(HOM_ba(:,2),'omitnan'),std(HOM_ba(:,2),'omitnan')/sqrt(length(HOM_ba(:,2))),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_ba(:,2),'.k')
title('Brief Aw. - Dark');
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';
ylabel('Number of episodes per min of NREM sleep'); 
set(gca,'Color',[0.8 0.8 0.8]);


%%%Histograms of episode durations concatenated across animals

figure()
Values_WT_NR_L=mean(Ep_Dur_all_WT_NR_L,1);Values_HOM_NR_L=mean(Ep_Dur_all_HOM_NR_L,1);
SEM_WT_NR_L=std(Ep_Dur_all_WT_NR_L,0,1)/sqrt(n_WT);SEM_HOM_NR_L=std(Ep_Dur_all_HOM_NR_L,0,1)/sqrt(n_HOM);

Values_WT_NR_D=mean(Ep_Dur_all_WT_NR_D,1);Values_HOM_NR_D=mean(Ep_Dur_all_HOM_NR_D,1);
SEM_WT_NR_D=std(Ep_Dur_all_WT_NR_D,0,1)/sqrt(n_WT);SEM_HOM_NR_D=std(Ep_Dur_all_HOM_NR_D,0,1)/sqrt(n_HOM);

edges_NR_plot=edges_NR(1:length(edges_NR)-1);

subplot(1,2,1)
bar(edges_NR_plot,[Values_WT_NR_L' Values_HOM_NR_L']);
%legend('WT','HOM');
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_L' Values_HOM_NR_L'],[SEM_WT_NR_L' SEM_HOM_NR_L'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
ylim([0 60]);
title('Distribution of episode durations - NR - L');



subplot(1,2,2)
bar(edges_NR_plot,[Values_WT_NR_D' Values_HOM_NR_D']);
%legend('WT','HOM');
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_D' Values_HOM_NR_D'],[SEM_WT_NR_D' SEM_HOM_NR_D'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
ylim([0 60]);
title('Distribution of episode durations - NR - D');



figure()
Values_WT_R_L=mean(Ep_Dur_all_WT_R_L,1);Values_HOM_R_L=mean(Ep_Dur_all_HOM_R_L,1);
SEM_WT_R_L=std(Ep_Dur_all_WT_R_L,0,1)/sqrt(n_WT);SEM_HOM_R_L=std(Ep_Dur_all_HOM_R_L,0,1)/sqrt(n_HOM);

Values_WT_R_D=mean(Ep_Dur_all_WT_R_D,1);Values_HOM_R_D=mean(Ep_Dur_all_HOM_R_D,1);
SEM_WT_R_D=std(Ep_Dur_all_WT_R_D,0,1)/sqrt(n_WT);SEM_HOM_R_D=std(Ep_Dur_all_HOM_R_D,0,1)/sqrt(n_HOM);

edges_R_plot=edges_R(1:length(edges_R)-1);

subplot(1,2,1)
bar(edges_R_plot,[Values_WT_R_L' Values_HOM_R_L']);
%legend('WT','HOM');
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_L' Values_HOM_R_L'],[SEM_WT_R_L' SEM_HOM_R_L'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
ylim([0 25]);
title('Distribution of episode durations - R - L');



subplot(1,2,2)
bar(edges_R_plot,[Values_WT_R_D' Values_HOM_R_D'])
%legend('WT','HOM');
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_D' Values_HOM_R_D'],[SEM_WT_R_D' SEM_HOM_R_D'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
ylim([0 25]);
title('Distribution of episode durations - R - D');



figure()
Values_WT_W_L=mean(Ep_Dur_all_WT_W_L,1);Values_HOM_W_L=mean(Ep_Dur_all_HOM_W_L,1);
SEM_WT_W_L=std(Ep_Dur_all_WT_W_L,0,1)/sqrt(n_WT);SEM_HOM_W_L=std(Ep_Dur_all_HOM_W_L,0,1)/sqrt(n_HOM);

Values_WT_W_D=mean(Ep_Dur_all_WT_W_D,1);Values_HOM_W_D=mean(Ep_Dur_all_HOM_W_D,1);
SEM_WT_W_D=std(Ep_Dur_all_WT_W_D,0,1)/sqrt(n_WT);SEM_HOM_W_D=std(Ep_Dur_all_HOM_W_D,0,1)/sqrt(n_HOM);

edges_W_plot=edges_W(1:length(edges_W)-1);

subplot(1,2,1)
bar(edges_W_plot,[Values_WT_W_L' Values_HOM_W_L']);
legend('WT','HOM');
hold on
errorbar([edges_W_plot'-4 edges_W_plot'+4],[Values_WT_W_L' Values_HOM_W_L'],[SEM_WT_W_L' SEM_HOM_W_L'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
title('Distribution of episode durations - W - L');



subplot(1,2,2)
bar(edges_W_plot,[Values_WT_W_D' Values_HOM_W_D'])
legend('WT','HOM');
hold on
errorbar([edges_W_plot'-4 edges_W_plot'+4],[Values_WT_W_D' Values_HOM_W_D'],[SEM_WT_W_D' SEM_HOM_W_D'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
title('Distribution of episode durations - W - D');



%%%Histograms of episode durations concatenated across animals and
%%%normalised against total number of episodes of a given state
Ep_Dur_all_WT_NR_L_norm=Ep_Dur_all_WT_NR_L;Ep_Dur_all_WT_NR_D_norm=Ep_Dur_all_WT_NR_D;
Ep_Dur_all_WT_R_L_norm=Ep_Dur_all_WT_R_L;Ep_Dur_all_WT_R_D_norm=Ep_Dur_all_WT_R_D;
Ep_Dur_all_WT_W_L_norm=Ep_Dur_all_WT_W_L;Ep_Dur_all_WT_W_D_norm=Ep_Dur_all_WT_W_D;

Ep_Dur_all_HOM_NR_L_norm=Ep_Dur_all_HOM_NR_L;Ep_Dur_all_HOM_NR_D_norm=Ep_Dur_all_HOM_NR_D;
Ep_Dur_all_HOM_R_L_norm=Ep_Dur_all_HOM_R_L;Ep_Dur_all_HOM_R_D_norm=Ep_Dur_all_HOM_R_D;
Ep_Dur_all_HOM_W_L_norm=Ep_Dur_all_HOM_W_L;Ep_Dur_all_HOM_W_D_norm=Ep_Dur_all_HOM_W_D;

for n=1:n_WT
    Ep_Dur_all_WT_NR_L_norm(n,:)=Ep_Dur_all_WT_NR_L(n,:)/WT_NR(n,1);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_WT_R_L_norm(n,:)=Ep_Dur_all_WT_R_L(n,:)/WT_R(n,1);
    Ep_Dur_all_WT_W_L_norm(n,:)=Ep_Dur_all_WT_W_L(n,:)/WT_W(n,1);
    
    Ep_Dur_all_WT_NR_D_norm(n,:)=Ep_Dur_all_WT_NR_D(n,:)/WT_NR(n,2);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_WT_R_D_norm(n,:)=Ep_Dur_all_WT_R_D(n,:)/WT_R(n,2);
    Ep_Dur_all_WT_W_D_norm(n,:)=Ep_Dur_all_WT_W_D(n,:)/WT_W(n,2);  
end
for n=1:n_HOM
    Ep_Dur_all_HOM_NR_L_norm(n,:)=Ep_Dur_all_HOM_NR_L(n,:)/HOM_NR(n,1);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_HOM_R_L_norm(n,:)=Ep_Dur_all_HOM_R_L(n,:)/HOM_R(n,1);
    Ep_Dur_all_HOM_W_L_norm(n,:)=Ep_Dur_all_HOM_W_L(n,:)/HOM_W(n,1);
    
    Ep_Dur_all_HOM_NR_D_norm(n,:)=Ep_Dur_all_HOM_NR_D(n,:)/HOM_NR(n,2);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_HOM_R_D_norm(n,:)=Ep_Dur_all_HOM_R_D(n,:)/HOM_R(n,2);
    Ep_Dur_all_HOM_W_D_norm(n,:)=Ep_Dur_all_HOM_W_D(n,:)/HOM_W(n,2);  
end

figure()
Values_WT_NR_L_norm=mean(Ep_Dur_all_WT_NR_L_norm,1);Values_HOM_NR_L_norm=mean(Ep_Dur_all_HOM_NR_L_norm,1);
SEM_WT_NR_L_norm=std(Ep_Dur_all_WT_NR_L_norm,0,1)/sqrt(n_WT);SEM_HOM_NR_L_norm=std(Ep_Dur_all_HOM_NR_L_norm,0,1)/sqrt(n_HOM);

Values_WT_NR_D_norm=mean(Ep_Dur_all_WT_NR_D_norm,1);Values_HOM_NR_D_norm=mean(Ep_Dur_all_HOM_NR_D_norm,1);
SEM_WT_NR_D_norm=std(Ep_Dur_all_WT_NR_D_norm,0,1)/sqrt(n_WT);SEM_HOM_NR_D_norm=std(Ep_Dur_all_HOM_NR_D_norm,0,1)/sqrt(n_HOM);

edges_NR_plot=edges_NR(1:length(edges_NR)-1);

subplot(1,2,1)
bar(edges_NR_plot,[Values_WT_NR_L_norm' Values_HOM_NR_L_norm']);
%legend('WT','HOM');
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_L_norm' Values_HOM_NR_L_norm'],[SEM_WT_NR_L_norm' SEM_HOM_NR_L_norm'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 1]);
title('Distribution of episode durations - NR - L');



subplot(1,2,2)
bar(edges_NR_plot,[Values_WT_NR_D_norm' Values_HOM_NR_D_norm']);
%legend('WT','HOM');
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_D_norm' Values_HOM_NR_D_norm'],[SEM_WT_NR_D_norm' SEM_HOM_NR_D_norm'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 1]);
title('Distribution of episode durations - NR - D');


%%%
figure()
Values_WT_R_L_norm=mean(Ep_Dur_all_WT_R_L_norm,1);Values_HOM_R_L_norm=mean(Ep_Dur_all_HOM_R_L_norm,1);
SEM_WT_R_L_norm=std(Ep_Dur_all_WT_R_L_norm,0,1)/sqrt(n_WT);SEM_HOM_R_L_norm=std(Ep_Dur_all_HOM_R_L_norm,0,1)/sqrt(n_HOM);

Values_WT_R_D_norm=mean(Ep_Dur_all_WT_R_D_norm,1);Values_HOM_R_D_norm=mean(Ep_Dur_all_HOM_R_D_norm,1);
SEM_WT_R_D_norm=std(Ep_Dur_all_WT_R_D_norm,0,1)/sqrt(n_WT);SEM_HOM_R_D_norm=std(Ep_Dur_all_HOM_R_D_norm,0,1)/sqrt(n_HOM);

edges_R_plot=edges_R(1:length(edges_R)-1);

subplot(1,2,1)
bar(edges_R_plot,[Values_WT_R_L_norm' Values_HOM_R_L_norm']);
%legend('WT','HOM');
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_L_norm' Values_HOM_R_L_norm'],[SEM_WT_R_L_norm' SEM_HOM_R_L_norm'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 1]);
title('Distribution of episode durations - R - L');



subplot(1,2,2)
bar(edges_R_plot,[Values_WT_R_D_norm' Values_HOM_R_D_norm'])
%legend('WT','HOM');
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_D_norm' Values_HOM_R_D_norm'],[SEM_WT_R_D_norm' SEM_HOM_R_D_norm'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 1]);
title('Distribution of episode durations - R - D');


%%%%%
figure()
Values_WT_W_L_norm=mean(Ep_Dur_all_WT_W_L_norm,1);Values_HOM_W_L_norm=mean(Ep_Dur_all_HOM_W_L_norm,1);
SEM_WT_W_L_norm=std(Ep_Dur_all_WT_W_L_norm,0,1)/sqrt(n_WT);SEM_HOM_W_L_norm=std(Ep_Dur_all_HOM_W_L_norm,0,1)/sqrt(n_HOM);

Values_WT_W_D_norm=mean(Ep_Dur_all_WT_W_D_norm,1);Values_HOM_W_D_norm=mean(Ep_Dur_all_HOM_W_D_norm,1);
SEM_WT_W_D_norm=std(Ep_Dur_all_WT_W_D_norm,0,1)/sqrt(n_WT);SEM_HOM_W_D_norm=std(Ep_Dur_all_HOM_W_D_norm,0,1)/sqrt(n_HOM);

edges_W_plot=edges_W(1:length(edges_W)-1);

subplot(1,2,1)
bar(edges_W_plot,[Values_WT_W_L_norm' Values_HOM_W_L_norm']);
legend('WT','HOM');
hold on
errorbar([edges_W_plot'-4 edges_W_plot'+4],[Values_WT_W_L_norm' Values_HOM_W_L_norm'],[SEM_WT_W_L_norm' SEM_HOM_W_L_norm'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
title('Distribution of episode durations - W - L');



subplot(1,2,2)
bar(edges_W_plot,[Values_WT_W_D_norm' Values_HOM_W_D_norm'])
legend('WT','HOM');
hold on
errorbar([edges_W_plot'-4 edges_W_plot'+4],[Values_WT_W_D_norm' Values_HOM_W_D_norm'],[SEM_WT_W_D_norm' SEM_HOM_W_D_norm'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
title('Distribution of episode durations - W - D');


%%%%%% Combining Light and Dark for new figures

Ep_Dur_all_WT_NR=Ep_Dur_all_WT_NR_L+Ep_Dur_all_WT_NR_D;
Ep_Dur_all_WT_R=Ep_Dur_all_WT_R_L+Ep_Dur_all_WT_R_D;

Ep_Dur_all_HOM_NR=Ep_Dur_all_HOM_NR_L+Ep_Dur_all_HOM_NR_D;
Ep_Dur_all_HOM_R=Ep_Dur_all_HOM_R_L+Ep_Dur_all_HOM_R_D;


figure() %%% NR, Light and dark combined, absolute numbers of episodes

Values_WT_NR=mean(Ep_Dur_all_WT_NR,1);Values_HOM_NR=mean(Ep_Dur_all_HOM_NR,1);
SEM_WT_NR=std(Ep_Dur_all_WT_NR,0,1)/sqrt(n_WT);SEM_HOM_NR=std(Ep_Dur_all_HOM_NR,0,1)/sqrt(n_HOM);

edges_NR_plot_sec=edges_NR_sec(2:length(edges_NR_sec))-(edges_NR_sec(2)/2);

bar(edges_NR_plot_sec,[Values_WT_NR' Values_HOM_NR']);
%legend('WT','HOM');
hold on
errorbar([edges_NR_plot_sec'-25 edges_NR_plot_sec'+25],[Values_WT_NR' Values_HOM_NR'],[SEM_WT_NR' SEM_HOM_NR'],'.','Color','k')
xticks(edges_NR_sec);
xlabel('Duration (seconds)');
ylabel('Number of episodes');
%ylim([0 60]);
title('Distribution of episode durations - NR');

figure() %%% R, Light and dark combined, absolute numbers of episodes

Values_WT_R=mean(Ep_Dur_all_WT_R,1);Values_HOM_R=mean(Ep_Dur_all_HOM_R,1);
SEM_WT_R=std(Ep_Dur_all_WT_R,0,1)/sqrt(n_WT);SEM_HOM_R=std(Ep_Dur_all_HOM_R,0,1)/sqrt(n_HOM);

edges_R_plot_sec=edges_R_sec(2:length(edges_R_sec))-(edges_R_sec(2)/2);

bar(edges_R_plot_sec,[Values_WT_R' Values_HOM_R']);
%legend('WT','HOM');
hold on
errorbar([edges_R_plot_sec'-6 edges_R_plot_sec'+6],[Values_WT_R' Values_HOM_R'],[SEM_WT_R' SEM_HOM_R'],'.','Color','k')
xticks(edges_R_sec);
xlabel('Duration (seconds)');
ylabel('Number of episodes');
%ylim([0 60]);
title('Distribution of episode durations - R');


%%%%%%% Creating normalised data, for L and D combined
Ep_Dur_all_WT_NR_norm=Ep_Dur_all_WT_NR;
Ep_Dur_all_WT_R_norm=Ep_Dur_all_WT_R;

Ep_Dur_all_HOM_NR_norm=Ep_Dur_all_HOM_NR;
Ep_Dur_all_HOM_R_norm=Ep_Dur_all_HOM_R;

for n=1:n_WT
    Ep_Dur_all_WT_NR_norm(n,:)=Ep_Dur_all_WT_NR(n,:)/(WT_NR(n,1)+WT_NR(n,2));% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_WT_R_norm(n,:)=Ep_Dur_all_WT_R(n,:)/(WT_R(n,1)+WT_R(n,2));
end
for n=1:n_HOM
    Ep_Dur_all_HOM_NR_norm(n,:)=Ep_Dur_all_HOM_NR(n,:)/(HOM_NR(n,1)+HOM_NR(n,2));% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_HOM_R_norm(n,:)=Ep_Dur_all_HOM_R(n,:)/(HOM_R(n,1)+HOM_R(n,2));
end

figure() %%% NR, Light and dark combined, % of episodes

Values_WT_NR_norm=mean(Ep_Dur_all_WT_NR_norm,1);Values_HOM_NR_norm=mean(Ep_Dur_all_HOM_NR_norm,1);
SEM_WT_NR_norm=std(Ep_Dur_all_WT_NR_norm,0,1)/sqrt(n_WT);SEM_HOM_NR_norm=std(Ep_Dur_all_HOM_NR_norm,0,1)/sqrt(n_HOM);

edges_NR_plot_sec=[1:1:7];%edges_NR_sec(2:length(edges_NR_sec))-(edges_NR_sec(2)/2);

bar([Values_WT_NR_norm' Values_HOM_NR_norm']);
% bar(edges_NR_plot_sec,[Values_WT_NR_norm' Values_HOM_NR_norm']);
%legend('WT','HOM');
hold on
errorbar([edges_NR_plot_sec'-0.15 edges_NR_plot_sec'+0.15],[Values_WT_NR_norm' Values_HOM_NR_norm'],[SEM_WT_NR_norm' SEM_HOM_NR_norm'],'.','Color','k')
% xticks(edges_NR_sec);
xticklabels({'[16-32[','[32-64[','[64-128[','[128-256[','[256-512[','[512-1024[','\geq 1024'});
xlabel('Duration (seconds)');
ylabel('% of episodes');
%ylim([0 60]);
title('Distribution of episode durations - NR');

figure() %%% R, Light and dark combined, % of episodes

Values_WT_R_norm=mean(Ep_Dur_all_WT_R_norm,1);Values_HOM_R_norm=mean(Ep_Dur_all_HOM_R_norm,1);
SEM_WT_R_norm=std(Ep_Dur_all_WT_R_norm,0,1)/sqrt(n_WT);SEM_HOM_R_norm=std(Ep_Dur_all_HOM_R_norm,0,1)/sqrt(n_HOM);

edges_R_plot_sec=[1:1:8];%edges_R_sec(2:length(edges_R_sec))-(edges_R_sec(2)/2);

bar(edges_R_plot_sec,[Values_WT_R_norm' Values_HOM_R_norm']);
%legend('WT','HOM');
hold on
errorbar([edges_R_plot_sec'-0.15 edges_R_plot_sec'+0.15],[Values_WT_R_norm' Values_HOM_R_norm'],[SEM_WT_R_norm' SEM_HOM_R_norm'],'.','Color','k')
%xticks(edges_R_sec);
xticklabels({'\leq 20','[20-40[','[40-60[','[60-80[','[80-100[','[100-120[','[120-140[','\geq 140'});
xlabel('Duration (seconds)');
ylabel('% of episodes');
%ylim([0 60]);
title('Distribution of episode durations - R');


%%% Looking at mean wake episodes duration


for n=1:n_WT
WT_W_L_mean(n,1)=mean(WT_W_L{n,1},2)*4/60;% 4/60 to convert to minutes
WT_W_D_mean(n,1)=mean(WT_W_D{n,1},2)*4/60;
WT_W_LD_mean(n,1)=mean([WT_W_L{n,1},WT_W_D{n,1}],2)*4/60;
end

for n=1:n_WT
HOM_W_L_mean(n,1)=mean(HOM_W_L{n,1},2)*4/60;
HOM_W_D_mean(n,1)=mean(HOM_W_D{n,1},2)*4/60;
HOM_W_LD_mean(n,1)=mean([HOM_W_L{n,1},WT_W_D{n,1}],2)*4/60;
end

figure() %L&D separated
subplot(1,2,1)
notBoxPlot([WT_W_L_mean(:,1) HOM_W_L_mean(:,1)])
title('Wake - Light');
ylabel('Mean episode duration (min)'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_W_D_mean(:,1) HOM_W_D_mean(:,1)])
title('Wake - Dark');
ylabel('Mean episode duration (min)');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});

figure() % L&D combined

notBoxPlot([WT_W_LD_mean(:,1) HOM_W_LD_mean(:,1)])
title('Wake - L&D');
ylabel('Mean episode duration (min)'); 
set(gca,'XTickLabel',{'WT','HOM'});

