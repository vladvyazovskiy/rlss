%%% New plots OFF period data


clear all
close all

WT={'Ed';'Fe';'He';'Le';'Qu'};
Rstl={'Ju';'Me';'Ne';'Oc';'Ph'};

Phases_BL_L_WT={'091117L';'091117L';'161117L';'161117L';'200318L'};
Phases_BL_D_WT={'091117D';'091117D';'161117D';'161117D';'200318D'};
Phases_SD_L_WT={'101117L';'101117L';'171117L';'171117L';'210318L'};
Phases_SD_D_WT={'101117D';'101117D';'171117D';'171117D';'210318D'};
Phases_WT=[Phases_BL_L_WT Phases_BL_D_WT Phases_SD_L_WT Phases_SD_D_WT];

Phases_BL_L_Rstl={'161117L';'200318L';'200318L';'200318L';'200318L'};
Phases_BL_D_Rstl={'161117D';'200318D';'200318D';'200318D';'200318D'};
Phases_SD_L_Rstl={'171117L';'210318L';'210318L';'210318L';'210318L'};
Phases_SD_D_Rstl={'171117D';'210318D';'210318D';'210318D';'210318D'};
Phases_Rstl=[Phases_BL_L_Rstl Phases_BL_D_Rstl Phases_SD_L_Rstl Phases_SD_D_Rstl];

% Filename_In='Qu_200318_L_BasicCluster.mat';
% load(Filename_In);
All_count_values_WT=cell(5,4);
All_count_values_Rstl=cell(5,4);
All_cdf_values_WT=cell(5,4);
All_cdf_values_Rstl=cell(5,4);
Mean_shortest_WT=cell(5,4);
Mean_shortest_Rstl=cell(5,4);
Mean_longest_WT=cell(5,4);
Mean_longest_Rstl=cell(5,4);

edges=0:5:1200;
perc_OP_interest=5; % If I want to look at 5% shortest and longest off-periods.

mindur_R=8;%REM episodes of at least 14=1 min, 8=32s
mindur_NR=8;%min duration of preceding NREM
mindur_W=8;%min duration of preceding wake
ba_NR=4;% allow ba in preceding NR
ba_R=2;%allow ba_R in REM episodes
ba_W=4; %allow sleep of ba_W length in preceding wake
num_epochs_before=3;
num_epochs_start=4;
num_epochs_during=4;%num_epochs_start and _during basically do the same (i.e. take epochs after onset so could have just done one variable)

num_transition_type=5;%NR to R, NR to W, R to NR, R to W, W to NR

%Plot as a bar graph the number of spikes per channel for each animal

path='/Volumes/Elements/Sleepy6EEG-March2018/SpikeScripts/OutputSpikesWaveForms/';

for genotype=1:2 % 1=WT, 2=Rstl
    for anm=1:5
        
        if genotype==1 && anm==1 % Ed out
        else
            
            if genotype==1 && anm==4 %Le only has a recording for BL L
                phase_scope=1;
            else
                phase_scope=1:4;
            end
            
            for phase=1%I only want to BL L values here. phase_scope % BL L, BL D , SD L, SD D.
                if genotype==1
                    Names=WT;phase_name=Phases_WT{anm,phase};
                else
                    Names=Rstl;phase_name=Phases_Rstl{anm,phase};
                end
                name=Names{anm};
                if phase==1
                    end_name='Newclustering';
                else
                    end_name='Newclustering_wPresets';
                end
                
                filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',name,'_',phase_name,'_',end_name,'.mat'];
                load(filename);
                
                VS_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',name,'_',phase_name(1:6),'_',phase_name(7),'_fro_VSspec.mat'];
                load(VS_filename);
                
                
                nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
                rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
                wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
                baw=zeros(1,10800);baw(mt)=1;
                Spectr_L=spectr;
                
                
                
                
                [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba_W);
                [SE_NR,EpDur_NR]=DetectEpisodes(nrem,21600,mindur_NR,ba_NR);
                [SE_R,EpDur_R]=DetectEpisodes(rem,21600,mindur_R,ba_R);
                
                
                Temp_counts_NRtoR=nan(16,num_epochs_before+num_epochs_start+num_epochs_during);
                Temp_counts_NRtoW=nan(16,num_epochs_before+num_epochs_start+num_epochs_during);
                Temp_counts_RtoNR=nan(16,num_epochs_before+num_epochs_start+num_epochs_during);
                Temp_counts_RtoW=nan(16,num_epochs_before+num_epochs_start+num_epochs_during);
                Temp_counts_WtoNR=nan(16,num_epochs_before+num_epochs_start+num_epochs_during);
                
                
                for ch=OFFDATA.Channels'
                    
                    fname=[name,'-',phase_name(1:end-1),'_L-ch',num2str(ch),'-Spikes_TimeStamps'];
                    eval(['load ',path,fname,'.mat TimeStamps -mat']);
                    Timestamps_epochs=ceil(TimeStamps/4);
                    
                    bins=1:10800;
                    counts_per_epoch=hist(Timestamps_epochs,bins);
                    
                    
                    % Looking at NR->R transitions
                    Selected_NRtoR=[]; temp_count=[];
                    for i=1:length(EpDur_R)
                        if (SE_R(i,1)-(mindur_NR+1)>0) && (sum(nrem(SE_R(i,1)-(mindur_NR+1):SE_R(i,1)-1))>mindur_NR-ba_NR) %I allow ba in the minute of NREM directly preceding the REM episode.
                            Selected_NRtoR=[Selected_NRtoR; SE_R(i,:)];
                            temp_count=[temp_count;counts_per_epoch(SE_R(i,1)-num_epochs_before:SE_R(i,1)+num_epochs_start+num_epochs_during-1)/4];%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec);
                            
                        end
                    end
                    Temp_counts_NRtoR(ch,:)=mean(temp_count,'omitnan');
                    
                    
                    % Looking at NR->W transitions
                    Selected_NRtoW=[];temp_count=[];
                    for i=1:length(EpDur_W)
                        if (SE_W(i,1)-(mindur_NR+1)>0) && (sum(nrem(SE_W(i,1)-(mindur_NR+1):SE_W(i,1)-1))>mindur_NR-ba_NR) %I allow ba in the minute of NREM directly preceding the REM episode.
                            Selected_NRtoW=[Selected_NRtoW; SE_W(i,:)];
                            temp_count=[temp_count;counts_per_epoch(SE_W(i,1)-num_epochs_before:SE_W(i,1)+num_epochs_start+num_epochs_during-1)/4];%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec);
                            
                        end
                    end
                    Temp_counts_NRtoW(ch,:)=mean(temp_count,'omitnan');
                    
                    % Looking at R->NR transitions
                    Selected_RtoNR=[];temp_count=[];
                    for i=1:length(EpDur_NR)
                        if (SE_NR(i,1)-(mindur_R+1)>0) && (sum(rem(SE_NR(i,1)-(mindur_R+1):SE_NR(i,1)-1))>mindur_R-ba_R) %I allow ba in the minute of NREM directly preceding the REM episode.
                            Selected_RtoNR=[Selected_RtoNR; SE_NR(i,:)];
                            temp_count=[temp_count;counts_per_epoch(SE_NR(i,1)-num_epochs_before:SE_NR(i,1)+num_epochs_start+num_epochs_during-1)/4];%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec);
                            
                        end
                    end
                    Temp_counts_RtoNR(ch,:)=mean(temp_count,'omitnan');
                    
                    % Looking at R->W transitions
                    Selected_RtoW=[];temp_count=[];
                    for i=1:length(EpDur_W)
                        if (SE_W(i,1)-(mindur_R+1)>0) && (sum(rem(SE_W(i,1)-(mindur_R+1):SE_W(i,1)-1))>mindur_R-ba_R) %I allow ba in the minute of NREM directly preceding the REM episode.
                            Selected_RtoW=[Selected_RtoW; SE_W(i,:)];
                            temp_count=[temp_count;counts_per_epoch(SE_W(i,1)-num_epochs_before:SE_W(i,1)+num_epochs_start+num_epochs_during-1)/4];%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec);
                            
                        end
                    end
                    Temp_counts_RtoW(ch,:)=mean(temp_count,'omitnan');
                    
                    % Looking at W->NR transitions
                    Selected_WtoNR=[];temp_count=[];
                    for i=1:length(EpDur_NR)
                        if (SE_NR(i,1)-(mindur_W+1)>0) && (sum(wake(SE_NR(i,1)-(mindur_W+1):SE_NR(i,1)-1))>mindur_W-ba_W) %I allow ba in the minute of NREM directly preceding the REM episode.
                            Selected_WtoNR=[Selected_WtoNR; SE_NR(i,:)];
                            temp_count=[temp_count;counts_per_epoch(SE_NR(i,1)-num_epochs_before:SE_NR(i,1)+num_epochs_start+num_epochs_during-1)/4];%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec);
                            
                        end
                    end
                    Temp_counts_WtoNR(ch,:)=mean(temp_count,'omitnan');
                    
                end
                
                if genotype==1
                    All_count_values_WT{anm,1}=Temp_counts_NRtoR;
                    All_count_values_WT{anm,2}=Temp_counts_NRtoW;
                    All_count_values_WT{anm,3}=Temp_counts_RtoNR;
                    All_count_values_WT{anm,4}=Temp_counts_RtoW;
                    All_count_values_WT{anm,5}=Temp_counts_WtoNR;
                    
                elseif genotype==2
                    All_count_values_Rstl{anm,1}=Temp_counts_NRtoR;
                    All_count_values_Rstl{anm,2}=Temp_counts_NRtoW;
                    All_count_values_Rstl{anm,3}=Temp_counts_RtoNR;
                    All_count_values_Rstl{anm,4}=Temp_counts_RtoW;
                    All_count_values_Rstl{anm,5}=Temp_counts_WtoNR;
                    
                end
                
                
            end
        end
    end
end


%%%Plotting the histograms per genotype

Transition_titles={'NREM to REM','NREM to Wake','REM to NREM','REM to Wake','Wake to NREM'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

%%%Plotting the survival curves per genotype - with error bars

x=4*(-num_epochs_before+1:1:num_epochs_start+num_epochs_during);

%Keeping each channel of each mouse
figure()
for transition=1:5
    subplot(1,5,transition)
    
    temp_WT=[];
    temp_Rstl=[];
    
    for anm=1:5
        temp_WT=[temp_WT; All_count_values_WT{anm,transition}];
        %temp_WT(temp_WT==0)=NaN;
        
        temp_Rstl=[temp_Rstl; All_count_values_Rstl{anm,transition}];
        %temp_Rstl(temp_Rstl==0)=NaN;
        
    end
    hold all
    
    shadedErrorBar(x,mean(temp_WT,'omitnan'),std(temp_WT,[],'omitnan'),'lineProps',{'Color',Colours(1,:),'LineWidth',3});
    hold on
    %plot(x,temp_WT,'Color',Colours(1,:))
    hold on
    shadedErrorBar(x,mean(temp_Rstl,'omitnan'),std(temp_Rstl,[],'omitnan'),'lineProps',{'Color',Colours(2,:),'LineWidth',3});
    hold on
    %plot(x,temp_Rstl,'Color',Colours(2,:))
    hold on
%     if phase==1 || phase==3
%         ylabel('% of OFF-periods')
%     end
%     if phase==3 || phase==4
%         xlabel('OFF-period duration (ms)')
%     end
    %xlim([0 3])
    %ylim([0 50])
    title([Transition_titles{transition}])
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    ylabel('Average FR (spikes/s)')
    

end

%Avergaing across channels of a given mouse (after normalising against initial value)
figure()
for transition=1:5
    subplot(1,5,transition)
    
    temp_WT_norm=nan(5,num_epochs_before+num_epochs_start+num_epochs_during);
    temp_Rstl_norm=nan(5,num_epochs_before+num_epochs_start+num_epochs_during);
    
    for anm=1:5
        
        temp_WT_norm(anm,:)=mean(zscore(All_count_values_WT{anm,transition},[],2),'omitnan');
        %temp_WT(temp_WT==0)=NaN;
        
        temp_Rstl_norm(anm,:)=mean(zscore(All_count_values_Rstl{anm,transition},[],2),'omitnan');
        %temp_Rstl(temp_Rstl==0)=NaN;
    
        
    end
    
    hold all
    
    shadedErrorBar(x,mean(temp_WT_norm,'omitnan'),std(temp_WT_norm,[],'omitnan')/sqrt(4),'lineProps',{'Color',Colours(1,:),'LineWidth',3});
    hold on
    %plot(x,temp_WT_norm,'Color',Colours(1,:))
    hold on
    shadedErrorBar(x,mean(temp_Rstl_norm,'omitnan'),std(temp_Rstl_norm,[],'omitnan')/sqrt(5),'lineProps',{'Color',Colours(2,:),'LineWidth',3});
    hold on
    %plot(x,temp_Rstl_norm,'Color',Colours(2,:))
    hold on
%     if phase==1 || phase==3
%         ylabel('% of OFF-periods')
%     end
%     if phase==3 || phase==4
%         xlabel('OFF-period duration (ms)')
%     end
    xlim(4*[-num_epochs_before+1 num_epochs_start+num_epochs_during])
    %ylim([0 50])
    title([Transition_titles{transition}])
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    ylabel('Average FR (zscored)')
    xlabel('Time from state transition (s)')
    legend('WT','rlss')
    legend('boxoff')
    

end
