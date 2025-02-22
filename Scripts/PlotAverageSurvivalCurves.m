%%% Plot survival curves after averaging within animals (across their
%%% respective channels) and across animals (within a given genotype).
clear all
close all
%%%%%%

WT_names=['Ed';'Fe';'He';'Le';'Qu'];
Rstl_names=['Ju';'Me';'Ne';'Oc';'Ph'];
Included_WT=[1 2 3 4 5];
Included_Rstl=[1 2 3 4 5];

xq=0:1:1000; % Query points for the interpolation, so as to be able to average across channels and animals.

Average_Curve_All_BL_NR_WT=NaN(5,length(xq));
Average_Curve_All_BL_R_WT=NaN(5,length(xq));
Average_Curve_All_SD_NR_WT=NaN(5,length(xq));
Average_Curve_All_SD_R_WT=NaN(5,length(xq));

Average_Curve_All_BL_NR_Rstl=NaN(5,length(xq));
Average_Curve_All_BL_R_Rstl=NaN(5,length(xq));
Average_Curve_All_SD_NR_Rstl=NaN(5,length(xq));
Average_Curve_All_SD_R_Rstl=NaN(5,length(xq));

Half_life_All_BL_NR_WT=cell(5,1);
Half_life_All_BL_R_WT=cell(5,1);
Half_life_All_SD_NR_WT=cell(5,1);
Half_life_All_SD_R_WT=cell(5,1);

Half_life_All_BL_NR_Rstl=cell(5,1);
Half_life_All_BL_R_Rstl=cell(5,1);
Half_life_All_SD_NR_Rstl=cell(5,1);
Half_life_All_SD_R_Rstl=cell(5,1);

%% WT animals

for an_WT=Included_WT
    
    Filename=['OP_durations_',WT_names(an_WT,:),'_Hours 6-8.mat'];
    load(Filename);
    
    num_ch=length(OP_durations_all_BL_NR);
    % 1-ecdf(OP_durations_NR)
    f_BL_NR=cell(1,num_ch);x_BL_NR=cell(1,num_ch);finterp_BL_NR=NaN(num_ch,length(xq));
    f_BL_R=cell(1,num_ch);x_BL_R=cell(1,num_ch);finterp_BL_R=NaN(num_ch,length(xq));
    f_SD_NR=cell(1,num_ch);x_SD_NR=cell(1,num_ch);finterp_SD_NR=NaN(num_ch,length(xq));
    f_SD_R=cell(1,num_ch);x_SD_R=cell(1,num_ch);finterp_SD_R=NaN(num_ch,length(xq));
    Half_lives_BL_NR=NaN(1,num_ch);Half_lives_BL_R=NaN(1,num_ch);Half_lives_SD_NR=NaN(1,num_ch);Half_lives_SD_R=NaN(1,num_ch);
    %% BL NR
    for ch=1:num_ch
        [f_BL_NR{1,ch}, x_BL_NR{1,ch}] = ecdf(OP_durations_all_BL_NR{1,ch});
        [x, index]=unique(x_BL_NR{1,ch});
        y=f_BL_NR{1,ch};
        finterp_BL_NR(ch,:) = interp1(x,y(index),xq);
        [M, Half_lives_BL_NR(1,ch)]=min(abs(0.5-finterp_BL_NR(ch,:)));%xq(given_index)=given_index-1 so recording the index where the min occurs will be here considered equivalent to recording the abscissa of the half-life.
    end
        
    
    
    %% BL R
    for ch=1:num_ch
        [f_BL_R{1,ch}, x_BL_R{1,ch}] = ecdf(OP_durations_all_BL_R{1,ch});
        [x, index]=unique(x_BL_R{1,ch});
        y=f_BL_R{1,ch};
        finterp_BL_R(ch,:) = interp1(x,y(index),xq);
        [M, Half_lives_BL_R(1,ch)]=min(abs(0.5-finterp_BL_R(ch,:)));
    end
    
    %% SD NR
    if an_WT ~= 4
        for ch=1:num_ch
            [f_SD_NR{1,ch}, x_SD_NR{1,ch}] = ecdf(OP_durations_all_SD_NR{1,ch});
            [x, index]=unique(x_SD_NR{1,ch});
            y=f_SD_NR{1,ch};
            finterp_SD_NR(ch,:) = interp1(x,y(index),xq);
            [M, Half_lives_SD_NR(1,ch)]=min(abs(0.5-finterp_SD_NR(ch,:)));
        end
        
        %% SD R
        for ch=1:num_ch
            [f_SD_R{1,ch}, x_SD_R{1,ch}] = ecdf(OP_durations_all_SD_R{1,ch});
            [x, index]=unique(x_SD_R{1,ch});
            y=f_SD_R{1,ch};
            finterp_SD_R(ch,:) = interp1(x,y(index),xq);
            [M, Half_lives_SD_R(1,ch)]=min(abs(0.5-finterp_SD_R(ch,:)));
        end
    end
    
    Average_Curve_All_BL_NR_WT(an_WT,:)=mean(finterp_BL_NR,'omitnan');
    Average_Curve_All_BL_R_WT(an_WT,:)=mean(finterp_BL_R,'omitnan');
    Average_Curve_All_SD_NR_WT(an_WT,:)=mean(finterp_SD_NR,'omitnan');
    Average_Curve_All_SD_R_WT(an_WT,:)=mean(finterp_SD_R,'omitnan');
    
    Half_life_All_BL_NR_WT{an_WT,1}=Half_lives_BL_NR;
    Half_life_All_BL_R_WT{an_WT,1}=Half_lives_BL_R;
    Half_life_All_SD_NR_WT{an_WT,1}=Half_lives_SD_NR;
    Half_life_All_SD_R_WT{an_WT,1}=Half_lives_SD_R;
end

%% Rstl animals

for an_Rstl=Included_Rstl
    
    Filename=['OP_durations_',Rstl_names(an_Rstl,:),'_Hours 6-8.mat'];
    load(Filename);
    
    num_ch=length(OP_durations_all_BL_NR);
    % 1-ecdf(OP_durations_NR)
    f_BL_NR=cell(1,num_ch);x_BL_NR=cell(1,num_ch);finterp_BL_NR=NaN(num_ch,length(xq));
    f_BL_R=cell(1,num_ch);x_BL_R=cell(1,num_ch);finterp_BL_R=NaN(num_ch,length(xq));
    f_SD_NR=cell(1,num_ch);x_SD_NR=cell(1,num_ch);finterp_SD_NR=NaN(num_ch,length(xq));
    f_SD_R=cell(1,num_ch);x_SD_R=cell(1,num_ch);finterp_SD_R=NaN(num_ch,length(xq));
    Half_lives_BL_NR=NaN(1,num_ch);Half_lives_BL_R=NaN(1,num_ch);Half_lives_SD_NR=NaN(1,num_ch);Half_lives_SD_R=NaN(1,num_ch);
    
    %% BL NR
    for ch=1:num_ch
        [f_BL_NR{1,ch}, x_BL_NR{1,ch}] = ecdf(OP_durations_all_BL_NR{1,ch});
        [x, index]=unique(x_BL_NR{1,ch});
        y=f_BL_NR{1,ch};
        finterp_BL_NR(ch,:) = interp1(x,y(index),xq);
        [M, Half_lives_BL_NR(1,ch)]=min(abs(0.5-finterp_BL_NR(ch,:)));
    end
    
    %% BL R
    if an_Rstl ~= 2
        for ch=1:num_ch
            [f_BL_R{1,ch}, x_BL_R{1,ch}] = ecdf(OP_durations_all_BL_R{1,ch});
            [x, index]=unique(x_BL_R{1,ch});
            y=f_BL_R{1,ch};
            finterp_BL_R(ch,:) = interp1(x,y(index),xq);
            [M, Half_lives_BL_R(1,ch)]=min(abs(0.5-finterp_BL_R(ch,:)));
        end
    end
    
    %% SD NR
    for ch=1:num_ch
        [f_SD_NR{1,ch}, x_SD_NR{1,ch}] = ecdf(OP_durations_all_SD_NR{1,ch});
        [x, index]=unique(x_SD_NR{1,ch});
        y=f_SD_NR{1,ch};
        finterp_SD_NR(ch,:) = interp1(x,y(index),xq);
        [M, Half_lives_SD_NR(1,ch)]=min(abs(0.5-finterp_SD_NR(ch,:)));
    end
    
    %% SD R
    for ch=1:num_ch
        [f_SD_R{1,ch}, x_SD_R{1,ch}] = ecdf(OP_durations_all_SD_R{1,ch});
        [x, index]=unique(x_SD_R{1,ch});
        y=f_SD_R{1,ch};
        finterp_SD_R(ch,:) = interp1(x,y(index),xq);
        [M, Half_lives_SD_R(1,ch)]=min(abs(0.5-finterp_SD_R(ch,:)));
    end
    
    Average_Curve_All_BL_NR_Rstl(an_Rstl,:)=mean(finterp_BL_NR,'omitnan');
    Average_Curve_All_BL_R_Rstl(an_Rstl,:)=mean(finterp_BL_R,'omitnan');
    Average_Curve_All_SD_NR_Rstl(an_Rstl,:)=mean(finterp_SD_NR,'omitnan');
    Average_Curve_All_SD_R_Rstl(an_Rstl,:)=mean(finterp_SD_R,'omitnan');
    
    Half_life_All_BL_NR_Rstl{an_Rstl,1}=Half_lives_BL_NR;
    Half_life_All_BL_R_Rstl{an_Rstl,1}=Half_lives_BL_R;
    Half_life_All_SD_NR_Rstl{an_Rstl,1}=Half_lives_SD_NR;
    Half_life_All_SD_R_Rstl{an_Rstl,1}=Half_lives_SD_R;
end

%% WT vs Rstl 
figure(1)
subplot(2,2,1)
plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan'),'Color',[0.1 0.2 0.9],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan'),'Color',[0.9 0.2 0.1],'LineWidth',1.5)
legend('WT', 'Rstl')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan')+std(Average_Curve_All_BL_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan')-std(Average_Curve_All_BL_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan')+std(Average_Curve_All_BL_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan')-std(Average_Curve_All_BL_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('NR off-periods - BL day')
xlim([0 1000])
set(gca, 'YScale', 'log')

subplot(2,2,2)
plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan'),'Color',[0.1 0.2 0.9],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan'),'Color',[0.9 0.2 0.1],'LineWidth',1.5)
legend('WT', 'Rstl')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan')+std(Average_Curve_All_SD_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan')-std(Average_Curve_All_SD_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan')+std(Average_Curve_All_SD_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan')-std(Average_Curve_All_SD_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('NR off-periods - SD day')
set(gca, 'YScale', 'log')

subplot(2,2,3)
plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan'),'Color',[0.1 0.2 0.9],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan'),'Color',[0.9 0.2 0.1],'LineWidth',1.5)
legend('WT', 'Rstl')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan')+std(Average_Curve_All_BL_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan')-std(Average_Curve_All_BL_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan')+std(Average_Curve_All_BL_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan')-std(Average_Curve_All_BL_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('REM off-periods - BL day')
set(gca, 'YScale', 'log')

subplot(2,2,4)
plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan'),'Color',[0.1 0.2 0.9],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan'),'Color',[0.9 0.2 0.1],'LineWidth',1.5)
legend('WT', 'Rstl')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan')+std(Average_Curve_All_SD_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan')-std(Average_Curve_All_SD_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.1 0.2 0.9],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan')+std(Average_Curve_All_SD_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan')-std(Average_Curve_All_SD_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.9 0.2 0.1],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('REM off-periods - SD day')
set(gca, 'YScale', 'log')


sgtitle('WT vs. Rstl')


%% BL vs. SD

figure(2)
subplot(2,2,1)
plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('BL', 'SD')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan')+std(Average_Curve_All_BL_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan')-std(Average_Curve_All_BL_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan')+std(Average_Curve_All_SD_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan')-std(Average_Curve_All_SD_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('NR off-periods - WT')
set(gca, 'YScale', 'log')

subplot(2,2,2)
plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('BL', 'SD')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan')+std(Average_Curve_All_BL_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan')-std(Average_Curve_All_BL_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan')+std(Average_Curve_All_SD_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan')-std(Average_Curve_All_SD_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('R off-periods - WT')
set(gca, 'YScale', 'log')

subplot(2,2,3)
plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('BL', 'SD')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan')+std(Average_Curve_All_BL_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan')-std(Average_Curve_All_BL_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan')+std(Average_Curve_All_SD_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan')-std(Average_Curve_All_SD_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('NR off-periods - Rstl')
set(gca, 'YScale', 'log')

subplot(2,2,4)
plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('BL', 'SD')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan')+std(Average_Curve_All_BL_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan')-std(Average_Curve_All_BL_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan')+std(Average_Curve_All_SD_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan')-std(Average_Curve_All_SD_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('R off-periods - Rstl')
set(gca, 'YScale', 'log')


sgtitle('BL vs. SD')


%% NR vs. R

figure(3)
subplot(2,2,1)
plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('NR', 'R')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan')+std(Average_Curve_All_BL_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_NR_WT,'omitnan')-std(Average_Curve_All_BL_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan')+std(Average_Curve_All_BL_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_BL_R_WT,'omitnan')-std(Average_Curve_All_BL_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('BL off-periods - WT')
set(gca, 'YScale', 'log')

subplot(2,2,2)
plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('NR', 'R')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan')+std(Average_Curve_All_SD_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_SD_NR_WT,'omitnan')-std(Average_Curve_All_SD_NR_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan')+std(Average_Curve_All_SD_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_R_WT,'omitnan')-std(Average_Curve_All_SD_R_WT,'omitnan')/sqrt(length(Included_WT)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('SD off-periods - WT')
set(gca, 'YScale', 'log')

subplot(2,2,3)
plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('NR', 'R')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan')+std(Average_Curve_All_BL_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_BL_NR_Rstl,'omitnan')-std(Average_Curve_All_BL_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan')+std(Average_Curve_All_BL_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_BL_R_Rstl,'omitnan')-std(Average_Curve_All_BL_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('BL off-periods - Rstl')
set(gca, 'YScale', 'log')

subplot(2,2,4)
plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan'),'Color',[0.5 0.5 0.5],'LineWidth',1.5)
hold on
plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan'),'Color',[0.6 0.2 0.6],'LineWidth',1.5)
legend('NR', 'R')
% hold on
% h1=plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan')+std(Average_Curve_All_SD_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h2=plot(xq,1-mean(Average_Curve_All_SD_NR_Rstl,'omitnan')-std(Average_Curve_All_SD_NR_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.5 0.5 0.5],'MarkerSize',0.2);
% h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h3=plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan')+std(Average_Curve_All_SD_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
% hold on
% h4=plot(xq,1-mean(Average_Curve_All_SD_R_Rstl,'omitnan')-std(Average_Curve_All_SD_R_Rstl,'omitnan')/sqrt(length(Included_Rstl)),'.','Color',[0.6 0.2 0.6],'MarkerSize',0.2);
% h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
title('SD off-periods - Rstl')
set(gca, 'YScale', 'log')


sgtitle('NR vs. R')

%%Half-life figures

%% WT vs. Rstl
figure(4)
subplot(2,2,1)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_NR_WT{i,1})),Half_life_All_BL_NR_WT{i,1},[],[0.1 0.2 1-0.1*i]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_BL_NR_Rstl{j,1})),Half_life_All_BL_NR_Rstl{j,1},[],[1-0.1*j 0.2 0.1]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'WT','Rstl'})
title('NR off-periods - BL day')

subplot(2,2,2)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_SD_NR_WT{i,1})),Half_life_All_SD_NR_WT{i,1},[],[0.1 0.2 1-0.1*i]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_NR_Rstl{j,1})),Half_life_All_SD_NR_Rstl{j,1},[],[1-0.1*j 0.2 0.1]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'WT','Rstl'})
title('NR off-periods - SD day')

subplot(2,2,3)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_R_WT{i,1})),Half_life_All_BL_R_WT{i,1},[],[0.1 0.2 1-0.1*i]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_BL_R_Rstl{j,1})),Half_life_All_BL_R_Rstl{j,1},[],[1-0.1*j 0.2 0.1]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'WT','Rstl'})
title('REM off-periods - BL day')

subplot(2,2,4)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_SD_R_WT{i,1})),Half_life_All_SD_R_WT{i,1},[],[0.1 0.2 1-0.1*i]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_R_Rstl{j,1})),Half_life_All_SD_R_Rstl{j,1},[],[1-0.1*j 0.2 0.1]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'WT','Rstl'})
title('REM off-periods - SD day')

sgtitle('WT vs. Rstl')

%% BL vs. SD
figure(5)
subplot(2,2,1)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_NR_WT{i,1})),Half_life_All_BL_NR_WT{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_WT)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_NR_WT{j,1})),Half_life_All_SD_NR_WT{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'BL','SD'})
title('NR off-periods - WT')

subplot(2,2,2)
for i=1:length(Included_Rstl)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_R_WT{i,1})),Half_life_All_BL_R_WT{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_R_WT{j,1})),Half_life_All_SD_R_WT{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'BL','SD'})
title('REM off-periods - WT')

subplot(2,2,3)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_NR_Rstl{i,1})),Half_life_All_BL_NR_Rstl{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_WT)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_NR_Rstl{j,1})),Half_life_All_SD_NR_Rstl{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'BL','SD'})
title('NR off-periods - Rstl')

subplot(2,2,4)
for i=1:length(Included_Rstl)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_R_Rstl{i,1})),Half_life_All_BL_R_Rstl{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_R_Rstl{j,1})),Half_life_All_SD_R_Rstl{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'BL','SD'})
title('REM off-periods - Rstl')

sgtitle('BL vs. SD')


%% NR vs. R
figure(6)
subplot(2,2,1)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_NR_WT{i,1})),Half_life_All_BL_NR_WT{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_WT)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_BL_R_WT{j,1})),Half_life_All_BL_R_WT{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'NR','R'})
title('BL off-periods - WT')

subplot(2,2,2)
for i=1:length(Included_Rstl)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_SD_NR_WT{i,1})),Half_life_All_SD_NR_WT{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_R_WT{j,1})),Half_life_All_SD_R_WT{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'NR','R'})
title('SD off-periods - WT')

subplot(2,2,3)
for i=1:length(Included_WT)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_BL_NR_Rstl{i,1})),Half_life_All_BL_NR_Rstl{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_WT)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_BL_R_Rstl{j,1})),Half_life_All_BL_R_Rstl{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'NR','R'})
title('BL off-periods - Rstl')

subplot(2,2,4)
for i=1:length(Included_Rstl)
    scatter(0.7+0.1*i*ones(1,length(Half_life_All_SD_NR_Rstl{i,1})),Half_life_All_SD_NR_Rstl{i,1},[],[0.5 0.5 0.5]);
    hold on
end
for j=1:length(Included_Rstl)
    scatter(1.7+0.1*j*ones(1,length(Half_life_All_SD_R_Rstl{j,1})),Half_life_All_SD_R_Rstl{j,1},[],[0.6 0.2 0.6]);
    hold on
end
xlim([0 3])
ylim([0 100])
xticks([1 2])
xticklabels({'NR','R'})
title('SD off-periods - Rstl')

sgtitle('NR vs. R')