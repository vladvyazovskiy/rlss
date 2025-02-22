% Plot mean spectra across genotypes and basic plots
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5

der='occ';
n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WT_SDdays=['101117';'101117';'171117';'171117';'210318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%spectra
WT_spectr_NR=zeros(5,81);WT_spectr_R=zeros(5,81);WT_spectr_W=zeros(5,81);
HOM_spectr_NR=zeros(5,81);HOM_spectr_R=zeros(5,81);HOM_spectr_W=zeros(5,81);



%WT animals
for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WT_SDdays(n,:);
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
    day=HOM_SDdays(n,:);
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

%%%%%%%% NREM
figure(1)

hAx=axes;
hAx.YScale='log';
hold all
errorbar(f,mean(WT_spectr_NR),std(WT_spectr_NR)/sqrt(n_WT),'LineWidth',2) 

hold on
errorbar(f,mean(HOM_spectr_NR),std(HOM_spectr_NR)/sqrt(n_HOM),'LineWidth',2) 

grid on
legend('WT','HOM')
title('NREM spectra SD day -  occ');



%%%%%%%%%%% REM
figure(2)

hAx=axes;
hAx.YScale='log';
hold all
errorbar(f,mean(WT_spectr_R),std(WT_spectr_R)/sqrt(n_WT),'LineWidth',2) 

hold on
errorbar(f,mean(HOM_spectr_R),std(HOM_spectr_R)/sqrt(n_HOM),'LineWidth',2) 

grid on
legend('WT','HOM')
title('REM spectra SD day- occ');


%%%%%%%%%%% Wake
figure(3)

hAx=axes;
hAx.YScale='log';
hold all
errorbar(f,mean(WT_spectr_W),std(WT_spectr_W)/sqrt(n_WT),'LineWidth',2) 

hold on
errorbar(f,mean(HOM_spectr_W),std(HOM_spectr_W)/sqrt(n_HOM),'LineWidth',2) 

grid on
legend('WT','HOM')
title('Wake spectra SD day - occ');




%%%%%% Plot one figure for WT (NR, R, W curves) and HOM (NR,R, W curves)
%%%%%% separately

figure(4)

hAx=axes;
hAx.YScale='log';
hold all
errorbar(f,mean(WT_spectr_W),std(WT_spectr_W)/sqrt(n_WT),'LineWidth',2) 

hold on
errorbar(f,mean(WT_spectr_NR),std(WT_spectr_NR)/sqrt(n_WT),'LineWidth',2) 

hold on
errorbar(f,mean(WT_spectr_R),std(WT_spectr_R)/sqrt(n_WT),'LineWidth',2) 


grid on
legend('Wake','NREM','REM')
title('OCC WT - SD day');

%%%
figure(5)

hAx=axes;
hAx.YScale='log';
hold all
errorbar(f,mean(HOM_spectr_W),std(HOM_spectr_W)/sqrt(n_HOM),'LineWidth',2) 

hold on
errorbar(f,mean(HOM_spectr_NR),std(HOM_spectr_NR)/sqrt(n_HOM),'LineWidth',2) 

hold on
errorbar(f,mean(HOM_spectr_R),std(HOM_spectr_R)/sqrt(n_HOM),'LineWidth',2) 


grid on
legend('Wake','NREM','REM')
title('OCC HOM - SD day');






WT_spectr_NR_log=log10(WT_spectr_NR);
WT_spectr_R_log=log10(WT_spectr_R);
WT_spectr_W_log=log10(WT_spectr_W);

HOM_spectr_NR_log=log10(HOM_spectr_NR);
HOM_spectr_R_log=log10(HOM_spectr_R);
HOM_spectr_W_log=log10(HOM_spectr_W);


%%% For transfer to Excel for Gareth
Mean_WT_NR=mean(WT_spectr_NR);
SEM_WT_NR=std(WT_spectr_NR)/sqrt(n_WT);
Mean_HOM_NR=mean(HOM_spectr_NR);
SEM_HOM_NR=std(HOM_spectr_NR)/sqrt(n_HOM);

Mean_WT_R=mean(WT_spectr_R);
SEM_WT_R=std(WT_spectr_R)/sqrt(n_WT);
Mean_HOM_R=mean(HOM_spectr_R);
SEM_HOM_R=std(HOM_spectr_R)/sqrt(n_HOM);

Mean_WT_W=mean(WT_spectr_W);
SEM_WT_W=std(WT_spectr_W)/sqrt(n_WT);
Mean_HOM_W=mean(HOM_spectr_W);
SEM_HOM_W=std(HOM_spectr_W)/sqrt(n_HOM);






