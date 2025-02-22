clear all
close all



pathinVS='/Volumes/Elements/Sleepy6EEG-March2018/outputVS/'; %path for VS files

%%%%% PARAMETERS to CHANGE %%%%%%%%%
mousename='Qu';
RECdate='200318_L';
load('pNE_Oc_Qu_Ph_200318_L.mat','pNe2_extract');
pNe_extract=pNe2_extract;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


filenameVS=[mousename,'_',RECdate,'_fro','_VSspec'];
load([pathinVS,filenameVS,'.mat'],'-mat','nr','spectr');
% 

%Plotting pNe signal from all 16 channels
% for chan=1:16
%     figure(chan)
%     %subplot(4,4,chan)
%     
%     plot(pNe_extract.data(chan,:))
%     ylim([-500 500])
%     title([mousename,' ',RECdate])
%     
% end



% Looking more specifically at epochs of NREM or epochs of high SWA
fs=pNe_extract.fs;

NR_eps=zeros(1,length(pNe_extract.data));
high_swa_eps=zeros(1,length(pNe_extract.data));

swa=mean(spectr(:,3:17),2);

swa_threshold=median(swa)+std(swa);
high_swa=find(swa>swa_threshold);

save(['SWA_threshold_',mousename,RECdate,'.mat'],'swa_threshold');

for i=1:length(nr)
    NR_eps(round((nr(i)-1)*fs*4+1):round(nr(i)*4*fs))=1;
end

for i=1:length(high_swa)
    high_swa_eps(round((high_swa(i)-1)*fs*4+1):round(high_swa(i)*4*fs))=1;
end

sig_NR=pNe_extract.data(:,NR_eps(1:length(pNe_extract.data))==1);
sig_high_SWA=pNe_extract.data(:,high_swa_eps(1:length(pNe_extract.data))==1);

sig_highSWA_NR=pNe_extract.data(:,NR_eps(1:length(pNe_extract.data))+high_swa_eps(1:length(pNe_extract.data))==2);
% %To check: 
% sig_NR_index=find(NR_eps(1:length(pNe_extract.data)));
% sig_SWA_index=find(high_swa_eps(1:length(pNe_extract.data)));
% sig_SWA_NR_index=find(NR_eps(1:length(pNe_extract.data))+high_swa_eps(1:length(pNe_extract.data))==2);

for chan=2:5
    for av=10
              
        averagetotsig_NR=movmean(abs(sig_NR(chan,:)),av); %smooth total signal
        averagetotsig_swa=movmean(abs(sig_high_SWA(chan,:)),av);
        averagetotsig_NR_swa=movmean(abs(sig_highSWA_NR(chan,:)),av);
        
        figure(3+chan)
        %subplot(1,4,av)
        h=histc(averagetotsig_NR,[0:1:150]);
        bar(h);
        xlabel('Spike Amplitude [uV]')
        sgtitle(['NR method - Channel ',num2str(chan)])
        %     set(gca, 'XTick', [0:5:30]);
        %     xticklabels({[0:25:150]});
        
        
        figure(10+chan)
        %subplot(1,4,av)
        h=histc(averagetotsig_swa,[0:1:150]);
        bar(h);
        xlabel('Spike Amplitude [uV]')
        sgtitle(['SWA above median method - Channel ',num2str(chan)])
        %     set(gca, 'XTick', [0:5:30]);
        %     xticklabels({[0:25:150]});
        
        figure(20+chan)
        %subplot(1,4,av)
        h=histc(averagetotsig_NR_swa,[0:1:150]);
        bar(h);
        xlabel('Spike Amplitude [uV]')
        sgtitle(['NR SWA above median method - Channel ',num2str(chan)])
        %     set(gca, 'XTick', [0:5:30]);
        %     xticklabels({[0:25:150]});
             

        %%%%% Plotting after finding the peaks fo those signals %%%%%%
        
        peaks_NR=findpeaks(averagetotsig_NR);
        peaks_swa=findpeaks(averagetotsig_swa);
        peaks_NR_swa=findpeaks(averagetotsig_NR_swa);
        
        figure(30+chan)
        %subplot(1,4,av)
        h=histc(peaks_NR,[0:1:150]);
        bar(h);
        xlabel('Spike Amplitude [uV]')
        sgtitle(['NR findpeaks method - Channel ',num2str(chan)])
        %     set(gca, 'XTick', [0:5:30]);
        %     xticklabels({[0:25:150]});
        
        
        figure(40+chan)
        %subplot(1,4,av)
        h=histc(peaks_swa,[0:1:150]);
        bar(h);
        xlabel('Spike Amplitude [uV]')
        sgtitle(['SWA above med Find peaks method - Channel ',num2str(chan)])
        %     set(gca, 'XTick', [0:5:30]);
        %     xticklabels({[0:25:150]});
        
        figure(50+chan)
        %subplot(1,4,av)
        h=histc(peaks_NR_swa,[0:1:150]);
        bar(h);
        xlabel('Spike Amplitude [uV]')
        sgtitle(['NR SWA above med Find peaks method - Channel ',num2str(chan)])
        %     set(gca, 'XTick', [0:5:30]);
        %     xticklabels({[0:25:150]});
             
    end
end
