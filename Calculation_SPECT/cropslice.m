function [Xpr,Xc,Xpd,Ypr,Yc,Ypd]=cropslice(img,cf)

% cf, calibration factor.

figure

peak1=max(max(img(:,80:end)));
[y1,x1]=find(peak1==img);
I1 = imcrop(img,[x1-20 y1-20 41 41]);
subplot(1,3,1)
imshow(I1);
title('point 1');
xlabel('x');
ylabel('y');

peak2=max(max(img(1:80,1:80)));
[y1,x1]=find(peak2==img);
I2 = imcrop(img,[x1-20 y1-20 41 41]);
subplot(1,3,2)
imshow(I2);
title('point 2');
xlabel('x');
ylabel('y');

peak3=max(max(img(80:end,:)));
[y1,x1]=find(peak3==img);
I3 = imcrop(img,[x1-20 y1-20 41 41]);
subplot(1,3,3)
imshow(I3);
title('point 3');
xlabel('x');
ylabel('y');

figure
subplot(1,3,1)
[fwhm1]=plothpeak(I1,peak1,'x',1);
subplot(1,3,2)
[fwhm2]=plothpeak(I2,peak2,'x',2);
subplot(1,3,3)
[fwhm3]=plothpeak(I3,peak3,'x',3);

Xpr = fwhm1*cf;
Xc = fwhm2*cf;
Xpd = fwhm3*cf;

figure
subplot(1,3,1)
[fwhm1]=plothpeak(I1,peak1,'y',1);
subplot(1,3,2)
[fwhm2]=plothpeak(I2,peak2,'y',2);
subplot(1,3,3)
[fwhm3]=plothpeak(I3,peak3,'y',3);

Ypr = fwhm1*cf;
Yc = fwhm2*cf;
Ypd = fwhm3*cf;