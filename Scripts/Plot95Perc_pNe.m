
close all
clear all

 Filenames={'pNe_data_Ju_161117_L_Channels1to16.mat','pNe_data_Ju_161117_D_Channels1to16.mat','pNe_data_Ju_171117_L_Channels1to16.mat','pNe_data_Ju_171117_D_Channels1to16.mat'};
 
 Animal_name='Ju';
 num_ch=16;
 Valid_Channels=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
 
 
 %%%%%%
 All_Means_4_phases=[];

 
for file=1:4
     
   
    load(Filenames{file});
    
    
    Bin_length=10; % i.e. 10min
    
    Bin_width=floor(Bin_length*60*fs);
    
    N_bins=floor(length(Ch1)/Bin_width);
    
    All_Means_Top_values=zeros(num_ch,N_bins);
    
    
    
    figure()
    
    for ch=Valid_Channels
        
        ChX=eval(['Ch',num2str(ch)]);
        
        for i=1:N_bins
            
            Block=ChX((i-1)*Bin_width+1:i*Bin_width);
            Indexes_top_values=find(abs(Block)>prctile(Block,95));
            Mean_top_value=mean(abs(Block(Indexes_top_values)));
            All_Means_Top_values(ch,i)=Mean_top_value;
            
            
        end
        
        subplot(num_ch,1,ch)
        plot(All_Means_Top_values(ch,:))
        ylim([0 200])
        
    end
    
    All_Means_4_phases=[All_Means_4_phases All_Means_Top_values];
    
    
end

figure()
for ch=1:num_ch

    subplot(num_ch,1,ch)
    plot(All_Means_4_phases(ch,:));
    ylim([0 150])
    
    for phase=1:4
        hold on
        plot([N_bins*phase N_bins*phase], [0 150]);
    end
    
end
sgtitle(Animal_name);

figure()
for ch=1:num_ch

    subplot(num_ch,1,ch)
    plot(All_Means_4_phases(ch,:));
    %ylim([0 150])
    
    for phase=1:4
        hold on
        plot([N_bins*phase N_bins*phase], [0 150]);
    end
    
end

sgtitle(Animal_name);

figure()
for ch=1:num_ch

    plot(All_Means_4_phases(ch,:));
    hold on
    %ylim([0 150])
   
    
end

for phase=1:4
        hold on
        plot([N_bins*phase N_bins*phase], [0 150]);
end
sgtitle(Animal_name);