% Calculate number of episodes of each vigilance state
clear all
close all

exte='.txt';

path2017='/Volumes/MyPasseport/Sleepy6EEG-November2017/'; %'F:\Sleepy6EEG-November2017\'; n1
path2018='/Volumes/Elements/Sleepy6EEG-March2018/'; %'G:\Sleepy6EEG-March2018\'; n5

der='LFP';
n_WT=3;
n_HOM=5;



WTnames=char('Fe','He','Qu');
WTdays=['201117';'201117';'280318'];
pathWT=char(path2017,path2017,path2018);

HOMnames=char('Ju','Ne','Oc','Ph');
HOMdays=['201117';'280318';'280318';'280318'];
pathHOM=char(path2017,path2018,path2018,path2018,path2018);


day2017='201117';
day2018='280318';

LDphase='L';





%%%%

fs=256; %sampling rate (Hz)
freq=0:0.25:20;
x_ticks=-60:4:56;
c_upper_limit=800;
dur=8; %duration sound and how much I take before and after



%%%%%PARAMETERS


Average_Spec_WT=zeros(81,30,n_WT); Average_Spec_HOM=zeros(81,30,n_HOM);
%WT animals

for n=1:n_WT
    
    mouse=WTnames(n,:);
    day=WTdays(n,:);
    pathin1=pathWT(n,:);pathin1(isspace(pathin1))=[];
    pathin=[pathin1,'outputVS/'];
    
    for ld=1%:2
        if ld==1
            
            LD='L';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; 
%             wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,21600);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,21600);rem(r)=1;rem(r3)=1;
            baw=zeros(1,21600);baw(mt)=1;
            Spectr_L=spectr;
            
            fnAud=[mouse,'_',day,'_',LD,'_aud_parameters'];
            pathAud=[pathin,'OutputAuditory/'];
            eval(['load ',pathAud,fnAud,'.mat lims -mat']);
        
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            %             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
%             wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem(nr+10800)=1;nrem(nr2+10800)=1;
            rem(r+10800)=1;rem(r3+10800)=1;
            baw(mt+10800)=1;
            Spectr=vertcat(Spectr_L,spectr);spectr=Spectr;
        end
    end       
%             [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);

          
            Selected_Eps=lims;

            % To record the spectra of selected episodes
             % Frequencies across rows; 1min (15ep) NREM + 1Min REM across columns;
            % multiple saved episodes across thrid dimention
            
            
            Selec_Spec=zeros(81,30,length(Selected_Eps(:,1)));
            for j=1:length(Selected_Eps(:,1))
                Selec_Spec(:,:,j)=horzcat(spectr(Selected_Eps(j,1)-15:Selected_Eps(j,1)-1,:)',spectr(Selected_Eps(j,1):Selected_Eps(j,1)+14,:)');
            end 
            
            Average_Spec=nanmean(Selec_Spec,3); 
            
            figure(1)
            subplot(n_WT,1,n)
            surf(x_ticks,freq,Average_Spec)
            shading interp
            view(2)
            caxis([50 c_upper_limit]);
            title(['WT-Transitions:',num2str(length(Selected_Eps(:,1)))]);
            ylabel('Frequency (Hz)');
            xlabel('Time (s) - 1min NR + 1min R');
            colorbar  
            
            
            Average_Spec_WT(:,:,n)=Average_Spec;
            
    
    
    
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
            
%             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; 
%             wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem=zeros(1,21600);nrem(nr)=1;nrem(nr2)=1;
            rem=zeros(1,21600);rem(r)=1;rem(r3)=1;
            baw=zeros(1,21600);baw(mt)=1;
            Spectr_L=spectr;
            
        else
            LD='D';
            
            fileName=[mouse,'_',day,'_',LD,'_',der,'_VSspec'];
            
            eval(['load ',pathin,fileName,'.mat ma spectr w nr r w1 nr2 r3 mt -mat']);
            %             W_L=w; NR_L=nr; R_L=r; W1_L=w1; NR2_L=nr2; R3_L=r3; MT_L=mt; Spectr_L=spectr;
%             wake=zeros(1,10800);wake(w)=1;wake(w1)=1;
            nrem(nr+10800)=1;nrem(nr2+10800)=1;
            rem(r+10800)=1;rem(r3+10800)=1;
            baw(mt+10800)=1;
            Spectr=vertcat(Spectr_L,spectr);spectr=Spectr;
        end
     end       
%             [SE_W,EpDur_W]=DetectEpisodes(wake,10800,mindur_W,ba);
            [SE_NR,EpDur_NR]=DetectEpisodes(nrem,21600,mindur_NR,ba);
            [SE_R,EpDur_R]=DetectEpisodes(rem,21600,mindur_R,ba_R);
          
            Selected_Eps=[];
            for i=1:length(EpDur_R)
                if sum(nrem(SE_R(i,1)-15:SE_R(i,1)-1))>mindur_NR-ba %I allow ba in the minute of NREM directly preceding the REM episode.
                   Selected_Eps=[Selected_Eps; SE_R(i,:)];
                end
            end
            % To record the spectra of selected episodes
             % Frequencies across rows; 1min (15ep) NREM + 1Min REM across columns;
            % multiple saved episodes across thrid dimention
            spectr=spectr; spectr(rem~=1,:)=NaN;
            
            Selec_Spec=zeros(81,30,length(Selected_Eps(:,1)));
            for j=1:length(Selected_Eps(:,1))
                Selec_Spec(:,:,j)=horzcat(spectr(Selected_Eps(j,1)-15:Selected_Eps(j,1)-1,:)',spectr(Selected_Eps(j,1):Selected_Eps(j,1)+14,:)');
            end 
            
            Average_Spec=nanmean(Selec_Spec,3);
            
            figure(2)
            subplot(n_HOM,1,n)
            surf(x_ticks,freq,Average_Spec)
            shading interp
            view(2)
            caxis([50 c_upper_limit]);
            title(['HOM-Transitions:',num2str(length(Selected_Eps(:,1)))]);
            ylabel('Frequency (Hz)');
            xlabel('Time (s) - 1min NR + 1min R');
            colorbar
            
            Average_Spec_HOM(:,:,n)=Average_Spec;
            
            


end

figure(3)

subplot(2,1,1)
surf(x_ticks,freq,mean(Average_Spec_WT,3))
shading interp
view(2)
caxis([50 c_upper_limit]);
title('All WT');
ylabel('Frequency (Hz)');
xlabel('Time (s) - 1min NR + 1min R');
% cb=colorbar();
% cb.Ruler.Scale='log';

subplot(2,1,2)
surf(x_ticks,freq,mean(Average_Spec_HOM,3))
shading interp
view(2)
caxis([50 c_upper_limit]);
title('All HOM');
ylabel('Frequency (Hz)');
xlabel('Time (s) - 1min NR + 1min R');
colorbar

figure()

subplot(2,1,1)
surf(x_ticks, freq,mean(Average_Spec_WT,3))
colormap bone%colormap(map)
colorbar
shading interp
view(2)
caxis([50 c_upper_limit]);
title('All WT');
ylabel('Frequency (Hz)');
xlabel('Time (s) - 1min NR + 1min R');

subplot(2,1,2)
surf(x_ticks,freq,mean(Average_Spec_HOM,3))
colormap bone%colormap(map)
colorbar
shading interp
view(2)
caxis([50 c_upper_limit]);
title('All Rlss');
ylabel('Frequency (Hz)');
xlabel('Time (s) - 1min NR + 1min R');