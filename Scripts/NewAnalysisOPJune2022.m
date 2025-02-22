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
All_Hist_values_WT=cell(5,4);
All_Hist_values_Rstl=cell(5,4);
All_cdf_values_WT=cell(5,4);
All_cdf_values_Rstl=cell(5,4);
Mean_shortest_WT=cell(5,4);
Mean_shortest_Rstl=cell(5,4);
Mean_longest_WT=cell(5,4);
Mean_longest_Rstl=cell(5,4);
Mean_longest_absNum_WT=cell(5,4);
Mean_longest_absNum_Rstl=cell(5,4);
Perc_shortest_WT=cell(5,4);
Perc_shortest_Rstl=cell(5,4);
Perc_longest_WT=cell(5,4);
Perc_longest_Rstl=cell(5,4);
All_OFFperiod_length_WT=cell(5,4);
All_OFFperiod_length_Rstl=cell(5,4);

edges=0:5:1200;
perc_OP_interest=5; % If I want to look at 5% shortest and longest off-periods.
abs_num_of_interest=1000;

VS_interest='NR'; % 'All' , 'NR', 'R' , 'W'


%%%%%%  Plotting Histograms (probability)
for genotype=1:2 % 1=WT, 2=Rstl
    for anm=1:5
        
        if genotype==1 && anm==4 %Le only has a recording for BL L 
            phase_scope=1;
        else
            phase_scope=1:4;
        end
        
        for phase=phase_scope % BL L, BL D , SD L, SD D.
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
            
            Start_OFF=OFFDATA.StartOP;
            End_OFF=OFFDATA.EndOP;
            
            if strcmp(VS_interest,'All')
                vigilance_state_of_interest=[nr;r;w];
            elseif strcmp(VS_interest,'NR')
                vigilance_state_of_interest=nr;
            elseif strcmp(VS_interest,'R')
                vigilance_state_of_interest=r;
            elseif strcmp(VS_interest,'W')
                vigilance_state_of_interest=w;
            end

            
            
            Temp_Hist_Values=nan(size(Start_OFF,2),length(edges)-1);
            Temp_cdf_Values=nan(size(Start_OFF,2),length(edges)-1);
            Temp_shortest=[];
            Temp_longest=[];
            Temp_longest_absNum=[];
            Temp_OFF_Durations=cell(size(Start_OFF,2),1);
            
            for i=1:size(Start_OFF,2)
                StartOFF_indexes_allVS=find(Start_OFF(:,i)); %StartOFF_indexes(end)=[];
                EndOFF_indexes_allVS=find(End_OFF(:,i)); %EndON_indexes(1)=[];
                
                
                
                
                StartOFF_indexes=StartOFF_indexes_allVS(ismember(ceil(StartOFF_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
                EndOFF_indexes=EndOFF_indexes_allVS(ismember(ceil(StartOFF_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
    

                OFF_Durations=(EndOFF_indexes-StartOFF_indexes)*1000/OFFDATA.PNEfs;
                OFF_Durations(OFF_Durations==0)=[];
                
               
                
                
                %                 figure(1)
                %                 h=histogram(OFF_Durations,edges,'Normalization','Probability');
                %                 hold on
                
                [Temp_Hist_Values(i,:),edges]=histcounts(OFF_Durations,edges,'Normalization','Probability');
                [Temp_cdf_Values(i,:),edges]=histcounts(OFF_Durations,edges,'Normalization','cdf');
                
                
                %%% Calculating mean value of shortest/longest x% Off periods
                Sorted_OP_durations=sort(OFF_Durations);
                Temp_shortest=[Temp_shortest; mean(Sorted_OP_durations(1:round(length(Sorted_OP_durations)/100*perc_OP_interest)),'omitnan')];
                Temp_longest=[Temp_longest; mean(Sorted_OP_durations(end-round(length(Sorted_OP_durations)/100*perc_OP_interest):end),'omitnan')];                
                %%% Getting the value of the xth percentile threshold value of the shortest/longest Off periods:
                Temp_shortest_percThreshold=[Temp_shortest; Sorted_OP_durations(round(length(Sorted_OP_durations)/100*perc_OP_interest))];
                Temp_longest_percThreshold=[Temp_longest; Sorted_OP_durations(end-round(length(Sorted_OP_durations)/100*perc_OP_interest))];
                Temp_OFF_Durations{i}=OFF_Durations;
                %%% Calculating mean value of X absolute number ('abs_num_of_interest') of longest OFF periods, removing very short OP (<20ms) first just in case
                Sorted_OP_durations_noShort=Sorted_OP_durations;
                Sorted_OP_durations_noShort(Sorted_OP_durations_noShort<20)=[];
                Temp_longest_absNum=[Temp_longest_absNum; mean(Sorted_OP_durations_noShort(end-abs_num_of_interest:end),'omitnan')];                
                
                
            end
                if genotype==1
                    All_Hist_values_WT{anm,phase}=Temp_Hist_Values;
                    All_cdf_values_WT{anm,phase}=Temp_cdf_Values;
                    Mean_shortest_WT{anm,phase}=Temp_shortest;
                    Mean_longest_WT{anm,phase}=Temp_longest;
                    Mean_longest_absNum_WT{anm,phase}=Temp_longest_absNum;
                    Perc_shortest_WT{anm,phase}=Temp_shortest_percThreshold;
                    Perc_longest_WT{anm,phase}=Temp_longest_percThreshold;
                    All_OFFperiod_length_WT{anm,phase}=Temp_OFF_Durations;
                elseif genotype==2
                    All_Hist_values_Rstl{anm,phase}=Temp_Hist_Values;
                    All_cdf_values_Rstl{anm,phase}=Temp_cdf_Values;
                    Mean_shortest_Rstl{anm,phase}=Temp_shortest;
                    Mean_longest_Rstl{anm,phase}=Temp_longest;
                    Mean_longest_absNum_Rstl{anm,phase}=Temp_longest_absNum;
                    Perc_shortest_Rstl{anm,phase}=Temp_shortest_percThreshold;
                    Perc_longest_Rstl{anm,phase}=Temp_longest_percThreshold;
                    All_OFFperiod_length_Rstl{anm,phase}=Temp_OFF_Durations;
                end
                   
        end
    end
end


%%%Plotting the histograms per genotype

Phase_titles={'BL-light','BL-dark','SD-light','SD-dark'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

figure()
for phase=1:4
    subplot(1,4,phase)
    
    semilogy(edges(1:end-1),100*mean(cell2mat(All_Hist_values_WT(:,phase)),'omitnan'),'Color',Colours(1,:),'LineWidth',3);
    hold on
    semilogy(edges(1:end-1),100*mean(cell2mat(All_Hist_values_Rstl(:,phase)),'omitnan'),'Color',Colours(2,:),'LineWidth',3)
    xlim([0 500])
    xlabel('Off-period duration (ms)')
    ylabel('% of OFF-periods')
    title(Phase_titles{phase})
    legend('WT','Rlss','Box','off')
    sgtitle(['Distribution of OFF-period durations - ',VS_interest])
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
end

%%%Plotting the survival curves per genotype

figure()
for phase=1:4
    subplot(2,2,phase)
    
    semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_WT(:,phase)),'omitnan')),'Color',Colours(1,:),'LineWidth',3);
    hold on
    semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_Rstl(:,phase)),'omitnan')),'Color',Colours(2,:),'LineWidth',3)
    xlim([0 500])    
    if phase==1 || phase==3
        ylabel('% of OFF-periods')
    end
    if phase==3 || phase==4
        xlabel('OFF-period duration (ms)')
    end
    title(Phase_titles{phase})
    if phase==4
        legend('WT','Rlss','Box','off')
    end
    sgtitle(['Survival curves of OFF-periods - ',VS_interest])
    if phase==1 || phase==3
        set(subplot(2,2,phase),'color',[1 1 0.8])
    else
        set(subplot(2,2,phase),'Color',[0.8 0.8 0.8])
    end
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;

end

%%%Plotting the survival curves per animal


for phase=1%1:4
    for genotype=1:2
        for anm=1:5
            figure()
            numCh=size(cell2mat(All_cdf_values_WT(anm,phase)),1);
            if genotype==1
                semilogy(edges(1:end-1),100*(1-cell2mat(All_cdf_values_WT(anm,phase)))','LineWidth',3);
                name=WT{anm};
            else
                semilogy(edges(1:end-1),100*(1-cell2mat(All_cdf_values_Rstl(anm,phase))),'LineWidth',3);
                name=Rstl{anm};
            end
            
            ylim([0.01 100])
            
            ylabel('% of OFF-periods')
            
            xlabel('OFF-period duration (ms)')
            
            title([Phase_titles{phase},'-',name])
            
            lgd=legend;
            
            
            box off
            ax = gca; % current axes
            ax.TickDir = 'out';
            ax.LineWidth = 1.5;
        end
    end

end

%%%% TEST because it's starting to get on my nerves
figure()
chosen_end=75;
hAx=axes;
hAx.YScale='log';
temp_WT=cell2mat(All_cdf_values_WT(:,phase));
temp_WT(temp_WT==0)=NaN;

temp_Rstl=cell2mat(All_cdf_values_Rstl(:,phase));
temp_Rstl(temp_Rstl==0)=NaN;
hold all
shadedErrorBar(edges(1:chosen_end),100*(1-mean(temp_WT(:,1:chosen_end),'omitnan')),[100*(std(temp_WT(:,1:chosen_end),[],'omitnan')/sqrt(5));zeros(1,chosen_end)],'lineProps',{'Color',Colours(1,:),'LineWidth',3});
hold on
shadedErrorBar(edges(1:chosen_end),100*(1-mean(temp_Rstl(:,1:chosen_end),'omitnan')),[100*(std(temp_Rstl(:,1:chosen_end),[],'omitnan')/sqrt(5));zeros(1,chosen_end)],'lineProps',{'Color',Colours(2,:),'LineWidth',3})
%grid on
legend('WT','Rlss','Box','off')
%xlim([0,100])
title('.......');
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
xlabel('OFF-period duration (ms)')
ylabel('% of OFF-periods')

%%%Plotting the survival curves per genotype - with error bars

%figure()
for phase=1:4
    %subplot(2,2,phase)
    figure()
    chosen_end=75;
    
    hAx=axes;
    hAx.YScale='log';
    temp_WT=cell2mat(All_cdf_values_WT(:,phase));
    temp_WT(temp_WT==0)=NaN;
    
    temp_Rstl=cell2mat(All_cdf_values_Rstl(:,phase));
    temp_Rstl(temp_Rstl==0)=NaN;
    hold all
    shadedErrorBar(edges(1:chosen_end),100*(1-mean(temp_WT(:,1:chosen_end),'omitnan')),[100*(std(temp_WT(:,1:chosen_end),[],'omitnan')/sqrt(5));zeros(1,chosen_end)],'lineProps',{'Color',Colours(1,:),'LineWidth',3});
    hold on
    shadedErrorBar(edges(1:chosen_end),100*(1-mean(temp_Rstl(:,1:chosen_end),'omitnan')),[100*(std(temp_Rstl(:,1:chosen_end),[],'omitnan')/sqrt(5));zeros(1,chosen_end)],'lineProps',{'Color',Colours(2,:),'LineWidth',3})

%     if phase==1 || phase==3
%         ylabel('% of OFF-periods')
%     end
%     if phase==3 || phase==4
%         xlabel('OFF-period duration (ms)')
%     end
    if phase==4
        legend('WT','Rlss','Box','off')
    end
    title([Phase_titles{phase}])
    if phase==1 || phase==3
        set(gca,'color',[1 1 0.8])
    else
        set(gca,'Color',[0.8 0.8 0.8])
    end
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;

end


%%%%

figure()
for phase=1:4
    subplot(2,2,phase)
    hAx=axes;
    hAx.YScale='log';
    hold all
    shadedErrorBar(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_WT(:,phase)),'omitnan')),100*(std(cell2mat(All_cdf_values_WT(:,phase)),'omitnan')/sqrt(5)),'lineProps',{'Color',Colours(1,:),'LineWidth',3});
    hold on
    shadedErrorBar(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_Rstl(:,phase)),'omitnan')),100*(std(cell2mat(All_cdf_values_Rstl(:,phase)),'omitnan')/sqrt(5)),'lineProps',{'Color',Colours(2,:),'LineWidth',3})
    %xlim([0 500])
    if phase==1 || phase==3
        ylabel('% of OFF-periods')
    end
    if phase==3 || phase==4
        xlabel('OFF-period duration (ms)')
    end
    title(Phase_titles{phase})
    if phase==4
        legend('WT','Rlss','Box','off')
    end
    sgtitle(['Survival curves of OFF-periods - ',VS_interest])
    if phase==1 || phase==3
        set(subplot(2,2,phase),'color',[1 1 0.8])
    else
        set(subplot(2,2,phase),'Color',[0.8 0.8 0.8])
    end
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    %set(gca,'YScale','log')
end

% %%% Statistics on survival curves using the logrank function obtained from GitHub
% % Merge all OFF_period durations !!!! Only considers OFF period durations from the last channel of each mouse.
% 
% OP_WT=[];OP_Rstl=[];
% 
% for anm=1:5
%     for phase=1
%        OP_WT=[OP_WT; All_OFFperiod_length_WT{anm,phase}];
%        OP_Rstl=[OP_Rstl; All_OFFperiod_length_Rstl{anm,phase}];
%     end
% end
% % Adding column of zeros to each so logrank works
% OP_WT=[OP_WT zeros(length(OP_WT),1)];
% OP_Rstl=[OP_Rstl zeros(length(OP_Rstl),1)];
% logrank(OP_WT,OP_Rstl);

%%%% Plotting the mean duration of OFF periods (all included) per channel
MeanDuration_WT_allOP=cell(5,4);
MeanDuration_Rstl_allOP=cell(5,4);

for phase=1:4
    for anm=1:5
        numCh_WT=length(All_OFFperiod_length_WT{anm,phase});
        Temp=[];
        for ch=1:numCh_WT
            Mean_ch=mean(All_OFFperiod_length_WT{anm,phase}{ch});
            Temp=[Temp;Mean_ch];
        end
        MeanDuration_WT_allOP{anm,phase}=Temp;
        
        numCh_Rstl=length(All_OFFperiod_length_Rstl{anm,phase});
        Temp=[];
        for ch=1:numCh_Rstl
            Mean_ch=mean(All_OFFperiod_length_Rstl{anm,phase}{ch});
            Temp=[Temp;Mean_ch];
        end
        MeanDuration_Rstl_allOP{anm,phase}=Temp;
    end
end


figure()
for phase=1%:4
    %subplot(1,4,phase)
    for genotype=1:2
        if genotype==1
            notBoxPlot(cell2mat(MeanDuration_WT_allOP(:,phase)),genotype*ones(1,length(cell2mat(MeanDuration_WT_allOP(:,phase)))))
            hold on
%             plot(genotype,cell2mat(MeanDuration_WT_allOP(:,phase)),'.k')
%             hold on
            
        elseif genotype==2
            notBoxPlot(cell2mat(MeanDuration_Rstl_allOP(:,phase)),genotype*ones(1,length(cell2mat(MeanDuration_Rstl_allOP(:,phase)))))
            hold on
%             plot(genotype,cell2mat(MeanDuration_Rstl_allOP(:,phase)),'.k')
%             hold on
            
        end
        xlim([0 3])
        xticks(1:2)
        xticklabels({'WT','rlss'})
        if phase==1
            ylabel('Mean OFF-period duration (ms)')
        end
        
        title(['Average duration of OFF-periods - ',VS_interest,'-',Phase_titles{phase}])
%         if phase==1 || phase==3
%             set(subplot(1,4,phase),'color',[1 1 0.8])
%         else
%             set(subplot(1,4,phase),'Color',[0.8 0.8 0.8])
%         end
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        set(gca, 'YScale', 'log')
    end   
end

%%%% Plotting the median duration of OFF periods (all included) per channel
MedianDuration_WT_allOP=cell(5,4);
MedianDuration_Rstl_allOP=cell(5,4);

for phase=1:4
    for anm=1:5
        numCh_WT=length(All_OFFperiod_length_WT{anm,phase});
        Temp=[];
        for ch=1:numCh_WT
            Median_ch=median(All_OFFperiod_length_WT{anm,phase}{ch});
            Temp=[Temp;Median_ch];
        end
        MedianDuration_WT_allOP{anm,phase}=Temp;
        
        numCh_Rstl=length(All_OFFperiod_length_Rstl{anm,phase});
        Temp=[];
        for ch=1:numCh_Rstl
            Median_ch=mean(All_OFFperiod_length_Rstl{anm,phase}{ch});
            Temp=[Temp;Median_ch];
        end
        MedianDuration_Rstl_allOP{anm,phase}=Temp;
    end
end


figure()
for phase=1%:4
    %subplot(1,4,phase)
    for genotype=1:2
        if genotype==1
            notBoxPlot(cell2mat(MedianDuration_WT_allOP(:,phase)),genotype*ones(1,length(cell2mat(MedianDuration_WT_allOP(:,phase)))))
            hold on
%             plot(genotype,cell2mat(MeanDuration_WT_allOP(:,phase)),'.k')
%             hold on
            
        elseif genotype==2
            notBoxPlot(cell2mat(MedianDuration_Rstl_allOP(:,phase)),genotype*ones(1,length(cell2mat(MedianDuration_Rstl_allOP(:,phase)))))
            hold on
%             plot(genotype,cell2mat(MeanDuration_Rstl_allOP(:,phase)),'.k')
%             hold on
            
        end
        xlim([0 3])
        xticks(1:2)
        xticklabels({'WT','rlss'})
        if phase==1
            ylabel('Median OFF-period duration (ms)')
        end
        
        title(['Median duration of OFF-periods - ',VS_interest,'-',Phase_titles{phase}])
%         if phase==1 || phase==3
%             set(subplot(1,4,phase),'color',[1 1 0.8])
%         else
%             set(subplot(1,4,phase),'Color',[0.8 0.8 0.8])
%         end
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        set(gca, 'YScale', 'log')
    end   
end

%%% Plotting the mean duration of the 1% shortest off periods

figure()
for phase=1:4
    subplot(1,4,phase)
    for genotype=1:2
        if genotype==1 && anm==4 %Le only has a recording for BL L
            % do nothing
        elseif genotype==1
            errorbar(genotype,mean(cell2mat(Mean_shortest_WT(:,phase)),'omitnan'),std(cell2mat(Mean_shortest_WT(:,phase)),'omitnan')/sqrt(length(cell2mat(Mean_shortest_WT(:,phase)))),'o','Color',Colours(1,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Mean_shortest_WT(:,phase)),'.k')
            
        elseif genotype==2
            errorbar(genotype,mean(cell2mat(Mean_shortest_Rstl(:,phase)),'omitnan'),std(cell2mat(Mean_shortest_Rstl(:,phase)),'omitnan')/sqrt(length(cell2mat(Mean_shortest_Rstl(:,phase)))),'o','Color',Colours(2,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Mean_shortest_Rstl(:,phase)),'.k')
            
        end
        xlim([0 3])
        xticks(1:2)
        xticklabels({'WT','Rlss'})
        if phase==1
            ylabel('OFF-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% shortest OFF-periods - ',VS_interest])
        if phase==1 || phase==3
            set(subplot(1,4,phase),'color',[1 1 0.8])
        else
            set(subplot(1,4,phase),'Color',[0.8 0.8 0.8])
        end
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        set(gca, 'YScale', 'log')
    end   
end


%%% Plotting the mean duration of the 1% longest off periods
figure()
for phase=1:4
    subplot(1,4,phase)
    for genotype=1:2
        if genotype==1 && anm==4 %Le only has a recording for BL L
            % do nothing
        elseif genotype==1
            errorbar(genotype,mean(cell2mat(Mean_longest_WT(:,phase)),'omitnan'),std(cell2mat(Mean_longest_WT(:,phase)),'omitnan')/sqrt(length(cell2mat(Mean_longest_WT(:,phase)))),'o','Color',Colours(1,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Mean_longest_WT(:,phase)),'.k')
            
        elseif genotype==2
            errorbar(genotype,mean(cell2mat(Mean_longest_Rstl(:,phase)),'omitnan'),std(cell2mat(Mean_longest_Rstl(:,phase)),'omitnan')/sqrt(length(cell2mat(Mean_longest_Rstl(:,phase)))),'o','Color',Colours(2,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Mean_longest_Rstl(:,phase)),'.k')
            
        end
        xlim([0 3])
        %ylim([0 1000])
        xticks(1:2)
        xticklabels({'WT','rlss'})
        if phase==1
            ylabel('OFF-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% longest OFF-periods - ',VS_interest])
        if phase==1 || phase==3
            set(subplot(1,4,phase),'color',[1 1 0.8])
        else
            set(subplot(1,4,phase),'Color',[0.8 0.8 0.8])
        end
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        set(gca, 'YScale', 'log')
    end   
end


%%% Plotting the mean duration of the abs X num longest off periods
figure()
for phase=1:4
    subplot(1,4,phase)
    for genotype=1:2
        if genotype==1 && anm==4 %Le only has a recording for BL L
            % do nothing
        elseif genotype==1
            errorbar(genotype,mean(cell2mat(Mean_longest_absNum_WT(:,phase)),'omitnan'),std(cell2mat(Mean_longest_absNum_WT(:,phase)),'omitnan')/sqrt(length(cell2mat(Mean_longest_absNum_WT(:,phase)))),'o','Color',Colours(1,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Mean_longest_absNum_WT(:,phase)),'.k')
            
        elseif genotype==2
            errorbar(genotype,mean(cell2mat(Mean_longest_absNum_Rstl(:,phase)),'omitnan'),std(cell2mat(Mean_longest_absNum_Rstl(:,phase)),'omitnan')/sqrt(length(cell2mat(Mean_longest_absNum_Rstl(:,phase)))),'o','Color',Colours(2,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Mean_longest_absNum_Rstl(:,phase)),'.k')
            
        end
        xlim([0 3])
        %ylim([0 1000])
        xticks(1:2)
        xticklabels({'WT','rlss'})
        if phase==1
            ylabel('OFF-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Average duration of the ',num2str(abs_num_of_interest),' longest OFF-periods - ',VS_interest])
        if phase==1 || phase==3
            set(subplot(1,4,phase),'color',[1 1 0.8])
        else
            set(subplot(1,4,phase),'Color',[0.8 0.8 0.8])
        end
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        set(gca, 'YScale', 'log')
    end
    phase
    %p_wilcoxonTest = signrank(cell2mat(Mean_longest_absNum_WT(:,phase)),cell2mat(Mean_longest_absNum_Rstl(:,phase)))
end


%%% Plotting the xth percentile threshold of the longest off periods
figure()
for phase=1:4
    subplot(1,4,phase)
    for genotype=1:2
        if genotype==1 && anm==4 %Le only has a recording for BL L
            % do nothing
        elseif genotype==1
            errorbar(genotype,mean(cell2mat(Perc_longest_WT(:,phase)),'omitnan'),std(cell2mat(Perc_longest_WT(:,phase)),'omitnan')/sqrt(length(cell2mat(Perc_longest_WT(:,phase)))),'o','Color',Colours(1,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Perc_longest_WT(:,phase)),'.k')
            
        elseif genotype==2
            errorbar(genotype,mean(cell2mat(Perc_longest_Rstl(:,phase)),'omitnan'),std(cell2mat(Perc_longest_Rstl(:,phase)),'omitnan')/sqrt(length(cell2mat(Perc_longest_Rstl(:,phase)))),'o','Color',Colours(2,:),'LineWidth',1.5)
            hold on
            plot(genotype,cell2mat(Perc_longest_Rstl(:,phase)),'.k')
            
        end
        xlim([0 3])
        %ylim([0 1000])
        xticks(1:2)
        xticklabels({'WT','rlss'})
        if phase==1
            ylabel('OFF-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Threshold duration of the ',num2str(perc_OP_interest),'% longest OFF-periods - ',VS_interest])
        if phase==1 || phase==3
            set(subplot(1,4,phase),'color',[1 1 0.8])
        else
            set(subplot(1,4,phase),'Color',[0.8 0.8 0.8])
        end
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        set(gca, 'YScale', 'log')
    end   
end

%%%%%% SIMILAR PLOTS but comparing BL vs SD

%%%Plotting the survival curves; one subplot per genotype

figure()

subplot(1,2,1)
semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_WT(:,1)),'omitnan')),'Color',Colours(1,:),'LineWidth',3);
hold on
semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_WT(:,3)),'omitnan')),'Color',Colours(1,:)+0.2,'LineWidth',3)
xlim([0 500])
xlabel('OFF-period duration (ms)')
ylabel('% of OFF-periods')
title('WT mice')
legend('BL','SD','Box','off')
sgtitle(['Survival curves of OFF-periods during the light phase - ',VS_interest])
ylim([0.0001 100])  %% NR: ylim([0.001 100])   REM: ylim([0.0001 100])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,2,2)
semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_Rstl(:,1)),'omitnan')),'Color',Colours(2,:),'LineWidth',3);
hold on
semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_Rstl(:,3)),'omitnan')),'Color',Colours(2,:)+0.2,'LineWidth',3)
xlim([0 500])
xlabel('OFF-period duration (ms)')
ylabel('% of OFF-periods')
title('Rlss mice')
legend('BL','SD','Box','off')
sgtitle(['Survival curves of OFF-periods during the light phase - ',VS_interest])
ylim([0.0001 100]) %% NR: ylim([0.001 100])   REM: ylim([0.0001 100])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

%%% Plotting the mean duration of the 1% shortest off periods


figure()

subplot(1,2,1)
%BL
errorbar(1,mean(cell2mat(Mean_shortest_WT(:,1)),'omitnan'),std(cell2mat(Mean_shortest_WT(:,1)),'omitnan')/sqrt(length(cell2mat(Mean_shortest_WT(:,1)))),'o','Color',Colours(1,:),'LineWidth',1.5)
hold on
plot(1,cell2mat(Mean_shortest_WT(:,1)),'.k')
hold on
%SD
errorbar(2,mean(cell2mat(Mean_shortest_WT(:,3)),'omitnan'),std(cell2mat(Mean_shortest_WT(:,3)),'omitnan')/sqrt(length(cell2mat(Mean_shortest_WT(:,3)))),'o','Color',Colours(1,:)+0.2,'LineWidth',1.5)
hold on
plot(2,cell2mat(Mean_shortest_WT(:,3)),'.k')
xlim([0 3])
ylim([0 70])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('OFF-period duration (ms)')
title('WT mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% shortest OFF-periods - ',VS_interest,' (light phase)'])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,2,2)
%BL
errorbar(1,mean(cell2mat(Mean_shortest_Rstl(:,1)),'omitnan'),std(cell2mat(Mean_shortest_Rstl(:,1)),'omitnan')/sqrt(length(cell2mat(Mean_shortest_Rstl(:,1)))),'o','Color',Colours(2,:),'LineWidth',1.5)
hold on
plot(1,cell2mat(Mean_shortest_Rstl(:,1)),'.k')
hold on
%SD
errorbar(2,mean(cell2mat(Mean_shortest_Rstl(:,3)),'omitnan'),std(cell2mat(Mean_shortest_Rstl(:,3)),'omitnan')/sqrt(length(cell2mat(Mean_shortest_Rstl(:,3)))),'o','Color',Colours(2,:)+0.2,'LineWidth',1.5)
hold on
plot(2,cell2mat(Mean_shortest_Rstl(:,3)),'.k')
xlim([0 3])
ylim([0 70])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('OFF-period duration (ms)')
title('Rlss mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% shortest OFF-periods - ',VS_interest,' (light phase)'])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;


%%% Plotting the mean duration of the 1% longest off periods


figure()

subplot(1,2,1)
%BL
errorbar(1,mean(cell2mat(Mean_longest_WT(:,1)),'omitnan'),std(cell2mat(Mean_longest_WT(:,1)),'omitnan')/sqrt(length(cell2mat(Mean_longest_WT(:,1)))),'o','Color',Colours(1,:),'LineWidth',1.5)
hold on
plot(1,cell2mat(Mean_longest_WT(:,1)),'.k')
hold on
%SD
errorbar(2,mean(cell2mat(Mean_longest_WT(:,3)),'omitnan'),std(cell2mat(Mean_longest_WT(:,3)),'omitnan')/sqrt(length(cell2mat(Mean_longest_WT(:,3)))),'o','Color',Colours(1,:)+0.2,'LineWidth',1.5)
hold on
plot(2,cell2mat(Mean_longest_WT(:,3)),'.k')
xlim([0 3])
ylim([0 1000])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('OFF-period duration (ms)')
title('WT mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% longest OFF-periods - ',VS_interest,' (light phase)'])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,2,2)
%BL
errorbar(1,mean(cell2mat(Mean_longest_Rstl(:,1)),'omitnan'),std(cell2mat(Mean_longest_Rstl(:,1)),'omitnan')/sqrt(length(cell2mat(Mean_longest_Rstl(:,1)))),'o','Color',Colours(2,:),'LineWidth',1.5)
hold on
plot(1,cell2mat(Mean_longest_Rstl(:,1)),'.k')
hold on
%SD
errorbar(2,mean(cell2mat(Mean_longest_Rstl(:,3)),'omitnan'),std(cell2mat(Mean_longest_Rstl(:,3)),'omitnan')/sqrt(length(cell2mat(Mean_longest_Rstl(:,3)))),'o','Color',Colours(2,:)+0.2,'LineWidth',1.5)
hold on
plot(2,cell2mat(Mean_longest_Rstl(:,3)),'.k')
xlim([0 3])
ylim([0 1000])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('OFF-period duration (ms)')
title('Rlss mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% longest OFF-periods - ',VS_interest,' (light phase)'])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;


% For stats round 2 of revisions where we want to keep only one value (median) per mouse
Values_WT=nan(5,4);
Values_Rstl=nan(5,4);
for phase=1:4
    for anm=1:5
        Values_WT(anm,phase)=median(Mean_longest_WT{anm,phase},'omitnan');
        Values_Rstl(anm,phase)=median(Mean_longest_Rstl{anm,phase},'omitnan');
    end
end

% Notes for stats:
% phase=1 or 2 or 3 or 4;
%[h,p,ci,stats] = ttest2(cell2mat(Mean_longest_WT(:,phase)),cell2mat(Mean_longest_Rstl(:,phase)))

% IF WANTING TO KEEP ALL CHANNELS INDIVIDUALLY:
%[p,h,stats] = ranksum(cell2mat(Mean_longest_WT(:,phase)),cell2mat(Mean_longest_Rstl(:,phase)))
%IF WANTING TO KEEP ONE (Median) VALUE PER MOUSE:
% [p,h,stats] = ranksum(Values_WT(:,phase),Values_Rstl(:,phase))
% [h,p,ci,stats] = ttest2(Values_WT(:,phase),Values_Rstl(:,phase))

% Preparing variables to use the 'simple_mixed_anova.m' function
% We will have a 10 x maxNumCh x 4 matrix: For the 10mice, with as many columns as the largest number of channesls (filled with nan accordingly) and 4 phases along the z dimension.
%Find maxnumber of channels:
maxCh=0;
minCh=100;
for phase=1
    for anm=1:5
        temp=length(Mean_longest_WT{anm,phase});
        temp2=length(Mean_longest_Rstl{anm,phase});
        if max(temp,temp2)>maxCh 
            maxCh=max(temp,temp2);
        end
        if min(temp,temp2)<minCh
            minCh=min(temp,temp2);
        end
    end
end

% % Keeping all channels, feeling missing ones with NaNs in mice whihc have fewer channels thant the others.
% mat_for_anova_withNaN=nan(10,maxCh,4);
% for phase=1:4
%     for anm=1:5
%         mat_for_anova_withNaN(anm,1:length(Mean_longest_WT{anm,phase}),phase)=Mean_longest_WT{anm,phase}';
%         mat_for_anova_withNaN(anm+5,1:length(Mean_longest_Rstl{anm,phase}),phase)=Mean_longest_Rstl{anm,phase}';
%     end
% end
% Keeping only as many channels as the smallest number available in all mice, feeling missing ones with NaNs in mice whihc have fewer channels thant the others.
mat_for_anova_withoutNaN=nan(10,minCh,4);
for phase=1:4
    for anm=1:5
        if ~isempty(Mean_longest_WT{anm,phase})
            mat_for_anova_withoutNaN(anm,:,phase)=Mean_longest_WT{anm,phase}(1:minCh)';
        end
        mat_for_anova_withoutNaN(anm+5,:,phase)=Mean_longest_Rstl{anm,phase}(1:minCh)';
    end
end

% Non log-transformed values
between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
for phase=1:4
    if phase==1
        datamat=mat_for_anova_withoutNaN(:,:,phase);
        between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
    else
        datamat=mat_for_anova_withoutNaN([1 2 3 5 6 7 8 9 10],:,phase);
        between_factors=[0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
    end
    phase
    tbl = simple_mixed_anova(datamat, between_factors, {'Channel'},{'Genotype'})
end


% Log-transformed values
between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
for phase=1:4
    if phase==1
        datamat=log(mat_for_anova_withoutNaN(:,:,phase));
        between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
    else
        datamat=log(mat_for_anova_withoutNaN([1 2 3 5 6 7 8 9 10],:,phase));
        between_factors=[0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
    end
    phase
    tbl = simple_mixed_anova(datamat, between_factors, {'ChannelLOG'},{'Genotype'})
end


% Calculating area under the curve of the survival curves

% Testing with BL light first
AUC_WT=cell(5,1);
AUC_rlss=cell(5,1);
AUC_all=nan(10,minCh);

for phase=2
    for anm=1:5
        %WT
        AUC_temp_WT=nan(1,size(All_cdf_values_WT{anm,phase},1));
        for ch=1:size(All_cdf_values_WT{anm,phase},1)
            AUC_temp_WT(ch)=trapz(1-All_cdf_values_WT{anm,phase}(ch,:));
            AUC_WT{anm}=AUC_temp_WT;
            AUC_all(anm,:)=AUC_temp_WT(1:minCh);
        end
        
        %rlss
        AUC_temp_rlss=nan(1,size(All_cdf_values_Rstl{anm,phase},1));
        for ch=1:size(All_cdf_values_Rstl{anm,phase},1)
            AUC_temp_rlss(ch)=trapz(1-All_cdf_values_Rstl{anm,phase}(ch,:));
            AUC_rlss{anm}=AUC_temp_rlss;
            AUC_all(anm+5,:)=AUC_temp_rlss(1:minCh);
        end
    end
    Geno=[1 1 1 1 1 2 2 2 2 2]';
    tbl_AUC = simple_mixed_anova(AUC_all(:,1:5), Geno, {'ChannelAUC'},{'Genotype'})
end

%Other way to try
meas=AUC_all;

t = table(Geno,meas(:,1),meas(:,2),meas(:,3),meas(:,4),meas(:,5),...
'VariableNames',{'Genotype','meas1','meas2','meas3','meas4','meas5'});
Meas = table([1 2 3 4 5]','VariableNames',{'Channels'});

rm = fitrm(t,'meas1-meas5~Genotype','WithinDesign',Meas);

ranovatbl = ranova(rm)

% Now Combining Light and dark of baseline day

cdf_Values_BL_LandD_WT=cell(5,1);
cdf_Values_BL_LandD_rlss=cell(5,1);

for anm=1:5
    
    %WT
    num_Ch_WT=size(All_cdf_values_WT{anm,phase},1);    
    Temp_cdf_Values_BL_LandD_WT=nan(num_Ch_WT,length(edges)-1);
    
    for ch=1:num_Ch_WT
        Temp_OP_Durations=[All_OFFperiod_length_WT{anm,1}{ch};All_OFFperiod_length_WT{anm,2}{ch}];
        
        [Temp_cdf_Values_BL_LandD_WT(ch,:),edges]=histcounts(Temp_OP_Durations,edges,'Normalization','cdf');
    end  
    cdf_Values_BL_LandD_WT{anm}=Temp_cdf_Values_BL_LandD_WT;
    
    
    
    %rlss
    num_Ch_rlss=size(All_cdf_values_Rstl{anm,phase},1);    
    Temp_cdf_Values_BL_LandD_rlss=nan(num_Ch_rlss,length(edges)-1);
    
    for ch=1:num_Ch_rlss
        Temp_OP_Durations=[All_OFFperiod_length_Rstl{anm,1}{ch};All_OFFperiod_length_Rstl{anm,2}{ch}];
        
        [Temp_cdf_Values_BL_LandD_rlss(ch,:),edges]=histcounts(Temp_OP_Durations,edges,'Normalization','cdf');
    end  
    cdf_Values_BL_LandD_rlss{anm}=Temp_cdf_Values_BL_LandD_rlss;
    
end

AUC_BL_WT=cell(5,1);
AUC_BL_rlss=cell(5,1);
AUC_BL_all=nan(10,minCh);

for anm=1:5
    %WT
    AUC_temp_WT=nan(1,size(cdf_Values_BL_LandD_WT{anm},1));
    for ch=1:size(cdf_Values_BL_LandD_WT{anm},1)
        AUC_temp_WT(ch)=trapz(1-cdf_Values_BL_LandD_WT{anm}(ch,:));
        AUC_BL_WT{anm}=AUC_temp_WT;
        AUC_BL_all(anm,:)=AUC_temp_WT(1:minCh);
    end
    
    %rlss
    AUC_temp_rlss=nan(1,size(cdf_Values_BL_LandD_rlss{anm},1));
    for ch=1:size(cdf_Values_BL_LandD_rlss{anm},1)
        AUC_temp_rlss(ch)=trapz(1-cdf_Values_BL_LandD_rlss{anm}(ch,:));
        AUC_BL_rlss{anm}=AUC_temp_rlss;
        AUC_BL_all(anm+5,:)=AUC_temp_rlss(1:minCh);
    end
end
Geno=[1 1 1 1 1 2 2 2 2 2]';
tbl_AUC = simple_mixed_anova(AUC_BL_all(:,1:2), Geno, {'ChannelLDcomb'},{'Genotype'})

%%% Repeated measures ANOVA on the mean duration of the top X off-periods
mat_for_anova_TopXOP=nan(10,minCh,4);
for phase=1:2
    for anm=1:5
        if ~isempty(Mean_longest_absNum_WT{anm,phase})
            mat_for_anova_TopXOP(anm,:,phase)=Mean_longest_absNum_WT{anm,phase}(1:minCh)';
        end
        mat_for_anova_TopXOP(anm+5,:,phase)=Mean_longest_absNum_Rstl{anm,phase}(1:minCh)';
    end
end

between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
for phase=1:2
    if phase==1
        datamat=mat_for_anova_TopXOP(:,:,phase);
        between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
    else
        datamat=mat_for_anova_TopXOP([1 2 3 5 6 7 8 9 10],:,phase);
        between_factors=[0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
    end
    phase
    tbl = simple_mixed_anova(datamat, between_factors, {'Channel'},{'Genotype'})
end
%Line 118 - Temp_longest=[Temp_longest;sum(Sorted_OP_durations(Sorted_OP_durations>250))/sum(Sorted_OP_durations)*100];

% Evaluating whether there is more variability in rlss mice than in WT mice
% Working on mean longest OFF period values to start with.
% To have one value per mouse, I will take for each mouse the difference between the mean OFF period length 
%(of longest off periods) of the channel with the max value and the channel with the mean value.

Values_DiffLength_MaxCh_MinCh=zeros(10,1);
Group_matrix=[1 1 1 1 1 2 2 2 2 2];
for phase=1
    for genotype=1:2
        for mouse=1:5
            if genotype==1
                Max_Val=max(Mean_longest_WT{mouse,phase});
                Min_Val=min(Mean_longest_WT{mouse,phase});
                Values_DiffLength_MaxCh_MinCh(mouse,1)=Max_Val-Min_Val;
            else
                Max_Val=max(Mean_longest_Rstl{mouse,phase});
                Min_Val=min(Mean_longest_Rstl{mouse,phase});
                Values_DiffLength_MaxCh_MinCh(5+mouse,1)=Max_Val-Min_Val;
            end 
        end
    end
end
[p,tbl,stats,terms] = anovan(Values_DiffLength_MaxCh_MinCh,{Group_matrix})

figure()

%BL
errorbar(1,mean(Values_DiffLength_MaxCh_MinCh(1:5,1),'omitnan'),std(Values_DiffLength_MaxCh_MinCh(1:5,1),'omitnan')/sqrt(length(Values_DiffLength_MaxCh_MinCh(1:5,1))),'o','Color',Colours(1,:),'LineWidth',3)
hold on
plot(1,Values_DiffLength_MaxCh_MinCh(1:5,1),'.k','MarkerSize',12)
hold on
%SD
errorbar(2,mean(Values_DiffLength_MaxCh_MinCh(6:10,1),'omitnan'),std(Values_DiffLength_MaxCh_MinCh(6:10,1),'omitnan')/sqrt(length(Values_DiffLength_MaxCh_MinCh(6:10,1))),'o','Color',Colours(2,:),'LineWidth',3)
hold on
plot(2,Values_DiffLength_MaxCh_MinCh(6:10,1),'.k','MarkerSize',12)
xlim([0 3])
ylim([0 1199])
xticks(1:2)
xticklabels({'WT','rlss'})
ylabel('Max.Ch-Min.Ch of mean longest OP (ms)')
title({'Difference between channel with max.', 'and channel with min. mean ',[num2str(perc_OP_interest),'% longest OFF-periods - ',VS_interest,' (light phase)']})
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;
