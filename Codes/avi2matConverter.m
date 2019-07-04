clear all;
clc;

list = dir('*.avi');
if isfolder('matDataset')
    rmdir('matDataset', 's');
    fprintf('...Recreatiing folder for .mat Training data... \n \n')
end
    
x = mkdir('matDataset');
numFiles = length(list);

for f=1:numFiles
%vidobj=VideoReader(['/Users/sourabhkulhare/Documents/MATLAB/3DSIFT_CODE_v1/Small_test/v',num2str(f),'.avi']);
name = list(f).name;
path = list(f).folder;
fullpathname=fullfile(path,name);
obj=VideoReader([fullpathname]);
nFrames=obj.NumberOfFrames;
nRow=obj.Height;
nColumn=obj.Width;
video3Dm=zeros(nRow,nColumn,nFrames);  
for k=1:nFrames
   im=read(obj,k);
   im=im(:,:,1);
   video3Dm(:,:,k)=im;
   %video3Dm= video3Dm./max(max(max(video3Dm)));
end
[pathstr,name,ext] = fileparts(fullpathname);
fout = ['matDataset/',name,'.mat'];
save(fout,'video3Dm');
end
fprintf('...Finished converting %d files into %s directory.  \n',numFiles, x )