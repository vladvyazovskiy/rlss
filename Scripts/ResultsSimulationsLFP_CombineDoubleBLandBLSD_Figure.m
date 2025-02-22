% Double baseline results

Fe_fro=[0.00053 0.00009 406];


He_fro=[0.00034 0.00005 455];


Ju_fro=[0.00014 0.00002 449];


% Le_fro=[0.00033 0.00005 423];
% Le_occ=[0.00042 0.00010 323];

%%%%

Me_fro=[0.00034 0.00012 236];


Ne_fro=[0.00035 0.00013 233];


Oc_fro=[0.00037 0.00007 365];


Ph_fro=[0.00031 0.00006 351];

Qu_fro=[0.00026 0.00006 327];



% BL + SD results

Fe_fro_BLSD=[0.00053 0.00006 528];


He_fro_BLSD=[0.00022 0.00025 160];


Ju_fro_BLSD=[0.00013 0.00002 427];


% Le_fro=[0.00033 0.00005 423];
% Le_occ=[0.00042 0.00010 323];

%%%%

Me_fro_BLSD=[0.00030 0.00011 227];


Ne_fro_BLSD=[0.00035 0.00012 240];


Oc_fro_BLSD=[0.00023 0.00011 207];


Ph_fro_BLSD=[0.00030 0.00013 201];


Qu_fro_BLSD=[0.00041 0.00004 640];



%%%%% WT - Double baseline
gc_fro_WT=[Fe_fro(1) He_fro(1) Qu_fro(1) NaN NaN];

rs_fro_WT=[Fe_fro(2) He_fro(2) Qu_fro(2) NaN NaN];

Su_fro_WT=[Fe_fro(3) He_fro(3) Qu_fro(3) NaN NaN];


%%% HOM - Double baseline
gc_fro_HOM=[Ju_fro(1) Me_fro(1) Ne_fro(1) Oc_fro(1) Ph_fro(1)];

rs_fro_HOM=[Ju_fro(2) Me_fro(2) Ne_fro(2) Oc_fro(2) Ph_fro(2)];

Su_fro_HOM=[Ju_fro(3) Me_fro(3) Ne_fro(3) Oc_fro(3) Ph_fro(3)];


%%%%% WT - BL + SD
gc_fro_WT_BLSD=[Fe_fro_BLSD(1) He_fro_BLSD(1) Qu_fro_BLSD(1) NaN NaN];

rs_fro_WT_BLSD=[Fe_fro_BLSD(2) He_fro_BLSD(2) Qu_fro_BLSD(2) NaN NaN];

Su_fro_WT_BLSD=[Fe_fro_BLSD(3) He_fro_BLSD(3) Qu_fro_BLSD(3) NaN NaN];


%%% HOM - BL + SD
gc_fro_HOM_BLSD=[Ju_fro_BLSD(1) Me_fro_BLSD(1) Ne_fro_BLSD(1) Oc_fro_BLSD(1) Ph_fro_BLSD(1)];

rs_fro_HOM_BLSD=[Ju_fro_BLSD(2) Me_fro_BLSD(2) Ne_fro_BLSD(2) Oc_fro_BLSD(2) Ph_fro_BLSD(2)];

Su_fro_HOM_BLSD=[Ju_fro_BLSD(3) Me_fro_BLSD(3) Ne_fro_BLSD(3) Oc_fro_BLSD(3) Ph_fro_BLSD(3)];




figure(1)
subplot(1,3,1)
notBoxPlot([gc_fro_WT; gc_fro_HOM; gc_fro_WT_BLSD; gc_fro_HOM_BLSD]', [1 2 4 5]);
set(gca,'XTickLabel',{'WT','HOM'});
title('gc - LFP');

subplot(1,3,2)
notBoxPlot([rs_fro_WT; rs_fro_HOM; rs_fro_WT_BLSD; rs_fro_HOM_BLSD]', [1 2 4 5]);
set(gca,'XTickLabel',{'WT','HOM'});
title('rs - LFP');

subplot(1,3,3)
notBoxPlot([Su_fro_WT; Su_fro_HOM; Su_fro_WT_BLSD; Su_fro_HOM_BLSD]', [1 2 4 5]);
set(gca,'XTickLabel',{'WT','HOM'});
title('Su - LFP');



%%% Figures with better aesthetics

Colours=[0.40 0.40 0.60;... %WT
    0.68 0.85 0.90]; %Rlss
Colours=Colours-0.2;

%%% Frontal LFP
figure()
subplot(1,3,1)
errorbar([1 4],mean([gc_fro_WT; gc_fro_WT_BLSD]','omitnan'),std([gc_fro_WT; gc_fro_WT_BLSD]','omitnan')/sqrt(5),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot([1.1 4.1],[gc_fro_WT; gc_fro_WT_BLSD]','.k')
hold on
errorbar([2 5],mean([gc_fro_HOM; gc_fro_HOM_BLSD]','omitnan'),std([gc_fro_HOM; gc_fro_HOM_BLSD]','omitnan')/sqrt(5),'o','Color',Colours(2,:),'LineWidth',2)
hold on
plot([2.1 5.1],[gc_fro_HOM; gc_fro_HOM_BLSD]','.k')
title('gc -LFP');
xlim([0 6])
xticks([1 2 4 5])
xticklabels({'WT','Rlss','WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';

subplot(1,3,2)
errorbar([1 4],mean([rs_fro_WT; rs_fro_WT_BLSD]','omitnan'),std([rs_fro_WT; rs_fro_WT_BLSD]','omitnan')/sqrt(5),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot([1.1 4.1],[rs_fro_WT; rs_fro_WT_BLSD]','.k')
hold on
errorbar([2 5],mean([rs_fro_HOM; rs_fro_HOM_BLSD]','omitnan'),std([rs_fro_HOM; rs_fro_HOM_BLSD]','omitnan')/sqrt(5),'o','Color',Colours(2,:),'LineWidth',2)
hold on
plot([2.1 5.1],[rs_fro_HOM; rs_fro_HOM_BLSD]','.k')
title('rs -LFP');
xlim([0 6])
xticks([1 2 4 5])
xticklabels({'WT','Rlss','WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';

subplot(1,3,3)
errorbar([1 4],mean([Su_fro_WT; Su_fro_WT_BLSD]','omitnan'),std([Su_fro_WT; Su_fro_WT_BLSD]','omitnan')/sqrt(5),'o','Color',Colours(1,:),'LineWidth',2)
hold on
plot([1.1 4.1],[Su_fro_WT; Su_fro_WT_BLSD]','.k')
hold on
errorbar([2 5],mean([Su_fro_HOM; Su_fro_HOM_BLSD]','omitnan'),std([Su_fro_HOM; Su_fro_HOM_BLSD]','omitnan')/sqrt(5),'o','Color',Colours(2,:),'LineWidth',2)
hold on
plot([2.1 5.1],[Su_fro_HOM; Su_fro_HOM_BLSD]','.k')
title('Su -LFP');
xlim([0 6])
xticks([1 2 4 5])
xticklabels({'WT','Rlss','WT','Rlss'})
box off
ax=gca;
ax.LineWidth=1.5;
ax.TickDir = 'out';
