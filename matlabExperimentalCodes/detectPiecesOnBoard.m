% Author:      Mohak Kumar Sukhwani
function detectPiecesOnBoard( )
%detectPiecesOnBoard This function segment outs the black, white and
%magenta pieces

%Decide Destination Directory
destinationDir1 = 'white\';
if ~exist(destinationDir1, 'dir')
    mkdir(destinationDir1)
end

destinationDir2 = 'black\';
if ~exist(destinationDir2, 'dir')
    mkdir(destinationDir2)
end

destinationDir3 = 'red\';
if ~exist(destinationDir3, 'dir')
    mkdir(destinationDir3)
end

%Source Destination
sourceDir = 'LocBoards\';

i=1;

fileNameSrc=[sourceDir num2str(i) '.jpg'];

%Parsing every image in frame
while exist(fileNameSrc,'file')
    carFramRGB=imread(fileNameSrc);
       
    %Black
    carFramCMY=255-carFramRGB;
    channelOne=carFramCMY(:,:,1);
    blackPieces=(channelOne<185 | channelOne>225);
    SE=strel('DISK',6);
    blackPieces=imclose(blackPieces,SE);
    fileNameDes=[destinationDir2 num2str(i) '.jpg'];
    imwrite(blackPieces,fileNameDes);
 
    %White
    cform = makecform('srgb2lab');
    channelThreeLAB = applycform(carFramRGB,cform);
    thresh=graythresh(channelThreeLAB(:,:,3));
    whitePieces=(channelThreeLAB(:,:,3)<150);
    whitePieces=imclose(whitePieces,SE);
    fileNameDes=[destinationDir1 num2str(i) '.jpg'];
    imwrite(whitePieces,fileNameDes);
    
    %Queen
    carFramYIQ=rgb2ntsc(carFramRGB);
    extraPieces=carFramYIQ(:,:,3);
    thresh=graythresh(extraPieces);
    extraPiecesQ=(extraPieces<thresh);
    extraPiecesQ=imclose(extraPiecesQ,SE);
    fileNameDes=[destinationDir3 num2str(i) '.jpg'];
    imwrite(extraPiecesQ,fileNameDes);
    
    %Increment file name
    i=i+1; 
    fileNameSrc=[sourceDir num2str(i) '.jpg'];
    
end





end

