% Plot mean spectra across genotypes and basic plots
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


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


x=0:48/43200:48;
x=x(1:43200);

%WT animals
figure(1)
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
                WT_swa_norm(n,:)=WT_swa(n,:)/nanmean(WT_swa(n,1:21600))*100;
                
                Wake_swa=WT_swa_norm(n,:);Wake_swa(Wake_logical==0)=NaN;
                NR_swa=WT_swa_norm(n,:);NR_swa(NR_logical==0)=NaN;
                R_swa=WT_swa_norm(n,:);R_swa(R_logical==0)=NaN;
            end
            
        end
    end
    subplot(n_WT,1,n)
    plot(x,Wake_swa);
    hold on
    plot(x,NR_swa);
    hold on
    plot(x,R_swa);
    xlim([0 48]);
    
    legend('W','NR','R');
    title('WT');
    ylim([0 1000])
    ylabel('EEG SWA (% of 24-h BL mean)');

end


%HOM animals
figure(2)
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
                HOM_swa_norm(n,:)=HOM_swa(n,:)/nanmean(HOM_swa(n,1:21600))*100;
                
                Wake_swa=HOM_swa_norm(n,:);Wake_swa(Wake_logical==0)=NaN;
                NR_swa=HOM_swa_norm(n,:);NR_swa(NR_logical==0)=NaN;
                R_swa=HOM_swa_norm(n,:);R_swa(R_logical==0)=NaN;
            end
            
        end
    end
    subplot(n_HOM,1,n)
    plot(x,Wake_swa);
    hold on
    plot(x,NR_swa);
    hold on
    plot(x,R_swa);
    xlim([0 48]);
    legend('W','NR','R');
    title('HOM');
    ylim([0 800])
    ylabel('EEG SWA (% of 24-h BL mean)');
    
end


