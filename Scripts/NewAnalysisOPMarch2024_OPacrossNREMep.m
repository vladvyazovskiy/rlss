%%% New plots OFF period data


clear all
close all

WT={'Ed';'Fe';'He';'Le';'Qu'};
Rstl={'Ju';'Me';'Ne';'Oc';'Ph'};
n_WT=5;
n_Rstl=5;

Phases_BL_L_WT={'091117L';'091117L';'161117L';'161117L';'200318L'};
Phases_BL_D_WT={'091117D';'091117D';'161117D';'161117D';'200318D'};
Phases_SD_L_WT={'101117L';'101117L';'171117L';'171117L';'210318L'};
Phases_SD_D_WT={'101117D';'101117D';'171117D';'171117D';'210318D'};
Phases_WT=[Phases_BL_L_WT Phases_BL_D_WT Phases_SD_L_WT Phases_SD_D_WT];
LFP_channel_WT=[4 3 5 6 5];%Same channels as in ON period analysis

Phases_BL_L_Rstl={'161117L';'200318L';'200318L';'200318L';'200318L'};
Phases_BL_D_Rstl={'161117D';'200318D';'200318D';'200318D';'200318D'};
Phases_SD_L_Rstl={'171117L';'210318L';'210318L';'210318L';'210318L'};
Phases_SD_D_Rstl={'171117D';'210318D';'210318D';'210318D';'210318D'};
Phases_Rstl=[Phases_BL_L_Rstl Phases_BL_D_Rstl Phases_SD_L_Rstl Phases_SD_D_Rstl];
LFP_channel_HOM=[1 3 4 5 5];%Same channels as in ON period analysis

%%%%%PARAMETERS
mindur=30;% episodes length of VS of interest
ba=0;%allow ba in episodes of VS of interest

nb_perc=50;


All_Incidence_values_WT=nan(n_WT,nb_perc,4);%3rd dimensions corresponds to the different LD phases
All_AvDuration_values_WT=nan(n_WT,nb_perc,4);%3rd dimensions corresponds to the different LD phases
All_Incidence_values_Rstl=nan(n_Rstl,nb_perc,4);%3rd dimensions corresponds to the different LD phases
All_AvDuration_values_Rstl=nan(n_Rstl,nb_perc,4);%3rd dimensions corresponds to the different LD phases


VS_interest='NR'; % 'All' , 'NR', 'R' , 'W'


%%%%%%  Plotting Histograms (probability)
for genotype=1%:2 % 1=WT, 2=Rstl
    for anm=1%:5
        
        if genotype==1 && anm==4 %Le only has a recording for BL L 
            phase_scope=1;
        else
            phase_scope=1:4;
        end
        
        for phase=phase_scope % BL L, BL D , SD L, SD D.
            if genotype==1
                Names=WT;phase_name=Phases_WT{anm,phase};
                LFP_channels=LFP_channel_WT;
            else
                Names=Rstl;phase_name=Phases_Rstl{anm,phase};
                LFP_channels=LFP_channel_HOM;
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
            
            Start_OFF=OFFDATA.StartOP;
            End_OFF=OFFDATA.EndOP;
            
            fs=OFFDATA.PNEfs;
            
            if strcmp(VS_interest,'All')
                vigilance_state_of_interest=[nr;r;w];
            elseif strcmp(VS_interest,'NR')
                vigilance_state_of_interest=nr;
            elseif strcmp(VS_interest,'R')
                vigilance_state_of_interest=r;
            elseif strcmp(VS_interest,'W')
                vigilance_state_of_interest=w;
            end
            
            % Find the episodes of the VS of interest
            vs_interest=zeros(1,10800);vs_interest(vigilance_state_of_interest)=1;
            
            [SE_VSint,EpDur_VSint]=DetectEpisodes(vs_interest,10800,mindur,ba);
            nb_epi=length(EpDur_VSint);
            
            StartOFF_indexes_allVS=find(Start_OFF(:,LFP_channels(anm))); %StartOFF_indexes(end)=[];
            EndOFF_indexes_allVS=find(End_OFF(:,LFP_channels(anm))); %EndON_indexes(1)=[];
            
            Records_Incidence_OP=nan(nb_epi,nb_perc);
            Records_AvDuration_OP=nan(nb_epi, nb_perc);

            
            % For each episode, find the number of OFF periods in the different percentiles
            for i=8%:nb_epi

                %%devide in 6 percentiles & detect and count OFF periods and record their duration
                step_size=floor(EpDur_VSint(i)*fs*4/nb_perc);
                for j=1:nb_perc

                    Start_percentile=((SE_VSint(i,1)-1)*fs*4+1) + (1+(j-1)*step_size);%Start episode+elements before start percentile
                    End_percentile=((SE_VSint(i,1)-1)*fs*4+1) + (j*step_size); % Start episode + elements until end of percentile
                    
                    OP_of_interest=StartOFF_indexes_allVS>Start_percentile&StartOFF_indexes_allVS<End_percentile;
                    StartOFF_indexes=StartOFF_indexes_allVS(OP_of_interest);
                    EndOFF_indexes=EndOFF_indexes_allVS(OP_of_interest);
                    
                    
                    %Number of OP during that percentile of the episode:
                    %length_perc=(End_percentile-Start_percentile)*1000/fs;
                    Records_Incidence_OP(i,j)=sum(OP_of_interest);%./length_perc;
                    
                    %Average duration of OP during that percentile:                    
                    OFF_Durations=(EndOFF_indexes-StartOFF_indexes)*1000/fs;
                    OFF_Durations(OFF_Durations==0)=[];
                                        
                    Records_AvDuration_OP(i,j)=mean(OFF_Durations,'omitnan');
                    
                    
                end
                
            end
            
            

            if genotype==1
                All_Incidence_values_WT(anm,:,phase)=mean(Records_Incidence_OP,1,'omitnan');
                All_AvDuration_values_WT(anm,:,phase)=mean(Records_AvDuration_OP,1,'omitnan');
                
            elseif genotype==2
                All_Incidence_values_Rstl(anm,:,phase)=mean(Records_Incidence_OP,1,'omitnan');
                All_AvDuration_values_Rstl(anm,:,phase)=mean(Records_AvDuration_OP,1,'omitnan');
            end
                   
        end
    end
end

Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

Phase_names=['BL-L';'BL-D';'SD-L';'SD-D'];


for phase=1:4
    figure()
    errorbar(1:nb_perc,mean(All_Incidence_values_WT(:,:,phase),1,'omitnan'),std(All_Incidence_values_WT(:,:,phase),[],1,'omitnan')/sqrt(n_WT),'o','Color',Colours(1,:),'LineWidth',1.5)
    hold on
    plot(1:nb_perc,All_Incidence_values_WT(:,:,phase),'.k')
    hold on
    errorbar((1:nb_perc)+0.1,mean(All_Incidence_values_Rstl(:,:,phase),1,'omitnan'),std(All_Incidence_values_Rstl(:,:,phase),[],1,'omitnan')/sqrt(n_Rstl),'o','Color',Colours(2,:),'LineWidth',1.5)
    hold on
    plot((1:nb_perc)+0.1,All_Incidence_values_Rstl(:,:,phase),'.k')
    hold on
    
    %xlim([0.5 6.5])
    ylabel('Number of OFF periods /s')

    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;

    legend('WT','','rlss','')
    title(['phase ',Phase_names(phase,:)])
end

for phase=1:4
    figure()
    errorbar(1:nb_perc,mean(All_AvDuration_values_WT(:,:,phase),1,'omitnan'),std(All_AvDuration_values_WT(:,:,phase),[],1,'omitnan')/sqrt(n_WT),'o','Color',Colours(1,:),'LineWidth',1.5)
    hold on
    plot(1:nb_perc,All_AvDuration_values_WT(:,:,phase),'.k')
    hold on
    errorbar((1:nb_perc)+0.1,mean(All_AvDuration_values_Rstl(:,:,phase),1,'omitnan'),std(All_AvDuration_values_Rstl(:,:,phase),[],1,'omitnan')/sqrt(n_Rstl),'o','Color',Colours(2,:),'LineWidth',1.5)
    hold on
    plot((1:nb_perc)+0.1,All_AvDuration_values_Rstl(:,:,phase),'.k')
    hold on
    
    %xlim([0.5 6.5])
    ylabel('Duration of OFF periods (ms)')

    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;

    legend('WT','','rlss','')
    title(['phase ',Phase_names(phase,:)])
end
figure()
plot(mean(All_Incidence_values_WT(:,:,phase),1,'omitnan'))

