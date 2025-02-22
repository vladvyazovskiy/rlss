% Analysis of results clustering - PLotting survival curves of OFF periods

clear all
close all

Time_window='Hours 0-12';
Start_time_window=0*900; % Expressed in 4-sec epochs
End_time_window=12*900;

% %%%% WTs
% 
% An_Name='Ed';
% Filename_In_BL='Ed_091117_L_BasicCluster_adjusted.mat';
% Filename_In_SD='Ed_101117_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='Ed_091117_L_fro_VSspec.mat';
% Filename_VSspec_SD='Ed_101117_L_fro_VSspec.mat';
% Selected_channels=[4 6 7 8 9 10];

% An_Name='Fe';
% Filename_In_BL='Fe_091117_L_BasicCluster_adjusted.mat';
% Filename_In_SD='Fe_101117_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='Fe_091117_L_fro_VSspec.mat';
% Filename_VSspec_SD='Fe_101117_L_fro_VSspec.mat';
% Selected_channels=[3 4 6 7 8 9 13 14 15 16];

% An_Name='He';
% Filename_In_BL='He_161117_L_BasicCluster_adjusted.mat';
% Filename_In_SD='He_171117_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='He_161117_L_fro_VSspec.mat';
% Filename_VSspec_SD='He_171117_L_fro_VSspec.mat';
% Selected_channels=[5 6 7 8 10 12];

% An_Name='Le';
% Filename_In_BL='Le_161117_L_BasicCluster_adjusted.mat';
% % Filename_In_SD='Le_171117_L_BasicCluster_wpresets.mat';
% Filename_VSspec_BL='Le_161117_L_fro_VSspec.mat';
% % Filename_VSspec_SD='Le_171117_L_fro_VSspec.mat';
% Selected_channels=[6 7 8 9 11 15 16];

% An_Name='Qu';
% Filename_In_BL='Qu_200318_L_BasicCluster_adjusted.mat';
% Filename_In_SD='Qu_210318_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='Qu_200318_L_fro_VSspec.mat';
% Filename_VSspec_SD='Qu_210318_L_fro_VSspec.mat';
% Selected_channels=[4 5 6 7 8 10];




%%%%% Rstl
% An_Name='Ju';
% Filename_In_BL='Ju_161117_L_BasicCluster_adjusted.mat';
% Filename_In_SD='Ju_171117_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='Ju_161117_L_fro_VSspec.mat';
% Filename_VSspec_SD='Ju_171117_L_fro_VSspec.mat';
% Selected_channels=[1 2 3 4 5 6 11 12 13];

% An_Name='Me';
% Filename_In_BL='Me_200318_L_BasicCluster_adjusted.mat';
% Filename_In_SD='Me_210318_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='Me_200318_L_fro_VSspec.mat';
% Filename_VSspec_SD='Me_210318_L_fro_VSspec.mat';
% Selected_channels=[3 4 5 6 10 13];

% An_Name='Ne';
% Filename_In_BL='Ne_200318_L_BasicCluster_adjusted.mat';
% Filename_In_SD='Ne_210318_L_BasicCluster_wpresets_adjusted.mat';
% Filename_VSspec_BL='Ne_200318_L_fro_VSspec.mat';
% Filename_VSspec_SD='Ne_210318_L_fro_VSspec.mat';
% Selected_channels=[3 4 5 6 7 8 11 15];

% An_Name='Oc';
% Filename_In_BL='Oc_200318_L_BasicCluster_wCorrections_adjusted.mat';
% Filename_In_SD='Oc_210318_L_BasicCluster_wpresetsAndCorr_adjusted.mat';
% Filename_VSspec_BL='Oc_200318_L_fro_VSspec.mat';
% Filename_VSspec_SD='Oc_210318_L_fro_VSspec.mat';
% Selected_channels=[5 6 7 8 9];

An_Name='Ph';
Filename_In_BL='Ph_200318_L_BasicCluster_adjusted.mat';
Filename_In_SD='Ph_210318_L_BasicCluster_wpresets_adjusted.mat';
Filename_VSspec_BL='Ph_200318_L_fro_VSspec.mat';
Filename_VSspec_SD='Ph_210318_L_fro_VSspec.mat';
Selected_channels=[1 2 3 4 5 6 11];


%%%%%% BL day
%%% To select OFF periods in NREM only
load(Filename_In_BL);
load(Filename_VSspec_BL);

pNe_f=OFFDATA.PNEfs;

% nr_epochs=[];
% for i=1:length(nr)
%     nr_epochs=[nr_epochs (nr(i)-1)*4*pNe_f:nr(i)*4*pNe_f-1];
% end

nr_inTimeWindow=nr(nr>Start_time_window);
nr_inTimeWindow=nr_inTimeWindow(nr_inTimeWindow<End_time_window);

r_inTimeWindow=r(r>Start_time_window);
r_inTimeWindow=r_inTimeWindow(r_inTimeWindow<End_time_window);

Percent_NR_Hour6_7=length(nr(nr>Start_time_window & nr<Start_time_window+900))/900;
Percent_NR_Hour7_8=length(nr(nr>Start_time_window+900 & nr<Start_time_window+1800))/900;

Percent_R_Hour6_7=length(r(r>Start_time_window & r<Start_time_window+900))/900;
Percent_R_Hour7_8=length(r(r>Start_time_window+900 & r<Start_time_window+1800))/900;

OP_durations_all_BL=cell(1,length(Selected_channels));
OP_durations_all_BL_NR=cell(1,length(Selected_channels));
OP_durations_all_BL_R=cell(1,length(Selected_channels));
OP_durations_all_SD=cell(1,length(Selected_channels));
OP_durations_all_SD_NR=cell(1,length(Selected_channels));
OP_durations_all_SD_R=cell(1,length(Selected_channels));


i=0;
for ch = Selected_channels
    
    i=i+1;
    StartOFF_indexes=find(OFFDATA.StartOPadjusted(:,ch));
    EndOFF_indexes=find(OFFDATA.EndOPadjusted(:,ch));
    OP_durations=EndOFF_indexes-StartOFF_indexes;
    
    StartOFF_indexes_NR=StartOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),nr_inTimeWindow));
    EndOFF_indexes_NR=EndOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),nr_inTimeWindow));
    
    StartOFF_indexes_R=StartOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),r_inTimeWindow));
    EndOFF_indexes_R=EndOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),r_inTimeWindow));
    
      
    OP_durations_NR=EndOFF_indexes_NR-StartOFF_indexes_NR;
    OP_durations_R=EndOFF_indexes_R-StartOFF_indexes_R;
    
    figure(1)
    subplot(4,3,i)
    [f,x] = ecdf(OP_durations);
    semilogy(x,1-f)
    hold on
    title(['Channel ',num2str(ch)]);
   
    
    figure(2)
    subplot(4,3,i)
    [f,x] = ecdf(OP_durations_NR);
    semilogy(x,1-f)
    hold on
    title(['Channel ',num2str(ch)]);
    xlim([0 400])
    
    figure(3)
    if ~isempty(OP_durations_R)
        subplot(4,3,i)
        [f,x] = ecdf(OP_durations_R);
        semilogy(x,1-f)
        hold on
        title(['Channel ',num2str(ch)]);
        xlim([0 300])
    end
    
    figure(4)
    subplot(4,3,i)
    [f,x] = ecdf(OP_durations_NR);
    semilogy(x,1-f,'Color',[0.9290    0.6940    0.1250])
    hold on
    [f,x] = ecdf(OP_durations_R);
    semilogy(x,1-f,'Color',[0.4940    0.1840    0.5560])
    title(['Channel ',num2str(ch)]);
    xlim([0 1000])
    legend('NR BL','R BL')
    
    OP_durations_all_BL{1,i}=OP_durations;
    OP_durations_all_BL_NR{1,i}=OP_durations_NR;
    OP_durations_all_BL_R{1,i}=OP_durations_R;
    
end


%%%%%% SD day
%%% To select OFF periods in NREM only
load(Filename_In_SD);
load(Filename_VSspec_SD);

pNe_f=OFFDATA.PNEfs;

% nr_epochs=[];
% for i=1:length(nr)
%     nr_epochs=[nr_epochs (nr(i)-1)*4*pNe_f:nr(i)*4*pNe_f-1];
% end

nr_inTimeWindow=nr(nr>Start_time_window);
nr_inTimeWindow=nr_inTimeWindow(nr_inTimeWindow<End_time_window);

r_inTimeWindow=r(r>Start_time_window);
r_inTimeWindow=r_inTimeWindow(r_inTimeWindow<End_time_window);

Percent_NR_Hour6_7_SD=length(nr(nr>Start_time_window & nr<Start_time_window+900))/900;
Percent_NR_Hour7_8_SD=length(nr(nr>Start_time_window+900 & nr<Start_time_window+1800))/900;

Percent_R_Hour6_7_SD=length(r(r>Start_time_window & r<Start_time_window+900))/900;
Percent_R_Hour7_8_SD=length(r(r>Start_time_window+900 & r<Start_time_window+1800))/900;




i=0;
for ch = Selected_channels
    
    i=i+1;
    StartOFF_indexes=find(OFFDATA.StartOPadjusted(:,ch));
    EndOFF_indexes=find(OFFDATA.EndOPadjusted(:,ch));
    OP_durations=EndOFF_indexes-StartOFF_indexes;
    
    StartOFF_indexes_NR=StartOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),nr_inTimeWindow));
    EndOFF_indexes_NR=EndOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),nr_inTimeWindow));
    
    StartOFF_indexes_R=StartOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),r_inTimeWindow));
    EndOFF_indexes_R=EndOFF_indexes(ismember(ceil(StartOFF_indexes./(4*pNe_f)),r_inTimeWindow));
    
      
    OP_durations_NR=EndOFF_indexes_NR-StartOFF_indexes_NR;
    OP_durations_R=EndOFF_indexes_R-StartOFF_indexes_R;
    
    figure(1)
    subplot(4,3,i)
    [f,x] = ecdf(OP_durations);
    semilogy(x,1-f)
    hold on
    title(['Channel ',num2str(ch)]);
   
    
    figure(2)
    subplot(4,3,i)
    [f,x] = ecdf(OP_durations_NR);
    semilogy(x,1-f)
    hold on
    title(['Channel ',num2str(ch)]);
    xlim([0 1000])
    
    figure(3)
    subplot(4,3,i)
    [f,x] = ecdf(OP_durations_NR);
    semilogy(x,1-f,'Color',[0.8500    0.3250    0.0980])
    hold on
    title(['Channel ',num2str(ch)]);
    xlim([0 400])
    
    OP_durations_all_SD{1,i}=OP_durations;
    OP_durations_all_SD_NR{1,i}=OP_durations_NR;
    OP_durations_all_SD_R{1,i}=OP_durations_R;
    
end



figure(1)
sgtitle(['All OFF periods - ',An_Name,' - ',Time_window]);

figure(2)
sgtitle(['NREM OFF periods - ',An_Name,' - ',Time_window]);

figure(3)
sgtitle(['REM OFF periods - ',An_Name,' - ',Time_window]);

figure(4)
sgtitle(['NR and REM OFF periods BL - ',An_Name,' - ',Time_window]);

FileName_save=['OP_durations_',An_Name,'_',Time_window];
%save(FileName_save,'OP_durations_all_BL','OP_durations_all_BL_NR','OP_durations_all_BL_R','OP_durations_all_SD','OP_durations_all_SD_NR','OP_durations_all_SD_R');

