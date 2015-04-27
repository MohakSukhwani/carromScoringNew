% Author:      Mohak Kumar Sukhwani
function [newImg]=skinDetection( ipImg )
%skinDetection: This function detects helps detecting skin using various color
%models
%Ref Paper: http://www.ijiee.org/papers/292-S1674.pdf


imgRGB=imread(ipImg);
%imgRGB=ipImg;
imgHSV=rgb2hsv(imgRGB);
imgYCbCr=rgb2ycbcr(imgRGB);

[rSize,cSize,chan]=size(imgRGB);

%YCbCr space
Y=imgYCbCr(:,:,1);
Cb = imgYCbCr(:,:,2);
Cr = imgYCbCr(:,:,3);
%Various color spaces
%[row,col,chn] = find(Y>80 & Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
%[row,col,chn] = find(Y>80 & Cb>=97.5 & Cb<=142.5 & Cr>=134 & Cr<=173);

%HSV space
hue=imgHSV(:,:,1);
sat=imgHSV(:,:,2);
val=imgHSV(:,:,3);
[row,col,chn]=find( (Y>80 & Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173 ) | ((hue >=0 & hue <=50) & (sat >=0.23 & sat <0.68)));

%RGB space
% red=imgRGB(:,:,1);
% green=imgRGB(:,:,2);
% blue=imgRGB(:,:,3);
% %[row,col,chn]=find( (red>95 & green>40 & blue>20 ) & ((max([red,green,blue]) - (min([red,green,blue])) > 15) & ((abs(red-green))>15) & (red>green) & (red>blue) ));
% [row,col,chn]=find( (red>95 & green>40 & blue>20 ) & ((abs(red-green))>15) & (red>green) & (red>blue) );
%     

imgRGB=zeros(rSize,cSize);
for i=1:size(row,1)
        imgRGB(row(i),col(i)) = 1;
end

newImg=imgRGB;
end

