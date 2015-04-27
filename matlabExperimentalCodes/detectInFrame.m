% Author:      Mohak Kumar Sukhwani
function detectInFrame( inpImg )
%Detect Pieces in frame. Will assist in Scoring.

carFramRGB=imread(inpImg);
subplot(3,2,1);
imshow(carFramRGB);
title('Original');

%Black 
carFramCMY=255-carFramRGB;
channelOne=carFramCMY(:,:,1);
blackPieces=(channelOne<185 | channelOne>225);
SE=strel('DISK',6);
blackPieces=imclose(blackPieces,SE);
subplot(3,2,2);
imshow(blackPieces);
title('Black Pieces');

%White 
cform = makecform('srgb2lab');
channelThreeLAB = applycform(carFramRGB,cform);

thresh=graythresh(channelThreeLAB(:,:,3));
whitePieces=(channelThreeLAB(:,:,3)<150);
whitePieces=imclose(whitePieces,SE);
subplot(3,2,3);
imshow(whitePieces);
title('White Pieces');

%Queen
carFramYIQ=rgb2ntsc(carFramRGB);
extraPieces=carFramYIQ(:,:,3);
thresh=graythresh(extraPieces);
extraPiecesQ=(extraPieces<thresh);
extraPiecesQ=imclose(extraPiecesQ,SE);
subplot(3,2,4);
imshow(extraPiecesQ);
title('Queen');
 
%Striker
carFramYCB=rgb2ycbcr(carFramRGB);
extraPieces=carFramYCB(:,:,3);
thresh=min(min(extraPieces))+10;
extraPiecesS=(extraPieces<thresh);
subplot(3,2,5);
imshow(extraPiecesS);
title('Striker');


%(B-S)-W
diffBSt=blackPieces-extraPiecesS;
imshow(diffBSt);

% diffWQ=abs((1-whitePieces)-(1-extraPiecesQ));
% whitePieces=1-whitePieces;
% imshow(whitePieces);

% extraPieces=im2bw(extraPieces);
% diffImg=(blackPieces & extraPieces);
% subplot(3,2,5);
% imshow(diffImg);
% 
% 

avImg=((diffBSt)+whitePieces)./2;
subplot(3,2,6);
imshow(avImg);
imwrite(avImg,'segImg.jpg');

%detectCirlces(avImg);

end

