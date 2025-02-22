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
Perc_shortest_WT=cell(5,4);
Perc_shortest_Rstl=cell(5,4);
Perc_longest_WT=cell(5,4);
Perc_longest_Rstl=cell(5,4);
Num_ON_periods_WT=zeros(5,4);
Num_ON_periods_Rstl=zeros(5,4);

edges=0:5:1200;
perc_OP_interest=5; % If I want to look at 5% shortest and longest off-periods.

VS_interest='All'; % 'All' , 'NR', 'R' , 'W'


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
            
            for i=1:size(Start_OFF,2)
                StartOFF_indexes_allVS=find(Start_OFF(:,i)); %StartOFF_indexes(end)=[];
                EndOFF_indexes_allVS=find(End_OFF(:,i)); %EndON_indexes(1)=[];
                
                StartON_indexes_allVS=EndOFF_indexes_allVS(1:end-1)+1; %First ON periods starts at the end of the first OFF period
                EndON_indexes_allVS=StartOFF_indexes_allVS(2:end)-1; % First ON period end at the start of the second OFF period

                
                
                StartON_indexes=StartON_indexes_allVS(ismember(ceil(StartON_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
                EndON_indexes=EndON_indexes_allVS(ismember(ceil(StartON_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
    

                ON_Durations=(EndON_indexes-StartON_indexes)*1000/OFFDATA.PNEfs;
                ON_Durations(ON_Durations==0)=[];
                
                
                %                 figure(1)
                %                 h=histogram(OFF_Durations,edges,'Normalization','Probability');
                %                 hold on
                
                [Temp_Hist_Values(i,:),edges]=histcounts(ON_Durations,edges,'Normalization','Probability');
                [Temp_cdf_Values(i,:),edges]=histcounts(ON_Durations,edges,'Normalization','cdf');
                
                
                %%% Calculating mean value of shortest 1% Off periods
                Sorted_OP_durations=sort(ON_Durations);
                Temp_shortest=[Temp_shortest; mean(Sorted_OP_durations(1:round(length(Sorted_OP_durations)/100*perc_OP_interest)),'omitnan')];
                Temp_longest=[Temp_longest; mean(Sorted_OP_durations(end-round(length(Sorted_OP_durations)/100*perc_OP_interest):end),'omitnan')];
                %%% Getting the value of the xth percentile threshold value of the shortest/longest Off periods:
                Temp_shortest_percThreshold=[Temp_shortest; Sorted_OP_durations(round(length(Sorted_OP_durations)/100*perc_OP_interest))];
                Temp_longest_percThreshold=[Temp_longest; Sorted_OP_durations(end-round(length(Sorted_OP_durations)/100*perc_OP_interest))];
                
                
                
            end
                if genotype==1
                    All_Hist_values_WT{anm,phase}=Temp_Hist_Values;
                    All_cdf_values_WT{anm,phase}=Temp_cdf_Values;
                    Mean_shortest_WT{anm,phase}=Temp_shortest;
                    Mean_longest_WT{anm,phase}=Temp_longest;
                    Perc_shortest_WT{anm,phase}=Temp_shortest_percThreshold;
                    Perc_longest_WT{anm,phase}=Temp_longest_percThreshold;
                    Num_ON_periods_WT(anm,phase)=length(ON_Durations)/length(OFFDATA.Channels);% I devide the number of ON periods by the number of channels which is not equal across mice.
                    
                elseif genotype==2
                    All_Hist_values_Rstl{anm,phase}=Temp_Hist_Values;
                    All_cdf_values_Rstl{anm,phase}=Temp_cdf_Values;
                    Mean_shortest_Rstl{anm,phase}=Temp_shortest;
                    Mean_longest_Rstl{anm,phase}=Temp_longest;
                    Perc_shortest_Rstl{anm,phase}=Temp_shortest_percThreshold;
                    Perc_longest_Rstl{anm,phase}=Temp_longest_percThreshold;
                    Num_ON_periods_Rstl(anm,phase)=length(ON_Durations)/length(OFFDATA.Channels);% I devide the number of ON periods by the number of channels which is not equal across mice.
                    
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
    xlabel('ON-period duration (ms)')
    ylabel('% of ON-periods')
    title(Phase_titles{phase})
    legend('WT','Rlss','Box','off')
    sgtitle(['Distribution of ON-period durations - ',VS_interest])
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
        ylabel('% of ON-periods')
    end
    if phase==3 || phase==4
        xlabel('ON-period duration (ms)')
    end
    title(Phase_titles{phase})
    if phase==4
        legend('WT','Rlss','Box','off')
    end
    sgtitle(['Survival curves of ON-periods - ',VS_interest])
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
xlabel('ON-period duration (ms)')
ylabel('% of ON-periods')

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
        ylabel('% of ON-periods')
    end
    if phase==3 || phase==4
        xlabel('ON-period duration (ms)')
    end
    title(Phase_titles{phase})
    if phase==4
        legend('WT','Rlss','Box','off')
    end
    sgtitle(['Survival curves of ON-periods - ',VS_interest])
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
            ylabel('ON-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% shortest ON-periods - ',VS_interest])
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
        xticklabels({'WT','Rlss'})
        if phase==1
            ylabel('ON-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% longest ON-periods - ',VS_interest])
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
        xticklabels({'WT','Rlss'})
        if phase==1
            ylabel('OFF-period duration (ms)')
        end
        title(Phase_titles{phase})
        sgtitle(['Threshold duration of the ',num2str(perc_OP_interest),'% longest ON-periods - ',VS_interest])
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
xlabel('ON-period duration (ms)')
ylabel('% of ON-periods')
title('WT mice')
legend('BL','SD','Box','off')
sgtitle(['Survival curves of ON-periods during the light phase - ',VS_interest])
%ylim([0.0001 100])  %% NR: ylim([0.001 100])   REM: ylim([0.0001 100])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

subplot(1,2,2)
semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_Rstl(:,1)),'omitnan')),'Color',Colours(2,:),'LineWidth',3);
hold on
semilogy(edges(1:end-1),100*(1-mean(cell2mat(All_cdf_values_Rstl(:,3)),'omitnan')),'Color',Colours(2,:)+0.2,'LineWidth',3)
xlim([0 500])
xlabel('ON-period duration (ms)')
ylabel('% of ON-periods')
title('Rlss mice')
legend('BL','SD','Box','off')
sgtitle(['Survival curves of ON-periods during the light phase - ',VS_interest])
%ylim([0.0001 100]) %% NR: ylim([0.001 100])   REM: ylim([0.0001 100])
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
%ylim([0 70])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('ON-period duration (ms)')
title('WT mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% shortest ON-periods - ',VS_interest,' (light phase)'])
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
%ylim([0 70])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('ON-period duration (ms)')
title('Rlss mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% shortest ON-periods - ',VS_interest,' (light phase)'])
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
%ylim([0 1000])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('ON-period duration (ms)')
title('WT mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% longest ON-periods - ',VS_interest,' (light phase)'])
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
%ylim([0 1000])
xticks(1:2)
xticklabels({'BL','SD'})
ylabel('ON-period duration (ms)')
title('Rlss mice')
sgtitle(['Average duration of the ',num2str(perc_OP_interest),'% longest ON-periods - ',VS_interest,' (light phase)'])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;


% For stats round 2 of revisions where we want to keep only one value (median) per mouse
Values_WT=nan(5,4);
Values_Rstl=nan(5,4);
Values_shortest_WT=nan(5,4);
Values_shortest_Rstl=nan(5,4);
for phase=1:4
    for anm=1:5
        Values_WT(anm,phase)=median(Mean_longest_WT{anm,phase},'omitnan');
        Values_Rstl(anm,phase)=median(Mean_longest_Rstl{anm,phase},'omitnan');
        
        Values_shortest_WT(anm,phase)=median(Mean_shortest_WT{anm,phase},'omitnan');
        Values_shortest_Rstl(anm,phase)=median(Mean_shortest_Rstl{anm,phase},'omitnan');
    end
end

figure()

errorbar(1,mean(Num_ON_periods_WT(:,1),'omitnan'),std(Num_ON_periods_WT(:,1),'omitnan')/sqrt(length(Num_ON_periods_WT(:,1))),'o','Color',Colours(1,:),'LineWidth',1.5)
hold on
plot(1,Num_ON_periods_WT(:,1),'.k')
hold on
hold on
errorbar(2,mean(Num_ON_periods_Rstl(:,1),'omitnan'),std(Num_ON_periods_Rstl(:,1),'omitnan')/sqrt(length(Num_ON_periods_Rstl(:,1))),'o','Color',Colours(2,:),'LineWidth',1.5)
hold on
plot(2,Num_ON_periods_Rstl(:,1),'.k')
hold on
xlim([0.5 2.5])
xticks(1:2)
xticklabels({'WT','rlss'})
ylabel('Number of ON periods detected/channel')
title([VS_interest,' BL-L'])
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

[h,p,ci,stats] = ttest2(Num_ON_periods_WT(:,1),Num_ON_periods_Rstl(:,1))

% Notes for stats:
% phase=1 or 2 or 3 or 4;
%[h,p,ci,stats] = ttest2(cell2mat(Mean_longest_WT(:,phase)),cell2mat(Mean_longest_Rstl(:,phase)))

% IF WANTING TO KEEP ALL CHANNELS INDIVIDUALLY:
%[p,h,stats] = ranksum(cell2mat(Mean_longest_WT(:,phase)),cell2mat(Mean_longest_Rstl(:,phase)))
%IF WANTING TO KEEP ONE (Median) VALUE PER MOUSE:
%[p,h,stats] = ranksum(Values_WT(:,phase),Values_Rstl(:,phase))


%%% Repeated measures ANOVA on the mean duration of the top X off-periods
minCh=5;
pick_Ch_random=0; % 1 means yes, we choose the minCh channels randomly
mat_for_anova_TopXOP=nan(10,minCh,4);

if pick_Ch_random==0 % We don't pick randomly we choose the first 5 of each mouse
    for phase=1:4
        for anm=1:5
            if ~isempty(Mean_longest_WT{anm,phase})
                mat_for_anova_TopXOP(anm,:,phase)=Mean_longest_WT{anm,phase}(1:minCh)';
            end
            mat_for_anova_TopXOP(anm+5,:,phase)=Mean_longest_Rstl{anm,phase}(1:minCh)';
        end
    end
else    % We pick randomly using randperm()
    for phase=1:4
        for anm=1:5
            if ~isempty(Mean_longest_WT{anm,phase})
                mat_for_anova_TopXOP(anm,:,phase)=Mean_longest_WT{anm,phase}(randperm(length(Mean_longest_WT{anm,phase}),minCh))';
            end
            mat_for_anova_TopXOP(anm+5,:,phase)=Mean_longest_Rstl{anm,phase}(randperm(length(Mean_longest_Rstl{anm,phase}),minCh))';
        end
    end
end

between_factors=[0 0 0 0 0 1 1 1 1 1]';%Given the above filling of the data matrix (mat_for_anova), 0=WT, 1=Rstl
for phase=1:4
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

