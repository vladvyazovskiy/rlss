clear all
close all
path=['H:\SLEEPY6\'];

pathVS=[path,'OutputVS\'];
pathRast=[path,'OutputRasters\'];
pathOFF=[path,'OutputOFF\'];mkdir(pathOFF)
%pathLFP=[path,'OutputSignals\']; mkdir(pathOFF)

mousenames1=strvcat('Ed','Fe','He','Le','Qu');
dateBL1=['091117';'091117';'161117';'161117';'200318'];
dateSD1=['101117';'101117';'171117';'171117';'210318'];

mousenames2=strvcat('Ju','Me','Ne','Oc','Ph');
dateBL2=['161117';'200318';'200318';'200318';'200318'];
dateSD2=['171117';'210318';'210318';'210318';'210318'];

der='fro';

chans=[1:16];

LD='LD'
ld=1;
epochl=4;
steps=0:10:1000;
fs=1000;

step=5400;
endep=step+1800;

for geno=1:2
    
    if geno==1
        mousenames=mousenames1; d1=dateBL1; d2=dateSD1;
    elseif geno==2
        mousenames=mousenames2; d1=dateBL2; d2=dateSD2;
    end
    numanim=size(mousenames,1);
    
    figure(geno)
    OFFb=[];OFFr=[];
    for anim=1:numanim
        
        if geno==1 if anim==4 continue; end; end
        
        mousename=mousenames(anim,:);
        mousename(isspace(mousename))=[];
        
        % baseline
        dd=1; if dd==1 recorddates=d1; else recorddates=d2; end
        recorddate=recorddates(anim,:);
        
        fnOFF=[mousename,'-',recorddate,'_',LD(ld),'-OFF_Raster_NREM']
        eval(['load ',pathOFF,fnOFF,'.mat nr recorddate off TSmsN MUA -mat']);
        TS=ceil(TSmsN./fs); TSep=ceil(TS/epochl);out1=find(TSep<step);out2=find(TSep>endep); out=[out1 out2];off(out)=[];
        
        OFF=[];
        for s=1:length(steps) ff=find(off>steps(s)); OFF=[OFF length(ff)/length(off)*100]; end
        OFF1=OFF;
        
        % recovery
        dd=2; if dd==1 recorddates=d1; else recorddates=d2; end
        recorddate=recorddates(anim,:);
        
        fnOFF=[mousename,'-',recorddate,'_',LD(ld),'-OFF_Raster_NREM']
        eval(['load ',pathOFF,fnOFF,'.mat nr recorddate off TSmsN MUA -mat']);
        TS=ceil(TSmsN./fs); TSep=ceil(TS/epochl);out1=find(TSep<step);out2=find(TSep>endep); out=[out1 out2];off(out)=[];
        
        OFF=[];
        for s=1:length(steps) ff=find(off>steps(s)); OFF=[OFF length(ff)/length(off)*100]; end
        OFF2=OFF;
        
        OFFa=[OFF1;OFF2];
        
        OFFb=[OFFb;OFF1];OFFr=[OFFr;OFF2];
        
        subplot(2,3,anim)
        semilogy(steps,OFFa,'LineWidth',2)
        legend('BSL','REC')
        legend('boxoff')
        grid on
        xlabel('OFF period duration (ms)')
        ylabel('number of OFF periods (%)')
        title(mousename)
        
    end
    
    m1=nanmean(OFFb); s1=nanstd(OFFb)./sqrt(size(OFFb,1));
    m2=nanmean(OFFr); s2=nanstd(OFFr)./sqrt(size(OFFr,1));
    
    figure(3)
    if geno==1
        semilogy(steps,m1,'.-b','LineWidth',2)
        hold on
        semilogy(steps,m2,'.-r','LineWidth',2);
    else
        semilogy(steps,m1,'s-b','LineWidth',2)
        hold on
        semilogy(steps,m2,'s-r','LineWidth',2);
    end
    
    %     hAx=axes;                     % new axes; save handle
    %      if geno==1
    %         errorbar(steps,m1,s1,'.-b','LineWidth',2)
    %         hold on
    %         errorbar(steps,m2,s2,'.-r','LineWidth',2);
    %     else
    %         errorbar(steps,m1,s1,'s-b','LineWidth',2)
    %         hold on
    %         errorbar(steps,m2,s2,'s-r','LineWidth',2);
    %     end
    %     hAx.YScale='log'
    %
    %     pause
    
    legend('BSL','REC')
    legend('boxoff')
    grid on
    xlabel('OFF period duration (ms)')
    ylabel('number of OFF periods (%)')
    
end

