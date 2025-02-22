% Calculate total amount in each state in baseline 24h
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5



der='fro';

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%sleep/wake times
WT_time_NR=zeros(5,1);WT_time_R=zeros(5,1);WT_time_W=zeros(5,1);
HOM_time_NR=zeros(5,1);HOM_time_R=zeros(5,1);HOM_time_W=zeros(5,1);

WT_time_NR_L=zeros(5,1);WT_time_R_L=zeros(5,1);WT_time_W_L=zeros(5,1);
HOM_time_NR_L=zeros(5,1);HOM_time_R_L=zeros(5,1);HOM_time_W_L=zeros(5,1);

WT_time_NR_D=zeros(5,1);WT_time_R_D=zeros(5,1);WT_time_W_D=zeros(5,1);
HOM_time_NR_D=zeros(5,1);HOM_time_R_D=zeros(5,1);HOM_time_W_D=zeros(5,1);

%WT animals
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
           
            WT_time_NR_L(n,1)=(length(nr)+length(nr2))*4/3600;
            WT_time_R_L(n,1)=(length(r)+length(r3))*4/3600;
            WT_time_W_L(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
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
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            HOM_time_NR_L(n,1)=(length(nr)+length(nr2))*4/3600;
            HOM_time_R_L(n,1)=(length(r)+length(r3))*4/3600;
            HOM_time_W_L(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            HOM_time_NR_D(n,1)=(length(nr)+length(nr2))*4/3600;
            HOM_time_R_D(n,1)=(length(r)+length(r3))*4/3600;
            HOM_time_W_D(n,1)=(length(w)+length(w1)+length(mt))*4/3600;
            
        end
        
    end

end

WT_time_NR=WT_time_NR_L+WT_time_NR_D;
WT_time_R=WT_time_R_L+WT_time_R_D;
WT_time_W=WT_time_W_L+WT_time_W_D;

HOM_time_NR=HOM_time_NR_L+HOM_time_NR_D;
HOM_time_R=HOM_time_R_L+HOM_time_R_D;
HOM_time_W=HOM_time_W_L+HOM_time_W_D;

%%%%%%%%Matrix of times

WT_times_mean=zeros(1,3); HOM_times_mean=zeros(1,3);
WT_times_mean(1,1)=mean(WT_time_NR);HOM_times_mean(1,1)=mean(HOM_time_NR);
WT_times_mean(1,2)=mean(WT_time_R);HOM_times_mean(1,2)=mean(HOM_time_R);
WT_times_mean(1,3)=mean(WT_time_W);HOM_times_mean(1,3)=mean(HOM_time_W);

Times_means=table(WT_times_mean',HOM_times_mean','VariableNames', {'WT', 'HOM'},'RowNames',{'NREM','REM','Wake'})

WT_times_std=zeros(1,3); HOM_times_std=zeros(1,3);
WT_times_std(1,1)=std(WT_time_NR);HOM_times_std(1,1)=std(HOM_time_NR);
WT_times_std(1,2)=std(WT_time_R);HOM_times_std(1,2)=std(HOM_time_R);
WT_times_std(1,3)=std(WT_time_W);HOM_times_std(1,3)=std(HOM_time_W);

Times_stds=table(WT_times_std',HOM_times_std','VariableNames', {'WT', 'HOM'},'RowNames',{'NREM','REM','Wake'})

Times_sems=table(WT_times_std'/sqrt(5),HOM_times_std'/sqrt(5),'VariableNames', {'WT', 'HOM'},'RowNames',{'NREM','REM','Wake'})
%%%%%%%% Plot
figure(1)

ax(1)=subplot(1,3,1);
h1=notBoxPlot([WT_time_NR,HOM_time_NR]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Time spent in NREM')

ax(2)=subplot(1,3,2);
h2=notBoxPlot([WT_time_R,HOM_time_R]);
title('Time spent in REM')
set(gca,'XTickLabel',{'WT','HOM'});

ax(2)=subplot(1,3,3);
h2=notBoxPlot([WT_time_W,HOM_time_W]);
title('Time spent in wake')
set(gca,'XTickLabel',{'WT','HOM'});


figure(2)
%NREM 
subplot(1,2,1)
notBoxPlot([WT_time_NR_L HOM_time_NR_L])
title('NREM - Light');
ylabel('Time(h)'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_time_NR_D HOM_time_NR_D])
title('NREM - Dark');
ylabel('Time(h)');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});


figure(3)
%NREM 
subplot(1,2,1)
notBoxPlot([WT_time_R_L HOM_time_R_L])
title('REM - Light');
ylabel('Time(h)'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_time_R_D HOM_time_R_D])
title('REM - Dark');
ylabel('Time(h)');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});

figure(4)
%NREM 
subplot(1,2,1)
notBoxPlot([WT_time_W_L HOM_time_W_L])
title('Wake - Light');
ylabel('Time(h)'); 
set(gca,'XTickLabel',{'WT','HOM'});

subplot(1,2,2)
notBoxPlot([WT_time_W_D HOM_time_W_D])
title('Wake - Dark');
ylabel('Time(h)');
set(gca,'Color',[0.4 0.4 0.4]);
set(gca,'XTickLabel',{'WT','HOM'});


%%%% Proportion of REM sleep compared to total sleep time

%Rappel:
% WT_time_NR=WT_time_NR_L+WT_time_NR_D;
% WT_time_R=WT_time_R_L+WT_time_R_D;
% WT_time_W=WT_time_W_L+WT_time_W_D;
% 
% HOM_time_NR=HOM_time_NR_L+HOM_time_NR_D;
% HOM_time_R=HOM_time_R_L+HOM_time_R_D;
% HOM_time_W=HOM_time_W_L+HOM_time_W_D;


Prop_REM_WT=WT_time_R./(WT_time_NR+WT_time_R);
Prop_REM_HOM=HOM_time_R./(HOM_time_NR+HOM_time_R);

figure(5)

h1=notBoxPlot([Prop_REM_WT,Prop_REM_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('REM as proportion of total sleep time')
ylabel('% total sleep time')
xlabel('Genotype')

