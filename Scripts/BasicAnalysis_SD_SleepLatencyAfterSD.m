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

%Matrices to record the first 20 NR indices after the end of SD
Start_NR_WT=zeros(5,1);
Start_NR_HOM=zeros(5,1);
WT_NRlatencies=zeros(5,20); WT_NR2latencies=zeros(5,20);
HOM_NRlatencies=zeros(5,20); HOM_NR2latencies=zeros(5,20);

Check_NR_WT=zeros(5,10800); nr_postSD_WT=zeros(5,5401);
Check_NR_HOM=zeros(5,10800);nr_postSD_HOM=zeros(5,5401);

EndSD=5400; % 6*3600/4 = 5400


for d=2
    %WT animals
    for n=1:5
        
        mouse=WTnames(n,:);
        day=WTdays(n,:);
        SDday=WT_SDdays(n,:);
        pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
        pathin=[pathin1,'outputVS/'];
        
        
                
        LD='L';
        
        fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];

        eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
        
        Check_NR_WT(n,nr)=1;Check_NR_WT(n,nr2)=1;
        
        nr_postSD_WT(n,:)=Check_NR_WT(n,5400:10800);
        
        k=1;
        while sum(nr_postSD_WT(n,k:k+19))<16 % I want episodes of at least 1min (15 epochs), allowing for 4 epochs of ba if need be
            k=k+1;
        end
        
        while nr_postSD_WT(n,k)~=1 % As I allow a short ba above, it is possible that at place k, nr==0, so I go and search for the first 1 (which may be up to 4 columns later at most)
            k=k+1;
        end
        Start_NR_WT(n)=k;
        WT_NRlatencies(n,:)=nr_postSD_WT(k:k+19);
        

    end
        
    
    
    
    %HOM animals
    for n=1:5
        
        mouse=HOMnames(n,:);
        day=HOMdays(n,:);
        SDday=HOM_SDdays(n,:);
        pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
        pathin=[pathin1,'outputVS/'];
        
        
        LD='L';
        

        fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];

        
        eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
        
        Check_NR_HOM(n,nr)=1;Check_NR_HOM(n,nr2)=1;
        
        nr_postSD_HOM(n,:)=Check_NR_HOM(n,5400:10800);
        
        k=1;
        while sum(nr_postSD_HOM(n,k:k+19))<16 % I want episodes of at least 1min (15 epochs), allowing for 4 epochs of ba if need be
            k=k+1;
        end
        
        while nr_postSD_HOM(n,k)~=1 % As I allow a short ba above, it is possible that at place k, nr==0, so I go and search for the first 1 (which may be up to 4 columns later at most)
            k=k+1;
        end
        Start_NR_HOM(n)=k;
        HOM_NRlatencies(n,:)=nr_postSD_HOM(k:k+19);
        
    end
        
end

Latency_WT=(Start_NR_WT-1)*4/60;
Latency_HOM=(Start_NR_HOM-1)*4/60;

Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;


figure()
h1=notBoxPlot([Latency_WT,Latency_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Latency to enter NR following SD')
ylabel('Time (min)')

figure()

%WT
errorbar(1,mean(Latency_WT,'omitnan'),std(Latency_WT,'omitnan')/sqrt(length(Latency_WT)),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot(1,Latency_WT,'.k')
hold on
%Rlss
errorbar(2,mean(Latency_HOM,'omitnan'),std(Latency_HOM,'omitnan')/sqrt(length(Latency_HOM)),'o','Color',Colours(2,:)+0.2,'LineWidth',2)
hold on
plot(2,Latency_HOM,'.k')

xlim([0 3])
xticks(1:2)
xticklabels({'WT','Rlss'})
sgtitle('Latency to enter NR following SD')
ylabel('Time (min)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;







    