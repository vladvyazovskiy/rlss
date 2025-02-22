clear all
close all

%%%%%%%%%%%%%%%%%
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5


pathin2017=[path2017,'Auditory_Analysis_TrialResults/'];
pathin2018=[path2018,'Auditory_Analysis_TrialResults/'];

pathAud2017=[path2017,'OutputAuditory/'];
pathAud2018=[path2018,'OutputAuditory/'];


An_2017=char('Ed','Fe','He','Ju','Le');
An_2018=char('Ne','Oc','Ph','Qu');

HOMs=char('Ju','Ne','Oc','Ph');
WTs=char('Ed','Fe','He','Le','Qu');

day2017='201117';
day2018='280318';

LDphase='L';


fs=256; %sampling rate (Hz)
f=(0:0.25:20);
dur=8; %duration sound and how much I take before and after


Msp_LFPds_NRbef_ALL=[];Msp_LFPds_NRdur_ALL=[];Msp_LFPds_NRaft_ALL=[];
Msp_LFPds_Rbef_ALL=[];Msp_LFPds_Rdur_ALL=[];Msp_LFPds_Raft_ALL=[];
Msp_EEGfro_NRbef_ALL=[];Msp_EEGfro_NRdur_ALL=[];Msp_EEGfro_NRaft_ALL=[];
Msp_EEGfro_Rbef_ALL=[];Msp_EEGfro_Rdur_ALL=[];Msp_EEGfro_Raft_ALL=[];
Msp_EEGocc_NRbef_ALL=[];Msp_EEGocc_NRdur_ALL=[];Msp_EEGocc_NRaft_ALL=[];
Msp_EEGocc_Rbef_ALL=[];Msp_EEGocc_Rdur_ALL=[];Msp_EEGocc_Raft_ALL=[];


%load auditory trials results
sessions=char('1','2');
TrialsResults_conc=[];
    
%% Loading all data
for year =1:2
    if year==1
        An_names=An_2017;
        day=day2017;
        pathAud=pathAud2017;
        pathin=pathin2017;
    else
        An_names=An_2018;
        day=day2018;
        pathAud=pathAud2018;
        pathin=pathin2018;
    end
    
    for An=1:size(An_names(:,1),1)
        TrialsResults_conc=[];
        
        fnAud=[An_names(An,:),'_',day,'_',LDphase,'_aud_parameters'];
        eval(['load ',pathAud,fnAud,'.mat lims -mat']);
        
        fnData=[An_names(An,:),'-',day,'_',LDphase,'-','Trials_LFP_EEG'];
        eval(['load ',pathin,fnData,'.mat EEGfro EEGocc LFPds -mat']);
        
        for session=1:2
            aud_results=[An_names(An,:),'-',day,'_',LDphase,'-TrialsScreening-Session-',sessions(session)];
            eval(['load ',pathin,aud_results,'.mat TrialsResults -mat']);
            TrialsResults_conc=[TrialsResults_conc;TrialsResults];
        end
        
        
        TrialsResults=TrialsResults_conc;
        
        
        %% Find times before, during and after sound
        sound_d=lims(1,2)-lims(1,1);
        before=(1:dur*fs);
        during=(dur*fs+1:(dur*fs+1)+(sound_d));
        after=((dur*fs+1)+(sound_d):length(EEGfro));
        
        
        %% Filters
        
        %Basic filter design
        basicfilt = designfilt('bandpassfir','FilterOrder',20,...
            'CutoffFrequency1',0.5,'CutoffFrequency2',20,'SampleRate',256);
        
        %Sigma filter design
        sigfilt = designfilt('bandpassiir','FilterOrder',10, ...
            'HalfPowerFrequency1',10,'HalfPowerFrequency2',15, ...
            'SampleRate',256,'DesignMethod','butter');
        
        %fvtool(basicfilt);
        % fLFPds=filtfilt(sigfilt,LFPds); % Filters data in vector SIG using the filter described by sigfilt
        % fLFPns=filtfilt(sigfilt,LFPns);
        % fEEGfro=filtfilt(sigfilt,EEGfro);
        % fEEGocc=filtfilt(sigfilt,EEGocc);
        %
        fLFPds=LFPds;%filtfilt(basicfilt,LFPds); % Filters data in vector SIG using the filter described by sigfilt
        %fLFPns=filtfilt(basicfilt,LFPns);
        fEEGfro=EEGfro;%filtfilt(basicfilt,EEGfro);
        fEEGocc=EEGocc;%filtfilt(basicfilt,EEGocc);
        
        % fLFPds=LFPds; % Filters data in vector SIG using the filter described by sigfilt
        % fLFPns=LFPns;
        % fEEGfro=EEGfro;
        % fEEGocc=EEGocc;
        
        %y=filtfilt(basicfilt,SIG); % Filters data in vector SIG using the filter described by basicfilt
        
        %% Select signal based on stages
        
        idW=find(TrialsResults(:,1)==1); %Based on socring in TrialScreening--> 1=W, 2=NR, 3=R
        idNR=find(TrialsResults(:,1)==2);
        idR=find(TrialsResults(:,1)==3);
        
        LFPds_W=fLFPds(idW,:);
        %LFPns_W=fLFPns(idW,:);
        EEGfro_W=fEEGfro(idW,:);
        EEGocc_W=fEEGocc(idW,:);
        
        LFPds_NR=fLFPds(idNR,:);
        %LFPns_NR=fLFPns(idNR,:);
        EEGfro_NR=fEEGfro(idNR,:);
        EEGocc_NR=fEEGocc(idNR,:);
        
        LFPds_R=fLFPds(idR,:);
        %LFPns_R=fLFPns(idR,:);
        EEGfro_R=fEEGfro(idR,:);
        EEGocc_R=fEEGocc(idR,:);
        
        %% Calculate Spectra LFP DS during NREM %%%%%%
        
        LFPds_NRbef=LFPds_NR(:,before)';
        [sp_LFPds_NRbef,f]=pwelch(LFPds_NRbef,length(LFPds_NRbef)-2,length(LFPds_NRbef)/2,f,fs);
        Msp_LFPds_NRbef=nanmean(sp_LFPds_NRbef,2);
        Msp_LFPds_NRbef(1:2,1)=nan;
        stdSP_LFPds_NRbef=nanstd(sp_LFPds_NRbef,0,2);
        seSP_LFPds_NRbef=stdSP_LFPds_NRbef./sqrt(size(LFPds_NRbef,2));
        
        LFPds_NRdur=LFPds_NR(:,during)';
        [sp_LFPds_NRdur,f]=pwelch(LFPds_NRdur,length(LFPds_NRdur)-2,length(LFPds_NRdur)/2,f,fs);
        Msp_LFPds_NRdur=nanmean(sp_LFPds_NRdur,2);
        Msp_LFPds_NRdur(1:2,1)=nan;
        stdSP_LFPds_NRdur=nanstd(sp_LFPds_NRdur,0,2);
        seSP_LFPds_NRdur=stdSP_LFPds_NRdur./sqrt(size(LFPds_NRdur,2));
        
        LFPds_NRaft=LFPds_NR(:,after)';
        [sp_LFPds_NRaft,f]=pwelch(LFPds_NRaft(~isnan(LFPds_NRaft)),length(LFPds_NRaft)-2,length(LFPds_NRaft)/2,f,fs);
        Msp_LFPds_NRaft=nanmean(sp_LFPds_NRaft,2);
        Msp_LFPds_NRaft(1:2,1)=nan;
        stdSP_LFPds_NRaft=nanstd(sp_LFPds_NRaft,0,2);
        seSP_LFPds_NRaft=stdSP_LFPds_NRaft./sqrt(size(LFPds_NRaft,2));
        
        
        
        
        
        
        %% Calculate Spectra LFP DS during REM %%%%%%%%
        
        LFPds_Rbef=LFPds_R(:,before)';
        [sp_LFPds_Rbef,f]=pwelch(LFPds_Rbef,length(LFPds_Rbef)-2,length(LFPds_Rbef)/2,f,fs);
        Msp_LFPds_Rbef=nanmean(sp_LFPds_Rbef,2);
        Msp_LFPds_Rbef(1:2,1)=nan;
        stdSP_LFPds_Rbef=nanstd(sp_LFPds_Rbef,0,2);
        seSP_LFPds_Rbef=stdSP_LFPds_Rbef./sqrt(size(LFPds_Rbef,2));
        
        LFPds_Rdur=LFPds_R(:,during)';
        [sp_LFPds_Rdur,f]=pwelch(LFPds_Rdur,length(LFPds_Rdur)-2,length(LFPds_Rdur)/2,f,fs);
        Msp_LFPds_Rdur=nanmean(sp_LFPds_Rdur,2);
        Msp_LFPds_Rdur(1:2,1)=nan;
        stdSP_LFPds_Rdur=nanstd(sp_LFPds_Rdur,0,2);
        seSP_LFPds_Rdur=stdSP_LFPds_Rdur./sqrt(size(LFPds_Rdur,2));
        
        LFPds_Raft=LFPds_R(:,after)';
        [sp_LFPds_Raft,f]=pwelch(LFPds_Raft,length(LFPds_Raft)-2,length(LFPds_Raft)/2,f,fs);
        Msp_LFPds_Raft=nanmean(sp_LFPds_Raft,2);
        Msp_LFPds_Raft(1:2,1)=nan;
        stdSP_LFPds_Raft=nanstd(sp_LFPds_Raft,0,2);
        seSP_LFPds_Raft=stdSP_LFPds_Raft./sqrt(size(LFPds_Raft,2));
        
        
        
        
        %% %% Calculate Spectra FRONTAL during NREM before
        
        EEGfro_NRbef=EEGfro_NR(:,before)';
        [sp_EEGfro_NRbef,f]=pwelch(EEGfro_NRbef,length(EEGfro_NRbef)-2,length(EEGfro_NRbef)/2,f,fs);
        Msp_EEGfro_NRbef=nanmean(sp_EEGfro_NRbef,2);
        Msp_EEGfro_NRbef(1:2,1)=nan;
        stdSP_EEGfro_NRbef=nanstd(sp_EEGfro_NRbef,0,2);
        seSP_EEGfro_NRbef=stdSP_EEGfro_NRbef./sqrt(size(EEGfro_NRbef,2));
        
        EEGfro_NRdur=EEGfro_NR(:,during)';
        [sp_EEGfro_NRdur,f]=pwelch(EEGfro_NRdur,length(EEGfro_NRdur)-2,length(EEGfro_NRdur)/2,f,fs);
        Msp_EEGfro_NRdur=nanmean(sp_EEGfro_NRdur,2);
        Msp_EEGfro_NRdur(1:2,1)=nan;
        stdSP_EEGfro_NRdur=nanstd(sp_EEGfro_NRdur,0,2);
        seSP_EEGfro_NRdur=stdSP_EEGfro_NRdur./sqrt(size(EEGfro_NRdur,2));
        
        EEGfro_NRaft=EEGfro_NR(:,after)';
        [sp_EEGfro_NRaft,f]=pwelch(EEGfro_NRaft(~isnan(EEGfro_NRaft)),length(EEGfro_NRaft)-2,length(EEGfro_NRaft)/2,f,fs);
        Msp_EEGfro_NRaft=nanmean(sp_EEGfro_NRaft,2);
        Msp_EEGfro_NRaft(1:2,1)=nan;
        stdSP_EEGfro_NRaft=nanstd(sp_EEGfro_NRaft,0,2);
        seSP_EEGfro_NRaft=stdSP_EEGfro_NRaft./sqrt(size(EEGfro_NRaft,2));
        
        
        
        
        %% %% Calculate Spectra FRONTAL during REM before
        
        EEGfro_Rbef=EEGfro_R(:,before)';
        [sp_EEGfro_Rbef,f]=pwelch(EEGfro_Rbef,length(EEGfro_Rbef)-2,length(EEGfro_Rbef)/2,f,fs);
        Msp_EEGfro_Rbef=nanmean(sp_EEGfro_Rbef,2);
        Msp_EEGfro_Rbef(1:2,1)=nan;
        stdSP_EEGfro_Rbef=nanstd(sp_EEGfro_Rbef,0,2);
        seSP_EEGfro_Rbef=stdSP_EEGfro_Rbef./sqrt(size(EEGfro_Rbef,2));
        
        EEGfro_Rdur=EEGfro_R(:,during)';
        [sp_EEGfro_Rdur,f]=pwelch(EEGfro_Rdur,length(EEGfro_Rdur)-2,length(EEGfro_Rdur)/2,f,fs);
        Msp_EEGfro_Rdur=nanmean(sp_EEGfro_Rdur,2);
        Msp_EEGfro_Rdur(1:2,1)=nan;
        stdSP_EEGfro_Rdur=nanstd(sp_EEGfro_Rdur,0,2);
        seSP_EEGfro_Rdur=stdSP_EEGfro_Rdur./sqrt(size(EEGfro_Rdur,2));
        
        EEGfro_Raft=EEGfro_R(:,after)';
        [sp_EEGfro_Raft,f]=pwelch(EEGfro_Raft,length(EEGfro_Raft)-2,length(EEGfro_Raft)/2,f,fs);
        Msp_EEGfro_Raft=nanmean(sp_EEGfro_Raft,2);
        Msp_EEGfro_Raft(1:2,1)=nan;
        stdSP_EEGfro_Raft=nanstd(sp_EEGfro_Raft,0,2);
        seSP_EEGfro_Raft=stdSP_EEGfro_Raft./sqrt(size(EEGfro_Raft,2));
        
        
        
        
        %% Calculate Spectra OCCIPITAL during NREM before
        
        EEGocc_NRbef=EEGocc_NR(:,before)';
        [sp_EEGocc_NRbef,f]=pwelch(EEGocc_NRbef,length(EEGocc_NRbef)-2,length(EEGocc_NRbef)/2,f,fs);
        Msp_EEGocc_NRbef=nanmean(sp_EEGocc_NRbef,2);
        Msp_EEGocc_NRbef(1:2,1)=nan;
        stdSP_EEGocc_NRbef=nanstd(sp_EEGocc_NRbef,0,2);
        seSP_EEGocc_NRbef=stdSP_EEGocc_NRbef./sqrt(size(EEGocc_NRbef,2));
        
        EEGocc_NRdur=EEGocc_NR(:,during)';
        [sp_EEGocc_NRdur,f]=pwelch(EEGocc_NRdur,length(EEGocc_NRdur)-2,length(EEGocc_NRdur)/2,f,fs);
        Msp_EEGocc_NRdur=nanmean(sp_EEGocc_NRdur,2);
        Msp_EEGocc_NRdur(1:2,1)=nan;
        stdSP_EEGocc_NRdur=nanstd(sp_EEGocc_NRdur,0,2);
        seSP_EEGocc_NRdur=stdSP_EEGocc_NRdur./sqrt(size(EEGocc_NRdur,2));
        
        EEGocc_NRaft=EEGocc_NR(:,after)';
        [sp_EEGocc_NRaft,f]=pwelch(EEGocc_NRaft(~isnan(EEGocc_NRaft)),length(EEGocc_NRaft)-2,length(EEGocc_NRaft)/2,f,fs);
        Msp_EEGocc_NRaft=nanmean(sp_EEGocc_NRaft,2);
        Msp_EEGocc_NRaft(1:2,1)=nan;
        stdSP_EEGocc_NRaft=nanstd(sp_EEGocc_NRaft,0,2);
        seSP_EEGocc_NRaft=stdSP_EEGocc_NRaft./sqrt(size(EEGocc_NRaft,2));
        
        
        
        %% %% Calculate Spectra FRONTAL during REM before
        
        EEGocc_Rbef=EEGocc_R(:,before)';
        [sp_EEGocc_Rbef,f]=pwelch(EEGocc_Rbef,length(EEGocc_Rbef)-2,length(EEGocc_Rbef)/2,f,fs);
        Msp_EEGocc_Rbef=nanmean(sp_EEGocc_Rbef,2);
        Msp_EEGocc_Rbef(1:2,1)=nan;
        stdSP_EEGocc_Rbef=nanstd(sp_EEGocc_Rbef,0,2);
        seSP_EEGocc_Rbef=stdSP_EEGocc_Rbef./sqrt(size(EEGocc_Rbef,2));
        
        EEGocc_Rdur=EEGocc_R(:,during)';
        [sp_EEGocc_Rdur,f]=pwelch(EEGocc_Rdur,length(EEGocc_Rdur)-2,length(EEGocc_Rdur)/2,f,fs);
        Msp_EEGocc_Rdur=nanmean(sp_EEGocc_Rdur,2);
        Msp_EEGocc_Rdur(1:2,1)=nan;
        stdSP_EEGocc_Rdur=nanstd(sp_EEGocc_Rdur,0,2);
        seSP_EEGocc_Rdur=stdSP_EEGocc_Rdur./sqrt(size(EEGocc_Rdur,2));
        
        EEGocc_Raft=EEGocc_R(:,after)';
        [sp_EEGocc_Raft,f]=pwelch(EEGocc_Raft,length(EEGocc_Raft)-2,length(EEGocc_Raft)/2,f,fs);
        Msp_EEGocc_Raft=nanmean(sp_EEGocc_Raft,2);
        Msp_EEGocc_Raft(1:2,1)=nan;
        stdSP_EEGocc_Raft=nanstd(sp_EEGocc_Raft,0,2);
        seSP_EEGocc_Raft=stdSP_EEGocc_Raft./sqrt(size(EEGocc_Raft,2));
        
        
        %% Store results
        
        Msp_LFPds_NRbef_ALL=[Msp_LFPds_NRbef_ALL;Msp_LFPds_NRbef'];
        Msp_LFPds_NRdur_ALL=[Msp_LFPds_NRdur_ALL;Msp_LFPds_NRdur'];
        Msp_LFPds_NRaft_ALL=[Msp_LFPds_NRaft_ALL;Msp_LFPds_NRaft'];
                
        Msp_LFPds_Rbef_ALL=[Msp_LFPds_Rbef_ALL;Msp_LFPds_Rbef'];
        Msp_LFPds_Rdur_ALL=[Msp_LFPds_Rdur_ALL;Msp_LFPds_Rdur'];
        Msp_LFPds_Raft_ALL=[Msp_LFPds_Raft_ALL;Msp_LFPds_Raft'];
        
        Msp_EEGfro_NRbef_ALL=[Msp_EEGfro_NRbef_ALL;Msp_EEGfro_NRbef'];
        Msp_EEGfro_NRdur_ALL=[Msp_EEGfro_NRdur_ALL;Msp_EEGfro_NRdur'];
        Msp_EEGfro_NRaft_ALL=[Msp_EEGfro_NRaft_ALL;Msp_EEGfro_NRaft'];
        
        Msp_EEGfro_Rbef_ALL=[Msp_EEGfro_Rbef_ALL;Msp_EEGfro_Rbef'];
        Msp_EEGfro_Rdur_ALL=[Msp_EEGfro_Rdur_ALL;Msp_EEGfro_Rdur'];
        Msp_EEGfro_Raft_ALL=[Msp_EEGfro_Raft_ALL;Msp_EEGfro_Raft'];
        
        Msp_EEGocc_NRbef_ALL=[Msp_EEGocc_NRbef_ALL;Msp_EEGocc_NRbef'];
        Msp_EEGocc_NRdur_ALL=[Msp_EEGocc_NRdur_ALL;Msp_EEGocc_NRdur'];
        Msp_EEGocc_NRaft_ALL=[Msp_EEGocc_NRaft_ALL;Msp_EEGocc_NRaft'];
        
        Msp_EEGocc_Rbef_ALL=[Msp_EEGocc_Rbef_ALL;Msp_EEGocc_Rbef'];
        Msp_EEGocc_Rdur_ALL=[Msp_EEGocc_Rdur_ALL;Msp_EEGocc_Rdur'];
        Msp_EEGocc_Raft_ALL=[Msp_EEGocc_Raft_ALL;Msp_EEGocc_Raft'];
        
        
    
    
    
    end
end

%% Reshuffling data according to genotype
%1=Ed; 2=Fe; 3=He; 4=Ju; 5=Le; 6=Ne; 7=Oc; 8=Ph; 9=Qu.


%%%%% WT
Msp_LFPds_NRbef_WT=[Msp_LFPds_NRbef_ALL(1:3,:);Msp_LFPds_NRbef_ALL(5,:);Msp_LFPds_NRbef_ALL(9,:)];
Msp_LFPds_NRdur_WT=[Msp_LFPds_NRdur_ALL(1:3,:);Msp_LFPds_NRdur_ALL(5,:);Msp_LFPds_NRdur_ALL(9,:)];
Msp_LFPds_NRaft_WT=[Msp_LFPds_NRaft_ALL(1:3,:);Msp_LFPds_NRaft_ALL(5,:);Msp_LFPds_NRaft_ALL(9,:)];

Msp_LFPds_Rbef_WT=[Msp_LFPds_Rbef_ALL(1:3,:);Msp_LFPds_Rbef_ALL(5,:);Msp_LFPds_Rbef_ALL(9,:)];
Msp_LFPds_Rdur_WT=[Msp_LFPds_Rdur_ALL(1:3,:);Msp_LFPds_Rdur_ALL(5,:);Msp_LFPds_Rdur_ALL(9,:)];
Msp_LFPds_Raft_WT=[Msp_LFPds_Raft_ALL(1:3,:);Msp_LFPds_Raft_ALL(5,:);Msp_LFPds_Raft_ALL(9,:)];

Msp_EEGfro_NRbef_WT=[Msp_EEGfro_NRbef_ALL(1:3,:);Msp_EEGfro_NRbef_ALL(5,:);Msp_EEGfro_NRbef_ALL(9,:)];
Msp_EEGfro_NRdur_WT=[Msp_EEGfro_NRdur_ALL(1:3,:);Msp_EEGfro_NRdur_ALL(5,:);Msp_EEGfro_NRdur_ALL(9,:)];
Msp_EEGfro_NRaft_WT=[Msp_EEGfro_NRaft_ALL(1:3,:);Msp_EEGfro_NRaft_ALL(5,:);Msp_EEGfro_NRaft_ALL(9,:)];

Msp_EEGfro_Rbef_WT=[Msp_EEGfro_Rbef_ALL(1:3,:);Msp_EEGfro_Rbef_ALL(5,:);Msp_EEGfro_Rbef_ALL(9,:)];
Msp_EEGfro_Rdur_WT=[Msp_EEGfro_Rdur_ALL(1:3,:);Msp_EEGfro_Rdur_ALL(5,:);Msp_EEGfro_Rdur_ALL(9,:)];
Msp_EEGfro_Raft_WT=[Msp_EEGfro_Raft_ALL(1:3,:);Msp_EEGfro_Raft_ALL(5,:);Msp_EEGfro_Raft_ALL(9,:)];

Msp_EEGocc_NRbef_WT=[Msp_EEGocc_NRbef_ALL(1:3,:);Msp_EEGocc_NRbef_ALL(5,:);Msp_EEGocc_NRbef_ALL(9,:)];
Msp_EEGocc_NRdur_WT=[Msp_EEGocc_NRdur_ALL(1:3,:);Msp_EEGocc_NRdur_ALL(5,:);Msp_EEGocc_NRdur_ALL(9,:)];
Msp_EEGocc_NRaft_WT=[Msp_EEGocc_NRaft_ALL(1:3,:);Msp_EEGocc_NRaft_ALL(5,:);Msp_EEGocc_NRaft_ALL(9,:)];

Msp_EEGocc_Rbef_WT=[Msp_EEGocc_Rbef_ALL(1:3,:);Msp_EEGocc_Rbef_ALL(5,:);Msp_EEGocc_Rbef_ALL(9,:)];
Msp_EEGocc_Rdur_WT=[Msp_EEGocc_Rdur_ALL(1:3,:);Msp_EEGocc_Rdur_ALL(5,:);Msp_EEGocc_Rdur_ALL(9,:)];
Msp_EEGocc_Raft_WT=[Msp_EEGocc_Raft_ALL(1:3,:);Msp_EEGocc_Raft_ALL(5,:);Msp_EEGocc_Raft_ALL(9,:)];


%%%%%%%%% HOM
Msp_LFPds_NRbef_HOM=[Msp_LFPds_NRbef_ALL(4,:);Msp_LFPds_NRbef_ALL(6:8,:)];
Msp_LFPds_NRdur_HOM=[Msp_LFPds_NRdur_ALL(4,:);Msp_LFPds_NRdur_ALL(6:8,:)];
Msp_LFPds_NRaft_HOM=[Msp_LFPds_NRaft_ALL(4,:);Msp_LFPds_NRaft_ALL(6:8,:)];

Msp_LFPds_Rbef_HOM=[Msp_LFPds_Rbef_ALL(4,:);Msp_LFPds_Rbef_ALL(6:8,:)];
Msp_LFPds_Rdur_HOM=[Msp_LFPds_Rdur_ALL(4,:);Msp_LFPds_Rdur_ALL(6:8,:)];
Msp_LFPds_Raft_HOM=[Msp_LFPds_Raft_ALL(4,:);Msp_LFPds_Raft_ALL(6:8,:)];

Msp_EEGfro_NRbef_HOM=[Msp_EEGfro_NRbef_ALL(4,:);Msp_EEGfro_NRbef_ALL(6:8,:)];
Msp_EEGfro_NRdur_HOM=[Msp_EEGfro_NRdur_ALL(4,:);Msp_EEGfro_NRdur_ALL(6:8,:)];
Msp_EEGfro_NRaft_HOM=[Msp_EEGfro_NRaft_ALL(4,:);Msp_EEGfro_NRaft_ALL(6:8,:)];

Msp_EEGfro_Rbef_HOM=[Msp_EEGfro_Rbef_ALL(4,:);Msp_EEGfro_Rbef_ALL(6:8,:)];
Msp_EEGfro_Rdur_HOM=[Msp_EEGfro_Rdur_ALL(4,:);Msp_EEGfro_Rdur_ALL(6:8,:)];
Msp_EEGfro_Raft_HOM=[Msp_EEGfro_Raft_ALL(4,:);Msp_EEGfro_Raft_ALL(6:8,:)];

Msp_EEGocc_NRbef_HOM=[Msp_EEGocc_NRbef_ALL(4,:);Msp_EEGocc_NRbef_ALL(6:8,:)];
Msp_EEGocc_NRdur_HOM=[Msp_EEGocc_NRdur_ALL(4,:);Msp_EEGocc_NRdur_ALL(6:8,:)];
Msp_EEGocc_NRaft_HOM=[Msp_EEGocc_NRaft_ALL(4,:);Msp_EEGocc_NRaft_ALL(6:8,:)];

Msp_EEGocc_Rbef_HOM=[Msp_EEGocc_Rbef_ALL(4,:);Msp_EEGocc_Rbef_ALL(6:8,:)];
Msp_EEGocc_Rdur_HOM=[Msp_EEGocc_Rdur_ALL(4,:);Msp_EEGocc_Rdur_ALL(6:8,:)];
Msp_EEGocc_Raft_HOM=[Msp_EEGocc_Raft_ALL(4,:);Msp_EEGocc_Raft_ALL(6:8,:)];

%% FIGURES


figure (1)
errorbar(f,mean(Msp_LFPds_NRbef_WT),std(Msp_LFPds_NRbef_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_LFPds_NRbef_HOM),std(Msp_LFPds_NRbef_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_LFPds_NRdur_WT),std(Msp_LFPds_NRdur_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_LFPds_NRdur_HOM),std(Msp_LFPds_NRdur_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_LFPds_NRaft_WT),std(Msp_LFPds_NRaft_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_LFPds_NRaft_HOM),std(Msp_LFPds_NRaft_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

axis([0 20 1 10000])
set(gca, 'YScale', 'log')
set(gca,'fontsize',14,'fontname','Arial','FontWeight','bold')
hold off
%grid on
legend('WT Before','HOM Before','WT During','HOM During','WT After','HOM After')
xlabel('Frequency (Hz)')
%ylabel('LFP Power Density (\mu^2/0.25 Hz)')
title('LFP - NREM before')


figure (2)
errorbar(f,mean(Msp_LFPds_Rbef_WT),std(Msp_LFPds_Rbef_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_LFPds_Rbef_HOM),std(Msp_LFPds_Rbef_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_LFPds_Rdur_WT),std(Msp_LFPds_Rdur_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_LFPds_Rdur_HOM),std(Msp_LFPds_Rdur_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_LFPds_Raft_WT),std(Msp_LFPds_Raft_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_LFPds_Raft_HOM),std(Msp_LFPds_Raft_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

axis([0 20 1 10000])
set(gca, 'YScale', 'log')
set(gca,'fontsize',14,'fontname','Arial','FontWeight','bold')
hold off
%grid on
legend('WT Before','HOM Before','WT During','HOM During','WT After','HOM After')
xlabel('Frequency (Hz)')
%ylabel('LFP Power Density (\mu^2/0.25 Hz)')
title('LFP - REM before')



figure (3)
errorbar(f,mean(Msp_EEGfro_NRbef_WT),std(Msp_EEGfro_NRbef_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_EEGfro_NRbef_HOM),std(Msp_EEGfro_NRbef_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_EEGfro_NRdur_WT),std(Msp_EEGfro_NRdur_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_EEGfro_NRdur_HOM),std(Msp_EEGfro_NRdur_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_EEGfro_NRaft_WT),std(Msp_EEGfro_NRaft_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_EEGfro_NRaft_HOM),std(Msp_EEGfro_NRaft_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

axis([0 20 1 10000])
set(gca, 'YScale', 'log')
set(gca,'fontsize',14,'fontname','Arial','FontWeight','bold')
hold off
%grid on
legend('WT Before','HOM Before','WT During','HOM During','WT After','HOM After')
xlabel('Frequency (Hz)')
%ylabel('LFP Power Density (\mu^2/0.25 Hz)')
title('EEGfro - NREM before')


figure (4)
errorbar(f,mean(Msp_EEGfro_Rbef_WT),std(Msp_EEGfro_Rbef_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_EEGfro_Rbef_HOM),std(Msp_EEGfro_Rbef_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_EEGfro_Rdur_WT),std(Msp_EEGfro_Rdur_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_EEGfro_Rdur_HOM),std(Msp_EEGfro_Rdur_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

hold on
errorbar(f,mean(Msp_EEGfro_Raft_WT),std(Msp_EEGfro_Raft_WT)/sqrt(5),'CapSize',0,'LineWidth',2)
hold on
errorbar(f,mean(Msp_EEGfro_Raft_HOM),std(Msp_EEGfro_Raft_HOM)/sqrt(4),'CapSize',0,'LineWidth',2)

axis([0 20 1 10000])
set(gca, 'YScale', 'log')
set(gca,'fontsize',14,'fontname','Arial','FontWeight','bold')
hold off
%grid on
legend('WT Before','HOM Before','WT During','HOM During','WT After','HOM After')
xlabel('Frequency (Hz)')
%ylabel('LFP Power Density (\mu^2/0.25 Hz)')
title('EEGfro - REM before')


Colours_WT=[0.40 0.40 0.60;... %WT
    0.40 0.40 0.60;... %WT
    0.40 0.40 0.60]; %WT
Colours_WT(2,:)=Colours_WT(2,:)-0.2;
Colours_WT(3,:)=Colours_WT(3,:)-0.4;


Colours_Rlss=[0.68 0.85 0.90;... %WT
    0.68 0.85 0.90;... %WT
    0.68 0.85 0.90]; %WT
Colours_Rlss(2,:)=Colours_Rlss(2,:)-0.2;
Colours_Rlss(3,:)=Colours_Rlss(3,:)-0.4;


figure ()
shadedErrorBar(f,mean(Msp_EEGocc_NRbef_WT),std(Msp_EEGocc_NRbef_WT)/sqrt(5),'lineProps',{'LineWidth',2,'Color',Colours_WT(1,:)})
hold on
shadedErrorBar(f,mean(Msp_EEGocc_NRbef_HOM),std(Msp_EEGocc_NRbef_HOM)/sqrt(4),'lineProps',{'LineWidth',2,'Color',Colours_Rlss(1,:)})

hold on
shadedErrorBar(f,mean(Msp_EEGocc_NRdur_WT),std(Msp_EEGocc_NRdur_WT)/sqrt(5),'lineProps',{'--','LineWidth',2,'Color',Colours_WT(2,:)})
hold on
shadedErrorBar(f,mean(Msp_EEGocc_NRdur_HOM),std(Msp_EEGocc_NRdur_HOM)/sqrt(4),'lineProps',{'--','LineWidth',2,'Color',Colours_Rlss(2,:)})

hold on
shadedErrorBar(f,mean(Msp_EEGocc_NRaft_WT),std(Msp_EEGocc_NRaft_WT)/sqrt(5),'lineProps',{'LineWidth',2,'Color',Colours_WT(3,:)})
hold on
shadedErrorBar(f,mean(Msp_EEGocc_NRaft_HOM),std(Msp_EEGocc_NRaft_HOM)/sqrt(4),'lineProps',{'LineWidth',2,'Color',Colours_Rlss(3,:)})

axis([0 20 1 10000])
set(gca, 'YScale', 'log')
set(gca,'fontsize',14,'fontname','Arial','FontWeight','bold')
hold off
%grid on
legend('WT pre-sound','Rlss pre-sound','WT sound','Rlss sound','WT post-sound','Rlss post-sound','Box','off')
xlabel('Frequency (Hz)')
%ylabel('LFP Power Density (\mu^2/0.25 Hz)')
title('EEGocc - NREM before')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;




figure ()
shadedErrorBar(f,mean(Msp_EEGocc_Rbef_WT),std(Msp_EEGocc_Rbef_WT)/sqrt(5),'lineProps',{'LineWidth',2,'Color',Colours_WT(1,:)})
hold on
shadedErrorBar(f,mean(Msp_EEGocc_Rbef_HOM),std(Msp_EEGocc_Rbef_HOM)/sqrt(4),'lineProps',{'LineWidth',2,'Color',Colours_Rlss(1,:)})

hold on
shadedErrorBar(f,mean(Msp_EEGocc_Rdur_WT),std(Msp_EEGocc_Rdur_WT)/sqrt(5),'lineProps',{'--','LineWidth',2,'Color',Colours_WT(2,:)})
hold on
shadedErrorBar(f,mean(Msp_EEGocc_Rdur_HOM),std(Msp_EEGocc_Rdur_HOM)/sqrt(4),'lineProps',{'--','LineWidth',2,'Color',Colours_Rlss(2,:)})

hold on
shadedErrorBar(f,mean(Msp_EEGocc_Raft_WT),std(Msp_EEGocc_Raft_WT)/sqrt(5),'lineProps',{'LineWidth',2,'Color',Colours_WT(3,:)})
hold on
shadedErrorBar(f,mean(Msp_EEGocc_Raft_HOM),std(Msp_EEGocc_Raft_HOM)/sqrt(4),'lineProps',{'LineWidth',2,'Color',Colours_Rlss(3,:)})

axis([0 20 1 10000])
set(gca, 'YScale', 'log')
set(gca,'fontsize',14,'fontname','Arial','FontWeight','bold')
hold off
%grid on
legend('WT pre-sound','Rlss pre-sound','WT sound','Rlss sound','WT post-sound','Rlss post-sound','Box','off')
xlabel('Frequency (Hz)')
%ylabel('LFP Power Density (\mu^2/0.25 Hz)')
title('EEGocc - REM before')
box off
ax = gca; % current axes
ax.TickDir = 'out';
ax.LineWidth = 1.5;

%% Preparing log transforms for SPSS

Log_Msp_EEGocc_Rbef_WT=log10(Msp_EEGocc_Rbef_WT);
Log_Msp_EEGocc_Rdur_WT=log10(Msp_EEGocc_Rdur_WT);
Log_Msp_EEGocc_Raft_WT=log10(Msp_EEGocc_Raft_WT);

Log_Msp_EEGocc_Rbef_HOM=log10(Msp_EEGocc_Rbef_HOM);
Log_Msp_EEGocc_Rdur_HOM=log10(Msp_EEGocc_Rdur_HOM);
Log_Msp_EEGocc_Raft_HOM=log10(Msp_EEGocc_Raft_HOM);

Log_Msp_EEGocc_NRbef_WT=log10(Msp_EEGocc_NRbef_WT);
Log_Msp_EEGocc_NRdur_WT=log10(Msp_EEGocc_NRdur_WT);
Log_Msp_EEGocc_NRaft_WT=log10(Msp_EEGocc_NRaft_WT);

Log_Msp_EEGocc_NRbef_HOM=log10(Msp_EEGocc_NRbef_HOM);
Log_Msp_EEGocc_NRdur_HOM=log10(Msp_EEGocc_NRdur_HOM);
Log_Msp_EEGocc_NRaft_HOM=log10(Msp_EEGocc_NRaft_HOM);






