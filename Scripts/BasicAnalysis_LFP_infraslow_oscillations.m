% Calculate number of episodes of each vigilance state
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/';
path2018='/Volumes/Elements/Sleepy6EEG-March2018/';


der='fro';%It doesn't matter here; I just need to get the vigilance states; the signals are loaded back from the entire "raw" output containing all channels and derivations.

n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);
LFP_channel_WT=[4 3 5 6 5];%Same channels as in ON period analysis

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);
LFP_channel_HOM=[1 3 4 5 5];%Same channels as in ON period analysis

%fs=256;
freq=0:0.05:20;%0:0.25:20;
x_ticks=-60:4:56;
c_upper_limit=400;



%%%%%PARAMETERS
mindur_NR=12;%NREM episodes of at least 32s
ba_NR=0;%allow ba_NR in NREM episodes

%WT animals
Records_LFP_WT_L_noHann=[];
Records_LFP_WT_L_Hann=[];

for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    pathinSignal=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/'];
    
    for ld=1
        
        
        LD='L';
        
%         fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
%         eval(['load ',pathinSignal,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
%         
        VS_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',mouse,'_',day,'_',LD,'_',der,'_VSspec.mat'];
        load(VS_filename);
            
        
        if sum(mouse=='Qu')==2
            fileNameSignal=['LFPraw_data_',mouse,'_',day,'_',LD,'_Channels1to16-exc9'];
        else
            fileNameSignal=['LFPraw_data_',mouse,'_',day,'_',LD,'_Channels1to16'];
        end
        output=load([pathinSignal,fileNameSignal,'.mat']);
        
        fs=output.fs;
        All_channels=[output.Ch1;output.Ch2;output.Ch3;output.Ch4;output.Ch5;output.Ch6;output.Ch7];%No mouse has a channel number chosen above 7, but in theory I can go up to channel 16
        
        nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=0;% setting nr2 as zeros as I do not want to include episodes with more than 1 artifact (i.e. 1 ba or 1 artifact possible in the episodes detected as in Vlad's paper on infraslow oscillations).
        
        
        [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba_NR);
        nb_epi=length(EpDur_NR);
        
        Records_absY_noHann=[];
        Records_Pxx_Hann=[];
        
        for i=1:nb_epi
            Signal=All_channels(LFP_channel_WT(n),:);
            Selec_NR_LFP=Signal(round((SE_NR(i,1)-1)*fs*4)+1:round(SE_NR(i,2)*fs*4));%Selecting signals corresponding to episode i
            
            T = 1/fs;             % Sampling period
            L = round(fs*4*mindur_NR);
 
            
            % FFT without Hanning window
            
            %splitting signal in mindur_NR chunks
            num_chunks=floor(length(Selec_NR_LFP)/L);
            for chunk=1:num_chunks
                X = Selec_NR_LFP((chunk-1)*L+1:chunk*L);%selecting signal corresponding to chunk 'chunk' (in episode 'i' preselceted above)
                Y = fft(X);
                Records_absY_noHann=[Records_absY_noHann;abs(Y)];
                
                if (chunk==1 && i<4)
                    figure()
                    fs_timeseries=fs;%0.25;%1/4s
                    nfft = length(X);          % number of samples
                    f = (0:nfft-1)*(fs_timeseries/nfft);     % frequency range
                    power = abs(Y).^2/nfft;    % power of the DFT
                    plot(f,power,'LineWidth',1.5)
                    xlim([0 4])
                    xlabel('Frequency')
                    ylabel('Power')
                    set(gca, 'YScale', 'log')
                end
                
%                 %With Hanning Window
%                 % Segment the data to 10s
%                 X = X.*hann(length(X))';                                                   % Apply Hanning Window
%                 N = length(X);                                                                 % Length of signal segment
%                 P = nextpow2(N);                                                           % Pad signal to increase computational time
%                 npow = 2^P;
%                 Y = fft(X,npow);                                                                    % Apply the fft algorithm
%                 Pxx = 1/(N*fs)*abs(Y(1:length(X)/2+1)).^2;                  % Find signal power
%                 f = (0:fs/N:fs/2);                                                            % Frequency Vector
%                 Pxx(2:end-1) = 2*Pxx(2:end-1);
%                 Records_Pxx_Hann=[Records_Pxx_Hann;Pxx];

            end
            
            
            
        end
        
        Records_LFP_WT_L_noHann=[Records_LFP_WT_L_noHann;mean(Records_absY_noHann)];
        %Records_LFP_WT_L_Hann=[Records_LFP_WT_L_Hann;mean(Records_Pxx_Hann)];
        
        
    end
    
end


% %HOM animals
Records_LFP_Rstl_L_noHann=[];
Records_LFP_Rstl_L_Hann=[];

for n=1:n_HOM
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    pathinSignal=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/'];
    
    for ld=1
        
        
        LD='L';
        
%         fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
%         eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
%         
        VS_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',mouse,'_',day,'_',LD,'_',der,'_VSspec.mat'];
        load(VS_filename);
        
        fileNameSignal=['LFPraw_data_',mouse,'_',day,'_',LD,'_Channels1to16'];
        
        output=load([pathinSignal,fileNameSignal,'.mat']);
        
        fs=output.fs;
        All_channels=[output.Ch1;output.Ch2;output.Ch3;output.Ch4;output.Ch5;output.Ch6;output.Ch7];%No mouse has a channel number chosen above 7, but in theory I can go up to channel 16
        
        nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=0;% setting nr2 as zeros as I do not want to include episodes with more than 1 artifact (i.e. 1 ba or 1 artifact possible in the episodes detected as in Vlad's paper on infraslow oscillations).
        
        
        [SE_NR,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba_NR);
        nb_epi=length(EpDur_NR);
        
        Records_absY_noHann=[];
        Records_Pxx_Hann=[];
        
        for i=1:nb_epi
            Signal=All_channels(LFP_channel_HOM(n),:);
            Selec_NR_LFP=Signal(round((SE_NR(i,1)-1)*fs*4)+1:round(SE_NR(i,2)*fs*4));%Selecting signals corresponding to episode i
            
            T = 1/fs;             % Sampling period
            L = round(fs*4*mindur_NR);
            
           
            % FFT without Hanning window
            
            %splitting signal in mindur_NR chunks
            num_chunks=floor(length(Selec_NR_LFP)/L);
            for chunk=1:num_chunks
                X = Selec_NR_LFP((chunk-1)*L+1:chunk*L);%selecting signal corresponding to chunk 'chunk' (in episode 'i' preselceted above)
                Y = fft(X);
                Records_absY_noHann=[Records_absY_noHann;abs(Y)];

                if (chunk==1 && i<4)
                    figure()
                    fs_timeseries=fs;%0.25;%1/4s
                    nfft = length(X);          % number of samples
                    f = (0:nfft-1)*(fs_timeseries/nfft);     % frequency range
                    power = abs(Y).^2/nfft;    % power of the DFT
                    plot(f,power,'LineWidth',1.5)
                    xlim([0 4])
                    xlabel('Frequency')
                    ylabel('Power')
                    set(gca, 'YScale', 'log')
                end

                
%                 %With Hanning Window
%                 % Segment the data to 10s
%                 X = X.*hann(length(X))';                                                   % Apply Hanning Window
%                 N = length(X);                                                                 % Length of signal segment
%                 P = nextpow2(N);                                                           % Pad signal to increase computational time
%                 npow = 2^P;
%                 Y = fft(X,npow);                                                                    % Apply the fft algorithm
%                 Pxx = 1/(N*fs)*abs(Y(1:length(X)/2+1)).^2;                  % Find signal power
%                 f = (0:fs/N:fs/2);                                                            % Frequency Vector
%                 Pxx(2:end-1) = 2*Pxx(2:end-1);
%                 Records_Pxx_Hann=[Records_Pxx_Hann;Pxx];
%                 
                
                

            end
            
            
            
        end
        
        Records_LFP_Rstl_L_noHann=[Records_LFP_Rstl_L_noHann;mean(Records_absY_noHann)];
        %Records_LFP_Rstl_L_Hann=[Records_LFP_Rstl_L_Hann;mean(Records_Pxx_Hann)];
        
        
    end
    
end

figure()
plot(fs/L*(0:L-1),abs(mean(Records_LFP_WT_L_noHann,1)),'LineWidth',3)
hold on
plot(fs/L*(0:L-1),abs(mean(Records_LFP_Rstl_L_noHann,1)),'LineWidth',3)
title('Complex Magnitude of fft Spectrum - rlss mice')
xlabel("f (Hz)")
ylabel("|fft(X)|")
set(gca, 'YScale', 'log')
xlim([0 2])
legend('WT','rlss')


figure()
fs_timeseries=fs;%0.25;%1/4s
nfft = length(X);          % number of samples
f = (0:nfft-1)*(fs_timeseries/nfft);     % frequency range

power_WT = abs(mean(Records_LFP_WT_L_noHann,1)).^2/nfft;    % power of the DFT
plot(f,power_WT,'LineWidth',1.5)
hold on
power_rlss = abs(mean(Records_LFP_Rstl_L_noHann,1)).^2/nfft;    % power of the DFT
plot(f,power_rlss,'LineWidth',1.5)

xlim([0 4])
xlabel('Frequency')
ylabel('Power')
set(gca, 'YScale', 'log')
legend('WT','rlss')

% % With Hanning window
% figure()
% plot(f,10*log10(mean(Records_LFP_WT_L_Hann,1))); % Plot the power spectrum
% hold on
% plot(f,10*log10(mean(Records_LFP_Rstl_L_Hann,1))); % Plot the power spectrum
% title('Power Spectral Density Using FFT - Hanning window - rlss mice')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% xlim([0 2])
% legend('WT','rlss')

%save('Workspace_BasicAnalysis_LFP_infraslow_oscillations');
