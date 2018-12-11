% function accuracy = testImg()
load('joints.mat');
testdir = 'test/';
test = dir(strcat(testdir,'*.jpg'));
[~,~,posInd,negInd] = getLabels();
% trueLabels = [ones(1,37),zeros(1,123)];
predictedLabels = zeros(1,length(test));
classifier = learnClassifier();
c = 0;
if(exist('res','dir'))
    rmdir('res','s');
end
mkdir('res/true');
mkdir('res/false');
for ii = 9:length(test)
    testImage = extractPatch(test(ii).name,joints,'test');
    testImage = imresize(testImage,[52,31]);
    [testFeatures,vis] = extractHOGFeatures(testImage,'CellSize',[5 5]);
    predictedLabels(ii) = predict(classifier, testFeatures);
    name = test(ii).name;
    name = strrep(name,'im','');
    imgName = str2double(strrep(name,'.jpg',''));
    if find(posInd == imgName)
        trueLabels(ii) = 1;
    elseif find(negInd == imgName)
        trueLabels(ii) = 0;
    end
    if predictedLabels(ii) == trueLabels(ii)
        c = c + 1;
        copyfile(strcat(testdir,test(ii).name),strcat('res/true/' , num2str(trueLabels(ii)),'-',test(ii).name));
    else
        copyfile(strcat(testdir,test(ii).name),strcat('res/false/' ,num2str(trueLabels(ii)), '-',test(ii).name));
    end
    
end
accuracy = c / length(test);