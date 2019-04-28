function [slice1,slice2,slice3,RR,TR,CR]=calcuRecSpaReswS(img,info)
% calculate SPECT Reconstructed Spatial Resolution With Scatter

% img, Reconstructed image.
% info, information of the reconstructed image.

xnum = size(img,2);
ynum = size(img,1);
znum = size(img,3);
thickness = floor(10/2/info.ScalingFactorMmPixel3);
offset = floor(40/info.ScalingFactorMmPixel3);

% calculate three slice
slice1 = sum(img(:,:,znum/2-offset-thickness+1:znum/2-offset+thickness),3);
slice1 = squeeze(slice1);

slice2 = sum(img(:,:,znum/2-thickness+1:znum/2+thickness),3);
slice2 = squeeze(slice2);

slice3 = sum(img(:,:,znum/2+(offset+1)-thickness+1:znum/2+(offset+1)+thickness),3);
slice3 = squeeze(slice3);

figure 
subplot(1,3,1)
imshow(slice1)
title('slice 1, offset 40mm')
xlabel('x')
ylabel('y')
subplot(1,3,2)
imshow(slice2)
title('slice 2, offset 0mm')
xlabel('x')
ylabel('y')
subplot(1,3,3)
imshow(slice3)
title('slice 3, offset -40mm')
xlabel('x')
ylabel('y')

cf = info.ScalingFactorMmPixel3;

[Xpr1,Xc1,Xpd1,Ypr1,Yc1,Ypd1]=cropslice(slice1,cf);
[Xpr2,Xc2,Xpd2,Ypr2,Yc2,Ypd2]=cropslice(slice2,cf);
[Xpr3,Xc3,Xpd3,Ypr3,Yc3,Ypd3]=cropslice(slice3,cf);

% RR, average FWHM radial value
% TR, average FWHM tangential value
% CR, average FWHM central value
RR = (Xpr1+Ypd1+Xpr2+Ypd2+Xpr3+Ypd3)/6;
TR = (Ypr1+Xpd1+Ypr2+Xpd2+Ypr3+Xpd3)/6;
CR = (Xc1+Yc1+Xc2+Yc2+Xc3+Yc3)/6;









