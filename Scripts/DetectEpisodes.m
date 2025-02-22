function [startend, epidur]=DetectEpisodes(sleep,maxep,mindur,ba)
% If you want to include episodes of n epochs, then mindur should be set as
% n-1 (if mindur=n, episodes of exactly n-epoch duration will be
% excluded.)
% If ba=m, then interruptions of up to excatly m epochs (m included) are allowed.
sleep=find(sleep>0);
sleep=[sleep maxep]; dif=diff(sleep); dif1=find(dif>ba+1); endvs=sleep(dif1);
startvs=dif1+1; startvs=[1 startvs maxep];
nepivs=diff(startvs); nepi1vs=find(nepivs>mindur);     % episodes longer than interruption
epidurvs=nepivs(nepi1vs); startep=sleep(startvs(nepi1vs)); numvs=length(startep); startep(numvs)=[];
nepi1vs(length(nepi1vs))=[]; endep=endvs(nepi1vs); startend=[startep' endep']; epidur=endep-startep+1;