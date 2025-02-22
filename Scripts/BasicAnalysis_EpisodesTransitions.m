% Calculate number of episodes of each vigilance state
clear all
close all

exte='.txt';
path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5



der='fro';
n_WT=5;
n_HOM=5;

WTnames=char('Ed','Fe','He','Le','Qu');
WTdays=['091117';'091117';'161117';'161117';'200318'];
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);


% To store data
WT_data=cell(5,4);
HOM_data=cell(5,4);

%%%%%PARAMETERS
mindur_W=14;%14 This means that episodes of at least 1 min (15 epochs or more) will be included.
mindur_NR=14;%14
mindur_R=1;
ba=4;% works for both wake and NR
ba_R=1;
%For brief awakenings, a minimum duration of 1 is chosen and no
%interruptions allowed.

%WT animals

for n=1:5
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W_L,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR_L,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R_L,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw_L,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            WT_W(n,1)=length(EpDur_W);WT_NR(n,1)=length(EpDur_NR);WT_R(n,1)=length(EpDur_R);WT_ba(n,1)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            
            
            
            
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
%             NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
%             R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
%             Spectr=vertcat(Spectr_L,spectr);
%             art=[W1;NR2;R3;MT];
%             Spectr(art,:)=NaN;
%             
            
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W_D,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR_D,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R_D,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw_D,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            WT_W(n,2)=length(EpDur_W);WT_NR(n,2)=length(EpDur_NR);WT_R(n,2)=length(EpDur_R);WT_ba(n,2)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            
            
        end
        
        
    end
    SE_W=[SE_W_L;SE_W_D];SE_NR=[SE_NR_L;SE_NR_D];SE_R=[SE_R_L;SE_R_D];SE_baw=[SE_baw_L;SE_baw_D];
    WT_data(n,:)={SE_W,SE_NR,SE_R,SE_baw};

end


%HOM animals

for n=1:5
    
    mouse=HOMnames(n,:);
    day=HOMdays(n,:);
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
   for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W_L,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR_L,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R_L,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw_L,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            HOM_W(n,1)=length(EpDur_W);HOM_NR(n,1)=length(EpDur_NR);HOM_R(n,1)=length(EpDur_R);HOM_ba(n,1)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            
           
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W=vertcat(W_L,w+10800);W1=vertcat(W1_L,w1+10800);MT=vertcat(MT_L,mt+10800);
%             NR=vertcat(NR_L,nr+10800);NR2=vertcat(NR2_L,nr2+10800);
%             R=vertcat(R_L,r+10800);R3=vertcat(R3_L,r3+10800);
%             Spectr=vertcat(Spectr_L,spectr);
%             art=[W1;NR2;R3;MT];
%             Spectr(art,:)=NaN;
%             
            
            wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,10800);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,10800);rem(r)=1;rem(r3)=1;
            baw=zeros(1,10800);baw(mt)=1;
            
            [SE_W_D,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR_D,EpDur_NR]=DetectEpisodes(nrem,10800,mindur_NR,ba);
            [SE_R_D,EpDur_R]=DetectEpisodes(rem,10800,mindur_R,ba_R);
            [SE_baw_D,EpDur_baw]=DetectEpisodes(baw,10800,1,0);
            
            HOM_W(n,2)=length(EpDur_W);HOM_NR(n,2)=length(EpDur_NR);HOM_R(n,2)=length(EpDur_R);HOM_ba(n,2)=length(EpDur_baw)/sum(nrem)*15;%normalising ba as nbr of ba epochs per min of NREM
            
            
            
        end
        
    end
   SE_W=[SE_W_L;SE_W_D];SE_NR=[SE_NR_L;SE_NR_D];SE_R=[SE_R_L;SE_R_D];SE_baw=[SE_baw_L;SE_baw_D];
   HOM_data(n,:)={SE_W,SE_NR,SE_R,SE_baw};


end

%%%% WT animals
%Find following state for each wake episode

for n=1:5
    
    SE_W=WT_data{n,1};%Loading matrix of start and end epochs of all wake episodes of animal n
    Following_states=zeros(length(SE_W),1);
    
    SE_NR=WT_data{n,2};
    SE_R=WT_data{n,3};
        
    for ep=1:length(SE_W)
        
        End_epoch=SE_W(ep,2);
        
        SE_NR_mins=SE_NR(:,1)-End_epoch;SE_NR_mins(SE_NR_mins<0)=NaN;
        SE_R_mins=SE_R(:,1)-End_epoch;SE_R_mins(SE_R_mins<0)=NaN;
        
        min_NR=min(SE_NR_mins);
        min_R=min(SE_R_mins);
        
        if min_NR<min_R % then the following state is NR
            Following_states(ep)=2;%2==NREM
        else % the following state is REM
            Following_states(ep)=3;%3==REM
        end
    end
    
    WT_data{n,1}=[SE_W,Following_states];
    
end

%Find following state for each NREM episode

for n=1:5
    
    SE_NR=WT_data{n,2};%Loading matrix of start and end epochs of all NREM episodes of animal n
    Following_states=zeros(length(SE_NR),1);
    
    SE_W=WT_data{n,1};
    SE_R=WT_data{n,3};
        
    for ep=1:length(SE_NR)
        
        End_epoch=SE_NR(ep,2);
        
        SE_W_mins=SE_W(:,1)-End_epoch;SE_W_mins(SE_W_mins<0)=NaN;
        SE_R_mins=SE_R(:,1)-End_epoch;SE_R_mins(SE_R_mins<0)=NaN;
        
        min_W=min(SE_W_mins);
        min_R=min(SE_R_mins);
        
        if min_W<min_R % then the following state is wake
            Following_states(ep)=1;%1==W
        else % the following state is REM
            Following_states(ep)=3;%3==REM
        end
    end
    
    WT_data{n,2}=[SE_NR,Following_states];
    
end
%Find following state for each REM episode

for n=1:5
    
    SE_R=WT_data{n,3};%Loading matrix of start and end epochs of all NREM episodes of animal n
    Following_states=zeros(length(SE_R),1);
    
    SE_W=WT_data{n,1};
    SE_NR=WT_data{n,2};
        
    for ep=1:length(SE_R)
        
        End_epoch=SE_R(ep,2);
        
        SE_W_mins=SE_W(:,1)-End_epoch;SE_W_mins(SE_W_mins<0)=NaN;
        SE_NR_mins=SE_NR(:,1)-End_epoch;SE_NR_mins(SE_NR_mins<0)=NaN;
        
        min_W=min(SE_W_mins);
        min_NR=min(SE_NR_mins);
        
        if min_W<min_NR % then the following state is wake
            Following_states(ep)=1;%1==W
        else % the following state is NREM
            Following_states(ep)=2;%2==NREM
        end
    end
    
    WT_data{n,3}=[SE_R,Following_states];
    
end

%%%% HOM animals
%Find following state for each wake episode

for n=1:5
    
    SE_W=HOM_data{n,1};%Loading matrix of start and end epochs of all wake episodes of animal n
    Following_states=zeros(length(SE_W),1);
    
    SE_NR=HOM_data{n,2};
    SE_R=HOM_data{n,3};
        
    for ep=1:length(SE_W)
        
        End_epoch=SE_W(ep,2);
        
        SE_NR_mins=SE_NR(:,1)-End_epoch;SE_NR_mins(SE_NR_mins<0)=NaN;
        SE_R_mins=SE_R(:,1)-End_epoch;SE_R_mins(SE_R_mins<0)=NaN;
        
        min_NR=min(SE_NR_mins);
        min_R=min(SE_R_mins);
        
        if min_NR<min_R % then the following state is NREM
            Following_states(ep)=2;%2==NREM
        else % the following state is REM
            Following_states(ep)=3;%3==REM
        end
    end
    
    HOM_data{n,1}=[SE_W,Following_states];
    
end

%Find following state for each NREM episode

for n=1:5
    
    SE_NR=HOM_data{n,2};%Loading matrix of start and end epochs of all NREM episodes of animal n
    Following_states=zeros(length(SE_NR),1);
    
    SE_W=HOM_data{n,1};
    SE_R=HOM_data{n,3};
        
    for ep=1:length(SE_NR)
        
        End_epoch=SE_NR(ep,2);
        
        SE_W_mins=SE_W(:,1)-End_epoch;SE_W_mins(SE_W_mins<0)=NaN;
        SE_R_mins=SE_R(:,1)-End_epoch;SE_R_mins(SE_R_mins<0)=NaN;
        
        min_W=min(SE_W_mins);
        min_R=min(SE_R_mins);
        
        if min_W<min_R % then the following state is wake
            Following_states(ep)=1;%1==W
        else % the following state is REM
            Following_states(ep)=3;%3==REM
        end
    end
    
    HOM_data{n,2}=[SE_NR,Following_states];
    
end
%Find following state for each REM episode

for n=1:5
    
    SE_R=HOM_data{n,3};%Loading matrix of start and end epochs of all NREM episodes of animal n
    Following_states=zeros(length(SE_R),1);
    
    SE_W=HOM_data{n,1};
    SE_NR=HOM_data{n,2};
        
    for ep=1:length(SE_R)
        
        End_epoch=SE_R(ep,2);
        
        SE_W_mins=SE_W(:,1)-End_epoch;SE_W_mins(SE_W_mins<0)=NaN;
        SE_NR_mins=SE_NR(:,1)-End_epoch;SE_NR_mins(SE_NR_mins<0)=NaN;
        
        min_W=min(SE_W_mins);
        min_NR=min(SE_NR_mins);
        
        if min_W<min_NR % then the following state is wake
            Following_states(ep)=1;%1==W
        else % the following state is NREM
            Following_states(ep)=2;%2==NREM
        end
    end
    
    HOM_data{n,3}=[SE_R,Following_states];
    
end

Tr_NR_R_WT=zeros(5,1);Tr_NR_W_WT=zeros(5,1);
Tr_R_NR_WT=zeros(5,1);Tr_R_W_WT=zeros(5,1);
Tr_W_NR_WT=zeros(5,1);Tr_W_R_WT=zeros(5,1);

Tr_NR_R_HOM=zeros(5,1);Tr_NR_W_HOM=zeros(5,1);
Tr_R_NR_HOM=zeros(5,1);Tr_R_W_HOM=zeros(5,1);
Tr_W_NR_HOM=zeros(5,1);Tr_W_R_HOM=zeros(5,1);



figure(1) % aboslute numbers of transitions from one state to the next (as indicated by figure titles).
%subplot 1: NR=>R
subplot(3,2,1)
for n=1:5
    Tr_NR_R_WT(n)=sum(WT_data{n,2}(:,3)==3);
    Tr_NR_R_HOM(n)=sum(HOM_data{n,2}(:,3)==3);
end
h1=notBoxPlot([Tr_NR_R_WT,Tr_NR_R_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of NREM->REM transitions')
ylabel('Absolute nbre')
xlabel('Genotype')

%subplot 2: NR=>Wake

subplot(3,2,2)
for n=1:5
    Tr_NR_W_WT(n)=sum(WT_data{n,2}(:,3)==1);
    Tr_NR_W_HOM(n)=sum(HOM_data{n,2}(:,3)==1);
end
h2=notBoxPlot([Tr_NR_W_WT,Tr_NR_W_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of NREM->Wake transitions')
ylabel('Absolute nbre')
xlabel('Genotype')

%subplot 3: R=>NR

subplot(3,2,3)
for n=1:5
    Tr_R_NR_WT(n)=sum(WT_data{n,3}(:,3)==2);
    Tr_R_NR_HOM(n)=sum(HOM_data{n,3}(:,3)==2);
end
h3=notBoxPlot([Tr_R_NR_WT,Tr_R_NR_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of REM->NREM transitions')
ylabel('Absolute nbre')
xlabel('Genotype')

%subplot 4: R=>Wake

subplot(3,2,4)
for n=1:5
    Tr_R_W_WT(n)=sum(WT_data{n,3}(:,3)==1);
    Tr_R_W_HOM(n)=sum(HOM_data{n,3}(:,3)==1);
end
h4=notBoxPlot([Tr_R_W_WT,Tr_R_W_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of REM->Wake transitions')
ylabel('Absolute nbre')
xlabel('Genotype')

%subplot 5: Wake=>NR

subplot(3,2,5)
for n=1:5
    Tr_W_NR_WT(n)=sum(WT_data{n,1}(:,3)==2);
    Tr_W_NR_HOM(n)=sum(HOM_data{n,1}(:,3)==2);
end
h5=notBoxPlot([Tr_W_NR_WT,Tr_W_NR_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of Wake->NREM transitions')
ylabel('Absolute nbre')
xlabel('Genotype')

%subplot 6: Wake=>R (there should'nt be any, but let's check...)

subplot(3,2,6)
for n=1:5
    Tr_W_R_WT(n)=sum(WT_data{n,1}(:,3)==3);
    Tr_W_R_HOM(n)=sum(HOM_data{n,1}(:,3)==3);
end
h6=notBoxPlot([Tr_W_R_WT,Tr_W_R_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of Wake->REM transitions')
ylabel('Absolute nbre')
xlabel('Genotype')


%%%%%%%%%%
figure(2)% Proportion of transitions from one state to the next (normalised
         %against total number of episodes of the starting state)

subplot(3,2,1)
for n=1:5
    Tr_NR_R_WT(n)=sum(WT_data{n,2}(:,3)==3)/length(WT_data{n,2});
    Tr_NR_R_HOM(n)=sum(HOM_data{n,2}(:,3)==3)/length(HOM_data{n,2});
end
h1=notBoxPlot([Tr_NR_R_WT,Tr_NR_R_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of NREM->REM transitions')
ylabel('% of NREM episodes')
xlabel('Genotype')
%ylim([0 1]);

%subplot 2: NR=>Wake

subplot(3,2,2)
for n=1:5
    Tr_NR_W_WT(n)=sum(WT_data{n,2}(:,3)==1)/length(WT_data{n,2});
    Tr_NR_W_HOM(n)=sum(HOM_data{n,2}(:,3)==1)/length(HOM_data{n,2});
end
h2=notBoxPlot([Tr_NR_W_WT,Tr_NR_W_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of NREM->Wake transitions')
ylabel('% of NREM episodes')
xlabel('Genotype')
%ylim([0 1]);

%subplot 3: R=>NR

subplot(3,2,3)
for n=1:5
    Tr_R_NR_WT(n)=sum(WT_data{n,3}(:,3)==2)/length(WT_data{n,3});
    Tr_R_NR_HOM(n)=sum(HOM_data{n,3}(:,3)==2)/length(HOM_data{n,3});
end
h3=notBoxPlot([Tr_R_NR_WT,Tr_R_NR_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of REM->NREM transitions')
ylabel('% of REM episodes')
xlabel('Genotype')
%ylim([0 1]);

%subplot 4: R=>Wake

subplot(3,2,4)
for n=1:5
    Tr_R_W_WT(n)=sum(WT_data{n,3}(:,3)==1)/length(WT_data{n,3});
    Tr_R_W_HOM(n)=sum(HOM_data{n,3}(:,3)==1)/length(HOM_data{n,3});
end
h4=notBoxPlot([Tr_R_W_WT,Tr_R_W_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of REM->Wake transitions')
ylabel('% of REM episodes')
xlabel('Genotype')
%ylim([0 1]);

%subplot 5: Wake=>NR

subplot(3,2,5)
for n=1:5
    Tr_W_NR_WT(n)=sum(WT_data{n,1}(:,3)==2)/length(WT_data{n,1});
    Tr_W_NR_HOM(n)=sum(HOM_data{n,1}(:,3)==2)/length(HOM_data{n,1});
end
h5=notBoxPlot([Tr_W_NR_WT,Tr_W_NR_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of Wake->NREM transitions')
ylabel('% of wake episodes')
xlabel('Genotype')
%ylim([0 1]);

%subplot 6: Wake=>R (there should'nt be any - or very few -, but let's check...)

subplot(3,2,6)
for n=1:5
    Tr_W_R_WT(n)=sum(WT_data{n,1}(:,3)==3)/length(WT_data{n,1});
    Tr_W_R_HOM(n)=sum(HOM_data{n,1}(:,3)==3)/length(HOM_data{n,1});
end
h6=notBoxPlot([Tr_W_R_WT,Tr_W_R_HOM]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Number of Wake->REM transitions')
ylabel('% of wake episodes')
xlabel('Genotype')
%ylim([0 1]);
