function [T,F,diff] = calculateRate(RealScorO,RealScorR,RealScorL,invOrig,invRig,invLef,estScoreO,estScoreR,estScoreL)
% load('footDc.mat');
T = 0;
F = 0;
pixel_thresh = 20;
all = [RealScorO,RealScorR,RealScorL];
% RR = [RealScorO,RealScorR,RealScorL];
[~,bestIndEst] = max([estScoreO,estScoreR,estScoreL]);
[~,bestIndReal] = min(all);
RealScorEst = all(bestIndEst);
diff = RealScorO - RealScorEst;
absdiff = norm(RealScorO - RealScorEst);
if absdiff>= pixel_thresh
    if bestIndEst == bestIndReal
        T = 1;
    else
        F = 1;
    end
end