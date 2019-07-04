function trainData3DSIFT( )
% this function takes the training videos and form the trainfeature vectors
% % to get the files in the directory selected
% matFiles = dir2([path,'\*.mat']);
% 
% %to get number of files in the directory
% numFiles = length(matFiles);
% 
% fprintf('Converting dataset in "allDataset" folder to .mat file format... \n \n')
%avi2matConverter();
addpath('3DSIFT');

fprintf('\n ...Training Process... \n')

list = dir('matDataset/*.mat');
numbFiles = length(list);


featuresSetAll = [];
trainLabels = [];

for f = 1 : numbFiles
    videoFile=fullfile(list(f).folder,list(f).name);
    video3Dm = load(videoFile); %load mat data
    fprintf('\n ...Vidoe %d :- %s :  \n', f, videoFile)
    
    video3Dm = cell2mat(struct2cell(video3Dm));
    svideo = size(video3Dm);
    fprintf('\n ...size of vidoe :- %s  \n', num2str(svideo))
    
    fprintf(' \n ...Extracting features for Video %d \n', f)
    % get interest points
    points = interestPoints(video3Dm);
    numPoints = size(points);
    fprintf('\n ...Number of Interest points :- %s \n', num2str(numPoints))

    % get features set
    featuresSet = featureSet3DSift(video3Dm, points );
    
    % concatenate all features
    featuresSetAll = [featuresSetAll ; featuresSet];
    sizeFeatures = size(featuresSetAll);
    fprintf('\n ...Updated size of Features :- %s \n', num2str(sizeFeatures))
    
    %get class label
    labels = buildClassLabel(list(f).name);
    fprintf('\n ...Label of video is :- %d \n', labels)

    % stack all class labels
    trainLabels = [trainLabels labels];
    lSize = size(trainLabels);
    fprintf('\n ...Updated size of labels :- %s \n \n', num2str(lSize))
    
end

trainLabels = trainLabels(:);

fprintf('    ...Kmeans Clustering ...  \n \n')
% Perform kmeans Clustering to Construct words of the Visual Vocabulary
cluster_idx = kmeans(featuresSetAll,600, 'Display', 'iter');
m = length(trainLabels);
signature = zeros(m,600);
nDescriptor = 50;

%Bag of features
for k = 1:m    
    for j = 1:nDescriptor   
        idx = nDescriptor*(k-1) + j; 
        signature(k, cluster_idx(idx))= signature(k, cluster_idx(idx)) + 1; 
    end
end

fprintf('    ... Cross Validation ...  \n \n')

% Shuffle the training set
indxs = randperm(length(trainLabels));
CValues = [0.01; 0.1; 1; 10; 100; 1000];

for i = 1:length(CValues)
    % Performing 5 fold cross vaalidation
     C = CValues(i,:);
     featureBagCombn = signature(indxs(1:m), :);
     actionLabels = trainLabels(indxs(1:m), :);
     
     t = templateSVM('Standardize',1,'KernelFunction','linear', 'BoxConstraint', C);      
     
     SVMMulticlass_combn = fitcecoc(featureBagCombn, actionLabels, 'Coding', 'onevsone',...
                                          'Learners', t); 
     ActionCrossVal = crossval(SVMMulticlass_combn, 'KFold', 5);
     
     
     cross_val_error(i,:) = kfoldLoss(ActionCrossVal);
     
end

[~, indC] = min(cross_val_error);
COpt = CValues(indC,:);

fprintf('    ...Saving Trained Data ...  \n \n')

save('trainFeatures2.mat','featuresSetAll','trainLabels','COpt');

fprintf('    ... Training Successful ...  \n \n')

end

