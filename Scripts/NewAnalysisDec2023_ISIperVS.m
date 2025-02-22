%%% New plots OFF period data


clear all
close all

WT={'Ed';'Fe';'He';'Le';'Qu'};
Rstl={'Ju';'Me';'Ne';'Oc';'Ph'};

Phases_BL_L_WT={'091117L';'091117L';'161117L';'161117L';'200318L'};
Phases_BL_D_WT={'091117D';'091117D';'161117D';'161117D';'200318D'};
Phases_SD_L_WT={'101117L';'101117L';'171117L';'171117L';'210318L'};
Phases_SD_D_WT={'101117D';'101117D';'171117D';'171117D';'210318D'};
Phases_WT=[Phases_BL_L_WT Phases_BL_D_WT Phases_SD_L_WT Phases_SD_D_WT];

Phases_BL_L_Rstl={'161117L';'200318L';'200318L';'200318L';'200318L'};
Phases_BL_D_Rstl={'161117D';'200318D';'200318D';'200318D';'200318D'};
Phases_SD_L_Rstl={'171117L';'210318L';'210318L';'210318L';'210318L'};
Phases_SD_D_Rstl={'171117D';'210318D';'210318D';'210318D';'210318D'};
Phases_Rstl=[Phases_BL_L_Rstl Phases_BL_D_Rstl Phases_SD_L_Rstl Phases_SD_D_Rstl];

% Filename_In='Qu_200318_L_BasicCluster.mat';
% load(Filename_In);
All_ISIs_WT=cell(5,4);
All_ISIs_Rstl=cell(5,4);



%Plot as a bar graph the number of spikes per channel for each animal

path='/Volumes/Elements/Sleepy6EEG-March2018/SpikeScripts/OutputSpikesWaveForms/';
% An=strvcat('Fe','He','Ju','Le','Me','Ne','Oc','Qu','Ph');
% BL_days=strvcat('091117','161117','161117','161117','200318','200318','200318','200318','200318');
% NumCh=zeros(9,16);
% 
% for i=1:9
%     for ch=1:16
%         mousename=An(i,:);
%         recorddate=BL_days(i,:);
%         fname=[mousename,'-',recorddate,'_L-ch',num2str(ch),'-Spikes_TimeStamps'];
%         eval(['load ',path,fname,'.mat TimeStamps -mat']);
%         NumCh(i,ch)=length(TimeStamps);
%     end
%     figure(2)
%     subplot(3,3,i)
%     barh(NumCh(i,:));
%     title(mousename);
%     xlabel('# of spikes');
%     ylabel('Channel number');
%     xlim([0 2.5*10^6]);
%     set(gca, 'YDir','reverse')
% end


for genotype=1:2 % 1=WT, 2=Rstl
    for anm=1:5
        
        if genotype==1 && anm==1 % Ed out
        else
            
            if genotype==1 && anm==4 %Le only has a recording for BL L
                phase_scope=1;
            else
                phase_scope=1:4;
            end
            
            for phase=1%I only want to BL L values here. phase_scope % BL L, BL D , SD L, SD D.
                if genotype==1
                    Names=WT;phase_name=Phases_WT{anm,phase};
                else
                    Names=Rstl;phase_name=Phases_Rstl{anm,phase};
                end
                name=Names{anm};
                if phase==1
                    end_name='Newclustering';
                else
                    end_name='Newclustering_wPresets';
                end
                
                filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',name,'_',phase_name,'_',end_name,'.mat'];
                load(filename);
                
                VS_filename=['/Users/mguillaumin/Documents/Post-doc Zurich/Rstl Paper 2/Sleepy6_OFFperiods/',name,'_',phase_name(1:6),'_',phase_name(7),'_fro_VSspec.mat'];
                load(VS_filename);
                
                bins=0:5:1000;
                
                Temp_ISIs_allVS=nan(16,length(bins));
                Temp_ISIs_NR=nan(16,length(bins));
                Temp_ISIs_R=nan(16,length(bins));
                Temp_ISIs_W=nan(16,length(bins));
                
                for ch=OFFDATA.Channels'
                    
                    fname=[name,'-',phase_name(1:end-1),'_L-ch',num2str(ch),'-Spikes_TimeStamps'];
                    eval(['load ',path,fname,'.mat TimeStamps -mat']);
                    Timestamps_epochs=ceil(TimeStamps/4); Timestamps_epochs=Timestamps_epochs(1:end-1); %removing last entry to match length of ISIs below
                    TS_nr=ismember(Timestamps_epochs,nr);
                    TS_r=ismember(Timestamps_epochs,r);
                    TS_w=ismember(Timestamps_epochs,w);
                    ISIs=diff(TimeStamps);

                    Temp_ISIs_allVS(ch,:)=hist(1000*ISIs,bins);% Converting to ms
                    Temp_ISIs_NR(ch,:)=hist(1000*ISIs(TS_nr),bins);% Converting to ms
                    Temp_ISIs_R(ch,:)=hist(1000*ISIs(TS_r),bins);% Converting to ms
                    Temp_ISIs_W(ch,:)=hist(1000*ISIs(TS_w),bins);% Converting to ms
                    Temp_ISIs_Values=cat(3,cat(3,Temp_ISIs_NR,Temp_ISIs_R), Temp_ISIs_W);
                    
                    
                end
                
                
                if genotype==1
                    All_ISIs_WT{anm,phase}=Temp_ISIs_Values;
                    
                elseif genotype==2
                    All_ISIs_Rstl{anm,phase}=Temp_ISIs_Values;
                    
                end
                
            end
        end
    end
end


%%%Plotting the histograms per genotype

VS_titles={'BL-light-NR','BL-light-R','BL-light-W'};
Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

%%%Plotting the survival curves per genotype - with error bars
for phase=1
    figure()
    for vs=1:3
        subplot(1,3,vs)
        
        
        
        temp_WT=cell2mat(All_ISIs_WT(:,phase));
        temp_WT(temp_WT==0)=NaN;
        
        temp_Rstl=cell2mat(All_ISIs_Rstl(:,phase));
        temp_Rstl(temp_Rstl==0)=NaN;
        
        h_ttests=nan(1,length(bins));
        for col=1:length(bins)
            h_ttests(col)=ttest2(temp_WT(:,col,vs),temp_Rstl(:,col,vs),'Vartype','unequal');
        end
        
        hold all
        
        shadedErrorBar(bins,mean(temp_WT(:,:,vs),'omitnan'),std(temp_WT(:,:,vs),[],'omitnan')/sqrt(4),'lineProps',{'Color',Colours(1,:),'LineWidth',3});
        hold on
        
        %plot(1,temp_WT(:,vs),'.k')
        %hold on
        shadedErrorBar(bins,mean(temp_Rstl(:,:,vs),'omitnan'),std(temp_Rstl(:,:,vs),[],'omitnan')/sqrt(5),'lineProps',{'Color',Colours(2,:),'LineWidth',3});
        hold on
        
        %plot(2,temp_Rstl(:,vs),'.k')
        %hold on
        
        plot(bins,h_ttests*10^5,'k','LineWidth',3)
        hold on
        %     if phase==1 || phase==3
        %         ylabel('% of OFF-periods')
        %     end
        %     if phase==3 || phase==4
        %         xlabel('OFF-period duration (ms)')
        %     end
        xlim([0 900])
        ylim([0 2*10^5])
        title([VS_titles{vs}])
        %xticks(1:2)
        %xticklabels({'WT','Rlss'})
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        ylabel('Average ISI (ms)')
        set(gca,'YScale', 'log')
        legend('WT','rlss','p<0.05?')
        legend('boxoff')
        xlabel('ISI (ms)')
        ylabel('Counts')
    end
end
