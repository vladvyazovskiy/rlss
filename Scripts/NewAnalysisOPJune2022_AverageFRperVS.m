%%% New plots OFF period data


clear all
%close all

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




%Plot as a bar graph the number of spikes per channel for each animal

path='/Volumes/Elements/Sleepy6EEG-March2018/SpikeScripts/OutputSpikesWaveForms/';
% An=strvcat('Fe','He','Ju','Le','Me','Ne','Oc','Qu','Ph');
% BL_days=strvcat('091117','161117','161117','161117','200318','200318','200318','200318','200318');
% NumCh=zeros(9,16);
% 
% for i=1:9
%     for ch=1:16
%         mousename=An(i,:);
%         recorddate=BL_days(i,:);
%         fname=[mousename,'-',recorddate,'_L-ch',num2str(ch),'-Spikes_TimeStamps'];
%         eval(['load ',path,fname,'.mat TimeStamps -mat']);
%         NumCh(i,ch)=length(TimeStamps);
%     end
%     figure(2)
%     subplot(3,3,i)
%     barh(NumCh(i,:));
%     title(mousename);
%     xlabel('# of spikes');
%     ylabel('Channel number');
%     xlim([0 2.5*10^6]);
%     set(gca, 'YDir','reverse')
% end


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
                
                Temp_counts_NR=nan(16,1);
                Temp_counts_R=nan(16,1);
                Temp_counts_W=nan(16,1);
                
                for ch=OFFDATA.Channels'
                    
                    fname=[name,'-',phase_name(1:end-1),'_L-ch',num2str(ch),'-Spikes_TimeStamps'];
                    eval(['load ',path,fname,'.mat TimeStamps -mat']);
                    Timestamps_epochs=ceil(TimeStamps/4);
                    
                    bins=1:10800;
                    counts_per_epoch=hist(Timestamps_epochs,bins);
                    Temp_counts_NR(ch)=mean(counts_per_epoch(nr),'omitnan')/4;%We devide by 4 to have the average number of spikes per second (as an epoch is 4sec)
                    Temp_counts_R(ch)=mean(counts_per_epoch(r),'omitnan')/4;
                    Temp_counts_W(ch)=mean(counts_per_epoch(w),'omitnan')/4;
                    Temp_counts_Values=[Temp_counts_NR Temp_counts_R Temp_counts_W];
                    
                    
                end
                
                
                if genotype==1
                    All_count_values_WT{anm,phase}=Temp_counts_Values;
                    
                elseif genotype==2
                    All_count_values_Rstl{anm,phase}=Temp_counts_Values;
                    
                end
                
            end
        end
    end
end


%%%Plotting the histograms per genotype

VS_titles={'BL-light-NR','BL-light-R','BL-light-W'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

%%%Plotting the survival curves per genotype - with error bars

figure()
for vs=1:3
    subplot(1,3,vs)
    
    
    
    temp_WT=cell2mat(All_count_values_WT(:,1));
    temp_WT(temp_WT==0)=NaN;
    
    temp_Rstl=cell2mat(All_count_values_Rstl(:,1));
    temp_Rstl(temp_Rstl==0)=NaN;
    hold all
    
    errorbar(1,mean(temp_WT(:,vs),'omitnan'),std(temp_WT(:,vs),[],'omitnan')/sqrt(4),'o','Color',Colours(1,:),'LineWidth',3);
    hold on
    plot(1,temp_WT(:,vs),'.k')
    hold on
    errorbar(2,mean(temp_Rstl(:,vs),'omitnan'),std(temp_Rstl(:,vs),[],'omitnan')/sqrt(5),'o','Color',Colours(2,:),'LineWidth',3);
    hold on
    plot(2,temp_Rstl(:,vs),'.k')
    hold on
%     if phase==1 || phase==3
%         ylabel('% of OFF-periods')
%     end
%     if phase==3 || phase==4
%         xlabel('OFF-period duration (ms)')
%     end
    xlim([0 3])
    ylim([0 50])
    title([VS_titles{vs}])
    xticks(1:2)
    xticklabels({'WT','Rlss'})
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    ylabel('Average FR (spikes/s)')
    

end

