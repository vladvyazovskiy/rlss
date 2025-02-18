clear all
close all



pathLFP='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/LFPraw partial files/';
pathpNE='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/pNe data partial files/';

fs_LFP=305.1758;
fs_pNE=498.2463;

num_sec_to_show=10;
%%%% Plot LFP for Quentin (animal 2-WT) and Octave(Animal 1-Hom)
%ha = tight_subplot(8,1,0,[.06 .01],[.06 .01]);
Colors=[0.30 0.30 0.50 ; 0.40 0.40 0.60 ; 0.50 0.50 0.70 ; 0.60 0.60 0.80 ; 0.70 0.70 0.90];
Colors = Colors - 0.2;

% Colours=[0.40 0.40 0.60;... %WT
%     0.68 0.85 0.90]; %Rlss
% Colours=Colours-0.2;


fileName_LFP='LFPraw_data_Qu_200318_L_Channels3to8';
load([pathLFP,fileName_LFP]);%,'.mat sig -mat']);
Three_channels_LFP=[Ch4;Ch5;Ch6;Ch7;Ch8];%Three_channels_LFP=[Ch3;Ch4;Ch5;Ch6;Ch7;Ch8];

fileName_pNE='pNE_data_Qu_200318_L_Channels3to8';
load([pathpNE,fileName_pNE]);%,'.mat sig -mat']);
Three_channels_pNE=[Ch4;Ch5;Ch6;Ch7;Ch8];%Three_channels_pNE=[Ch3;Ch4;Ch5;Ch6;Ch7;Ch8];

figure()
for ch=1:5
    sig_LFP=Three_channels_LFP(ch,round(2000*fs_LFP):round((2000+num_sec_to_show)*fs_LFP));%Qu: 2022-2024 ; Oc: 11235-11237
    sig_pNE=Three_channels_pNE(ch,round(2000*fs_pNE):round((2000+num_sec_to_show)*fs_pNE));%Qu: 2022-2024 ; Oc: 11235-11237

    subplot(10,1,ch)
    plot(0:1/fs_LFP:length(sig_LFP)/fs_LFP-1/fs_LFP,sig_LFP,'-','LineWidth',2,'Color',Colors(ch,:));
    xlim([0 num_sec_to_show])
    if ch<5
    axis off
    else
        ax=gca;
        ax.LineWidth=3;
        set(gca,'XColor','none')
    end
    box off

    subplot(10,1,ch+5)
    plot(0:1/fs_pNE:length(sig_pNE)/fs_pNE-1/fs_pNE,sig_pNE,'-','LineWidth',2,'Color',Colors(ch,:));
    xlim([0 num_sec_to_show])
    if ch<5
    axis off
    else
        ax=gca;
        ax.LineWidth=3;
    end
    box off
%     axes(ha(ch)); 
%     plot(,'LineWidth',1.5);


    %plot([-10 -10],[-500 -1000],'-k','LineWidth',2)
end
sgtitle('Qu')
%%%%

%%% Rlss mouse
clear all
pathLFP='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/LFPraw partial files/';
pathpNE='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/pNe data partial files/';

fs_LFP=305.1758;
fs_pNE=498.2463;

num_sec_to_show=10;
%%%% Plot LFP for Quentin (animal 2-WT) and Octave(Animal 1-Hom)
%ha = tight_subplot(8,1,0,[.06 .01],[.06 .01]);
Colors=[0.38 0.55 0.60 ; 0.48 0.65 0.70 ; 0.58 0.75 0.80 ; 0.68 0.85 0.90 ; 0.78 0.95 1];
Colors = Colors - 0.2;

% Colours=[0.40 0.40 0.60;... %WT
%     0.68 0.85 0.90]; %Rlss
% Colours=Colours-0.2;

fileName_LFP='LFPraw_data_Ph_200318_L_Channels1to6';
load([pathLFP,fileName_LFP]);%,'.mat sig -mat']);
Three_channels_LFP=[Ch1;Ch2;Ch3;Ch4;Ch5];%Three_channels_LFP=[Ch1;Ch2;Ch3;Ch4;Ch5;Ch6];


fileName_pNE='pNE_data_Ph_200318_L_Channels1to6';
load([pathpNE,fileName_pNE]);%,'.mat sig -mat']);
Three_channels_pNE=[Ch1;Ch2;Ch3;Ch4;Ch5];%Three_channels_pNE=[Ch1;Ch2;Ch3;Ch4;Ch5;Ch6];

figure()
for ch=1:5
    sig_LFP=Three_channels_LFP(ch,round(3500*fs_LFP):round((3500+num_sec_to_show)*fs_LFP));%Ph: 4000
    sig_pNE=Three_channels_pNE(ch,round(3500*fs_pNE):round((3500+num_sec_to_show)*fs_pNE));%Ph: 4000

    subplot(10,1,ch)
    plot(0:1/fs_LFP:length(sig_LFP)/fs_LFP-1/fs_LFP,sig_LFP,'-','LineWidth',2 ,'Color',Colors(ch,:));
    xlim([0 num_sec_to_show])
    if ch<5
    axis off
    else
        ax=gca;
        ax.LineWidth=3;
        set(gca,'XColor','none')
    end
    box off

    subplot(10,1,ch+5)
    plot(0:1/fs_pNE:length(sig_pNE)/fs_pNE-1/fs_pNE,sig_pNE,'-','LineWidth',2,'Color',Colors(ch,:));
    xlim([0 num_sec_to_show])
    if ch<5
    axis off
    else
        ax=gca;
        ax.LineWidth=3;
    end
    box off
%     axes(ha(ch)); 
%     plot(,'LineWidth',1.5);


    %plot([-10 -10],[-500 -1000],'-k','LineWidth',2)
end
sgtitle('Ph')

%%% Rlss mouse #2
clear all
pathLFP='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/LFPraw partial files/';
pathpNE='/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/pNe data partial files/';

fs_LFP=305.1758;
fs_pNE=498.2463;

num_sec_to_show=10;
%%%% Plot LFP for Quentin (animal 2-WT) and Octave(Animal 1-Hom)
%ha = tight_subplot(8,1,0,[.06 .01],[.06 .01]);
Colors=[0 0.2 0.8;0 0.4 0.8; 0 0.6 0.8;0 0.8 0.8];


fileName_LFP='LFPraw_data_Ne_200318_L_Channels5to10';
load([pathLFP,fileName_LFP]);%,'.mat sig -mat']);
Three_channels_LFP=[Ch5;Ch6;Ch7;Ch8;Ch9;Ch10];

fileName_pNE='pNE_data_Ne_200318_L_Channels5to10';
load([pathpNE,fileName_pNE]);%,'.mat sig -mat']);
Three_channels_pNE=[Ch5;Ch6;Ch7;Ch8;Ch9;Ch10];

figure()
for ch=1:6
    sig_LFP=Three_channels_LFP(ch,round(3400*fs_LFP):round((3400+num_sec_to_show)*fs_LFP));%Ph: 3500 or 4000
    sig_pNE=Three_channels_pNE(ch,round(3400*fs_pNE):round((3400+num_sec_to_show)*fs_pNE));%Ph: 3500 or 4000

    subplot(12,1,ch)
    plot(0:1/fs_LFP:length(sig_LFP)/fs_LFP-1/fs_LFP,sig_LFP,'-','LineWidth',2);% ,'Color',Colors(ch-5*floor((ch-1)/4),:)
    xlim([0 num_sec_to_show])
    if ch<6
    axis off
    else
        ax=gca;
        ax.LineWidth=3;
        set(gca,'XColor','none')
    end
    box off

    subplot(12,1,ch+6)
    plot(0:1/fs_pNE:length(sig_pNE)/fs_pNE-1/fs_pNE,sig_pNE,'-','LineWidth',2);%,'Color',Colors(ch-5*floor((ch-1)/4),:)
    xlim([0 num_sec_to_show])
    if ch<6
    axis off
    else
        ax=gca;
        ax.LineWidth=3;
    end
    box off
%     axes(ha(ch)); 
%     plot(,'LineWidth',1.5);


    %plot([-10 -10],[-500 -1000],'-k','LineWidth',2)
end
sgtitle('Ne')