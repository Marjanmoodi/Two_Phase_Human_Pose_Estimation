function [probClassifier,trainingFeatures] = learnClassifier(train_data,m,n)
trainingFeatures = getHOGFeatures(train_data,m,n);
% z = [3.2898  0.3005];
% classifier = fitcsvm(trainingFeatures,[train_data.label],...
%     'KernelFunction','linear',...
%     'KernelScale',z(1),'BoxConstraint',z(2));

classifier = fitcsvm(trainingFeatures, [train_data.label]);
probClassifier = fitSVMPosterior(classifier);
end
