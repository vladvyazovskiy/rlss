clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


fs=256; %sampling rate (Hz)
f=(0:0.25:20);


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
EMG_Sound_Allmice_WT=cell(1,5);
AU_Allmice_WT=cell(1,5);
Spectr_EEGfro_Allmice_WT=cell(1,5);
SWA_EEGfro_Allmice_WT=cell(1,5);
Spectr_EEGocc_Allmice_WT=cell(1,5);
SWA_EEGocc_Allmice_WT=cell(1,5);
Spectr_LFP_Allmice_WT=cell(1,5);
SWA_LFP_Allmice_WT=cell(1,5);
MUA_Allmice_WT=cell(1,5);

LFP_Allmice_Rlss=cell(1,5);
EEGfro_Allmice_Rlss=cell(1,5);
EEGocc_Allmice_Rlss=cell(1,5);
EMG_Allmice_Rlss=cell(1,5);
EMG_Sound_Allmice_Rlss=cell(1,5);
AU_Allmice_Rlss=cell(1,5);
Spectr_EEGfro_Allmice_Rlss=cell(1,5);
SWA_EEGfro_Allmice_Rlss=cell(1,5);
Spectr_EEGocc_Allmice_Rlss=cell(1,5);
SWA_EEGocc_Allmice_Rlss=cell(1,5);
Spectr_LFP_Allmice_Rlss=cell(1,5);
SWA_LFP_Allmice_Rlss=cell(1,5);
MUA_Allmice_Rlss=cell(1,5);


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
                

                pathSignals=[path,'OutputSignals/'];
                pathAud=[path,'OutputAuditory/'];
                pathVS=[path,'Auditory_Analysis_TrialResults/']; %mkdir(pathout)
                block=[mousename,'_',recorddate];
                lfpCH=OFFDATA.Channels; %Oc
                %lfpCH=[6 14]; %Ga
                %lfpCH=[10 13]; %Ga
                eegCH=[1 2 4];
                
                
                yaxis=[-800 800;-800 800;-400 400;-400 400;-600 600];
                yaxisAU=[0 12];
                
                
                audname=[mousename,'-AUD-WrittenOut256Hz-',recorddate];
                audtr=[block,'_aud_parameters'];
                
                before=8;%20;
                after=8;%16;
                fs=256;
                
%                 p1=0.75; p2=30; s1=0.2; s2=40;
%                 Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=30; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
%                 [bb1,aa1]=cheby2(n,Rs,Wn);
%                 
%                 p1=5; p2=100; s1=4; s2=120;
%                 Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=20; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
%                 [bb2,aa2]=cheby2(n,Rs,Wn);
                
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
                
                %loading VS of each trial
                TrialsResults_conc=[];
                sessions=char('1','2');
                for session=1:2
                    aud_results=[mousename,'-',recorddate,'-TrialsScreening-Session-',sessions(session)];
                    eval(['load ',pathVS,aud_results,'.mat TrialsResults -mat']);
                    TrialsResults_conc=[TrialsResults_conc;TrialsResults];
                end
                
                %load auditory signal
                eval(['load ',pathSignals,audname,'.mat aud -mat']);
                
                % LFPs
                
                for i=1%:length(lfpCH) % Only keeping one channel per mouse
                    if genotype==1 && anm==5 % Qu
                        fnin=[mousename,'-LFP-',recorddate,'-ch5'];%Ne-LFP-280318_D-ch4
                        fname_spike=[mousename,'-',recorddate,'-ch5-Spikes_TimeStamps'];
                    elseif genotype==2 && anm==3 % Ne
                        fnin=[mousename,'-LFP-',recorddate,'-ch4'];%Ne-LFP-280318_D-ch4
                        fname_spike=[mousename,'-',recorddate,'-ch4-Spikes_TimeStamps'];
                    elseif genotype==2 && anm==4 % Oc
                        fnin=[mousename,'-LFP-',recorddate,'-ch5'];%Ne-LFP-280318_D-ch4
                        fname_spike=[mousename,'-',recorddate,'-ch5-Spikes_TimeStamps'];
                    elseif genotype==2 && anm==5 % Ph
                        fnin=[mousename,'-LFP-',recorddate,'-ch5'];%Ne-LFP-280318_D-ch4
                        fname_spike=[mousename,'-',recorddate,'-ch5-Spikes_TimeStamps'];
                    else
                        fnin=[mousename,'-LFP-',recorddate,'-ch',num2str(lfpCH(i))];%Ne-LFP-280318_D-ch4
                        fname_spike=[mousename,'-',recorddate,'-ch',num2str(lfpCH(i)),'-Spikes_TimeStamps'];
                    end
                    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
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
                    
                    %Loading spiking data from same channel as LFP
                    path_MUA_files='/Volumes/Elements/Sleepy6EEG-March2018/SpikeScripts/OutputSpikesWaveForms/';               
                    eval(['load ',path_MUA_files,fname_spike,'.mat TimeStamps -mat']);
%                     Timestamps_epochs=ceil(TimeStamps/4);           
%                     bins=1:10800;
%                     counts_per_epoch=hist(Timestamps_epochs,bins);
%                     Temp_counts_NR(ch)=mean(counts_per_epoch(nr),'omitnan')/4;%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec)
%                     
                                       
                    %%%%
                    
       
                end
                %     fnin=[mousename,'-LFP1-',recorddate,'-cont-ch',num2str(lfpCH(2))];
                %     eval(['load ',pathSignals,fnin,'.mat resampled_sig_LFP -mat']);
                %     signal=filtfilt(bb1,aa1,resampled_sig_LFP);
                %     LFP2=signal; clear signal resampled_sig_LFP;
                
                fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(1))];
                eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                %signal=filtfilt(bb1,aa1,sig);
                EEG1=sig; clear signal sig;
                
                fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(2))];
                eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                %signal=filtfilt(bb1,aa1,sig);
                EEG2=sig; clear signal sig;
                
                fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(3))];
                eval(['load ',pathSignals,fnin,'.mat sig -mat']);
                %signal=filtfilt(bb2,aa2,sig);
                EMG=sig; clear signal sig;
                
                
                
                LFPds=[];
                LFPns=[];
                EEGfro=[];
                EEGocc=[];
                EMGall=[];
                AUall=[];
                
                LFPds_pre=[];
                %LFPns_pre=[];
                EEGfro_pre=[];
                EEGocc_pre=[];
                EMG_sound=[];
                
                EEGfro_pre_spectr=[];
                EEGfro_pre_swa=[];
                EEGocc_pre_spectr=[];
                EEGocc_pre_swa=[];
                LFP_pre_spectr=[];
                LFP_pre_swa=[];
                
                
                TS=zeros(1,12*60*60*1000);
                ts1=round(TimeStamps*1000); TSch=TS; TSch(ts1)=1;
                MUAch=[];MUAchZ=[];
                
                %Finding trials for which the mouse was in NR before the sound
                idNR=find(TrialsResults(:,1)==2); %Based on socring in TrialScreening--> 1=W, 2=NR, 3=R
                idR=find(TrialsResults(:,1)==3);
                
                for i=1:length(idNR) %%%% ONLY CONSIDERING NREM:idNR TRIALS
                    trial=idNR(i);
                    if trial>91
                        Number_session='2';
                    else
                        Number_session='1';
                    end
                              
                    st=lims(trial,1)-fs*before;
                    en=st+fs*(before+8+after);%lims(trial,2)+fs*after; The sound wwas 8 sec.
                    
                    lfp=LFP(:,st:en);
                    lfp_pre=LFP(:,st:lims(trial,1));
                    %lfp2=LFP2(st:en);
                    eeg1=EEG1(st:en);
                    eeg1_pre=EEG1(st:lims(trial,1));
                    eeg2=EEG2(st:en);
                    eeg2_pre=EEG2(st:lims(trial,1));
                    emg=EMG(st:en);
                    emg_pre=EMG(st:lims(trial,1));
                    emg_sound=EMG(lims(trial,1):lims(trial,1)+8*fs);
                    %Normalising EMG_sound against the whole, pre-during-post signal
                    %emg_sound_norm=(emg_sound-mean(emg_pre,'omitnan'))/std(emg_pre,[],'omitnan');
                    emg_sound_norm=emg_sound/mean(emg_pre,'omitnan');
                    au=aud(st:en);
                    
                    LFPds=[LFPds;lfp];
                    LFPds_pre=[LFPds_pre;lfp_pre];
                    %LFPns=[LFPns;lfp2(1:5000)];
                    EEGfro=[EEGfro;eeg1];
                    EEGfro_pre=[EEGfro_pre;eeg1_pre];
                    EEGocc=[EEGocc;eeg2];
                    EEGocc_pre=[EEGocc_pre;eeg2_pre];
                    EMGall=[EMGall;emg];
                    EMG_sound=[EMG_sound;emg_sound_norm];
                    AUall=[AUall;au];
                    
                    %Calculating SWA in LFP_pre, EGfor_pre, EEGocc_pre 
                        % EGG fro
                    EEGfro_NRbef=eeg1_pre;
                    [sp_EEGfro_NRbef,f]=pwelch(EEGfro_NRbef,length(EEGfro_NRbef)-2,length(EEGfro_NRbef)/2,f,fs);                  
                    sp_EEGfro_NRbef(1,1:2)=nan;
                    Mean_swa_EEGfro=mean(sp_EEGfro_NRbef(1,3:17),'omitnan');
                    EEGfro_pre_spectr=[EEGfro_pre_spectr;sp_EEGfro_NRbef];
                    EEGfro_pre_swa=[EEGfro_pre_swa; Mean_swa_EEGfro];
                    
                        % EGG occ
                    EEGocc_NRbef=eeg2_pre;
                    [sp_EEGocc_NRbef,f]=pwelch(EEGocc_NRbef,length(EEGocc_NRbef)-2,length(EEGocc_NRbef)/2,f,fs);                  
                    sp_EEGocc_NRbef(1,1:2)=nan;
                    Mean_swa_EEGocc=mean(sp_EEGocc_NRbef(1,3:17),'omitnan');
                    EEGocc_pre_spectr=[EEGocc_pre_spectr;sp_EEGocc_NRbef];
                    EEGocc_pre_swa=[EEGocc_pre_swa; Mean_swa_EEGocc];
                    
                        % LFP
                    LFP_NRbef=lfp_pre;
                    [sp_LFP_NRbef,f]=pwelch(LFP_NRbef,length(LFP_NRbef)-2,length(LFP_NRbef)/2,f,fs);                  
                    sp_LFP_NRbef(1,1:2)=nan;
                    Mean_swa_LFP=mean(sp_LFP_NRbef(1,3:17),'omitnan');
                    LFP_pre_spectr=[LFP_pre_spectr;sp_LFP_NRbef];
                    LFP_pre_swa=[LFP_pre_swa; Mean_swa_LFP];
                    
                    
                        % MUAs
                    st=lims(trial,1)-fs*before;
                    en=lims(trial,1); % Taking epoch before the sound so finishes when the sound starts. 
                    st=round(st/fs*1000); en=round(en/fs*1000);
                    
                    mua=TSch(st:en);                   
                    MUAch=[MUAch;mua];
                    MUAchZ=[MUAchZ;zscore(mua)];
                    
                    
                    
                end
            end
            if genotype==1
                LFP_Allmice_WT{anm}=mean(zscore(LFPds'),2,'omitnan')';
                EEGfro_Allmice_WT{anm}=mean(zscore(EEGfro'),2,'omitnan')';
                EEGocc_Allmice_WT{anm}=mean(zscore(EEGocc'),2,'omitnan')';
                EMG_Allmice_WT{anm}=mean(zscore(EMGall'),2,'omitnan')';
                EMG_Sound_Allmice_WT{anm}=EMG_sound;
                AU_Allmice_WT{anm}=mean(zscore(AUall'),2,'omitnan')';
                MUA_Allmice_WT{anm}=mean(MUAch,2,'omitnan');
                
                Spectr_EEGfro_Allmice_WT{anm}=EEGfro_pre_spectr;
                SWA_EEGfro_Allmice_WT{anm}=EEGfro_pre_swa;
                Spectr_EEGocc_Allmice_WT{anm}=EEGocc_pre_spectr;
                SWA_EEGocc_Allmice_WT{anm}=EEGocc_pre_swa;
                Spectr_LFP_Allmice_WT{anm}=LFP_pre_spectr;
                SWA_LFP_Allmice_WT{anm}=LFP_pre_swa;
                
            else
                LFP_Allmice_Rlss{anm}=mean(zscore(LFPds'),2,'omitnan')';
                EEGfro_Allmice_Rlss{anm}=mean(zscore(EEGfro'),2,'omitnan')';
                EEGocc_Allmice_Rlss{anm}=mean(zscore(EEGocc'),2,'omitnan')';
                EMG_Allmice_Rlss{anm}=mean(zscore(EMGall'),2,'omitnan')';
                EMG_Sound_Allmice_Rlss{anm}=EMG_sound;
                AU_Allmice_Rlss{anm}=mean(zscore(AUall'),2,'omitnan')';
                MUA_Allmice_Rlss{anm}=mean(MUAch,2,'omitnan');
                
                Spectr_EEGfro_Allmice_Rlss{anm}=EEGfro_pre_spectr;
                SWA_EEGfro_Allmice_Rlss{anm}=EEGfro_pre_swa;
                Spectr_EEGocc_Allmice_Rlss{anm}=EEGocc_pre_spectr;
                SWA_EEGocc_Allmice_Rlss{anm}=EEGocc_pre_swa;
                Spectr_LFP_Allmice_Rlss{anm}=LFP_pre_spectr;
                SWA_LFP_Allmice_Rlss{anm}=LFP_pre_swa;
                
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



%%% Plotting correlation EGGfro SWA in NREM before sound with EMG during sound
    %concatenate all trials all mice
AllTrials_EMGsound_WT=[];
AllTrials_EEGfroSWApre_WT=[];
AllTrials_EMGsound_rlss=[];
AllTrials_EEGfroSWApre_rlss=[];
for anm=1:5
    AllTrials_EMGsound_WT=[AllTrials_EMGsound_WT;mean(EMG_Sound_Allmice_WT{anm},2,'omitnan')]; % lines=trials; clumn=timebins during sound
    AllTrials_EEGfroSWApre_WT=[AllTrials_EEGfroSWApre_WT;zscore(SWA_EEGfro_Allmice_WT{anm})]; % lines=trials; clumn=timebins during sound
    AllTrials_EMGsound_rlss=[AllTrials_EMGsound_rlss;mean(EMG_Sound_Allmice_Rlss{anm},2,'omitnan')]; % lines=trials; clumn=timebins during sound
    AllTrials_EEGfroSWApre_rlss=[AllTrials_EEGfroSWApre_rlss;zscore(SWA_EEGfro_Allmice_Rlss{anm})]; % lines=trials; clumn=timebins during sound

end
mdl_WT=fitlm(AllTrials_EEGfroSWApre_WT,AllTrials_EMGsound_WT);
Anova_WT_EEGfro=anova(mdl_WT,'Summary');
mdl_rlss=fitlm(AllTrials_EEGfroSWApre_rlss,AllTrials_EMGsound_rlss);
Anova_rlss_EEGfro=anova(mdl_rlss,'Summary');

figure()
plot(AllTrials_EEGfroSWApre_WT,AllTrials_EMGsound_WT,'.','Color',Colours(1,:),'LineWidth',3)
hold on
plot(AllTrials_EEGfroSWApre_rlss,AllTrials_EMGsound_rlss,'.','Color',Colours(2,:),'LineWidth',3)
hold on
plotLM_WT=plot(mdl_WT);
set(plotLM_WT(1),'MarkerEdgeColor',Colours(1,:));
set(plotLM_WT(2), 'Color',Colours(1,:),'Linewidth',3);
set(plotLM_WT(3:4), 'Color',Colours(1,:),'Linewidth',3);
hold on
plotLM_rlss=plot(mdl_rlss);
set(plotLM_rlss(1), 'MarkerEdgeColor',Colours(2,:));
set(plotLM_rlss(2), 'Color',Colours(2,:),'Linewidth',3);
set(plotLM_rlss(3:4), 'Color',Colours(2,:),'Linewidth',3);

legend('WT','rlss','','fit WT','','','','fit rlss','','')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
%set(gca,'XScale', 'log')
legend('boxoff')
xlabel('NREM SWA pre sound')
ylabel('Mean z-scored EMG during sound')
title('EMG response to sound vs. NREM EEG fro SWA')

%%% Plotting correlation EGGocc SWA in NREM before sound with EMG during sound
    %concatenate all trials all mice
AllTrials_EEGoccSWApre_WT=[];
AllTrials_EEGoccSWApre_rlss=[];
for anm=1:5
    AllTrials_EEGoccSWApre_WT=[AllTrials_EEGoccSWApre_WT;zscore(SWA_EEGocc_Allmice_WT{anm})]; % lines=trials; clumn=timebins during sound
    AllTrials_EEGoccSWApre_rlss=[AllTrials_EEGoccSWApre_rlss;zscore(SWA_EEGocc_Allmice_Rlss{anm})]; % lines=trials; clumn=timebins during sound

end
mdl_WT=fitlm(AllTrials_EEGoccSWApre_WT,AllTrials_EMGsound_WT);
Anova_WT_EEGocc=anova(mdl_WT,'Summary');
mdl_rlss=fitlm(AllTrials_EEGoccSWApre_rlss,AllTrials_EMGsound_rlss);
Anova_rlss_EEGocc=anova(mdl_rlss,'Summary');

figure()
plot(AllTrials_EEGoccSWApre_WT,AllTrials_EMGsound_WT,'.','Color',Colours(1,:),'LineWidth',3)
hold on
plot(AllTrials_EEGoccSWApre_rlss,AllTrials_EMGsound_rlss,'.','Color',Colours(2,:),'LineWidth',3)
hold on
plotLM_WT=plot(mdl_WT);
set(plotLM_WT(1), 'MarkerEdgeColor',Colours(1,:));
set(plotLM_WT(2), 'Color',Colours(1,:),'Linewidth',3);
set(plotLM_WT(3:4), 'Color',Colours(1,:),'Linewidth',3);
hold on
plotLM_rlss=plot(mdl_rlss);
set(plotLM_rlss(1), 'MarkerEdgeColor',Colours(2,:));
set(plotLM_rlss(2), 'Color',Colours(2,:),'Linewidth',3);
set(plotLM_rlss(3:4), 'Color',Colours(2,:),'Linewidth',3);

legend('WT','rlss','','fit WT','','','','fit rlss','','')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
%set(gca,'XScale', 'log')
legend('boxoff')
xlabel('NREM SWA pre sound')
ylabel('Mean z-scored EMG during sound')
title('EMG response to sound vs. NREM EEG occ SWA')

%%% Plotting correlation LFP SWA in NREM before sound with EMG during sound
    %concatenate all trials all mice
AllTrials_LFPSWApre_WT=[];
AllTrials_LFPSWApre_rlss=[];
for anm=1:5
    AllTrials_LFPSWApre_WT=[AllTrials_LFPSWApre_WT;zscore(SWA_LFP_Allmice_WT{anm})]; % lines=trials; clumn=timebins during sound
    AllTrials_LFPSWApre_rlss=[AllTrials_LFPSWApre_rlss;zscore(SWA_LFP_Allmice_Rlss{anm})]; % lines=trials; clumn=timebins during sound

end
mdl_WT=fitlm(AllTrials_LFPSWApre_WT,AllTrials_EMGsound_WT);
Anova_WT_LFP=anova(mdl_WT,'Summary');
mdl_rlss=fitlm(AllTrials_LFPSWApre_rlss,AllTrials_EMGsound_rlss);
Anova_rlss_LFP=anova(mdl_rlss,'Summary');

figure()
plot(AllTrials_LFPSWApre_WT,AllTrials_EMGsound_WT,'.','Color',Colours(1,:),'LineWidth',3)
hold on
plot(AllTrials_LFPSWApre_rlss,AllTrials_EMGsound_rlss,'.','Color',Colours(2,:),'LineWidth',3)
hold on
plotLM_WT=plot(mdl_WT);
set(plotLM_WT(1), 'MarkerEdgeColor',Colours(1,:));
set(plotLM_WT(2), 'Color',Colours(1,:),'Linewidth',3);
set(plotLM_WT(3:4), 'Color',Colours(1,:),'Linewidth',3);
hold on
plotLM_rlss=plot(mdl_rlss);
set(plotLM_rlss(1), 'MarkerEdgeColor',Colours(2,:));
set(plotLM_rlss(2), 'Color',Colours(2,:),'Linewidth',3);
set(plotLM_rlss(3:4), 'Color',Colours(2,:),'Linewidth',3);

legend('WT','rlss','','fit WT','','','','fit rlss','','')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
%set(gca,'XScale', 'log')
legend('boxoff')
xlabel('NREM SWA pre sound')
ylabel('Mean z-scored EMG during sound')
title('EMG response to sound vs. NREM LFP SWA')

%%% Plotting correlation Level of MUA in NREM before sound with EMG during sound
    %concatenate all trials all mice
AllTrials_MUApre_WT=[];
AllTrials_MUApre_rlss=[];
for anm=1:5
    AllTrials_MUApre_WT=[AllTrials_MUApre_WT;zscore(MUA_Allmice_WT{anm})]; % lines=trials; clumn=timebins during sound
    AllTrials_MUApre_rlss=[AllTrials_MUApre_rlss;zscore(MUA_Allmice_Rlss{anm})]; % lines=trials; clumn=timebins during sound

end
mdl_WT=fitlm(AllTrials_MUApre_WT,AllTrials_EMGsound_WT);
Anova_WT_MUA=anova(mdl_WT,'Summary');
mdl_rlss=fitlm(AllTrials_MUApre_rlss,AllTrials_EMGsound_rlss);
Anova_rlss_MUA=anova(mdl_rlss,'Summary');

figure()
plot(AllTrials_MUApre_WT,AllTrials_EMGsound_WT,'.','Color',Colours(1,:),'LineWidth',3)
hold on
plot(AllTrials_MUApre_rlss,AllTrials_EMGsound_rlss,'.','Color',Colours(2,:),'LineWidth',3)
hold on
plotLM_WT=plot(mdl_WT);
set(plotLM_WT(1), 'MarkerEdgeColor',Colours(1,:));
set(plotLM_WT(2), 'Color',Colours(1,:),'Linewidth',3);
set(plotLM_WT(3:4), 'Color',Colours(1,:),'Linewidth',3);
hold on
plotLM_rlss=plot(mdl_rlss);
set(plotLM_rlss(1), 'MarkerEdgeColor',Colours(2,:));
set(plotLM_rlss(2), 'Color',Colours(2,:),'Linewidth',3);
set(plotLM_rlss(3:4), 'Color',Colours(2,:),'Linewidth',3);

legend('WT','rlss','','fit WT','','','','fit rlss','','')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
%set(gca,'XScale', 'log')
legend('boxoff')
xlabel('NREM MUA pre sound')
ylabel('Mean norm. EMG during sound')
title('EMG response to sound vs. NREM MUA')

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
