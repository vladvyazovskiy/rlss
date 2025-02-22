

clear all
%close all
path=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/'];
pathVS=[path,'Sleepy6_OFFperiods/'];

maxep=10800;
epochl=4;
x=1:1:maxep;
mindur=45;
ba=0;


cols='bmr';

%outp1=[x'];

mousename='Oc';%'Qu';%'Oc';
date='200318_L';
dateOFF='200318L';
genotype=2;%1=WT (Qu), 2=rlss (Oc)
selected_episodes=[29,30,31,46,47,48];%Qu:[1,2,6,8,10,14];%Oc:[29,30,31,46,47,48]%%

fnameVS=[mousename,'_',date,'_fro_VSspec'];
load([pathVS,fnameVS,'.mat']);

fnameOFF=[mousename,'_',dateOFF,'_NewClustering'];
load([pathVS,fnameOFF,'.mat']);

sleep=zeros(1,maxep); sleep(nr)=1;

[startend epidur]=SleepEpisodes_VV_MG(sleep,maxep,mindur,ba);

Start_OFF=OFFDATA.StartOP;
End_OFF=OFFDATA.EndOP;
fs=OFFDATA.PNEfs;

ch=5;
StartOFF_indexes_allVS=find(Start_OFF(:,ch))./fs; %StartOFF_indexes(end)=[];
EndOFF_indexes_allVS=find(End_OFF(:,ch))./fs; %EndON_indexes(1)=[];

dur=EndOFF_indexes_allVS-StartOFF_indexes_allVS;
out=find(dur<0.05);
StartOFF_indexes_allVS(out)=[];
EndOFF_indexes_allVS(out)=[];

StartOFF=ceil(StartOFF_indexes_allVS);

offincid=nan(1,12*60*60);
offn=nan(1,12*60*60);

%OFF period incidence
for s=1:12*60*60
    s_incid=find(StartOFF==s);
    offincid(s)=length(s_incid);
end

%OFF period occupancy
for s=1:12*60*60
    se=find(StartOFF==s);
    de=dur(se);
    offn(s)=sum(de)*1000;
end


Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;


% OFF period incidence plots
figure()
episode=0;
for e=selected_episodes%1:length(epidur)%%[29,30,31,46,47,48];%Ju%%
    st=(startend(e,1)-1)*epochl+1;
    en=startend(e,2)*epochl;

    
    ep_incid=offincid(st:en);
    episode=episode+1;
    subplot(6,1,episode)
    plot(ep_incid,'Color',Colours(genotype,:));
    hold on
    plot(medfilt1(ep_incid,8),'-k','LineWidth',2)
    xlabel('Time (s)')
    ylabel({'# OFF periods';'/ 1-sec'})
    box off
    ax=gca;
    ax.LineWidth=1.5;
    ax.TickDir = 'out';

    %pause

    %close all

end

% OFF period occupancy episodes plots
figure()
episode=0;
for e=selected_episodes%1:length(epidur)%%
    st=(startend(e,1)-1)*epochl+1;
    en=startend(e,2)*epochl;

    
    epio=offn(st:en);
    episode=episode+1;
    subplot(6,1,episode)
    plot(epio,'Color',Colours(genotype,:));
    hold on
    plot(medfilt1(epio,8),'-k','LineWidth',2)
    xlabel('Time (s)')
    ylabel({'OFF-period'; 'occupancy (ms)'})
    box off
    ax=gca;
    ax.LineWidth=1.5;
    ax.TickDir = 'out';
    %pause

    %close all

end




