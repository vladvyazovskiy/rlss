% Calculate total amount in each state in baseline 24h
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


der='fro';

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
WT_SDdays=['101117';'101117';'171117';'171117';'210318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%sleep/wake times
WT_time_NR=zeros(5,1);WT_time_R=zeros(5,1);WT_time_W=zeros(5,1);
HOM_time_NR=zeros(5,1);HOM_time_R=zeros(5,1);HOM_time_W=zeros(5,1);

WT_time_NR_L=zeros(5,1);WT_time_R_L=zeros(5,1);WT_time_W_L=zeros(5,1);
HOM_time_NR_L=zeros(5,1);HOM_time_R_L=zeros(5,1);HOM_time_W_L=zeros(5,1);

WT_time_NR_D=zeros(5,1);WT_time_R_D=zeros(5,1);WT_time_W_D=zeros(5,1);
HOM_time_NR_D=zeros(5,1);HOM_time_R_D=zeros(5,1);HOM_time_W_D=zeros(5,1);

%%%% Preparing matrices to record the time spent in each state in the 2h/
%%%% 6h/ 18h following the 6h-SD.

WT_time_NR_2h=zeros(5,1);WT_time_R_2h=zeros(5,1);WT_time_W_2h=zeros(5,1);
HOM_time_NR_2h=zeros(5,1);HOM_time_R_2h=zeros(5,1);HOM_time_W_2h=zeros(5,1);

WT_time_NR_6h=zeros(5,1);WT_time_R_6h=zeros(5,1);WT_time_W_6h=zeros(5,1);
HOM_time_NR_6h=zeros(5,1);HOM_time_R_6h=zeros(5,1);HOM_time_W_6h=zeros(5,1);

WT_time_NR_18h=zeros(5,1);WT_time_R_18h=zeros(5,1);WT_time_W_18h=zeros(5,1);
HOM_time_NR_18h=zeros(5,1);HOM_time_R_18h=zeros(5,1);HOM_time_W_18h=zeros(5,1);


%WT animals
for n=1:5
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    SDday=WT_SDdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';

            fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];

            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            WT_time_NR_L(n,1)=(length(nr)+length(nr2))*4/3600;
            WT_time_R_L(n,1)=(length(r)+length(r3))*4/3600;
            WT_time_W_L(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
            
            WT_time_NR_2h(n,1)=(length(nr((5400<nr)&(nr<7201)))+length(nr2((5400<nr2)&(nr2<7201))))*4/3600;
            WT_time_R_2h(n,1)=(length(r((5400<r)&(r<7201)))+length(r3((5400<r3)&(r3<7201))))*4/3600;
            WT_time_W_2h(n,1)=(length(w((5400<w)&(w<7201)))+length(w1((5400<w1)&(w1<7201)))+length(mt((5400<mt)&(mt<7201))))*4/3600;
            
            WT_time_NR_6h(n,1)=(length(nr(nr>5400))+length(nr2(nr2>5400)))*4/3600;
            WT_time_R_6h(n,1)=(length(r(r>5400))+length(r3(r3>5400)))*4/3600;
            WT_time_W_6h(n,1)=(length(w(w>5400))+length(w1(w1>5400))+length(mt(mt>5400)))*4/3600;
            
            
        else
            LD='D';
                        
            fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                       
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            WT_time_NR_D(n,1)=(length(nr)+length(nr2))*4/3600;
            WT_time_R_D(n,1)=(length(r)+length(r3))*4/3600;
            WT_time_W_D(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
            
        end
        
    end
    
end


%HOM animals
for n=1:5
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    SDday=HOM_SDdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            HOM_time_NR_L(n,1)=(length(nr)+length(nr2))*4/3600;
            HOM_time_R_L(n,1)=(length(r)+length(r3))*4/3600;
            HOM_time_W_L(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
            
            HOM_time_NR_2h(n,1)=(length(nr((5400<nr)&(nr<7201)))+length(nr2((5400<nr2)&(nr2<7201))))*4/3600;
            HOM_time_R_2h(n,1)=(length(r((5400<r)&(r<7201)))+length(r3((5400<r3)&(r3<7201))))*4/3600;
            HOM_time_W_2h(n,1)=(length(w((5400<w)&(w<7201)))+length(w1((5400<w1)&(w1<7201)))+length(mt((5400<mt)&(mt<7201))))*4/3600;
            
            HOM_time_NR_6h(n,1)=(length(nr(nr>5400))+length(nr2(nr2>5400)))*4/3600;
            HOM_time_R_6h(n,1)=(length(r(r>5400))+length(r3(r3>5400)))*4/3600;
            HOM_time_W_6h(n,1)=(length(w(w>5400))+length(w1(w1>5400))+length(mt(mt>5400)))*4/3600;
            
        else
            LD='D';

            fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
     
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            HOM_time_NR_D(n,1)=(length(nr)+length(nr2))*4/3600;
            HOM_time_R_D(n,1)=(length(r)+length(r3))*4/3600;
            HOM_time_W_D(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
            
        end
        
    end
    

end
%Totals over the 24h of the SD day
WT_time_NR=WT_time_NR_L+WT_time_NR_D;
WT_time_R=WT_time_R_L+WT_time_R_D;
WT_time_W=WT_time_W_L+WT_time_W_D;

HOM_time_NR=HOM_time_NR_L+HOM_time_NR_D;
HOM_time_R=HOM_time_R_L+HOM_time_R_D;
HOM_time_W=HOM_time_W_L+HOM_time_W_D;


%Only taking into account the 18h following SD
WT_time_NR_18h=WT_time_NR_6h+WT_time_NR_D;
WT_time_R_18h=WT_time_R_6h+WT_time_R_D;
WT_time_W_18h=WT_time_W_6h+WT_time_W_D;

HOM_time_NR_18h=HOM_time_NR_6h+HOM_time_NR_D;
HOM_time_R_18h=HOM_time_R_6h+HOM_time_R_D;
HOM_time_W_18h=HOM_time_W_6h+HOM_time_W_D;


%%%%%%%%Matrices of times

WT_times_mean=zeros(1,3); HOM_times_mean=zeros(1,3);
WT_times_mean(1,1)=mean(WT_time_NR);HOM_times_mean(1,1)=mean(HOM_time_NR);
WT_times_mean(1,2)=mean(WT_time_R);HOM_times_mean(1,2)=mean(HOM_time_R);
WT_times_mean(1,3)=mean(WT_time_W);HOM_times_mean(1,3)=mean(HOM_time_W);



WT_times_std=zeros(1,3); HOM_times_std=zeros(1,3);
WT_times_std(1,1)=std(WT_time_NR);HOM_times_std(1,1)=std(HOM_time_NR);
WT_times_std(1,2)=std(WT_time_R);HOM_times_std(1,2)=std(HOM_time_R);
WT_times_std(1,3)=std(WT_time_W);HOM_times_std(1,3)=std(HOM_time_W);

%%%%%%%% Plots
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;


figure()

ax(1)=subplot(1,3,1);
h1=notBoxPlot([WT_time_NR,HOM_time_NR]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in NREM - SD day (24h)')
ylabel('Time (hours)')

ax(2)=subplot(1,3,2);
h2=notBoxPlot([WT_time_R,HOM_time_R]);
title('Time spent in REM - SD day (24h)')
set(gca,'XTickLabel',{'WT','HOM'});
ylabel('Time (hours)')

ax(2)=subplot(1,3,3);
h2=notBoxPlot([WT_time_W,HOM_time_W]);
title('Time spent in wake - SD day (24h)')
set(gca,'XTickLabel',{'WT','HOM'});
ylabel('Time (hours)')


figure()

ax(1)=subplot(1,3,1);
h1=notBoxPlot([WT_time_NR_2h,HOM_time_NR_2h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in NREM - 2h after SD')
ylabel('Time (hours)')

ax(2)=subplot(1,3,2);
h2=notBoxPlot([WT_time_NR_6h,HOM_time_NR_6h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in NREM - 6h after SD')
ylabel('Time (hours)')

ax(2)=subplot(1,3,3);
h3=notBoxPlot([WT_time_NR_18h,HOM_time_NR_18h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in NREM - 18h after SD')
ylabel('Time (hours)')

figure()

ax(1)=subplot(1,3,1);
h1=notBoxPlot([WT_time_R_2h,HOM_time_R_2h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in REM - 2h after SD')
ylabel('Time (hours)')

ax(2)=subplot(1,3,2);
h2=notBoxPlot([WT_time_R_6h,HOM_time_R_6h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in REM - 6h after SD')
ylabel('Time (hours)')

ax(2)=subplot(1,3,3);
h3=notBoxPlot([WT_time_R_18h,HOM_time_R_18h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in REM - 18h after SD')
ylabel('Time (hours)')

figure()

ax(1)=subplot(1,3,1);
h1=notBoxPlot([WT_time_W_2h,HOM_time_W_2h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in wake - 2h after SD')
ylabel('Time (hours)')

ax(2)=subplot(1,3,2);
h2=notBoxPlot([WT_time_W_6h,HOM_time_W_6h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in wake - 6h after SD')
ylabel('Time (hours)')

ax(2)=subplot(1,3,3);
h3=notBoxPlot([WT_time_W_18h,HOM_time_W_18h]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in wake - 18h after SD')
ylabel('Time (hours)')

%% NREMS
figure()

subplot(1,3,1)
errorbar(1,mean(WT_time_NR_2h,'omitnan'),std(WT_time_NR_2h,'omitnan')/sqrt(length(WT_time_NR_2h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_NR_2h,'.k')
hold on
errorbar(2,mean(HOM_time_NR_2h,'omitnan'),std(HOM_time_NR_2h,'omitnan')/sqrt(length(HOM_time_NR_2h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_NR_2h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in NREMS - 2h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,3,2)
errorbar(1,mean(WT_time_NR_6h,'omitnan'),std(WT_time_NR_6h,'omitnan')/sqrt(length(WT_time_NR_6h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_NR_6h,'.k')
hold on
errorbar(2,mean(HOM_time_NR_6h,'omitnan'),std(HOM_time_NR_6h,'omitnan')/sqrt(length(HOM_time_NR_6h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_NR_6h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in NREMS - 6h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,3,3)
errorbar(1,mean(WT_time_NR_18h,'omitnan'),std(WT_time_NR_18h,'omitnan')/sqrt(length(WT_time_NR_18h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_NR_18h,'.k')
hold on
errorbar(2,mean(HOM_time_NR_18h,'omitnan'),std(HOM_time_NR_18h,'omitnan')/sqrt(length(HOM_time_NR_18h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_NR_18h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in NREMS - 18h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
sgtitle('NREMS')

%% REMS

figure()

subplot(1,3,1)
errorbar(1,mean(WT_time_R_2h,'omitnan'),std(WT_time_R_2h,'omitnan')/sqrt(length(WT_time_R_2h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_R_2h,'.k')
hold on
errorbar(2,mean(HOM_time_R_2h,'omitnan'),std(HOM_time_R_2h,'omitnan')/sqrt(length(HOM_time_R_2h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_R_2h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in REMS - 2h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,3,2)
errorbar(1,mean(WT_time_R_6h,'omitnan'),std(WT_time_R_6h,'omitnan')/sqrt(length(WT_time_R_6h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_R_6h,'.k')
hold on
errorbar(2,mean(HOM_time_R_6h,'omitnan'),std(HOM_time_R_6h,'omitnan')/sqrt(length(HOM_time_R_6h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_R_6h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in REMS - 6h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,3,3)
errorbar(1,mean(WT_time_R_18h,'omitnan'),std(WT_time_R_18h,'omitnan')/sqrt(length(WT_time_R_18h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_R_18h,'.k')
hold on
errorbar(2,mean(HOM_time_R_18h,'omitnan'),std(HOM_time_R_18h,'omitnan')/sqrt(length(HOM_time_R_18h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_R_18h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in REMS - 18h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
sgtitle('REMS')


%%Wake

figure()

subplot(1,3,1)
errorbar(1,mean(WT_time_W_2h,'omitnan'),std(WT_time_W_2h,'omitnan')/sqrt(length(WT_time_W_2h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_W_2h,'.k')
hold on
errorbar(2,mean(HOM_time_W_2h,'omitnan'),std(HOM_time_W_2h,'omitnan')/sqrt(length(HOM_time_W_2h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_W_2h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in wake - 2h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,3,2)
errorbar(1,mean(WT_time_W_6h,'omitnan'),std(WT_time_W_6h,'omitnan')/sqrt(length(WT_time_W_6h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_W_6h,'.k')
hold on
errorbar(2,mean(HOM_time_W_6h,'omitnan'),std(HOM_time_W_6h,'omitnan')/sqrt(length(HOM_time_W_6h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_W_6h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in wake - 6h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,3,3)
errorbar(1,mean(WT_time_W_18h,'omitnan'),std(WT_time_W_18h,'omitnan')/sqrt(length(WT_time_W_18h)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,WT_time_W_18h,'.k')
hold on
errorbar(2,mean(HOM_time_W_18h,'omitnan'),std(HOM_time_W_18h,'omitnan')/sqrt(length(HOM_time_W_18h)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,HOM_time_W_18h,'.k')
xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
title('Time spent in wake - 18h after SD')
ylabel('Time (hours)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
sgtitle('Wake')