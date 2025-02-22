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
All_pNe_values_WT=cell(5,4);
All_pNe_values_Rstl=cell(5,4);
All_cdf_values_WT=cell(5,4);
All_cdf_values_Rstl=cell(5,4);
Mean_shortest_WT=cell(5,4);
Mean_shortest_Rstl=cell(5,4);
Mean_longest_WT=cell(5,4);
Mean_longest_Rstl=cell(5,4);

edges=0:5:1200;
perc_OP_interest=5; % If I want to look at 5% shortest and longest off-periods.

VS_interest='NR'; % 'All' , 'NR', 'R' , 'W'

num_sec_before_after_transition=5;


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

            
            Number_of_indexes=round(num_sec_before_after_transition*OFFDATA.PNEfs);
            Temp_pNe_Values=nan(size(Start_OFF,2),2*(Number_of_indexes)+1);

            
            for i=1:size(Start_OFF,2)
                StartOFF_indexes_allVS=find(Start_OFF(:,i)); %StartOFF_indexes(end)=[];
                EndOFF_indexes_allVS=find(End_OFF(:,i)); %EndON_indexes(1)=[];
                
                
                
                
                StartOFF_indexes=StartOFF_indexes_allVS(ismember(ceil(StartOFF_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
                EndOFF_indexes=EndOFF_indexes_allVS(ismember(ceil(StartOFF_indexes_allVS./(4*OFFDATA.PNEfs)),vigilance_state_of_interest));
    

                OFF_Durations=(EndOFF_indexes-StartOFF_indexes)*1000/OFFDATA.PNEfs;
                Indexes_OFF_Durations_long=find(OFF_Durations>99.9);
                Start_OFF_indexes_longOFF=StartOFF_indexes(Indexes_OFF_Durations_long);
                
                %load pNe data 
                if genotype==1 && anm==5
                     pNe_data_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/pNe_data_',name,'_',phase_name(1:end-1),'_',phase_name(end),'_Channels1to16-exc9.mat'];
               
                else
                    pNe_data_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/pNe_data_',name,'_',phase_name(1:end-1),'_',phase_name(end),'_Channels1to16.mat'];
                end
                load(pNe_data_filename);
                
                %Select pNe data
                current_channel=OFFDATA.Channels(i);
                channel_data=eval(['Ch',num2str(current_channel)]);
                
                
                
                %Create matrix of indexes of interest
                Indexes_to_select=[];
                
                Check_start=Start_OFF_indexes_longOFF-Number_of_indexes;
                Start_OFF_indexes_longOFF(Check_start<0)=[];
                Check_end=Start_OFF_indexes_longOFF+Number_of_indexes;
                Start_OFF_indexes_longOFF(Check_end>length(channel_data))=[];
                
                starts=Start_OFF_indexes_longOFF-Number_of_indexes;
                ends=Start_OFF_indexes_longOFF+Number_of_indexes;
    
                A = starts;
                B = ends;
                C = ones(size(A,1), 2*Number_of_indexes+1);
                C1 = cumsum(C,2);
                C2 = bsxfun(@plus, C1, A-1);
                
                Indexes_to_select=reshape(C2',1,[]);
                
                %Average pNe data for one channel
                temp_pNe=reshape(channel_data(Indexes_to_select),[2*Number_of_indexes+1,length(Indexes_to_select)/(2*Number_of_indexes+1)]);
                temp_pNe=temp_pNe';
                Temp_pNe_Values(i,:)=mean(temp_pNe,'omitnan');
            end
                if genotype==1
                    All_pNe_values_WT{anm,phase}=Temp_pNe_Values;
                    
                elseif genotype==2
                    All_pNe_values_Rstl{anm,phase}=Temp_pNe_Values;

                end
                   
        end
    end
end




Phase_titles={'BL-light','BL-dark','SD-light','SD-dark'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

x=-num_sec_before_after_transition:10/(2*Number_of_indexes+1):num_sec_before_after_transition-1/Number_of_indexes;

figure()
%WT
subplot(2,1,1)
temp_WT=cell2mat(All_pNe_values_WT(:,phase));
temp_WT(temp_WT==0)=NaN;

shadedErrorBar(x,mean(temp_WT,'omitnan'),std(temp_WT,[],'omitnan')/sqrt(5),'lineProps',{'Color',Colours(1,:),'LineWidth',3});

if phase==1 || phase==3
    ylabel('Average MUA activity')
end
if phase==3 || phase==4
    xlabel('Time from ON-OFF transition (s)')
end

legend('WT','Box','off')

title([Phase_titles{phase}])

box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

if phase==1 || phase==3
    set(gca,'color',[1 1 0.8])
else
    set(gca,'Color',[0.8 0.8 0.8])
end
xlim([-0.1 0.4])
ylim([-30 20])

%Rlss
subplot(2,1,2)
temp_Rstl=cell2mat(All_pNe_values_Rstl(:,phase));
temp_Rstl(temp_Rstl==0)=NaN;

shadedErrorBar(x,mean(temp_Rstl,'omitnan'),std(temp_Rstl,[],'omitnan')/sqrt(5),'lineProps',{'Color',Colours(2,:),'LineWidth',3})

if phase==1 || phase==3
    ylabel('Average MUA activity')
end


legend('Rlss','Box','off')

title([Phase_titles{phase}])

box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

if phase==1 || phase==3
    set(gca,'color',[1 1 0.8])
else
    set(gca,'Color',[0.8 0.8 0.8])
end
xlim([-0.1 0.4])
ylim([-30 20])
xlabel('Time from ON- to OFF-period transition (s)')

