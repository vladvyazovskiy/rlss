%close all
clear all

path='/Volumes/MyPasseport/Sleepy6EEG-November2017/';
pathin=[path,'outputStagesEpi/']; 
pathsim=[path,'ResultsSimulations/']; 
pathfig=[path,'figures_simulations/'];%mkdir(pathfig)


%%%%%%%%%%%%%%%%%%Parameters to adjust

Mousename='Ju';
dayshort='1617';
Der='LFP';
extensionIn='-ode15s-LFP-Sleepy6';
extensionOut=extensionIn;%'-ode15s-Fro-NewEq3-1stTrial-FRC02-FCW02-tp6';
%extensionOut='-ode15s-Fro-NewEq3-LDequal-newCalS0';

RCs=[0.5];
FCRs=[0.1];

%fout=['VigStEpi_',Mousename,'_',dayshort,'_MedFilt35-Improved7'];%-allnon-artStates'];
fout=['VigStEpi_',Mousename,'_',dayshort,'_MedFilt35-Improved7-LFP'];

%%%%%%%%%%%%%%%

eval(['load ',pathin,fout,'.mat swaFilt swaT WT NT RT  -mat']);



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
        
        plot(xt,swaFilt,'-k');
        hold on
        
        plot(xt,Ssim,'-','Color',[0 0.6 0.3],'LineWidth',2);
        hold on
        
        yN=SWAsim;
        yN(NT==0)=NaN;
        plot(xt,yN,'-','Color',[0.28 0.45 0.50],'LineWidth',2,'MarkerSize',4);
        hold on
        
        yW=SWAsim;
        yW(WT==0)=NaN;
        plot(xt,yW,'.-','Color',[0.48 0.65 0.70],'LineWidth',2,'MarkerSize',10);
        hold on
        
        yR=SWAsim;
        yR(RT==0)=NaN;
        plot(xt,yR,'-','Color',[0.68 0.85 0.90],'LineWidth',2,'MarkerSize',10);
        xlabel('Hours');
        ylabel('% of mean');
        set(gca,'XTick',[0:4:48])
        %hold on
        
        legend('emp SWA','Process S','SIM SWA nrem','SIM SWA wake','SIM SWA rem');
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
            if vs==3 set(gca, 'XTick', [0:4:max(xt)]); xlabel('Time [Hours]'); end
        end;
        
        linkaxes(ax,'x');
        
        
        
        %saveas(gcf,[pathfig,'Sim_',Mousename,'_',dayshort,'_MedFilt35Improved7_',extensionOut]);
        %saveas(gcf,[pathfig,'\plots_Sim2_Ol_1819_RC',num2str(p1),'_FCR',num2str(p2)],'tiff');
        %pause
    end
end
    