function [predictedLabel,jointEvidence] = isCrossed(joints,testPatch,classifier, threshold)
jointEvidence = 0;
margin = 5;
[predictedLabel,prob] = imgEvidence(testPatch,classifier,threshold);
if (norm(joints(1,1)-joints(1,3)) > norm(joints(1,1)-joints(1,4)) + margin ...
    || norm(joints(1,6)-joints(1,4))>norm(joints(1,6)-joints(1,3)) + margin)
    jointEvidence = 1;
end


end