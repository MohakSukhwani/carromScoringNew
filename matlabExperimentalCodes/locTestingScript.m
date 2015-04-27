% Author:      Mohak Kumar Sukhwani

function locTestingScript( )
%locTestingScript: Localization test function. Crop the frames post determining the best match with template 

%Template Matching Localization of board in the input frame
[ bestRow,bestCol,bestSize ] = tempMatchLoc('frameCarGame\34.jpg');

%Destination directory
destinationDir = 'LocBoards\';
if ~exist(destinationDir, 'dir')
    mkdir(destinationDir)
end

%Source directory
sourceDir = 'frameCarGame\';

i=1;

%Source file name
fileNameSrc=[sourceDir num2str(i) '.jpg'];

while exist(fileNameSrc,'file')
   imgRGB=imread(fileNameSrc); 
   %Crop the frames
   croppedImg=imcrop(imgRGB,[bestCol bestRow bestSize bestSize]);
   
   fileNameDes=[destinationDir num2str(i) '.jpg'];
   imwrite(croppedImg,fileNameDes);
   i=i+1; 
   fileNameSrc=[sourceDir num2str(i) '.jpg'];
   
end





end

