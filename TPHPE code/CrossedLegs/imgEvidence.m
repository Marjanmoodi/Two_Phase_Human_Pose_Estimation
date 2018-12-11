function [predictedLabel,prob] = imgEvidence(testPatch,classifier, threshold)
if(~exist('threshold','var'))
    threshold = 0.5;
end
testPatch = imresize(testPatch,[80,55]);
[testFeatures,~] = extractHOGFeatures(testPatch,'CellSize',[5 5]);
[~,prob] = predict(classifier, testFeatures);

if(prob(2) >= threshold)    
    predictedLabel = 1;
else
    predictedLabel = 0;
end

end