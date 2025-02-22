% Plot mean spectra across genotypes and basic plots
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


der='LFP';
n_WT=3;
n_HOM=5;

WTnames=char('Fe','He','Qu');
WTdays=['091117';'161117';'200318'];
pathWT=char(path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);


%spectra
WT_spectr_NR=zeros(n_WT,81);WT_spectr_R=zeros(n_WT,81);WT_spectr_W=zeros(n_WT,81);
HOM_spectr_NR=zeros(n_HOM,81);HOM_spectr_R=zeros(n_HOM,81);HOM_spectr_W=zeros(n_HOM,81);



%WT animals
for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            
            
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
            NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
            R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
            Spectr=vertcat(Spectr_L,spectr);
            art=[W1;NR2;R3;MT];
            Spectr(art,:)=NaN;
            
            
            WT_spectr_NR(n,:)=nanmean(Spectr(NR,:));%./mean(mean(spectr(nr,3:81)));
            WT_spectr_R(n,:)=nanmean(Spectr(R,:));%./mean(mean(spectr(r,3:81)));
            WT_spectr_W(n,:)=nanmean(Spectr(W,:));%./mean(mean(spectr(w,3:81)));
            
%             WT_time_NR(n,1)=(length(NR)+length(NR2))*4/3600;
%             WT_time_R(n,1)=(length(R)+length(R3))*4/3600;
%             WT_time_W(n,1)=(length(W)+length(W1)+length(MT))*4/3600;
            
        end
        
    end

end


%HOM animals
for n=1:n_HOM
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
   for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt;Spectr_L=spectr;
            
            
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
            W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
            NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
            R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
            Spectr=vertcat(Spectr_L,spectr);
            art=[W1;NR2;R3;MT];
            Spectr(art,:)=NaN;
            
            
            HOM_spectr_NR(n,:)=nanmean(Spectr(NR,:));%./mean(mean(spectr(nr,3:81)));
            HOM_spectr_R(n,:)=nanmean(Spectr(R,:));%./mean(mean(spectr(r,3:81)));
            HOM_spectr_W(n,:)=nanmean(Spectr(W,:));%./mean(mean(spectr(w,3:81)));
            
%             HOM_time_NR(n,1)=(length(NR)+length(NR2))*4/3600;
%             HOM_time_R(n,1)=(length(R)+length(R3))*4/3600;
%             HOM_time_W(n,1)=(length(W)+length(W1)+length(MT))*4/3600;
            
        end
        
    end

end

f=0:0.25:20;
Colours=[0.40 0.40 0.60;...
    0.68 0.85 0.90];
Colours=Colours-0.2;

%%%%%%%% NREM
figure(1)

hAx=axes;
hAx.YScale='log';
hold all
shadedErrorBar(f,mean(WT_spectr_NR),std(WT_spectr_NR)/sqrt(n_WT),'lineProps',{'LineWidth',2,'Color',Colours(1,:)}) 

hold on
shadedErrorBar(f,mean(HOM_spectr_NR),std(HOM_spectr_NR)/sqrt(n_HOM),'lineProps',{'LineWidth',2,'Color',Colours(2,:)}) 

%grid on
legend('WT','Rlss','Box','off')
title('NREM spectra -  LFP');
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
xlabel('Frequency (Hz)')
ylabel('Power density (uV^2/0.25Hz)')


%%%%%%%%%%% REM
figure(2)

hAx=axes;
hAx.YScale='log';
hold all
shadedErrorBar(f,mean(WT_spectr_R),std(WT_spectr_R)/sqrt(n_WT),'lineProps',{'LineWidth',2,'Color',Colours(1,:)}) 

hold on
shadedErrorBar(f,mean(HOM_spectr_R),std(HOM_spectr_R)/sqrt(n_HOM),'lineProps',{'LineWidth',2,'Color',Colours(2,:)}) 

%grid on
legend('WT','Rlss','Box','off')
title('REM spectra - LFP');
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
xlabel('Frequency (Hz)')
ylabel('Power density (uV^2/0.25Hz)')


%%%%%%%%%%% Wake
figure(3)

hAx=axes;
hAx.YScale='log';
hold all
shadedErrorBar(f,mean(WT_spectr_W),std(WT_spectr_W)/sqrt(n_WT),'lineProps',{'LineWidth',2,'Color',Colours(1,:)}) 

hold on
shadedErrorBar(f,mean(HOM_spectr_W),std(HOM_spectr_W)/sqrt(n_HOM),'lineProps',{'LineWidth',2,'Color',Colours(2,:)}) 

%grid on
legend('WT','Rlss','Box','off')
title('Wake spectra - LFP');
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
xlabel('Frequency (Hz)')
ylabel('Power density (uV^2/0.25Hz)')


%%% Adding p_value indications

load('Workspace_comparisons_Spectra_sleepy6_Chapter4_FromLogTransformedValues.mat')

Fro_NREM=FRO_NR_LOG;
Fro_REM=FRO_R_LOG;
Fro_Wake=FRO_W_LOG;

Occ_NREM=OCC_NR_LOG;
Occ_REM=OCC_R_LOG;
Occ_Wake=OCC_W_LOG;

LFP_NREM=LFP_NR_LOG;
LFP_REM=LFP_R_LOG;
LFP_Wake=LFP_W_LOG;

f=0:0.25:20;

Odd_indices=1:2:162;

Pval_Fro_NREM=Fro_NREM(Odd_indices);
Pval_Fro_REM=Fro_REM(Odd_indices);
Pval_Fro_Wake=Fro_Wake(Odd_indices);

Pval_Occ_NREM=Occ_NREM(Odd_indices);
Pval_Occ_REM=Occ_REM(Odd_indices);
Pval_Occ_Wake=Occ_Wake(Odd_indices);

Pval_LFP_NREM=LFP_NREM(Odd_indices);
Pval_LFP_REM=LFP_REM(Odd_indices);
Pval_LFP_Wake=LFP_Wake(Odd_indices);


Pval_Fro_NREM(Pval_Fro_NREM>0.05)=2;Pval_Fro_NREM(Pval_Fro_NREM<0.0501)=3;Pval_Fro_NREM(Pval_Fro_NREM==2)=NaN;
Pval_Fro_REM(Pval_Fro_REM>0.05)=2;Pval_Fro_REM(Pval_Fro_REM<0.0501)=3;Pval_Fro_REM(Pval_Fro_REM==2)=NaN;
Pval_Fro_Wake(Pval_Fro_Wake>0.05)=2;Pval_Fro_Wake(Pval_Fro_Wake<0.0501)=3;Pval_Fro_Wake(Pval_Fro_Wake==2)=NaN;

Pval_Occ_NREM(Pval_Occ_NREM>0.05)=2;Pval_Occ_NREM(Pval_Occ_NREM<0.0501)=3;Pval_Occ_NREM(Pval_Occ_NREM==2)=NaN;
Pval_Occ_REM(Pval_Occ_REM>0.05)=2;Pval_Occ_REM(Pval_Occ_REM<0.0501)=3;Pval_Occ_REM(Pval_Occ_REM==2)=NaN;
Pval_Occ_Wake(Pval_Occ_Wake>0.05)=2;Pval_Occ_Wake(Pval_Occ_Wake<0.0501)=3;Pval_Occ_Wake(Pval_Occ_Wake==2)=NaN;

Pval_LFP_NREM(Pval_LFP_NREM>0.05)=2;Pval_LFP_NREM(Pval_LFP_NREM<0.0501)=3;Pval_LFP_NREM(Pval_LFP_NREM==2)=NaN;
Pval_LFP_REM(Pval_LFP_REM>0.05)=2;Pval_LFP_REM(Pval_LFP_REM<0.0501)=3;Pval_LFP_REM(Pval_LFP_REM==2)=NaN;
Pval_LFP_Wake(Pval_LFP_Wake>0.05)=2;Pval_LFP_Wake(Pval_LFP_Wake<0.0501)=3;Pval_LFP_Wake(Pval_LFP_Wake==2)=NaN;


figure(1)
hold on
h=plot(f,Pval_LFP_NREM,'k','LineWidth',2);
for l=1:length(h)
    h(l).Annotation.LegendInformation.IconDisplayStyle = 'off';
end
xlim([0 20]);

figure(2)
hold on
h=plot(f,Pval_LFP_REM,'k','LineWidth',2);
for l=1:length(h)
    h(l).Annotation.LegendInformation.IconDisplayStyle = 'off';
end
xlim([0 20]);

figure(3)
hold on
h=plot(f,Pval_LFP_Wake,'k','LineWidth',2);
for l=1:length(h)
    h(l).Annotation.LegendInformation.IconDisplayStyle = 'off';
end
xlim([0 20]);


WT_spectr_NR_log=log10(WT_spectr_NR);
WT_spectr_R_log=log10(WT_spectr_R);
WT_spectr_W_log=log10(WT_spectr_W);

HOM_spectr_NR_log=log10(HOM_spectr_NR);
HOM_spectr_R_log=log10(HOM_spectr_R);
HOM_spectr_W_log=log10(HOM_spectr_W);

