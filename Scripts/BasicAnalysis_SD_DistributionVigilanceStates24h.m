% Calculate total amount in each state in baseline 24h
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5

bs=2; %bin size (in hours)


der='fro';
n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
WT_SDdays=['101117';'101117';'171117';'171117';'210318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
HOM_SDdays=['171117';'210318';'210318';'210318';'210318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%sleep/wake times
WT_time_NR=zeros(5,24/bs);WT_time_R=zeros(5,24/bs);WT_time_W=zeros(5,24/bs);
HOM_time_NR=zeros(5,24/bs);HOM_time_R=zeros(5,24/bs);HOM_time_W=zeros(5,24/bs);

WT_time_NR_L=zeros(5,12/bs);WT_time_R_L=zeros(5,12/bs);WT_time_W_L=zeros(5,12/bs);
HOM_time_NR_L=zeros(5,12/bs);HOM_time_R_L=zeros(5,12/bs);HOM_time_W_L=zeros(5,12/bs);

WT_time_NR_D=zeros(5,12/bs);WT_time_R_D=zeros(5,12/bs);WT_time_W_D=zeros(5,12/bs);
HOM_time_NR_D=zeros(5,12/bs);HOM_time_R_D=zeros(5,12/bs);HOM_time_W_D=zeros(5,12/bs);

%To store some values for figures 7 and 8
WT_time_NR_cum_BL=zeros(5,24/bs);WT_time_R_cum_BL=zeros(5,24/bs);
HOM_time_NR_cum_BL=zeros(5,24/bs);HOM_time_R_cum_BL=zeros(5,24/bs);

Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;


for d=1:2
    %WT animals
    for n=1:n_WT
        
        mouse=WTnames(n,:);
        day=WTdays(n,:);
        SDday=WT_SDdays(n,:);
        pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
        pathin=[pathin1,'outputVS/'];
        
        for ld=1:2
            if ld==1
                
                LD='L';
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                for h=1:12/bs
                    beg_int=bs*3600/4*(h-1);
                    end_int=bs*3600/4*h;
                    WT_time_NR_L(n,h)=(length(find(nr>beg_int & nr<end_int))+length(find(nr2>beg_int & nr2<end_int)))*4/3600;
                    WT_time_R_L(n,h)=(length(find(r>beg_int & r<end_int))+length(find(r3>beg_int & r3<end_int)))*4/3600;
                    WT_time_W_L(n,h)=(length(find(w>beg_int & w<end_int))+length(find(w1>beg_int & w1<end_int))+length(find(mt>beg_int & mt<end_int)))*4/3600;
                end
            else
                LD='D';
                
               if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                
                for h=1:12/bs
                    beg_int=bs*3600/4*(h-1);
                    end_int=bs*3600/4*h;
                    WT_time_NR_D(n,h)=(length(find(nr>beg_int & nr<end_int))+length(find(nr2>beg_int & nr2<end_int)))*4/3600;
                    WT_time_R_D(n,h)=(length(find(r>beg_int & r<end_int))+length(find(r3>beg_int & r3<end_int)))*4/3600;
                    WT_time_W_D(n,h)=(length(find(w>beg_int & w<end_int))+length(find(w1>beg_int & w1<end_int))+length(find(mt>beg_int & mt<end_int)))*4/3600;
                end
            end
            
        end
        
    end
    
    
    %HOM animals
    for n=1:n_HOM
        
        mouse=HOMnames(n,:);
        day=HOMdays(n,:);
        SDday=HOM_SDdays(n,:);
        pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
        pathin=[pathin1,'outputVS/'];
        
        for ld=1:2
            if ld==1
                
                LD='L';
                
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                for h=1:12/bs
                    beg_int=bs*3600/4*(h-1);
                    end_int=bs*3600/4*h;
                    HOM_time_NR_L(n,h)=(length(find(nr>beg_int & nr<end_int))+length(find(nr2>beg_int & nr2<end_int)))*4/3600;
                    HOM_time_R_L(n,h)=(length(find(r>beg_int & r<end_int))+length(find(r3>beg_int & r3<end_int)))*4/3600;
                    HOM_time_W_L(n,h)=(length(find(w>beg_int & w<end_int))+length(find(w1>beg_int & w1<end_int))+length(find(mt>beg_int & mt<end_int)))*4/3600;
                end
            else
                LD='D';
                
                if d==1
                    fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
                else
                    fileName=[mouse,'_',SDday,'_',LD,'_',der,'_VSspec'];
                end
                eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
                
                for h=1:12/bs
                    beg_int=bs*3600/4*(h-1);
                    end_int=bs*3600/4*h;
                    HOM_time_NR_D(n,h)=(length(find(nr>beg_int & nr<end_int))+length(find(nr2>beg_int & nr2<end_int)))*4/3600;
                    HOM_time_R_D(n,h)=(length(find(r>beg_int & r<end_int))+length(find(r3>beg_int & r3<end_int)))*4/3600;
                    HOM_time_W_D(n,h)=(length(find(w>beg_int & w<end_int))+length(find(w1>beg_int & w1<end_int))+length(find(mt>beg_int & mt<end_int)))*4/3600;
                end
            end
            
        end
        
    end
    
    WT_time_NR=horzcat(WT_time_NR_L,WT_time_NR_D);
    WT_time_R=horzcat(WT_time_R_L,WT_time_R_D);
    WT_time_W=horzcat(WT_time_W_L,WT_time_W_D);
    if d==1
    end
    
    HOM_time_NR=horzcat(HOM_time_NR_L,HOM_time_NR_D);
    HOM_time_R=horzcat(HOM_time_R_L,HOM_time_R_D);
    HOM_time_W=horzcat(HOM_time_W_L,HOM_time_W_D);
     
    
    %%%%%%%% Plot
    if d==1
        figure(1)
        
        x=1:2:24;
        x2=1.2:2:24.2;
        
        ax(1)=subplot(1,3,1);
        shadedErrorBar(x,mean(WT_time_NR),std(WT_time_NR)/sqrt(n_WT),'lineProps',{'-','LineWidth',1.5,'Color',Colours(1,:)});
        hold on
        shadedErrorBar(x2,mean(HOM_time_NR),std(HOM_time_NR)/sqrt(n_HOM),'lineProps',{'-','LineWidth',1.5,'Color',Colours(2,:)});
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in NREM - BL')
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        legend('boxoff')
        
        ax(2)=subplot(1,3,2);
        shadedErrorBar(x,mean(WT_time_R),std(WT_time_R)/sqrt(n_WT),'lineProps',{'-','LineWidth',1.5,'Color',Colours(1,:)});
        hold on
        shadedErrorBar(x2,mean(HOM_time_R),std(HOM_time_R)/sqrt(n_HOM),'lineProps',{'-','LineWidth',1.5,'Color',Colours(2,:)});
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in REM - BL')
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        legend('boxoff')
        
        ax(3)=subplot(1,3,3);
        shadedErrorBar(x,mean(WT_time_W),std(WT_time_W)/sqrt(n_WT),'lineProps',{'-','LineWidth',1.5,'Color',Colours(1,:)});
        hold on
        shadedErrorBar(x2,mean(HOM_time_W),std(HOM_time_W)/sqrt(n_HOM),'lineProps',{'-','LineWidth',1.5,'Color',Colours(2,:)});
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in wake - BL')
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        legend('boxoff')
        
    else
        figure(2)
        x=1:2:24;
        x2=1.2:2:24.2;
        
        ax(1)=subplot(1,3,1);
        shadedErrorBar(x,mean(WT_time_NR),std(WT_time_NR)/sqrt(n_WT),'lineProps',{'-','LineWidth',1.5,'Color',Colours(1,:)});
        hold on
        shadedErrorBar(x2,mean(HOM_time_NR),std(HOM_time_NR)/sqrt(n_HOM),'lineProps',{'-','LineWidth',1.5,'Color',Colours(2,:)});
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in NREM - SD')
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        legend('boxoff')
        
        ax(2)=subplot(1,3,2);
        shadedErrorBar(x,mean(WT_time_R),std(WT_time_R)/sqrt(n_WT),'lineProps',{'-','LineWidth',1.5,'Color',Colours(1,:)});
        hold on
        shadedErrorBar(x2,mean(HOM_time_R),std(HOM_time_R)/sqrt(n_HOM),'lineProps',{'-','LineWidth',1.5,'Color',Colours(2,:)});
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in REM - SD')
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        legend('boxoff')
        
        ax(3)=subplot(1,3,3);
        shadedErrorBar(x,mean(WT_time_W),std(WT_time_W)/sqrt(n_WT),'lineProps',{'-','LineWidth',1.5,'Color',Colours(1,:)});
        hold on
        shadedErrorBar(x2,mean(HOM_time_W),std(HOM_time_W)/sqrt(n_HOM),'lineProps',{'-','LineWidth',1.5,'Color',Colours(2,:)});
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in wake - SD')
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        legend('boxoff')
    end
    


%%%%%%%% Plot with one figure per genotype - featuring BL and SD together
    if d==1
        figure(3) %WT
        
        x=1:2:24;
        x2=1.2:2:24.2;
        
        ax(1)=subplot(1,3,1);
        errorbar(x,mean(WT_time_NR),std(WT_time_NR)/sqrt(n_WT));
        
        ax(2)=subplot(1,3,2);
        errorbar(x,mean(WT_time_R),std(WT_time_R)/sqrt(n_WT));
        
        ax(3)=subplot(1,3,3);
        errorbar(x,mean(WT_time_W),std(WT_time_W)/sqrt(n_WT));
        
        
        figure(4) %HOM
        x=1:2:24;
        x2=1.2:2:24.2;
        
        ax(1)=subplot(1,3,1);
        errorbar(x2,mean(HOM_time_NR),std(HOM_time_NR)/sqrt(n_HOM));
        
        ax(2)=subplot(1,3,2);
        errorbar(x2,mean(HOM_time_R),std(HOM_time_R)/sqrt(n_HOM));
        
        
        ax(3)=subplot(1,3,3); 
        errorbar(x2,mean(HOM_time_W),std(HOM_time_W)/sqrt(n_HOM));

        
    else
        figure(3) % WT
        
        subplot(1,3,1);
        hold on
        errorbar(x,mean(WT_time_NR),std(WT_time_NR)/sqrt(n_WT),'Color',Colours(1,:));
        legend('WT-BL','WT-SD','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in NREM - WT')
        
        subplot(1,3,2);
        hold on
        errorbar(x,mean(WT_time_R),std(WT_time_R)/sqrt(n_WT),'Color',Colours(1,:));
        legend('WT-BL','WT-SD','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in REM - WT')
        
        subplot(1,3,3);
        hold on
        errorbar(x,mean(WT_time_W),std(WT_time_W)/sqrt(n_WT),'Color',Colours(1,:));
        legend('WT-BL','WT-SD','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in wake - WT')
        
        
        figure(4) % HOM
        subplot(1,3,1);
        hold on
        errorbar(x2,mean(HOM_time_NR),std(HOM_time_NR)/sqrt(n_HOM),'Color',Colours(2,:));
        legend('HOM-BL','HOM-SD','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in NREM - HOM')
        
        subplot(1,3,2);
        hold on
        errorbar(x2,mean(HOM_time_R),std(HOM_time_R)/sqrt(n_HOM),'Color',Colours(2,:));
        legend('HOM-BL','HOM-SD','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in REM - HOM')
        
        subplot(1,3,3);
        hold on
        errorbar(x2,mean(HOM_time_W),std(HOM_time_W)/sqrt(n_HOM),'Color',Colours(2,:));
        legend('HOM-BL','HOM-SD','Location','best')
        xlabel('ZT (hours)')
        ylabel('Time (hours)')
        title('Time spent in wake - HOM')
    end
    
    %%% Cumulative durations of NREM
    WT_time_NR_cum=WT_time_NR;
    HOM_time_NR_cum=HOM_time_NR;
    
    for n=2:size(WT_time_NR,2)
        WT_time_NR_cum(:,n)=WT_time_NR_cum(:,n)+WT_time_NR_cum(:,n-1);
        HOM_time_NR_cum(:,n)=HOM_time_NR_cum(:,n)+HOM_time_NR_cum(:,n-1);
    end
    
    if d==1
        WT_time_NR_cum_BL=WT_time_NR_cum;
        HOM_time_NR_cum_BL=HOM_time_NR_cum;
    end
    
    figure(5)
    if d==1
        shadedErrorBar(x,mean(WT_time_NR_cum),std(WT_time_NR_cum)/sqrt(n_WT),'lineProps',{'-','Color',Colours(1,:),'LineWidth',1.5});
        hold on
        shadedErrorBar(x2,mean(HOM_time_NR_cum),std(HOM_time_NR_cum)/sqrt(n_HOM),'lineProps',{'-','Color',Colours(2,:),'LineWidth',1.5});
    else % d==2
        hold on
        shadedErrorBar(x,mean(WT_time_NR_cum),std(WT_time_NR_cum)/sqrt(n_WT),'lineProps',{':','Color',Colours(1,:),'LineWidth',1.5});
        hold on
        shadedErrorBar(x2,mean(HOM_time_NR_cum),std(HOM_time_NR_cum)/sqrt(n_HOM),'lineProps',{':','Color',Colours(2,:),'LineWidth',1.5});
        legend('WT-BL','Rlss-BL','WT-SD','Rlss-SD','Location','best','Box','off')
    end
    xlabel('ZT (hours)')
    ylabel('Cumulative time (hours)')
    title('Time spent in NREM')
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    
    %%% Cumulative durations of REM
    WT_time_R_cum=WT_time_R;
    HOM_time_R_cum=HOM_time_R;
    
    for n=2:size(WT_time_R,2)
        WT_time_R_cum(:,n)=WT_time_R_cum(:,n)+WT_time_R_cum(:,n-1);
        HOM_time_R_cum(:,n)=HOM_time_R_cum(:,n)+HOM_time_R_cum(:,n-1);
    end
    
    if d==1
        WT_time_R_cum_BL=WT_time_R_cum;
        HOM_time_R_cum_BL=HOM_time_R_cum;
    end
    
    figure(6)
    if d==1
        shadedErrorBar(x,mean(WT_time_R_cum),std(WT_time_R_cum)/sqrt(n_WT),'lineProps',{'-','Color',Colours(1,:),'LineWidth',1.5});
        hold on
        shadedErrorBar(x2,mean(HOM_time_R_cum),std(HOM_time_R_cum)/sqrt(n_HOM),'lineProps',{'-','Color',Colours(2,:),'LineWidth',1.5});
    else % d==2
        hold on
        shadedErrorBar(x,mean(WT_time_R_cum),std(WT_time_R_cum)/sqrt(n_WT),'lineProps',{':','Color',Colours(1,:),'LineWidth',1.5});
        hold on
        shadedErrorBar(x2,mean(HOM_time_R_cum),std(HOM_time_R_cum)/sqrt(n_HOM),'lineProps',{':','Color',Colours(2,:),'LineWidth',1.5});
        legend('WT-BL','Rlss-BL','WT-SD','Rlss-SD','Location','best','Box','off')
    end
    xlabel('ZT (hours)')
    ylabel('Cumulative time (hours)')
    title('Time spent in REM')
    box off
    ax = gca; % current axes
    ax.TickDir = 'out';
    ax.LineWidth = 1.5;
    
    %%% Cumulative differences (BL-postSD) in NREM time normalised against BL 
    if d==2
        WT_time_NR_diff=(WT_time_NR_cum_BL - WT_time_NR_cum)./(WT_time_NR_cum_BL);
        HOM_time_NR_diff=(HOM_time_NR_cum_BL - HOM_time_NR_cum)./(HOM_time_NR_cum_BL);

        
        figure(7)
        errorbar(x,mean(WT_time_NR_diff),std(WT_time_NR_diff)/sqrt(n_WT),'LineWidth',0.8);
        hold on
        errorbar(x2,mean(HOM_time_NR_diff),std(HOM_time_NR_diff)/sqrt(n_HOM),'LineWidth',0.8);
 
        legend('WT','HOM','Location','best')

        xlabel('ZT (hours)')
        ylabel('Difference between cumulative NREM times (normalised against BL) ')
        title('Cumulative-NREM-time difference (BL-SD)/BL ')
        
    end
    
    %%% Cumulative differences (BL-postSD) in REM time normalised against BL 
    if d==2
        WT_time_R_diff=(WT_time_R_cum_BL - WT_time_R_cum)./(WT_time_R_cum_BL);
        HOM_time_R_diff=(HOM_time_R_cum_BL - HOM_time_R_cum)./(HOM_time_R_cum_BL);

        
        figure(8)
        errorbar(x,mean(WT_time_R_diff),std(WT_time_R_diff)/sqrt(n_WT),'LineWidth',0.8);
        hold on
        errorbar(x2,mean(HOM_time_R_diff),std(HOM_time_R_diff)/sqrt(n_HOM),'LineWidth',0.8);
        hold on
        plot([0 25],[0 0],':','Color',[0.5 0.5 0.5])
        
        legend('WT','HOM','Location','best')
        xlabel('ZT (hours)')
        ylabel('Difference between cumulative REM times (normalised against BL) ')
        title('Cumulative-REM-time difference (BL-SD)/BL ')
        
    end
end




%% To get SD day values for Gareth

Mean_WT_NR=mean(WT_time_NR);
SEM_WT_NR=std(WT_time_NR)/sqrt(n_WT);
Mean_HOM_NR=mean(HOM_time_NR);
SEM_HOM_NR=std(HOM_time_NR)/sqrt(n_HOM);
Mean_WT_R=mean(WT_time_R);
SEM_WT_R=std(WT_time_R)/sqrt(n_WT);
Mean_HOM_R=mean(HOM_time_R);
SEM_HOM_R=std(HOM_time_R)/sqrt(n_HOM);
Mean_WT_W=mean(WT_time_W);
SEM_WT_W=std(WT_time_W)/sqrt(n_WT);
Mean_HOM_W=mean(HOM_time_W);
SEM_HOM_W=std(HOM_time_W)/sqrt(n_HOM);

