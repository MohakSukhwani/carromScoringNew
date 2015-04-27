% Author:      Mohak Kumar Sukhwani

function detectSkinOnBoard( )
%Detects skin pixel in every frame

%Destination folder
destinationDir = 'skinDetected\';
if ~exist(destinationDir, 'dir')
    mkdir(destinationDir)
end

%Source folder
sourceDir = 'LocBoards\';

i=1;

fileNameSrc=[sourceDir num2str(i) '.jpg'];

%Parsing through every frame
while exist(fileNameSrc,'file')
    i
    %carFramRGB=imread(fileNameSrc);
    newImg=skinDetection(fileNameSrc);
    fileNameDes=[destinationDir num2str(i) '.jpg'];
    imwrite(newImg,fileNameDes);
    
    %increment file number (generate new file name)
    i=i+1; 
    fileNameSrc=[sourceDir num2str(i) '.jpg'];
    
end





end

