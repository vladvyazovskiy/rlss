% Plot mean spectra across genotypes and basic plots
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/';%'F:\Sleepy6EEG-November2017\';
path2018='/Volumes/Elements/Sleepy6EEG-March2018/';%'G:\Sleepy6EEG-March2018\';


der='LFP';%'fro' ; 'occ'
n_WT=3;
n_HOM=5;

WTnames=char('Fe','He','Qu');
WTdays=['091117';'161117';'200318'];
WT_SDdays=['101117';'171117';'210318'];
pathWT=char(path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);


%spectra
WT_swa=zeros(n_WT,2*21600);
HOM_swa=zeros(n_HOM,2*21600);




%WT animals

for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    SDday=WT_SDdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    Wake_logical=zeros(1,43200);NR_logical=zeros(1,43200);R_logical=zeros(1,43200);
    for d=1:2
        for ld=1:2
            if ld==1
                
                LD='L';
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                
                W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
                
                
            else
                LD='D';
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                
                W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
                NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
                R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
                Spectr=vertcat(Spectr_L,spectr);
                art=[W1;NR2;R3;MT];
                Spectr(art,:)=NaN;
                
                
                if d==1
                    WT_swa(n,1:21600)=nanmean(Spectr(:,3:17),2)';
                    Wake_logical(W)=1;NR_logical(NR)=1;R_logical(R)=1;
                else
                    WT_swa(n,21601:43200)=nanmean(Spectr(:,3:17),2)';
                    Wake_logical(W+21600)=1;NR_logical(NR+21600)=1;R_logical(R+21600)=1;
                end
                
                
                
                
                
                
            end
            
            
        end
    end
    WT_swa(n,NR_logical==0)=NaN;
    WT_swa_norm(n,:)=WT_swa(n,:)/nanmean(WT_swa(n,1:21600))*100;


end


%HOM animals

for n=1:n_HOM
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    SDday=HOM_SDdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    Wake_logical=zeros(1,43200);NR_logical=zeros(1,43200);R_logical=zeros(1,43200);
    for d=1:2
        for ld=1:2
            if ld==1
                
                LD='L';
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                
                W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
                
                
            else
                LD='D';
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                
                W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
                NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
                R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
                Spectr=vertcat(Spectr_L,spectr);
                art=[W1;NR2;R3;MT];
                Spectr(art,:)=NaN;
                
                if d==1
                    HOM_swa(n,1:21600)=nanmean(Spectr(:,3:17),2)';
                    Wake_logical(W)=1;NR_logical(NR)=1;R_logical(R)=1;
                else
                    HOM_swa(n,21601:43200)=nanmean(Spectr(:,3:17),2)';
                    Wake_logical(W+21600)=1;NR_logical(NR+21600)=1;R_logical(R+21600)=1;
                end
                

            end
            
        end
    end
    HOM_swa(n,NR_logical==0)=NaN;
    HOM_swa_norm(n,:)=HOM_swa(n,:)/nanmean(HOM_swa(n,1:21600))*100;
                
               
                
end

%Averaging to get one value per 2-h bin
NR_swa_WT_2h=zeros(n_WT,24);
NR_swa_HOM_2h=zeros(n_HOM,24);

for h=1:24
    NR_swa_WT_2h(:,h)=nanmean(WT_swa_norm(:,(h-1)*2*3600/4+1:2*h*3600/4),2);
    NR_swa_HOM_2h(:,h)=nanmean(HOM_swa_norm(:,(h-1)*2*3600/4+1:2*h*3600/4),2);
end

NR_swa_WT_2h(:,13:15)=NaN;
NR_swa_HOM_2h(:,13:15)=NaN;

figure(1)
x=1:2:48;
errorbar(x,mean(NR_swa_WT_2h),std(NR_swa_WT_2h)/sqrt(n_WT),'-o','MarkerSize',4);
hold on
errorbar(x,mean(NR_swa_HOM_2h),std(NR_swa_HOM_2h)/sqrt(n_HOM),'-o','MarkerSize',4);
legend('WT','HOM')
xlabel('ZT (hours)');
ylabel('SWA in NREM normalised against baseline - 2-h bins')
grid on

%%% Plotting for Rlss paper 2
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;


figure()
x=1:2:12;
errorbar(x-0.1,mean(NR_swa_WT_2h(:,13:18)),std(NR_swa_WT_2h(:,13:18))/sqrt(n_WT),'-o','MarkerSize',4,'Color',Colours(1,:),'LineWidth',2);
hold on
errorbar(x+0.1,mean(NR_swa_HOM_2h(:,13:18)),std(NR_swa_HOM_2h(:,13:18))/sqrt(n_HOM),'-o','MarkerSize',4,'Color',Colours(2,:)+0.2,'LineWidth',2);
legend('WT','HOM')
legend boxoff
xlabel('ZT (h)');
ylabel('SWA in NREMS (% BL mean)')
xlim([6 12])
xticks(6:2:12)
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
title('Light phase - post sleep deprivation')


