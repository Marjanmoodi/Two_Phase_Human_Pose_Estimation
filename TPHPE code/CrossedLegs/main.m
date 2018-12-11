clear variables;
load('joints.mat');
[posInd,negInd,labels] = getLabels(joints);


folder = './trainImages/';
trainingFiles = dir([folder,'*.jpg']);
ChangeTrainImage = 1;
trainIDs = [];
threshold = 0.5;
mVec = zeros(length(trainingFiles),1);
nVec = zeros(length(trainingFiles),1);

for ii = 1 : length(trainingFiles)
    name = trainingFiles(ii).name;
    name = strrep(name,'im','');
    imgId = str2double(strrep(name,'.jpg',''));
    img = imread(fullfile(folder,trainingFiles(ii).name));
    patch = extractPatch(img,joints,imgId);
    train_data(ii).patch = patch;
    train_data(ii).label = labels(imgId);
    
    [mVec(ii),nVec(ii),~] = size(patch);
end

m = round(mean(mVec)); % 80
n = round(mean(nVec)); % 55

[classifier,trainingFeatures] = learnClassifier(train_data,m,n);


folder = './testImages/';
tests = dir([folder,'*.jpg']);
imgCross = zeros(length(tests),1);
configCross = zeros(length(tests),1);

for ii = 1: length(tests)
    ii
    name = tests(ii).name;
    name = strrep(name,'im','');
    imgId = str2double(strrep(name,'.jpg',''));
    img = imread(fullfile(folder,tests(ii).name));
    patch = extractPatch(img,joints,imgId);
    [predictedLabel,jointEvidence] = isCrossed(joints(1:2,:,imgId),patch,classifier, threshold);
    imgCross(ii) = predictedLabel;
    configCross(ii) = jointEvidence;
end

xx = strcat(num2str(imgCross),num2str(configCross));
tabulate(xx)
[C,order] = confusionmat(configCross,imgCross)