clear all
close all

addpath(genpath('/Users/mguillaumin/Documents/Post-doc Zurich/Sleepy6_OFFperiods/TDTMatlabSDK'));
%pathDATA='/Volumes/Elements/Sleepy6EEG-March2018/March2018/Me_Ne_210318_L';
pathDATA='/Volumes/MyPasseport/Sleepy6EEG-November2017/November2017/Ed_Fe_101117_L';


data=TDTbin2mat(pathDATA,'STORE','LFP1','T1',0,'T2',43100);
LFP1_extract=data.streams.LFP1;

% data=TDTbin2mat(pathDATA,'STORE','LFP2','T1',0,'T2',43100);
% LFP2_extract=data.streams.LFP2;

data=TDTbin2mat(pathDATA,'STORE','LFP3','T1',0,'T2',43100);
LFP3_extract=data.streams.LFP3;

for i=[1 3]%1:3
    for chan=1:16
        figure(i)
        subplot(4,4,chan)
        if i==1
            plot(LFP1_extract.data(chan,:))
            %ylim([-500 500])
        elseif i==2
            plot(LFP2_extract.data(chan,:))
            %ylim([-500 500])
        elseif i==3
            plot(LFP3_extract.data(chan,:))
            %ylim([-500 500])
        end
    end
end

save('LFPraw_Ed_Fe_101117_L.mat','LFP1_extract','LFP3_extract');%,'LFP2_extract');


