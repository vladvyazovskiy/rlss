% Calculating FR during ON periods

clear all
close all

% exte='.txt';
% path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
% path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5
% 
% 
% pathWT={path2017,path2017,path2017,path2017,path2018};
% 
% pathHOM={path2017,path2018,path2018,path2018,path2018};
% 
% 
% WT={'Ed';'Fe';'He';'Le';'Qu'};
% Rstl={'Ju';'Me';'Ne';'Oc';'Ph'};
% 
% Phases_BL_L_WT_aud={'201117L';'201117L';'201117L';'201117L';'280318L'};
% Phases_BL_L_WT={'091117L';'091117L';'161117L';'161117L';'200318L'};
% Phases_BL_D_WT={'091117D';'091117D';'161117D';'161117D';'200318D'};
% Phases_SD_L_WT={'101117L';'101117L';'171117L';'171117L';'210318L'};
% Phases_SD_D_WT={'101117D';'101117D';'171117D';'171117D';'210318D'};
% Phases_WT=[Phases_BL_L_WT Phases_BL_D_WT Phases_SD_L_WT Phases_SD_D_WT];
% 
% Phases_BL_L_Rstl_aud={'201117L';'280318L';'280318L';'280318L';'280318L'};
% Phases_BL_L_Rstl={'161117L';'200318L';'200318L';'200318L';'200318L'};
% Phases_BL_D_Rstl={'161117D';'200318D';'200318D';'200318D';'200318D'};
% Phases_SD_L_Rstl={'171117L';'210318L';'210318L';'210318L';'210318L'};
% Phases_SD_D_Rstl={'171117D';'210318D';'210318D';'210318D';'210318D'};
% Phases_Rstl=[Phases_BL_L_Rstl Phases_BL_D_Rstl Phases_SD_L_Rstl Phases_SD_D_Rstl];
% 
% % Filename_In='Qu_200318_L_BasicCluster.mat';
% % load(Filename_In);
% 
% 
% MUA_Allmice_WT=cell(1,5);
% MUA_Allmice_Rlss=cell(1,5);
% 
% 
% for genotype=1:2 % 1=WT, 2=Rstl
%     genotype
%     for anm=1:5
%         anm
%         if genotype==1 && anm==1 % No values for Ed, not sure why
%         else
% 
%             for phase=1%phase_scope % AU L, AU D 
% 
%      
%                 if genotype==1
%                     Names=WT;
%                     phase_name=Phases_WT{anm,phase};
%                     phase_name_aud=Phases_BL_L_WT_aud{anm,phase};
%                     path=pathWT{anm};
%                 else
%                     Names=Rstl;
%                     phase_name=Phases_Rstl{anm,phase};
%                     phase_name_aud=Phases_BL_L_Rstl_aud{anm,phase};
%                     path=pathHOM{anm};
%                 end
%                 mousename=Names{anm};
%                 if phase==1
%                     end_name='Newclustering';recorddate=[phase_name(1:end-1),'_L'];
%                 else
%                     end_name='Newclustering_wPresets';
%                 end
% 
%                 filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',mousename,'_',phase_name,'_',end_name,'.mat'];
%                 load(filename);
%                
%                 pathSignals=[path,'OutputSignals/'];
%                 
%                 Start_OFF=OFFDATA.StartOP;
%                 End_OFF=OFFDATA.EndOP;
%                 
%                 lfpCH=OFFDATA.Channels; %Oc
% 
%                 FR_ALL_ONperiods=[];% to store densities of all channels of a mouse
%                 
%                 for i=1:length(lfpCH) % Only keeping one channel per mouse
%                     i
% %                     if genotype==1 && anm==5 % Qu
% %                         
% %                         fname_spike=[mousename,'-',recorddate,'-ch5-Spikes_TimeStamps'];
% %                     elseif genotype==2 && anm==3 % Ne
% %                         
% %                         fname_spike=[mousename,'-',recorddate,'-ch4-Spikes_TimeStamps'];
% %                     elseif genotype==2 && anm==4 % Oc
% %                         
% %                         fname_spike=[mousename,'-',recorddate,'-ch5-Spikes_TimeStamps'];
% %                     elseif genotype==2 && anm==5 % Ph
% %                         
% %                         fname_spike=[mousename,'-',recorddate,'-ch5-Spikes_TimeStamps'];
% %                     else
%                         
%                     fname_spike=[mousename,'-',recorddate,'-ch',num2str(lfpCH(i)),'-Spikes_TimeStamps'];
% %                     end
%                     
%                     %%% Loading OFF periods and infering ON periods
%                     StartOFF_indexes_allVS=find(Start_OFF(:,i)); %StartOFF_indexes(end)=[];
%                     EndOFF_indexes_allVS=find(End_OFF(:,i)); %EndON_indexes(1)=[];
%                     
%                     StartON_indexes_allVS=EndOFF_indexes_allVS(1:end-1)+1; %First ON periods starts at the end of the first OFF period
%                     EndON_indexes_allVS=StartOFF_indexes_allVS(2:end)-1; % First ON period end at the start of the second OFF period     
%                     
% %                     StartON_indexes=StartON_indexes_allVS(ismember(ceil(StartON_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
% %                     EndON_indexes=EndON_indexes_allVS(ismember(ceil(StartON_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
% %     
%                     ON_Durations=(EndON_indexes_allVS-StartON_indexes_allVS)*1000/OFFDATA.PNEfs;%expressed in ms
%                     %ON_Durations(ON_Durations==0)=[];
%   
%                     %Loading spiking data from same channel as LFP
%                     path_MUA_files='/Volumes/Elements/Sleepy6EEG-March2018/SpikeScripts/OutputSpikesWaveForms/';               
%                     eval(['load ',path_MUA_files,fname_spike,'.mat TimeStamps -mat']);
%                 
%                     TS=zeros(1,12*60*60*1000);
%                     ts1=round(TimeStamps*1000); TSch=TS; TSch(ts1)=1;
%                     
%                     FR_ALL_ONperiods_temp=[];
% 
%                     for j=1:length(StartON_indexes_allVS) 
%                         
%                         if ON_Durations(j)~=0
%                                 % MUAs
%                             st=round(StartON_indexes_allVS(j)*1000/OFFDATA.PNEfs);
%                             en=round(EndON_indexes_allVS(j)*1000/OFFDATA.PNEfs); % Taking epoch before the sound so finishes when the sound starts. 
%                             duration=ON_Durations(j);
% 
%                             Spikes_in_ONperiod=sum(TSch(st:en));
%                             FR_ONperiod=1000*Spikes_in_ONperiod/duration;%I mutliply by 1000 as durations are expressed in ms
%                             FR_ALL_ONperiods_temp=[FR_ALL_ONperiods_temp;FR_ONperiod];
%                         end
% 
%                     end
%                     FR_ALL_ONperiods=[FR_ALL_ONperiods; mean(FR_ALL_ONperiods_temp,'omitnan')];
%                 end
%             end
%             if genotype==1  
%                 FR_Allmice_WT{anm}=FR_ALL_ONperiods;
%      
%             else 
%                 FR_Allmice_Rlss{anm}=FR_ALL_ONperiods;
%              
%             end
%         end
%     end
% end

%save('Workspace_ONperiodsDensity_Dec24.mat')
load('Workspace_ONperiodsDensity_Dec24.mat')

Phase_titles={'BL-light','BL-dark','SD-light','SD-dark'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

FR_ONperiods_WT=nan(1,5);
FR_ONperiods_Rlss=nan(1,5);
FR_ONperiods_WT_allCh=[];
FR_ONperiods_Rlss_allCh=[];
y_anovan=[];
g_geno=[];

for anm=1:5
    if anm==1
        temp_rlss=FR_Allmice_Rlss{1,anm};temp_rlss(isinf(temp_rlss))=nan;
        FR_ONperiods_Rlss(1,anm)=mean(temp_rlss,'omitnan');
        FR_ONperiods_Rlss_allCh=[FR_ONperiods_Rlss_allCh; temp_rlss];
    else
        temp_WT=FR_Allmice_WT{1,anm};temp_WT(isinf(temp_WT))=nan;
        temp_rlss=FR_Allmice_Rlss{1,anm};temp_rlss(isinf(temp_rlss))=nan;
        FR_ONperiods_WT(1,anm)=mean(temp_WT,'omitnan');
        FR_ONperiods_Rlss(1,anm)=mean(temp_rlss,'omitnan');
        FR_ONperiods_WT_allCh=[FR_ONperiods_WT_allCh; temp_WT];
        FR_ONperiods_Rlss_allCh=[FR_ONperiods_Rlss_allCh; temp_rlss];
    end
end


figure()

errorbar(1,mean(FR_ONperiods_WT,'omitnan'),std(FR_ONperiods_WT,'omitnan')/sqrt(5),'o','Color',Colours(1,:),'LineWidth',1.5)
hold on
plot(1,FR_ONperiods_WT_allCh,'.k')
hold on
%SD
errorbar(2,mean(FR_ONperiods_Rlss,'omitnan'),std(FR_ONperiods_Rlss,'omitnan')/sqrt(5),'o','Color',Colours(2,:),'LineWidth',1.5)
hold on
plot(2,FR_ONperiods_Rlss_allCh,'.k')
xlim([0 3])
%ylim([0 1000])
xticks(1:2)
xticklabels({'WT','rlss'})
ylabel('ON-period FR (Hz)')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

%%% Stats - 
%%% Indepednent samples t-test on one mean value per mouse
[h,p,ci,stats]  = ttest2(FR_ONperiods_WT(2:end),FR_ONperiods_Rlss)

%%% Repeated measures ANOVA, keeping 5 channels per mouse
mat_for_anova_TopXOP=nan(9,5);

for anm=1:5
    if anm==1
        mat_for_anova_TopXOP(anm+5,:)=FR_Allmice_Rlss{anm}(1:5)';
    else
        mat_for_anova_TopXOP(anm,:)=FR_Allmice_WT{anm}(1:5)';
        mat_for_anova_TopXOP(anm+5,:)=FR_Allmice_Rlss{anm}(1:5)';
    end
    
end

datamat=mat_for_anova_TopXOP([2 3 4 5 6 7 8 9 10],:);
between_factors=[0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl

tbl = simple_mixed_anova(datamat, between_factors, {'Channel'},{'Genotype'})

