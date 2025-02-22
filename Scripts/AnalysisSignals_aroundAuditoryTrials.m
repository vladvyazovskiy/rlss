clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


n_WT=5;
n_HOM=5;


pathWT={path2017,path2017,path2017,path2017,path2018};

pathHOM={path2017,path2018,path2018,path2018,path2018};


WT={'Ed';'Fe';'He';'Le';'Qu'};
Rstl={'Ju';'Me';'Ne';'Oc';'Ph'};

Phases_BL_L_WT_aud={'201117L';'201117L';'201117L';'201117L';'280318L'};
Phases_BL_L_WT={'091117L';'091117L';'161117L';'161117L';'200318L'};
Phases_BL_D_WT={'091117D';'091117D';'161117D';'161117D';'200318D'};
Phases_SD_L_WT={'101117L';'101117L';'171117L';'171117L';'210318L'};
Phases_SD_D_WT={'101117D';'101117D';'171117D';'171117D';'210318D'};
Phases_WT=[Phases_BL_L_WT Phases_BL_D_WT Phases_SD_L_WT Phases_SD_D_WT];

Phases_BL_L_Rstl_aud={'201117L';'280318L';'280318L';'280318L';'280318L'};
Phases_BL_L_Rstl={'161117L';'200318L';'200318L';'200318L';'200318L'};
Phases_BL_D_Rstl={'161117D';'200318D';'200318D';'200318D';'200318D'};
Phases_SD_L_Rstl={'171117L';'210318L';'210318L';'210318L';'210318L'};
Phases_SD_D_Rstl={'171117D';'210318D';'210318D';'210318D';'210318D'};
Phases_Rstl=[Phases_BL_L_Rstl Phases_BL_D_Rstl Phases_SD_L_Rstl Phases_SD_D_Rstl];

% Filename_In='Qu_200318_L_BasicCluster.mat';
% load(Filename_In);

LFP_Allmice_WT=cell(1,5);
EEGfro_Allmice_WT=cell(1,5);
EEGocc_Allmice_WT=cell(1,5);
EMG_Allmice_WT=cell(1,5);
AU_Allmice_WT=cell(1,5);

LFP_Allmice_Rlss=cell(1,5);
EEGfro_Allmice_Rlss=cell(1,5);
EEGocc_Allmice_Rlss=cell(1,5);
EMG_Allmice_Rlss=cell(1,5);
AU_Allmice_Rlss=cell(1,5);

for genotype=1:2 % 1=WT, 2=Rstl
    for anm=1:5
        
        if genotype==2 && anm==2 % No values for Me
        else
            
            
            
            for phase=1%phase_scope % AU L, AU D 
                if genotype==1
                    Names=WT;
                    phase_name=Phases_WT{anm,phase};
                    phase_name_aud=Phases_BL_L_WT_aud{anm,phase};
                    path=pathWT{anm};
                else
                    Names=Rstl;
                    phase_name=Phases_Rstl{anm,phase};
                    phase_name_aud=Phases_BL_L_Rstl_aud{anm,phase};
                    path=pathHOM{anm};
                end
                mousename=Names{anm};
                if phase==1
                    end_name='Newclustering';recorddate=[phase_name_aud(1:end-1),'_L'];
                else
                    end_name='Newclustering_wPresets';
                end
                filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',mousename,'_',phase_name,'_',end_name,'.mat'];
                load(filename);
                
%                 VS_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',mousename,'_',phase_name(1:6),'_',phase_name(7),'_fro_VSspec.mat'];
%                 load(VS_filename);
                
                Start_OFF=OFFDATA.StartOP;
                End_OFF=OFFDATA.EndOP;
                
                
                pathSignals=[path,'OutputSignals/'];
                pathAud=[path,'OutputAuditory/'];
                pathout=[path,'Auditory_Analysis_TrialResults/']; %mkdir(pathout)
                block=[mousename,'_',recorddate];
                lfpCH=OFFDATA.Channels; %Oc
                %lfpCH=[6 14]; %Ga
                %lfpCH=[10 13]; %Ga
                eegCH=[1 2 4];
                
                
                yaxis=[-800 800;-800 800;-400 400;-400 400;-600 600];
                yaxisAU=[0 12];
                
                
                audname=[mousename,'-AUD-WrittenOut256Hz-',recorddate];
                audtr=[block,'_aud_parameters'];
                
                before=5;%20;
                after=5;%16;
                fs=256;
                
                p1=0.75; p2=30; s1=0.2; s2=40;
                Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=30; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
                [bb1,aa1]=cheby2(n,Rs,Wn);
                
                p1=5; p2=100; s1=4; s2=120;
                Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=20; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
                [bb2,aa2]=cheby2(n,Rs,Wn);
                
                maxep=10800;
                xtt=1:1:1800; xtt=xtt/900;
                
                cols=[0.68 0.85 0.90;...
                    0.48 0.65 0.70;...
                    0.28 0.45 0.50;...
                    0 0 0;...
                    0 0 0];
                
                %cols='brmkk';
                %cols='brmk'; %Ka
                
                %load auditory trials
                eval(['load ',pathAud,audtr,'.mat lims -mat']);
                
                %load auditory signal
                eval(['load ',pathSignals,audname,'.mat aud -mat']);
                
                % LFPs
                
                for i=1%:length(lfpCH) % Only keeping one channel per mouse
                    if genotype==1 && anm==5 % Qu
                        fnin=[mousename,'-LFP-',recorddate,'-ch5'];%Ne-LFP-280318_D-ch4
                    elseif genotype==2 && anm==3 % Ne
                        fnin=[mousename,'-LFP-',recorddate,'-ch4'];%Ne-LFP-280318_D-ch4
                    elseif genotype==2 && anm==4 % Oc
                        fnin=[mousename,'-LFP-',recorddate,'-ch5'];%Ne-LFP-280318_D-ch4
                    elseif genotype==2 && anm==5 % Ph
                        fnin=[mousename,'-LFP-',recorddate,'-ch5'];%Ne-LFP-280318_D-ch4
                    else
                        fnin=[mousename,'-LFP-',recorddate,'-ch',num2str(lfpCH(i))];%Ne-LFP-280318_D-ch4
                    end
                    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                    signal=filtfilt(bb1,aa1,sig);
                    if i==1
                        LFP=sig;
                    else
                        
                        if size(LFP,2)>length(sig)
                            LFP=[LFP;nan(1,size(LFP,2))];
                            LFP(end,1:length(sig))=sig;
                        else
                            LFP=[LFP;sig(1:size(LFP,2))];
                            
                        end
                    end
                    clear signal sig;
                    
                    
                    
                end
                %     fnin=[mousename,'-LFP1-',recorddate,'-cont-ch',num2str(lfpCH(2))];
                %     eval(['load ',pathSignals,fnin,'.mat resampled_sig_LFP -mat']);
                %     signal=filtfilt(bb1,aa1,resampled_sig_LFP);
                %     LFP2=signal; clear signal resampled_sig_LFP;
                
                fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(1))];
                eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                signal=filtfilt(bb1,aa1,sig);
                EEG1=sig; clear signal sig;
                
                fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(2))];
                eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                signal=filtfilt(bb1,aa1,sig);
                EEG2=sig; clear signal sig;
                
                fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(3))];
                eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                signal=filtfilt(bb2,aa2,sig);
                EMG=sig; clear signal sig;
                
                TrialsResults=[];
                
                LFPds=[];
                LFPns=[];
                EEGfro=[];
                EEGocc=[];
                EMGall=[];
                AUall=[];
                
                
                for trial=1:size(lims,1)%1:90%
                    if trial>91
                        Number_session='2';
                    else
                        Number_session='1';
                    end
                    
                    
                    
                    st=lims(trial,1)-fs*before;
                    en=st+fs*(before+8+after);%lims(trial,2)+fs*after; The sound wwas 8 sec.
                    
                    lfp=LFP(:,st:en);
                    %lfp2=LFP2(st:en);
                    eeg1=EEG1(st:en);
                    eeg2=EEG2(st:en);
                    emg=EMG(st:en);
                    au=aud(st:en);
                    
                    LFPds=[LFPds;lfp];
                    %LFPns=[LFPns;lfp2(1:5000)];
                    EEGfro=[EEGfro;eeg1];
                    EEGocc=[EEGocc;eeg2];
                    EMGall=[EMGall;emg];
                    AUall=[AUall;au];
                    
                    
                    
                end
            end
            if genotype==1
                LFP_Allmice_WT{anm}=mean(zscore(LFPds'),2,'omitnan')';
                EEGfro_Allmice_WT{anm}=mean(zscore(EEGfro'),2,'omitnan')';
                EEGocc_Allmice_WT{anm}=mean(zscore(EEGocc'),2,'omitnan')';
                EMG_Allmice_WT{anm}=mean(zscore(EMGall'),2,'omitnan')';
                AU_Allmice_WT{anm}=mean(zscore(AUall'),2,'omitnan')';
            else
                LFP_Allmice_Rlss{anm}=mean(zscore(LFPds'),2,'omitnan')';
                EEGfro_Allmice_Rlss{anm}=mean(zscore(EEGfro'),2,'omitnan')';
                EEGocc_Allmice_Rlss{anm}=mean(zscore(EEGocc'),2,'omitnan')';
                EMG_Allmice_Rlss{anm}=mean(zscore(EMGall'),2,'omitnan')';
                AU_Allmice_Rlss{anm}=mean(zscore(AUall'),2,'omitnan')';
            end
        end
    end
end



Phase_titles={'BL-light','BL-dark','SD-light','SD-dark'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;
x=1:length(au); x=x-fs*before; x=x./fs;

myFig = figure; set(myFig, 'Position',[700 100 1200 900]);
                    

mean_sig_WT=[mean(cell2mat(LFP_Allmice_WT(:)),'omitnan');mean(cell2mat(EEGfro_Allmice_WT(:)));mean(cell2mat(EEGocc_Allmice_WT(:)));mean(cell2mat(EMG_Allmice_WT(:)));mean(cell2mat(AU_Allmice_WT(:)))];
std_sig_WT=[std(cell2mat(LFP_Allmice_WT(:)),[],'omitnan');std(cell2mat(EEGfro_Allmice_WT(:)));std(cell2mat(EEGocc_Allmice_WT(:)));std(cell2mat(EMG_Allmice_WT(:)));std(cell2mat(AU_Allmice_WT(:)))];

mean_sig_Rlss=[mean(cell2mat(LFP_Allmice_Rlss(:)),'omitnan');mean(cell2mat(EEGfro_Allmice_Rlss(:)));mean(cell2mat(EEGocc_Allmice_Rlss(:)));mean(cell2mat(EMG_Allmice_Rlss(:)));mean(cell2mat(AU_Allmice_Rlss(:)))];
std_sig_Rlss=[std(cell2mat(LFP_Allmice_Rlss(:)),[],'omitnan');std(cell2mat(EEGfro_Allmice_Rlss(:)));std(cell2mat(EEGocc_Allmice_Rlss(:)));std(cell2mat(EMG_Allmice_Rlss(:)));std(cell2mat(AU_Allmice_Rlss(:)))];

ylabels={'LFP'; 'Fro. EEG'; 'Occ. EEG'; 'EMG'};
ylims=[-2 1;-4 2;-3 1;-2 1.5];
for sss=1:4
    
    %subplot('position',[0.15 0.9-sss*0.13 0.8 0.11])
    subplot(4,1,sss)
    shadedErrorBar(x,mean_sig_WT(sss,:),std_sig_WT(sss,:)/sqrt(5),'lineProps',{'Color',Colours(1,:),'LineWidth',3});
    hold on
    shadedErrorBar(x,mean_sig_Rlss(sss,:),std_sig_Rlss(sss,:)/sqrt(5),'lineProps',{'Color',Colours(2,:),'LineWidth',3});
    
    hold on
    plot([0 0],ylims(sss,:),'k--')
    hold on
    plot([8 8],ylims(sss,:),'k--')
    
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    if sss==1 title([Phase_titles{phase}]); end
    ylabel([ylabels{sss},' (zscored)'])
    xlim([-before 8+after])
    ylim(ylims(sss,:))
    if sss==4
        xlabel('Time from sound onset (s)')
        legend('WT','Rlss','Box','off')
    end


end

% %subplot('position',[0.15 0.1 0.8 0.10])
% subplot(5,1,5)
% bar(x,mean_sig_WT(5,:))
% axis([0 max(x) 0 12])
% axis off
% 
% %%% Looking at FFT around sound onset
% X_WT=cell2mat(LFP_Allmice_WT(:))';
% Y = fft(X_WT);
% %Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
% L=size(X_WT,1);
% figure()
% 
% for i=1:5
% P2 = abs(Y(:,i)/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% %Define the frequency domain f and plot the single-sided amplitude spectrum P1. The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise. On average, longer signals produce better frequency approximations.
% 
% f = fs*(0:(L/2))/L;
% 
% 
% plot(f,P1) 
% hold on
% title("Single-Sided Amplitude Spectrum of X(t)")
% xlabel("f (Hz)")
% ylabel("|P1(f)|")
% xlim([0.5 20])
% end
