% Author:      Mohak Kumar Sukhwani
function detectCirlces(img)
%Detect circles in image (HOUGH tranform)
figure(2);
A=imread(img);
imshow(A)

%set radius
Rmin = 10;
Rmax = 15;

%Detect circles
[centersBright, radiiBright] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','bright');
[centersDark, radiiDark] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','dark');
 viscircles(centersBright, radiiBright,'EdgeColor','b');
 viscircles(centersDark, radiiDark,'EdgeColor','g');

end

