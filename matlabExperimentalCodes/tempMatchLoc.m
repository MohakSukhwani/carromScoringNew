% Author:      Mohak Kumar Sukhwani
function [ bestRow,bestCol,bestSize ] = tempMatchLoc( inpImage )
%Template Matching and Localizing Carrom Board - 34.jpg

%Read Image
imgRGB=imread(inpImage);
imgGray=rgb2gray(imgRGB);
imgGrayMean=mean(mean(imgGray));

%Decide the dimension
[row,col]=size(imgGray);
decidingDimen=min(row,col);

%Read file containing details of dimensions
tempFile=fopen('avgBoard\carmTemp\templateDetails.txt');
tline = fgets(tempFile);
ind=strfind(tline,' ');
tempSizes=[str2double(tline(ind(1):ind(2)))];
while ~feof(tempFile)
    tline = fgets(tempFile);
    ind=strfind(tline,' ');
    tempSizes=[tempSizes str2double(tline(ind(1):ind(2)))];
end
fclose(tempFile);


%Display error messages
if(decidingDimen<tempSizes(1,1))
    dsplay('Image Quality not upto the mark!!!');
    exit;
end

if(decidingDimen>tempSizes(1,length(tempSizes)))
    dsplay('Make sure board is localized... It would take longer to localize board in such high quality!!!');
    exit;
end

%Decide qualifying templates
[rowSel,colSel]=find(tempSizes<decidingDimen);
qualifiedTeplates=tempSizes(rowSel,colSel);
[rowSel,colSel]=size(qualifiedTeplates);
qualifiedTeplates=qualifiedTeplates(1,1:colSel);

[startRow,startCol]=find(tempSizes==qualifiedTeplates(1));
[stopRow,stopCol]=find(tempSizes==qualifiedTeplates(colSel));

%Template Matching
tempCount=startCol;
fileName=['avgBoard\carmTemp\template' num2str(tempCount) '.jpg'];
corArray=zeros(10,4);
while exist(fileName) & tempCount<stopCol
  tic  
  tempGray=imread(fileName);
  tempGrayMean=mean(mean(tempGray));
  %tempGrayDiff=tempGray-tempGrayMean;
  tempGrayDiff=tempGray-imgGrayMean;
  [tempRow,tempCol]=size(tempGray);
  
  rowLimit=row-tempRow;
  colLimit=col-tempCol;
  
  %Traversing through each pixel
  for iCount=1:3:rowLimit
  for jCount=randi(1,3):3:colLimit
      imgPart=imgGray(iCount:iCount+tempRow-1,jCount:jCount+tempCol-1);
      imgPartMean=mean(mean(imgPart));
      %imgPartDiff=imgPart-imgPartMean;
      imgPartDiff=imgPart-imgGrayMean;
      corDen=sqrt(sum(sum(imgPartDiff.^2)).* sum(sum(tempGrayDiff.^2)) );
      corNum=sum(sum(imgPartDiff.*tempGrayDiff));
      cor=corNum/corDen;
      corArray(10,:)=[cor tempCount iCount jCount];
      corArray=sortrows(corArray,-1);
  end
  end
  toc
  tempCount=tempCount+1
  fileName=['avgBoard\carmTemp\template' num2str(tempCount) '.jpg'];
end

display(corArray);

templateSize=tempSizes(corArray(1,2));
rowSel=corArray(1,3);
colSel=corArray(1,4);

%Details of best template match
croppedImg=imcrop(imgRGB,[colSel rowSel templateSize templateSize]);
imshow(croppedImg);
bestRow=rowSel;
bestCol=colSel;
bestSize=templateSize;


end

