%close all
clear all

path='/Volumes/MyPasseport/Sleepy6EEG-November2017/';
pathin=[path,'outputStagesEpi/']; 
pathsim=[path,'ResultsSimulations/']; 
pathfig=[path,'figures_simulations/'];%mkdir(pathfig)


%%%%%%%%%%%%%%%%%%Parameters to adjust

Mousename='Ed';%'Ju';
dayshort='0910';%'1617';
Der='Occ';%'LFP';
extensionIn='-ode15s-Occ-Sleepy6';%'-ode15s-LFP-Sleepy6';
extensionOut=extensionIn;

RCs=[0.5];
FCRs=[0.1];

fout=['VigStEpi_',Mousename,'_',dayshort,'_MedFilt35-Improved7-Occ'];
%fout=['VigStEpi_',Mousename,'_',dayshort,'_MedFilt35-Improved7-LFP'];

%%%%%%%%%%%%%%%

eval(['load ',pathin,fout,'.mat swaFilt swaT WT NT RT  -mat']);


Colours_WT=[0.10 0.10 0.40;...
    0.40 0.40 0.60;...
    0.60 0.60 0.80];

Colours_Rlss=[0.28 0.45 0.50;...
    0.48 0.65 0.70;...
    0.68 0.85 0.90];

Colours=Colours_WT;

xt=1:43200; xt=xt/900;

for p1=1%p1=8:9;
    for p2=1% p2=1:2
        figure()
        ax(1)=subplot('position',[0.1 0.25 0.8 0.65]);
        foutSim=['SimFixedTS_',Mousename,'_',dayshort,'_',extensionIn];%-Occipital'];
        eval(['load ',pathsim,foutSim,'.mat T Y fcr rc -mat']);
        
        t=floor(T);
        SWAsim=accumarray(t,Y(:,1),[],@mean);
        Ssim=accumarray(t,Y(:,2),[],@mean);
        
        if length(SWAsim)<43200
            for i=1:43200-length(SWAsim)
                SWAsim=[SWAsim; NaN];
                Ssim=[Ssim; NaN];
            end
        end
        
        f=[1 2 3 4];
        v=[24 0.4; 30 0.4; 30 200; 24 200];
        patch('Faces',f,'Vertices',v,'EdgeColor','non','FaceColor',[0.9 0.9 0.9])
        hold on
        
        plot(xt,swaFilt,'-k');
        hold on
        
        plot(xt,Ssim,'-','Color',[0 0.6 0.3],'LineWidth',2);
        hold on
        
        yN=SWAsim;
        yN(NT==0)=NaN;
        plot(xt,yN,'-','Color',Colours(1,:),'LineWidth',2,'MarkerSize',4);
        hold on
        
        yW=SWAsim;
        yW(WT==0)=NaN;
        plot(xt,yW,'-','Color',Colours(2,:),'LineWidth',2,'MarkerSize',10);
        hold on
        
        yR=SWAsim;
        yR(RT==0)=NaN;
        plot(xt,yR,'-','Color',Colours(3,:),'LineWidth',2,'MarkerSize',10);
        %xlabel('Hours');
        ylabel('% of mean');
        set(gca,'XTick',[0:4:48])
        %hold on
        
        legend('SD','Emp SWA','Process S','Sim. SWA NREMS','Sim. SWA wake','Sim. SWA REMS');
        legend('boxoff')
        %grid on
        axis([0 48 0 200])
        titles=[Mousename,'-',Der,'-rc: ',num2str(RCs(p1)), ', fcr: ',num2str(FCRs(p2))];
        title(titles);
        
        box off
        ax = gca; % current axes
        ax.TickDir = 'out';
        ax.LineWidth = 1.5;
        
        for vs=1:3
            if vs==1 v=WT; elseif vs==2 v=NT; else v=RT; end;
            ax(1+vs)=subplot('position',[0.1 0.15-0.011*(vs-1) 0.8 0.011]);
            bar(xt,v,1,'FaceColor',[0 0 0]); axis ([0 48 0 1]);
            set(gca, 'YTick', []); set(gca, 'XTick', []);
            if vs==3 set(gca, 'XTick', [0:48:max(xt)]); xlabel('Time [Hours]'); end
        end;
        
        linkaxes(ax,'x');
        
        
        
        %saveas(gcf,[pathfig,'Sim_',Mousename,'_',dayshort,'_MedFilt35Improved7_',extensionOut]);
        %saveas(gcf,[pathfig,'\plots_Sim2_Ol_1819_RC',num2str(p1),'_FCR',num2str(p2)],'tiff');
        %pause
    end
end
    