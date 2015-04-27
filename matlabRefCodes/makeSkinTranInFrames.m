% Author:      Mohak Kumar Sukhwani

function makeSkinTransInFrames( )
%Detect skin in frames and if found make it TRANSLUCENT

%Base Image
base=imread('skinDetected\30.jpg');
baseCount=30;
skinPixCountBase=length(find(base==255));

%Destination folder
destinationDir = 'skinTrans\';
if ~exist(destinationDir, 'dir')
    mkdir(destinationDir)
end

%Source folder
sourceDir = 'skinDetected\';

i=1;
fileNameSrc=[sourceDir num2str(i) '.jpg'];
while exist(fileNameSrc,'file')
    %carFramRGB=imread(fileNameSrc);
    fileNameSrc=[sourceDir num2str(i) '.jpg'];
    newImg=imread(fileNameSrc);
    skinPixCount=length(find(newImg==255));
    
    %Check if new base image (i.e. nearest to frame in skin) is found
    if(abs(skinPixCount-skinPixCountBase)<=1000)
        skinPixCountBase=skinPixCount;
        base=newImg;
        baseCount=i;
    else
        %Make skin in frame translucent
        avgImg=makeSkinTrans(['LocBoards\' num2str(i) '.jpg'],['LocBoards\' num2str(baseCount) '.jpg']);
        destFold=[destinationDir num2str(i) '.jpg'];
        imwrite(avgImg,destFold);
    end
    
    %Increment file number
    i=i+1;
    
end

end

