function [hActivity] = testData3DSift(videoFrames)
%this function to detect an action in a given video


% Reading the model data obtained from trainnig
load('trainFeatures.mat');

%  interest points detection from video frames
points = interestPoints(videoFrames);
% Feature detection from video frames
featuresSet = featureSet3DSift(videoFrames, points );

% combining test features with model features
newFeaturesSetAll = featuresSetAll;
newFeaturesSetAll = [newFeaturesSetAll ; featuresSet];

% classifying test data using K-means clustering
cluster_idx = kmeans(newFeaturesSetAll,600);
m = length(trainLabels);
signature = zeros(m+1,600);
nDescriptor = 100;


%bag of features
for k = 1:m+1
    for j = 1:nDescriptor
        idx = nDescriptor*(k-1) + j;
        signature(k, cluster_idx(idx))= signature(k, cluster_idx(idx)) + 1;
    end
end

% Predictions
featureBagTrain = signature(1:end-1, :);
classTrain = trainLabels;
t = templateSVM('Standardize',1,'KernelFunction','linear', 'BoxConstraint', COpt);

SVMMulticlassAction = fitcecoc(featureBagTrain, classTrain, 'Coding', 'onevsone',...
    'Learners',t);
featureBagTest = signature(end,:);
predictAction = predict(SVMMulticlassAction, featureBagTest);

if predictAction == 1
    hActivity = {'Boxing'};
elseif predictAction == 2
    hActivity = {'Hand clapping'};
elseif predictAction == 3
    hActivity = {'Hand Waving'};
elseif predictAction == 4
    hActivity = {'Jogging'};
elseif predictAction == 5
    hActivity = {'Running'};
else
    hActivity = {'Walking'};
end
end

