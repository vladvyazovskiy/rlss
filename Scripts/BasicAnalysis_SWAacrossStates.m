% Plot mean spectra across genotypes and basic plots
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

x_hour=[0:24/21600:24];x_hour=x_hour(1:21600);

%spectra
WT_NR=zeros(5,21600);WT_R=zeros(5,21600);WT_W=zeros(5,21600);WT_swa=zeros(5,21600);
HOM_NR=zeros(5,21600);HOM_R=zeros(5,21600);HOM_W=zeros(5,21600);HOM_swa=zeros(5,21600);




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
            

           WT_swa(n,:)=nanmean(Spectr(:,3:17),2)';
           WT_swa_norm(n,:)=WT_swa(n,:)/nanmean(WT_swa(n,:))*100;
           
           Wake_swa=WT_swa_norm(n,:);Wake_logical=zeros(1,21600);Wake_logical(W)=1;Wake_swa(Wake_logical==0)=NaN;
           NR_swa=WT_swa_norm(n,:);NR_logical=zeros(1,21600);NR_logical(NR)=1;NR_swa(NR_logical==0)=NaN;
           R_swa=WT_swa_norm(n,:);R_logical=zeros(1,21600);R_logical(R)=1;R_swa(R_logical==0)=NaN;
        end
        
    end
    subplot(5,1,n)
    plot(x_hour,Wake_swa);
    hold on
    plot(x_hour,NR_swa);
    hold on
    plot(x_hour,R_swa);
    
    legend('W','NR','R');
    title('WT');
    ylim([0 700])
    xlim([0 24])
    ylabel('EEG SWA (% of 24-h mean)');

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
            

           HOM_swa(n,:)=nanmean(Spectr(:,3:17),2)';
           HOM_swa_norm(n,:)=HOM_swa(n,:)/nanmean(HOM_swa(n,:))*100;
           
           Wake_swa=HOM_swa_norm(n,:);Wake_logical=zeros(1,21600);Wake_logical(W)=1;Wake_swa(Wake_logical==0)=NaN;
           NR_swa=HOM_swa_norm(n,:);NR_logical=zeros(1,21600);NR_logical(NR)=1;NR_swa(NR_logical==0)=NaN;
           R_swa=HOM_swa_norm(n,:);R_logical=zeros(1,21600);R_logical(R)=1;R_swa(R_logical==0)=NaN;
        end
        
    end
    subplot(5,1,n)
    plot(x_hour,Wake_swa);
    hold on
    plot(x_hour,NR_swa);
    hold on
    plot(x_hour,R_swa);
    
    legend('W','NR','R');
    title('HOM');
    ylim([0 700])
    xlim([0 24])
    ylabel('EEG SWA (% of 24-h mean)');

end


