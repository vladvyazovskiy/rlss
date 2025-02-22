% Calculate number of episodes of each vigilance state
clear all
%close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


der='fro';
n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WT_SDdays=['101117';'101117';'171117';'171117';'210318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);


% To record episode numbers - 1st column: Light, 2nd column: dark, 3rd
% column L&D combined.
WT_NR=zeros(5,3);WT_R=zeros(5,3);WT_ba=zeros(5,3);
HOM_NR=zeros(5,3);HOM_R=zeros(5,3);HOM_ba=zeros(5,3);


%%%%%PARAMETERS
mindur_NR=44;%14
mindur_R=1;
ba=4;% works for NR
ba_R=1;
%For brief awakenings, a minimum duration of 1 is chosen and no
%interruptions allowed.
edges_NR=[0:50:300];%edges_NR=[4 8 16 32 64 128 256 2000];edges_NR_sec=[16 32 64 128 256 512 1024 8000];%edges_NR=[0:50:450];edges_NR_sec=[0:4*50:4*450];%edges_NR=[0:50:300];
edges_R=[0:10:60];%edges_R=[0 5 10 15 20 25 30 35 125];edges_R_sec=[0 20 40 60 80 100 120 140 500];%edges_R=[0:10:70];edges_R_sec=[0:4*10:4*70];%edges_R=[0:10:60];

Ep_Dur_all_WT_NR_L=zeros(n_WT,length(edges_NR)-1);Ep_Dur_all_WT_R_L=zeros(n_WT,length(edges_R)-1);
Ep_Dur_all_HOM_NR_L=zeros(n_HOM,length(edges_NR)-1);Ep_Dur_all_HOM_R_L=zeros(n_HOM,length(edges_R)-1);


Ep_Dur_all_WT_NR_D=zeros(n_WT,length(edges_NR)-1);Ep_Dur_all_WT_R_D=zeros(n_WT,length(edges_R)-1);
Ep_Dur_all_HOM_NR_D=zeros(n_HOM,length(edges_NR)-1);Ep_Dur_all_HOM_R_D=zeros(n_HOM,length(edges_R)-1);

All_episodes_WT_NR_L=cell(5,1);All_episodes_WT_R_L=cell(5,1);
All_episodes_HOM_NR_L=cell(5,1);All_episodes_HOM_R_L=cell(5,1);

All_episodes_WT_NR_D=cell(5,1);All_episodes_WT_R_D=cell(5,1);
All_episodes_HOM_NR_D=cell(5,1);All_episodes_HOM_R_D=cell(5,1);




%WT animals

for n=1:5
    
    mouse=WTnames(n,:);
    day=WT_SDdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            
            nrem=zeros(1,10800);nrem(nr((5400<nr)&(nr<7201)))=1;nrem(nr2((5400<nr2)&(nr2<7201)))=1;
            rem=zeros(1,10800);rem(r((5400<r)&(r<7201)))=1;rem(r3((5400<r3)&(r3<7201)))=1;
            baw=zeros(1,10800);baw(mt((5400<mt)&(mt<7201)))=1;
            
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            All_episodes_WT_NR_L{n,1}=EpDur_NR;All_episodes_WT_R_L{n,1}=EpDur_R;
            
            WT_NR(n,1)=length(EpDur_NR);WT_R(n,1)=length(EpDur_R);WT_ba(n,1)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_WT_NR_L(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_WT_R_L(n,:)=histcounts(EpDur_R,edges_R);
           

        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                        
            
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            All_episodes_WT_NR_D{n,1}=EpDur_NR;All_episodes_WT_R_D{n,1}=EpDur_R;
            
            WT_NR(n,2)=length(EpDur_NR);WT_R(n,2)=length(EpDur_R);WT_ba(n,2)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_WT_NR_D(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_WT_R_D(n,:)=histcounts(EpDur_R,edges_R);
            
            
        end
        
    end


end


%HOM animals
figure(2)
for n=1:5
    
    mouse=HOMnames(n,:);
    day=HOM_SDdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
   for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            
            nrem=zeros(1,10800);nrem(nr((5400<nr)&(nr<7201)))=1;nrem(nr2((5400<nr2)&(nr2<7201)))=1;
            rem=zeros(1,10800);rem(r((5400<r)&(r<7201)))=1;rem(r3((5400<r3)&(r3<7201)))=1;
            baw=zeros(1,10800);baw(mt((5400<mt)&(mt<7201)))=1;
           
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            All_episodes_HOM_NR_L{n,1}=EpDur_NR;All_episodes_HOM_R_L{n,1}=EpDur_R;
            
            HOM_NR(n,1)=length(EpDur_NR);HOM_R(n,1)=length(EpDur_R);HOM_ba(n,1)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_HOM_NR_L(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_HOM_R_L(n,:)=histcounts(EpDur_R,edges_R);
            

        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            All_episodes_HOM_NR_D{n,1}=EpDur_NR;All_episodes_HOM_R_D{n,1}=EpDur_R;
            
            HOM_NR(n,2)=length(EpDur_NR);HOM_R(n,2)=length(EpDur_R);HOM_ba(n,2)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            Ep_Dur_all_HOM_NR_D(n,:)=histcounts(EpDur_NR,edges_NR);Ep_Dur_all_HOM_R_D(n,:)=histcounts(EpDur_R,edges_R);

            
        end
        
    end
   

end

k=18;

figure(1+k)
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

figure(2+k)
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

figure(3+k)
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



%%%Histograms of episode durations concatenated across animals

figure(4+k)
Values_WT_NR_L=mean(Ep_Dur_all_WT_NR_L,1);Values_HOM_NR_L=mean(Ep_Dur_all_HOM_NR_L,1);
SEM_WT_NR_L=std(Ep_Dur_all_WT_NR_L,0,1)/sqrt(n_WT);SEM_HOM_NR_L=std(Ep_Dur_all_HOM_NR_L,0,1)/sqrt(n_HOM);

Values_WT_NR_D=mean(Ep_Dur_all_WT_NR_D,1);Values_HOM_NR_D=mean(Ep_Dur_all_HOM_NR_D,1);
SEM_WT_NR_D=std(Ep_Dur_all_WT_NR_D,0,1)/sqrt(n_WT);SEM_HOM_NR_D=std(Ep_Dur_all_HOM_NR_D,0,1)/sqrt(n_HOM);

edges_NR_plot=edges_NR(1:length(edges_NR)-1);

subplot(1,2,1)
bar(edges_NR_plot,[Values_WT_NR_L' Values_HOM_NR_L']);
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_L' Values_HOM_NR_L'],[SEM_WT_NR_L' SEM_HOM_NR_L'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
%ylim([0 60]);
title('Distribution of episode durations - NR - L');



subplot(1,2,2)
bar(edges_NR_plot,[Values_WT_NR_D' Values_HOM_NR_D']);
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_D' Values_HOM_NR_D'],[SEM_WT_NR_D' SEM_HOM_NR_D'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
%ylim([0 60]);
title('Distribution of episode durations - NR - D');



figure(5+k)
Values_WT_R_L=mean(Ep_Dur_all_WT_R_L,1);Values_HOM_R_L=mean(Ep_Dur_all_HOM_R_L,1);
SEM_WT_R_L=std(Ep_Dur_all_WT_R_L,0,1)/sqrt(n_WT);SEM_HOM_R_L=std(Ep_Dur_all_HOM_R_L,0,1)/sqrt(n_HOM);

Values_WT_R_D=mean(Ep_Dur_all_WT_R_D,1);Values_HOM_R_D=mean(Ep_Dur_all_HOM_R_D,1);
SEM_WT_R_D=std(Ep_Dur_all_WT_R_D,0,1)/sqrt(n_WT);SEM_HOM_R_D=std(Ep_Dur_all_HOM_R_D,0,1)/sqrt(n_HOM);

edges_R_plot=edges_R(1:length(edges_R)-1);

subplot(1,2,1)
bar(edges_R_plot,[Values_WT_R_L' Values_HOM_R_L']);
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_L' Values_HOM_R_L'],[SEM_WT_R_L' SEM_HOM_R_L'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
%ylim([0 25]);
title('Distribution of episode durations - R - L');



subplot(1,2,2)
bar(edges_R_plot,[Values_WT_R_D' Values_HOM_R_D'])
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_D' Values_HOM_R_D'],[SEM_WT_R_D' SEM_HOM_R_D'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('Number of episodes');
%ylim([0 25]);
title('Distribution of episode durations - R - D');



%%%Histograms of episode durations concatenated across animals and
%%%normalised against total number of episodes of a given state
Ep_Dur_all_WT_NR_L_norm=Ep_Dur_all_WT_NR_L;Ep_Dur_all_WT_NR_D_norm=Ep_Dur_all_WT_NR_D;
Ep_Dur_all_WT_R_L_norm=Ep_Dur_all_WT_R_L;Ep_Dur_all_WT_R_D_norm=Ep_Dur_all_WT_R_D;

Ep_Dur_all_HOM_NR_L_norm=Ep_Dur_all_HOM_NR_L;Ep_Dur_all_HOM_NR_D_norm=Ep_Dur_all_HOM_NR_D;
Ep_Dur_all_HOM_R_L_norm=Ep_Dur_all_HOM_R_L;Ep_Dur_all_HOM_R_D_norm=Ep_Dur_all_HOM_R_D;

for n=1:n_WT
    Ep_Dur_all_WT_NR_L_norm(n,:)=Ep_Dur_all_WT_NR_L(n,:)/WT_NR(n,1);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_WT_R_L_norm(n,:)=Ep_Dur_all_WT_R_L(n,:)/WT_R(n,1);
    
    Ep_Dur_all_WT_NR_D_norm(n,:)=Ep_Dur_all_WT_NR_D(n,:)/WT_NR(n,2);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_WT_R_D_norm(n,:)=Ep_Dur_all_WT_R_D(n,:)/WT_R(n,2);
    
end
for n=1:n_HOM
    Ep_Dur_all_HOM_NR_L_norm(n,:)=Ep_Dur_all_HOM_NR_L(n,:)/HOM_NR(n,1);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_HOM_R_L_norm(n,:)=Ep_Dur_all_HOM_R_L(n,:)/HOM_R(n,1);
    
    Ep_Dur_all_HOM_NR_D_norm(n,:)=Ep_Dur_all_HOM_NR_D(n,:)/HOM_NR(n,2);% Colonne 1=light, 2= dark, 3=light and dark combined
    Ep_Dur_all_HOM_R_D_norm(n,:)=Ep_Dur_all_HOM_R_D(n,:)/HOM_R(n,2);
    
end

figure(6+k)
Values_WT_NR_L_norm=mean(Ep_Dur_all_WT_NR_L_norm,1);Values_HOM_NR_L_norm=mean(Ep_Dur_all_HOM_NR_L_norm,1);
SEM_WT_NR_L_norm=std(Ep_Dur_all_WT_NR_L_norm,0,1)/sqrt(n_WT);SEM_HOM_NR_L_norm=std(Ep_Dur_all_HOM_NR_L_norm,0,1)/sqrt(n_HOM);

Values_WT_NR_D_norm=mean(Ep_Dur_all_WT_NR_D_norm,1);Values_HOM_NR_D_norm=mean(Ep_Dur_all_HOM_NR_D_norm,1);
SEM_WT_NR_D_norm=std(Ep_Dur_all_WT_NR_D_norm,0,1)/sqrt(n_WT);SEM_HOM_NR_D_norm=std(Ep_Dur_all_HOM_NR_D_norm,0,1)/sqrt(n_HOM);

edges_NR_plot=edges_NR(1:length(edges_NR)-1);

subplot(1,2,1)
bar(edges_NR_plot,[Values_WT_NR_L_norm' Values_HOM_NR_L_norm']);
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_L_norm' Values_HOM_NR_L_norm'],[SEM_WT_NR_L_norm' SEM_HOM_NR_L_norm'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 0.8]);
title('Distribution of episode durations - NR - L');



subplot(1,2,2)
bar(edges_NR_plot,[Values_WT_NR_D_norm' Values_HOM_NR_D_norm']);
hold on
errorbar([edges_NR_plot'-6 edges_NR_plot'+6],[Values_WT_NR_D_norm' Values_HOM_NR_D_norm'],[SEM_WT_NR_D_norm' SEM_HOM_NR_D_norm'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 0.8]);
title('Distribution of episode durations - NR - D');


%%%
figure(7+k)
Values_WT_R_L_norm=mean(Ep_Dur_all_WT_R_L_norm,1);Values_HOM_R_L_norm=mean(Ep_Dur_all_HOM_R_L_norm,1);
SEM_WT_R_L_norm=std(Ep_Dur_all_WT_R_L_norm,0,1)/sqrt(n_WT);SEM_HOM_R_L_norm=std(Ep_Dur_all_HOM_R_L_norm,0,1)/sqrt(n_HOM);

Values_WT_R_D_norm=mean(Ep_Dur_all_WT_R_D_norm,1);Values_HOM_R_D_norm=mean(Ep_Dur_all_HOM_R_D_norm,1);
SEM_WT_R_D_norm=std(Ep_Dur_all_WT_R_D_norm,0,1)/sqrt(n_WT);SEM_HOM_R_D_norm=std(Ep_Dur_all_HOM_R_D_norm,0,1)/sqrt(n_HOM);

edges_R_plot=edges_R(1:length(edges_R)-1);

subplot(1,2,1)
bar(edges_R_plot,[Values_WT_R_L_norm' Values_HOM_R_L_norm']);
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_L_norm' Values_HOM_R_L_norm'],[SEM_WT_R_L_norm' SEM_HOM_R_L_norm'],'.','Color','k')
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 0.8]);
title('Distribution of episode durations - R - L');



subplot(1,2,2)
bar(edges_R_plot,[Values_WT_R_D_norm' Values_HOM_R_D_norm'])
hold on
errorbar([edges_R_plot'-1.5 edges_R_plot'+1.5],[Values_WT_R_D_norm' Values_HOM_R_D_norm'],[SEM_WT_R_D_norm' SEM_HOM_R_D_norm'],'.','Color','k')
set(gca,'Color',[0.4 0.4 0.4]);
xlabel('Duration (nbre of epochs)');
ylabel('% of episodes');
ylim([0 0.8]);
title('Distribution of episode durations - R - D');


% Jitter plots of all NR - L episodes' lengths for individual animals
figure(8+k)
for n=1:5
    subplot(1,10,n)
    notBoxPlot((All_episodes_WT_NR_L{n,1})'*4/60,'style','line')
    ylabel('Episode duration (min)')
    ylim([0 32])
end
for n=1:5
    subplot(1,10,n+5)
    notBoxPlot((All_episodes_HOM_NR_L{n,1})'*4/60,'style','line')
    ylabel('Episode duration (min)')
    ylim([0 32])
end

% As above but taking one value per animal

Mean_NRep_length_WT_L=zeros(5,1);Mean_NRep_length_HOM_L=zeros(5,1);
for n=1:5
    Mean_NRep_length_WT_L(n,1)=mean(All_episodes_WT_NR_L{n,1});
    Mean_NRep_length_HOM_L(n,1)=mean(All_episodes_HOM_NR_L{n,1});
end

figure(9+k)

notBoxPlot([Mean_NRep_length_WT_L Mean_NRep_length_HOM_L]*4/60)
ylabel('Episode duration (min)');
set(gca,'XTickLabel',{'WT','HOM'});
title('NR episodes - 2h after SD (light)');