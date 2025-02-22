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
pathWT=char(path2017,path2017,path2017,path2017,path2018);

HOMnames=char('Ju','Me','Ne','Oc','Ph');
HOMdays=['161117';'200318';'200318';'200318';'200318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);

%sleep/wake times
WT_time_NR=zeros(5,24/bs);WT_time_R=zeros(5,24/bs);WT_time_W=zeros(5,24/bs);
HOM_time_NR=zeros(5,24/bs);HOM_time_R=zeros(5,24/bs);HOM_time_W=zeros(5,24/bs);

WT_time_NR_L=zeros(5,12/bs);WT_time_R_L=zeros(5,12/bs);WT_time_W_L=zeros(5,12/bs);
HOM_time_NR_L=zeros(5,12/bs);HOM_time_R_L=zeros(5,12/bs);HOM_time_W_L=zeros(5,12/bs);

WT_time_NR_D=zeros(5,12/bs);WT_time_R_D=zeros(5,12/bs);WT_time_W_D=zeros(5,12/bs);
HOM_time_NR_D=zeros(5,12/bs);HOM_time_R_D=zeros(5,12/bs);HOM_time_W_D=zeros(5,12/bs);

%WT animals
for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
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
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
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
    pathin1=pathHOM(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
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
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
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

HOM_time_NR=horzcat(HOM_time_NR_L,HOM_time_NR_D);
HOM_time_R=horzcat(HOM_time_R_L,HOM_time_R_D);
HOM_time_W=horzcat(HOM_time_W_L,HOM_time_W_D);


%%%%%%%% Plot
figure(1)

x=1:2:24;
x2=1.2:2:24.2;

ax(1)=subplot(1,3,1);
errorbar(x,mean(WT_time_NR),std(WT_time_NR)/sqrt(n_WT));
hold on
errorbar(x2,mean(HOM_time_NR),std(HOM_time_NR)/sqrt(n_HOM));
legend('WT','HOM','Location','best')
ylabel('Time (hours)')
xlabel('ZT (hours)')
title('Time spent in NREM')

ax(2)=subplot(1,3,2);
errorbar(x,mean(WT_time_R),std(WT_time_R)/sqrt(n_WT));
hold on
errorbar(x2,mean(HOM_time_R),std(HOM_time_R)/sqrt(n_HOM));
legend('WT','HOM','Location','best')
ylabel('Time (hours)');
xlabel('ZT (hours)');
title('Time spent in REM');

ax(3)=subplot(1,3,3);
errorbar(x,mean(WT_time_W),std(WT_time_W)/sqrt(n_WT));
hold on
errorbar(x2,mean(HOM_time_W),std(HOM_time_W)/sqrt(n_HOM));
legend('WT','HOM','Location','best')
ylabel('Time (hours)')
xlabel('ZT (hours)')
title('Time spent in wake')


%% To get values for Gareth

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
