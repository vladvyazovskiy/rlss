1clear all
close all


%opengl('save', 'software')

path='/Volumes/MyPasseport/Sleepy6EEG-November2017/';
pathSignals=[path,'OutputSignals/'];
pathAud=[path,'OutputAuditory/'];
pathout=[path,'Auditory_Analysis_TrialResults/']; %mkdir(pathout)
mousenames=strvcat('Le');

recorddate='201117_D';%day month year
block=[mousenames,'_',recorddate];
lfpCH=[7]; %Oc
%lfpCH=[6 14]; %Ga
%lfpCH=[10 13]; %Ga
eegCH=[1 2 4];


yaxis=[-800 800;-800 800;-400 400;-400 400;-600 600];
yaxisAU=[0 12];

audname=[mousenames,'-AUD-WrittenOut256Hz-',recorddate];
audtr=[block,'_aud_parameters'];

before=20;
after=16;
fs=256;

p1=0.75; p2=30; s1=0.2; s2=40;
Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=30; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
[bb1,aa1]=cheby2(n,Rs,Wn);

p1=5; p2=100; s1=4; s2=120;
Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=20; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
[bb2,aa2]=cheby2(n,Rs,Wn);

maxep=10800;
xtt=1:1:1800; xtt=xtt/900;

cols=[0.68 0.85 0.90;...
    0.48 0.65 0.70;...
    0.28 0.45 0.50;...
    0 0 0;...
    0 0 0];

%cols='brmkk'; 
%cols='brmk'; %Ka

for anim=1:1
    
    mousename=mousenames(anim,:);
    
    %load auditory trials
    eval(['load ',pathAud,audtr,'.mat lims -mat']);
    
    %load auditory signal
    eval(['load ',pathSignals,audname,'.mat aud -mat']);
    
    % LFPs
    fnin=[mousename,'-LFP-',recorddate,'-ch',num2str(lfpCH(1))];%Ne-LFP-280318_D-ch4
    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
    signal=filtfilt(bb1,aa1,sig);
    LFP1=signal; clear signal sig;
    
%     fnin=[mousename,'-LFP1-',recorddate,'-cont-ch',num2str(lfpCH(2))];
%     eval(['load ',pathSignals,fnin,'.mat resampled_sig_LFP -mat']);
%     signal=filtfilt(bb1,aa1,resampled_sig_LFP);
%     LFP2=signal; clear signal resampled_sig_LFP;
    
    fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(1))];
    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
    signal=filtfilt(bb1,aa1,sig);
    EEG1=signal; clear signal sig;
    
    fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(2))];
    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
    signal=filtfilt(bb1,aa1,sig);
    EEG2=signal; clear signal sig;
    
    fnin=[mousename,'-EEG-',recorddate,'-ch',num2str(eegCH(3))];
    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
    signal=filtfilt(bb2,aa2,sig);
    EMG=signal; clear signal sig;
    
    TrialsResults=[];
    
    LFPds=[];
    LFPns=[];
    EEGfro=[];
    EEGocc=[];
    
    %for trial=1:5
       for trial=91:93%size(lims,1)%1:90%
           if trial>91
               Number_session='2';
           else
               Number_session='1';
           end
           
        
        myFig = figure; set(myFig, 'Position',[700 100 1200 900]);
        
        st=lims(trial,1)-fs*before;
        en=lims(trial,2)+fs*after;
        
        lfp1=LFP1(st:en);
        %lfp2=LFP2(st:en);
        eeg1=EEG1(st:en);
        eeg2=EEG2(st:en);
        emg=EMG(st:en);
        au=aud(st:en);
                
        LFPds=[LFPds;lfp1(1:5000)];
        %LFPns=[LFPns;lfp2(1:5000)];
        EEGfro=[EEGfro;eeg1(1:5000)];
        EEGocc=[EEGocc;eeg2(1:5000)];
        
        x=1:length(au); x=x./fs;
        
        sig=[lfp1;eeg1;eeg2;emg;au];
        %sig=[lfp1;lfp2;eeg2;emg;au]; %Ka
        
        for sss=1:4
            
            subplot('position',[0.15 0.9-sss*0.13 0.8 0.11])
            plot(x,sig(sss,:),'-','Color',cols(sss,:),'LineWidth',1.5)
            if sss==1  title([mousename,' trial ',num2str(trial)]); end
            %axis([0 max(x) yaxis(sss,:)])
            %axis off
            set(gca,'xtick',[])
            box off
        end
        
        subplot('position',[0.15 0.1 0.8 0.10])
        bar(x,au)
        axis([0 max(x) 0 12])
        axis off
        
        
        %close all
        StateBefore = waitinput('State before Aud stim : ',2000); % 1=W,2=NR,3=R,4=uncertain
        StateDuring = waitinput('State during Aud stim: ',2000);% 1=W,2=NR,3=R,4=uncertain
        StateAfter = waitinput('State after Aud stim: ',2000);% 1=W,2=NR,3=R,4=uncertain
        artifacts = waitinput('Artifacts: ',2000);% 0=No or 1
%         
%         close all
%         
        TrialsResults=[TrialsResults;StateBefore StateDuring StateAfter artifacts]
%         
%         
    end
%     
    fnameD=[mousename,'-',recorddate,'-TrialsScreening-Session-',Number_session];
    %eval(['save ',pathout,fnameD,'.mat TrialsResults -mat']);
    
%     fnameC=[mousename,'-',recorddate,'-Trials_LFP_EEG'];
%     
%     %eval(['save ',pathout,fnameC,'.mat LFPds LFPns EEGfro EEGocc -mat']); 
%     eval(['save ',pathout,fnameC,'.mat LFPds EEGocc -mat']); %EEGfro 
%     
end