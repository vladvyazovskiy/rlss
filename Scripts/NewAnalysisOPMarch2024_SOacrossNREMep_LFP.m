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
LFP_channel_HOM=[1 5 4 5 5];%Same channels as in ON period analysis

%%%%%PARAMETERS
mindur=30;% episodes length of VS of interest, 30 means 2 minutes
ba=0;%allow ba in episodes of VS of interest

All_Incidence_values_WT=cell(n_WT,4);%2nd dimensions corresponds to the different LD phases
All_AvDuration_values_WT=cell(n_WT,4);%2nd dimensions corresponds to the different LD phases
All_Incidence_values_Rstl=cell(n_Rstl,4);%2nd dimensions corresponds to the different LD phases
All_AvDuration_values_Rstl=cell(n_Rstl,4);%2nd dimensions corresponds to the different LD phases


VS_interest='NR'; % 'All' , 'NR', 'R' , 'W'

nb_epi_to_keep=5;

%%%%%%  Plotting Histograms (probability)
for genotype=1:2 % 1=WT, 2=Rstl
    for anm=1:5
        
        if genotype==1 && anm==4 %Le only has a recording for BL L 
            phase_scope=1;
        else
            phase_scope=1:4;
        end
        
        for phase=1%phase_scope % BL L, BL D , SD L, SD D.
            if genotype==1
                Names=WT;phase_name=Phases_WT{anm,phase};
                LFP_channels=LFP_channel_WT;
            else
                Names=Rstl;phase_name=Phases_Rstl{anm,phase};
                LFP_channels=LFP_channel_HOM;
            end
            name=Names{anm};
%             if phase==1
%                 end_name='Newclustering';
%             else
%                 end_name='Newclustering_wPresets';
%             end
%             filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',name,'_',phase_name,'_',end_name,'.mat'];
%             load(filename);
%             
%             VS_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',name,'_',phase_name(1:6),'_',phase_name(7),'_fro_VSspec.mat'];
%             load(VS_filename);
%             
%             Start_OFF=OFFDATA.StartOP;
%             End_OFF=OFFDATA.EndOP;
%             
%             fs=OFFDATA.PNEfs;
            day=phase_name(1:6);
            LD=phase_name(7);
            fileNameSignal=['LFPraw_data_',name,'_',day,'_',LD,'_Channels1to16'];

            pathinSignal=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/'];
            output=load([pathinSignal,fileNameSignal,'.mat']);

            fs=output.fs;
            All_channels=[output.Ch1;output.Ch2;output.Ch3;output.Ch4;output.Ch5;output.Ch6;output.Ch7];%No mouse has a channel number chosen above 7, but in theory I can go up to channel 16



            Signal=All_channels(LFP_channel_WT(n),:);
            Selec_NR_LFP=Signal(round((SE_NR(i,1)-1)*fs*4)+1:round(SE_NR(i,2)*fs*4));%Selecting signals corresponding to episode i

            T = 1/fs;             % Sampling period
            L = round(fs*4*mindur_NR);



    
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
            
            Records_Incidence_OP=nan(nb_epi_to_keep,max(EpDur_VSint));
            Records_AvDuration_OP=nan(nb_epi_to_keep,max(EpDur_VSint));

            % Find the 5 longest episodes
            [~, sortIndex] = sort(EpDur_VSint, 'descend');  % Sort the values in descending order
            maxIndexes = sortIndex(1:nb_epi_to_keep);
            % For each of those 5 ('nb_epi_to_keep') longest episodes, find the number of OFF periods across the episodes, added over 4-sec epochs
            index=0;
            
            for i=maxIndexes

                %%devide in 4-sec epochs & detect and count OFF periods and record their duration
                step_size=fs*4;
                
                index=index+1;
                
                for j=1:EpDur_VSint(i)
                    

                    Start_bin=((SE_VSint(i,1)-1)*fs*4+1) + (1+(j-1)*step_size);%Start episode+elements before start percentile
                    End_bin=((SE_VSint(i,1)-1)*fs*4+1) + (j*step_size); % Start episode + elements until end of percentile
                    
                    OP_of_interest=StartOFF_indexes_allVS>Start_bin&StartOFF_indexes_allVS<End_bin;
                    StartOFF_indexes=StartOFF_indexes_allVS(OP_of_interest);
                    EndOFF_indexes=EndOFF_indexes_allVS(OP_of_interest);
                    
                    
                    %Number of OP during that percentile of the episode:
                    %length_perc=(End_percentile-Start_percentile)*1000/fs;
                    Records_Incidence_OP(index,j)=sum(OP_of_interest);%./length_perc;
                    
                    %Average duration of OP during that percentile:                    
                    OFF_Durations=(EndOFF_indexes-StartOFF_indexes)*1000/fs;
                    OFF_Durations(OFF_Durations==0)=[];
                                        
                    Records_AvDuration_OP(index,j)=mean(OFF_Durations,'omitnan');
                    
                    
                end
                
            end
            
            

            if genotype==1
                All_Incidence_values_WT{anm,phase}=Records_Incidence_OP;
                All_AvDuration_values_WT{anm,phase}=Records_AvDuration_OP;
                
            elseif genotype==2
                All_Incidence_values_Rstl{anm,phase}=Records_Incidence_OP;
                All_AvDuration_values_Rstl{anm,phase}=Records_AvDuration_OP;
            end
                   
        end
    end
end

Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

Phase_names=['BL-L';'BL-D';'SD-L';'SD-D'];

autocorr_acf_WT=nan(n_WT,21);
autocorr_acf_rlss=nan(n_Rstl,21);
autocorr_lags_WT=nan(n_WT,21);
autocorr_lags_rlss=nan(n_Rstl,21);


% WT mice
for phase=1
    for mouse=1:n_WT
        
        data=All_Incidence_values_WT{mouse,phase};
        
        
        figure()

        for ep=1:nb_epi_to_keep
            
            data_ep=data(ep,:);
            data_ep(isnan(data_ep))=[];
            x=1:4:length(data_ep)*4;
            
            subplot(nb_epi_to_keep,3,(ep-1)*3+1)
            
            plot(x,data_ep,'Color',Colours(1,:),'LineWidth',1.5)
            xlabel('Time(s)')
            ylabel({'Number of ';'OFF-P/4s bin'})
            
            subplot(nb_epi_to_keep,3,(ep-1)*3+2)
            y=fft(data_ep);
            fs_timeseries=0.25;%1/4s
            n = length(data_ep);          % number of samples
            f = (0:n-1)*(fs_timeseries/n);     % frequency range
            power = abs(y).^2/n;    % power of the DFT      
            plot(f,power,'Color',Colours(1,:),'LineWidth',1.5)
            xlabel('Frequency')
            ylabel('Power')
            set(gca, 'YScale', 'log')
            
            subplot(nb_epi_to_keep,3,(ep-1)*3+3)
            [acf,lags] = autocorr(data_ep);
            plot(lags,acf,'Color',Colours(1,:),'LineWidth',1.5)
            xlabel('lag')
            ylabel('acf')
            
            autocorr_acf_WT(mouse,:)=acf;
            autocorr_lags_WT(mouse,:)=lags;
            
        end
        sgtitle(['WT mouse #',num2str(mouse)])
    end
end




%rlss mice
for phase=1
    for mouse=1:n_Rstl
        
        data=All_Incidence_values_Rstl{mouse,phase};
        
        
        figure()

        for ep=1:nb_epi_to_keep
            
            data_ep=data(ep,:);
            data_ep(isnan(data_ep))=[];
            x=1:4:length(data_ep)*4;
            
            subplot(nb_epi_to_keep,3,(ep-1)*3+1)
            
            plot(x,data_ep,'Color',Colours(2,:),'LineWidth',1.5)
            xlabel('Time(s)')
            ylabel({'Number of ';'OFF-P/4s bin'})
            
            subplot(nb_epi_to_keep,3,(ep-1)*3+2)
            y=fft(data_ep);
            fs_timeseries=0.25;%1/4s
            n = length(data_ep);          % number of samples
            f = (0:n-1)*(fs_timeseries/n);     % frequency range
            power = abs(y).^2/n;    % power of the DFT      
            plot(f,power,'Color',Colours(2,:),'LineWidth',1.5)
            xlabel('Frequency')
            ylabel('Power')
            set(gca, 'YScale', 'log')
            
            subplot(nb_epi_to_keep,3,(ep-1)*3+3)
            [acf,lags] = autocorr(data_ep);
            plot(lags,acf,'Color',Colours(2,:),'LineWidth',1.5)
            xlabel('lag')
            ylabel('acf')
            
            autocorr_acf_rlss(mouse,:)=acf;
            autocorr_lags_rlss(mouse,:)=lags;
            
        end
        sgtitle(['rlss mouse #',num2str(mouse)])
    end
end

figure()
plotA=errorbar(1:1:21,mean(autocorr_acf_WT,1,'omitnan'),std(autocorr_acf_WT,[],1,'omitnan')/sqrt(n_WT),'-o','Color',Colours(1,:),'LineWidth',1.5)
hold on
plot(1:1:21,autocorr_acf_WT,'.k')
hold on
plotB=errorbar(1.2:1:21.2,mean(autocorr_acf_rlss,1,'omitnan'),std(autocorr_acf_rlss,[],1,'omitnan')/sqrt(n_Rstl),'-o','Color',Colours(2,:),'LineWidth',1.5)
hold on
plot(1.2:1:21.2,autocorr_acf_rlss,'.k')
hold on

xlabel('lag')
ylabel('acf autocorrelogram')

box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

legend([plotA plotB],'WT','rlss')
title(['phase ',Phase_names(phase,:)])




