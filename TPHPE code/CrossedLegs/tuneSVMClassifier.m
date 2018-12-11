clear variables;

load('tuneSVMClassifierTrainData_1.mat')
load('tuneSVMClassifierTrainData_2.mat')

labels = [train_data.label];
c = cvpartition(length(labels),'KFold',10);
minfn = @(z)kfoldLoss(fitcsvm(trainingFeatures,labels,'CVPartition',c,...
    'KernelFunction','linear','BoxConstraint',exp(z(2)),...
    'KernelScale',exp(z(1))));

m = 20;
fval = zeros(m,1);
z = zeros(m,2);
opts = optimset('TolX',5e-4,'TolFun',5e-4);

for j = 1:m;
    j
    [searchmin fval(j)] = fminsearch(minfn,randn(2,1),opts);
    z(j,:) = exp(searchmin);
end

z = z(fval == min(fval),:)
z = z(1,:);

% z = [0.5553 8.8745];
% linear:     3.2898    0.3005


SVMModel = fitcsvm(trainingFeatures,labels,'KernelFunction','linear',...
    'KernelScale',z(1),'BoxConstraint',z(2));

