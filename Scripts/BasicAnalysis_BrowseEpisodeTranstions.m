clear all
close all


path='/Volumes/Elements/Sleepy6EEG-March2018/'; %'/Volumes/MyPasseport/Sleepy6EEG-November2017/';
pathSignals=[path,'OutputSignals/'];
mousenames=strvcat('Oc');

recorddate='200318_L';%day month year
block=[mousenames,'_',recorddate];
lfpCH=[7]; %Oc
eegCH=[1 2 4];
der='fro';


yaxis=[-700 700;-700 700;-400 400;-400 400;-600 600];

before=10;
after=10;
fs=256;

p1=0.75; p2=30; s1=0.2; s2=40;
Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=30; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
[bb1,aa1]=cheby2(n,Rs,Wn);

p1=5; p2=100; s1=4; s2=120;
Wp=[p1 p2]/(fs/2); Ws=[s1 s2]/(fs/2); Rp=3; Rs=20; [n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
[bb2,aa2]=cheby2(n,Rs,Wn);

maxep=10800;
xtt=1:1:1800; xtt=xtt/900;

cols='brmkk'; 


for anim=1:1
    
    mousename=mousenames(anim,:);
    
    %%% Detect episodes
    
    %%%%%PARAMETERS
    mindur_W=4;%14 This means that episodes of at least 1 min (15 epochs or more) will be included.
    mindur_NR=4;%14
    mindur_R=1;
    ba=4;% works for both wake and NR
    ba_R=1;
    %For brief awakenings, a minimum duration of 1 is chosen and no
    %interruptions allowed.
   
    
    pathin=[path,'outputVS/'];
    
    
    fileName=[mousename,'_',recorddate,'_',der,'_VSspec'];
    
    eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
    
    %             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
    wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
    nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
    rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
    baw=zeros(1,10800);baw(mt)=1;
    
    [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
    [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
    [SE_R,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
    [SE_baw,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
    
    %%%Parameters to change depending on what I want to look at
    Nbre_transitions=length(EpDur_NR);
    Correct_SE=SE_NR;
    
    %%%%%%
    
    % LFPs
    fnin=[mousename,'-LFP-',recorddate,'-ch',num2str(lfpCH(1))];%Ne-LFP-280318_D-ch4
    eval(['load ',pathSignals,fnin,'.mat sig -mat']);
    signal=filtfilt(bb1,aa1,sig);
    LFP1=signal; clear signal sig;
    
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
    EEGfro=[];
    EEGocc=[];
    
    for transition=20:22%Nbre_transitions-1
        
        myFig = figure; set(myFig, 'Position',[700 100 1200 900]);
        
        st=Correct_SE(transition,2)*4*fs-fs*before;% Looking a little before the end of the episode
        en=Correct_SE(transition,2)*4*fs+fs*after;% Looking a little after the end of the episode
        
        lfp1=LFP1(st:en);
        eeg1=EEG1(st:en);
        eeg2=EEG2(st:en);
        emg=EMG(st:en);
        
        LFPds=[LFPds;lfp1(1:5000)];
        EEGfro=[EEGfro;eeg1(1:5000)];
        EEGocc=[EEGocc;eeg2(1:5000)];
        
        %x=1:length(au); x=x./fs;
        
        
        sig=[lfp1;eeg1;eeg2;emg];

        
        for sss=1:4
            
            subplot('position',[0.15 0.9-sss*0.13 0.8 0.11])
            plot(sig(sss,:),['-',cols(sss)],'LineWidth',1.5)
            if sss==1  title([mousename,' transition ',num2str(transition)]); end
            axis([0 length(lfp1) yaxis(sss,:)])
            axis off
            
        end
        
    end
 
end