function [trues,falses,sumJoint] = tunning(wL ,wP,wD,wDC,wH)
% load('validation.mat');
load('cache_data.mat');
global trueInd;
global falsInd;
trues = 0;
falses = 0;
sumJoint = 0;
c = 0;
for i = 1:2:length(cachData)
    c = c + 1;
%     validationSet(c) = cachData(i);
    dc = cachData(i).Odc/8;
    scoreO = cachData(i).score0O + wL* cachData(i).leng_scoreO + wP*cachData(i).pair_scoreO + wD*cachData(i).ang_scoreO - wDC*dc + wH*cachData(i).HOGprob;
    dc = cachData(i).Ldc/8;
    scoreL = cachData(i).score0L + wL* cachData(i).leng_scoreL + wP*cachData(i).pair_scoreL + wD*cachData(i).ang_scoreL - wDC*dc + wH*cachData(i).HOGlprob;
    dc = cachData(i).Rdc/8;
    scoreR = cachData(i).score0R + wL* cachData(i).leng_scoreR + wP*cachData(i).pair_scoreR + wD*cachData(i).ang_scoreR - wDC*dc + wH*cachData(i).HOGrprob;
    realScrO = cachData(i).realScr(1);
    realScrR = cachData(i).realScr(2);
    realScrL = cachData(i).realScr(3);
    invOrig = cachData(i).realScr(4);
    invRig = cachData(i).realScr(5);
    invLef = cachData(i).realScr(6);
    
    [T, F,ss] = calculateRate(realScrO,realScrR,realScrL,invOrig,invRig,invLef,scoreO,scoreR,scoreL);
    sumJoint = sumJoint + ss;
    if T==1
        trues = trues + 1;
        trueInd(trues) = c;
    elseif F == 1
       falses = falses + 1; 
       falsInd(falses) = c;
    end
    
end
% save('validData.mat','validationSet');
end