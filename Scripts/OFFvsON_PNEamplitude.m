%% Plot mean OFF vs ON period PNE amplitude
%%%% NOTE missing MT LFP on sleep deprivation day so can't include
clear all
close all

WT={'Ed';'Fe';'He';'Le';'Qu'};
Rstl={'Ju';'Me';'Ne';'Oc';'Ph'};
VSstates={'ma','mt','nr','nr2','r','r3','w','w1'};  

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

edges=0:5:2000;
perc_OP_interest=1; % If I want to look at 5% shortest and longest off-periods.

VS_interest='NR'; % 'All' , 'NR', 'R' , 'W'

NREM_OFFperiod_durations_struct = struct();
Phase_strings=["Baseline_light",...
    "Baseline_dark",...
    "SleepDep_light",...
    "SleepDep_dark"];
Genotype_string=["Wt","Rstl"];

%%%%%%  Plotting Histograms (probability)
for genotype=1:2 % 1=WT, 2=Rstl
    for anm=1:5
        
        if genotype==1 && anm==4 %Le only has a recording for BL L
            
        else
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
                
                % Load PNEs into array
                PNEdata = [];
                for chanNum = 1:length(OFFDATA.ChannelsFullName)
                    a = load(OFFDATA.PNEpathin,OFFDATA.ChannelsFullName(chanNum));
                    PNEdata(:,chanNum) = a.(OFFDATA.ChannelsFullName(chanNum));
                    clear a
                end
                
                % Load vigilance state info
                VS=load(OFFDATA.VSpathin);
                allVSpointsPNE=zeros(length(OFFDATA.StartOP),1);
                for j=1:length(VSstates)
                    State=VS.(VSstates{j});
                    if ~isempty(State)
                        for k=1:length(State)
                            EndVS=State(k);
                            allVSpointsPNE(round((EndVS-1)*OFFDATA.epochLen*OFFDATA.PNEfs)+1:round(EndVS*OFFDATA.epochLen*OFFDATA.PNEfs))=j;
                        end
                    end
                    clear State
                end
                
                figure('Color',[1,1,1],'DefaultAxesFontSize',10)
                for channum = 1:size(OFFDATA.StartOP,2)
                    
                    NREM_meanOFFpne=[]; NREM_maxOFFpne = [];
                    NREM_meanONpne=[]; NREM_maxONpne = [];
                    
                    
                    StartOFF=find(OFFDATA.StartOP(:,channum));
                    EndOFF=find(OFFDATA.EndOP(:,channum));
                    NREM_StartOFF=StartOFF(allVSpointsPNE(StartOFF)==3);
                    NREM_EndOFF=EndOFF(allVSpointsPNE(StartOFF)==3);
                    for OFF = 1:length(NREM_StartOFF)
                        NREM_meanOFFpne(OFF) = mean(PNEdata(NREM_StartOFF(OFF):NREM_EndOFF(OFF),channum));
                        NREM_maxOFFpne(OFF) = max(PNEdata(NREM_StartOFF(OFF):NREM_EndOFF(OFF),channum));
                    end
                    
                    StartON=EndOFF(1:end-1)+1;
                    EndON=StartOFF(2:end)-1;
                    NREM_StartON=StartON(allVSpointsPNE(StartON)==3);
                    NREM_EndON=EndON(allVSpointsPNE(StartON)==3);
                    for ON = 1:length(NREM_StartON)
                        NREM_meanONpne(ON) = mean(PNEdata(NREM_StartON(ON):NREM_EndON(ON),channum));
                        NREM_maxONpne(ON) = max(PNEdata(NREM_StartON(ON):NREM_EndON(ON),channum));
                    end
                    
                    subplot(4,4,channum)
                    bar(categorical(["OFF periods","ON periods"]),[mean(abs(NREM_meanOFFpne)),mean(abs(NREM_meanONpne))])
                    hold on
                    errorbar(categorical(["OFF periods","ON periods"]),[mean(abs(NREM_meanOFFpne)),mean(abs(NREM_meanONpne))],...
                        [std(abs(NREM_meanOFFpne)),std(abs(NREM_meanONpne))])
                    ylim([-10,40])
                    ylabel('PNE amplitude')
                    text(categorical(["OFF periods"]),20,["Delta = ",num2str([mean(abs(NREM_meanONpne))-mean(abs(NREM_meanOFFpne))])])
                    
                end
                sgtitle(name)
            end
        end
    end
end

