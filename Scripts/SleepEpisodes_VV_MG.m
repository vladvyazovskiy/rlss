function [startend epidur]=SleepEpisodes(sleep,maxep,mindur,ba)

sleep=find(sleep>0);
sleep=[sleep maxep]; dif=diff(sleep); dif1=find(dif>ba+1); endvs=sleep(dif1);
startvs=dif1+1; startvs=[1 startvs maxep];
nepivs=diff(startvs); nepi1vs=find(nepivs>mindur);     % episodes longer than interruption
epidurvs=nepivs(nepi1vs); startep=sleep(startvs(nepi1vs)); numvs=length(startep); startep(numvs)=[];
nepi1vs(length(nepi1vs))=[]; endep=endvs(nepi1vs); startend=[startep' endep']; epidur=endep-startep+1;