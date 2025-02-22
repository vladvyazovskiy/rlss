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
WT_SDdays=['101117';'171117';'210318'];
pathWT=char(path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%spectra
WT_spectr_BL=zeros(n_WT,81);WT_spectr_SD=zeros(n_WT,81,4);
HOM_spectr_BL=zeros(n_HOM,81);HOM_spectr_SD=zeros(n_HOM,81,4);



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
                    WT_spectr_BL(n,:)=nanmean(Spectr(NR,:));%./mean(mean(spectr(nr,3:81)));
                else
                    NR_logical=zeros(21600,1);NR_logical(NR)=1;
                    Spectr_NR=Spectr; Spectr_NR(NR_logical==0,:)=NaN;
                    
                    for h=1:4
                        WT_spectr_SD(n,:,h)=nanmean(Spectr_NR((2*h+4)*900+1:(2*(h+1)+4)*900,:));
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
                    HOM_spectr_BL(n,:)=nanmean(Spectr(NR,:));%./mean(mean(spectr(nr,3:81)));
                else
                    NR_logical=zeros(21600,1);NR_logical(NR)=1;
                    Spectr_NR=Spectr; Spectr_NR(NR_logical==0,:)=NaN;
                    
                    for h=1:4
                        HOM_spectr_SD(n,:,h)=nanmean(Spectr_NR((2*h+4)*900+1:(2*(h+1)+4)*900,:));
                        HOM_spectr_SD(n,:,h)=HOM_spectr_SD(n,:,h)./HOM_spectr_BL(n,:)*100;
                    end
                    
                end
                
            end
            
        end
    end

end

f=0:0.25:20;


Colours_WT=[0.40 0.40 0.60;... %WT
    0.40 0.40 0.60;... %WT
    0.40 0.40 0.60;... %WT
    0.40 0.40 0.60]; %WT
Colours_WT(2,:)=Colours_WT(2,:)-0.1;
Colours_WT(3,:)=Colours_WT(2,:)-0.2;
Colours_WT(4,:)=Colours_WT(2,:)-0.3;

Colours_Rlss=[0.68 0.85 0.90;... %WT
    0.68 0.85 0.90;... %WT
    0.68 0.85 0.90;... %WT
    0.68 0.85 0.90]; %WT
Colours_Rlss(2,:)=Colours_Rlss(2,:)-0.1;
Colours_Rlss(3,:)=Colours_Rlss(2,:)-0.2;
Colours_Rlss(4,:)=Colours_Rlss(2,:)-0.3;


%%%%%%%% WT
figure(1)

for h=1:3%1:4
shadedErrorBar(f,mean(WT_spectr_SD(:,:,h),1),std(WT_spectr_SD(:,:,h))/sqrt(n_WT),'lineProps',{'LineWidth',2,'Color',Colours_WT(h,:)}) 
hold on
end

%grid on
legend('ZT6-8','ZT8-10','ZT10-12','ZT12-14','Box','off')
title('WT - Spectra in NREM following SD (normalised against BL)');
ylim([0 300])
ylabel('NREMS relative spectra (% of BL mean)');
xlabel('Frequency (Hz)');
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

%%%%%%%% HOM
figure(2)

for h=1:3%1:4
    shadedErrorBar(f,mean(HOM_spectr_SD(:,:,h),1),std(HOM_spectr_SD(:,:,h))/sqrt(n_HOM),'lineProps',{'LineWidth',2,'Color',Colours_Rlss(h,:)})
    hold on
end

%grid on
legend('ZT6-8','ZT8-10','ZT10-12','ZT12-14','Box','off')
title('Rlss - Spectra in NREM following SD (normalised against BL)');
ylim([0 300])
ylabel('NREMS relative spectra (% of BL mean)');
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


