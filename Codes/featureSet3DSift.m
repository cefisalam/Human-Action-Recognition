function setOfFeatures = featureSet3DSift( video3Dm, interestPoints )

% Obtain the Feature descriptors Using 3D SIFT


%Normalise video
video3Dm = video3Dm/max(max(max(video3Dm)));

offset = 0;

% m = size(interestPoints,1);
% if m < 100
%     disp(' ... low number of interest point !!!')
%     disp('... padding with zeros')
%     interestPoints = padarray(interestPoints,100,0,'post');
% end
%         
for i=1:100
    reRun = 1;

    while reRun == 1
        loc = interestPoints(i+offset,:);
        
        % Create a 3DSIFT descriptor at the given location
        [keys{i} reRun] = Create_Descriptor(video3Dm,1,1,loc(1),loc(2),loc(3));
        
        if reRun == 1
            offset = offset + 1;
        end
    end
end

for i = 1:100
    des(i,:) = keys{1,i}.ivec;
end
setOfFeatures = double(des);
end

