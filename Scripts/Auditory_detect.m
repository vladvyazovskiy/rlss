%% Cristina Blanco. 21/03/2018. Script to detect time stamps for beginning, end and middle point of sound
% lims = contains beginning of sound (row 1) and end of sound (row 2)
% midsound = contains mid-point of each sound

clear all
close all

%% Paths
path='/Volumes/MyPasseport/Sleepy6EEG-November2017/';%'F:\Sleepy6EEG-November2017\';
pathsig=[path,'OutputSignals/'];
pathaud=[path,'OutputAuditory/'];


%% Basic Variables
epochl=4;

recorddates=strvcat('201117');%day month year
mousenames=strvcat('Le')
ld='D';
block=['-AUD-WrittenOut256Hz-',recorddates,'_',ld];

maxep=10800; epochl=4;
fs=256;
fsh12=fs*epochl*maxep;
SR=256;

numanim=1;
days=1;
gap=10000; %Determines approximate gaps between sounds


%% Detect Sound beginning, end and midpoint
for mouse=1:numanim
    mousename=mousenames(mouse, :)
    
    figure
    for day=1:days
        recorddate=[recorddates(day,:)];
        
        fnoutaud=[mousename,block];
        
        eval(['load ',pathsig,fnoutaud,'.mat aud -mat']);
        
        plot(aud)
        axis([0 length(aud) 0 11])
        
        diffs=diff(aud);
        
        for nn=1:2
            
            if nn==1; dif(:,nn)=find(diffs==10); elseif nn==2 dif(:,nn)=find(diffs==-10); end %find wiggles in sound
            
            chang(:,nn)=diff(dif(:,nn)); % space between wiggles in sound
            stim(:,nn)=find(chang(:,nn)>gap); % find gaps between sounds to isolate each specific sound
            
            % lims row 1= beginning of sound; lims row 2= end of sound.
            lims(1,1)=dif(1,1);
            for ii=1:length(stim(:,nn))
                if nn==1 lims(ii+1,nn)=dif(stim(ii)+1,nn); elseif nn==2 lims(ii,nn)=dif(stim(ii),nn); end
            end
            
        end
        ften=find(aud==10);last10=ften(end);
        lims(end,2)=last10;
        midsound=(lims(:,1)+lims(:,2))./2; 
        
        fAUDname=[mousename,'_',recorddates,'_',ld,'_aud_parameters'];
        
        %eval(['save ',pathaud,fAUDname,'.mat lims -mat']);
        
    end
end