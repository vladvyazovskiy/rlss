clear all
close all

addpath(genpath('/Users/mguillaumin/Documents/Post-doc Zurich/Sleepy6_OFFperiods/TDTMatlabSDK'));
%pathDATA='/Volumes/Elements/Sleepy6EEG-March2018/March2018/Me_Ne_200318_D';
pathDATA='/Volumes/MyPasseport/Sleepy6EEG-November2017/November2017/Ed_Fe_101117_L';

data=TDTbin2mat(pathDATA,'STORE','pNe1','T1',0,'T2',43100);
pNe1_extract=data.streams.pNe1;

% data=TDTbin2mat(pathDATA,'STORE','pNe2','T1',0,'T2',43100);
% pNe2_extract=data.streams.pNe2;

data=TDTbin2mat(pathDATA,'STORE','pNe3','T1',0,'T2',43100);
pNe3_extract=data.streams.pNe3;

for i=[1 3] %1:3
    for chan=1:16
        figure(i)
        subplot(4,4,chan)
        if i==1
            plot(pNe1_extract.data(chan,:))
            ylim([-500 500])
        elseif i==2
            plot(pNe2_extract.data(chan,:))
            ylim([-500 500])
        elseif i==3
            plot(pNe3_extract.data(chan,:))
            ylim([-500 500])
        end
    end
end

save('pNE_Ed_Fe_101117_L.mat','pNe1_extract','pNe3_extract');%'pNe2_extract'

