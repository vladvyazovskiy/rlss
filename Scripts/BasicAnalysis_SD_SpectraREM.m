% Plot mean spectra across genotypes and basic plots
clear all
%close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


der='occ';
n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
WT_SDdays=['101117';'101117';'171117';'171117';'210318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%spectra
WT_spectr_BL=zeros(5,81);WT_spectr_SD=zeros(5,81,4);
HOM_spectr_BL=zeros(5,81);HOM_spectr_SD=zeros(5,81,4);



%WT animals
for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    SDday=WT_SDdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
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
                    WT_spectr_BL(n,:)=nanmean(Spectr(R,:));%./mean(mean(spectr(nr,3:81)));
                else
                    R_logical=zeros(21600,1);R_logical(R)=1;
                    Spectr_R=Spectr; Spectr_R(R_logical==0,:)=NaN;
                    
                    for h=1:4
                        WT_spectr_SD(n,:,h)=nanmean(Spectr_R((2*h+4)*900+1:(2*(h+1)+4)*900,:));
                        WT_spectr_SD(n,:,h)=WT_spectr_SD(n,:,h)./WT_spectr_BL(n,:)*100;
                    end
                    
                end
                
            end
            
        end
    end

end


%HOM animals
for n=1:n_HOM
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    SDday=HOM_SDdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
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
                    HOM_spectr_BL(n,:)=nanmean(Spectr(R,:));%./mean(mean(spectr(nr,3:81)));
                else
                    R_logical=zeros(21600,1);R_logical(R)=1;
                    Spectr_R=Spectr; Spectr_R(R_logical==0,:)=NaN;
                    
                    for h=1:4
                        HOM_spectr_SD(n,:,h)=nanmean(Spectr_R((2*h+4)*900+1:(2*(h+1)+4)*900,:));
                        HOM_spectr_SD(n,:,h)=HOM_spectr_SD(n,:,h)./HOM_spectr_BL(n,:)*100;
                    end
                    
                end
                
            end
            
        end
    end

end

f=0:0.25:20;

%%%%%%%% WT
figure()

for h=1:3%4
errorbar(f,mean(WT_spectr_SD(:,:,h),1),std(WT_spectr_SD(:,:,h))/sqrt(n_WT),'LineWidth',2) 
hold on
end

grid on
legend('ZT6-8','ZT8-10','ZT10-12')%,'ZT12-14')
title('WT - Spectra in REM following SD (normalised against BL)');
ylim([0 300])
ylabel('REMS relative spectra (% of baseline mean)');
xlabel('Frequency (Hz)');

%%%%%%%% HOM
figure()

for h=1:3%4
errorbar(f,mean(HOM_spectr_SD(:,:,h),1),std(HOM_spectr_SD(:,:,h))/sqrt(n_HOM),'LineWidth',2) 
hold on
end

grid on
legend('ZT6-8','ZT8-10','ZT10-12')%,'ZT12-14')
title('HOM - Spectra in REM following SD (normalised against BL)');
ylim([0 300])
ylabel('REMS relative spectra (% of baseline mean)');
xlabel('Frequency (Hz)');

%%%%% WT and HOM only first two hours
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

figure()
shadedErrorBar(f,mean(WT_spectr_SD(:,:,1),1),std(WT_spectr_SD(:,:,1))/sqrt(n_WT),'lineProps',{'LineWidth',2,'Color',Colours(1,:)})
hold on
shadedErrorBar(f,mean(HOM_spectr_SD(:,:,1),1),std(HOM_spectr_SD(:,:,1))/sqrt(n_HOM),'lineProps',{'LineWidth',2,'Color',Colours(2,:)})
hold on
plot([0 20],[100 100],'k')

legend('WT','Rlss','Box','off')
title('Spectra in REM in 2h following SD (normalised against BL)');
ylim([0 250])
ylabel('REMS relative spectra (% of BL mean)');
xlabel('Frequency (Hz)');
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

% For transfer of data to SPSS
WT_Spectr_SD_ZT6_8=WT_spectr_SD(:,:,1);
HOM_Spectr_SD_ZT6_8=HOM_spectr_SD(:,:,1);
WT_Spectr_SD_ZT8_10=WT_spectr_SD(:,:,2);
HOM_Spectr_SD_ZT8_10=HOM_spectr_SD(:,:,2);
WT_Spectr_SD_ZT10_12=WT_spectr_SD(:,:,3);
HOM_Spectr_SD_ZT10_12=HOM_spectr_SD(:,:,3);
WT_Spectr_SD_ZT12_14=WT_spectr_SD(:,:,4);
HOM_Spectr_SD_ZT12_14=HOM_spectr_SD(:,:,4);



% To transfer values to Excel for Gareth
Mean_WT_Fro=mean(WT_spectr_SD(:,:,1),1);
SEM_WT_Fro=std(WT_spectr_SD(:,:,1))/sqrt(n_WT);
Mean_HOM_Fro=mean(HOM_spectr_SD(:,:,1),1);
SEM_HOM_Fro=std(HOM_spectr_SD(:,:,1))/sqrt(n_HOM);
