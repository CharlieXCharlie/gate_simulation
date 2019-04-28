function [Zpls,Zcs,Zprs,Ypls,Ycs,Yprs]=cropss(ss,cf)

% cf, calibration factor
    
figure

peak1=max(max(ss(:,1:55)));
[y1,x1]=find(peak1==ss);
I1 = imcrop(ss,[x1-10 y1-10 21 21]);
subplot(1,3,1)
imshow(I1);
title('point 1');
xlabel('x');
ylabel('y');

peak2=max(max(ss(:,55:75)));
[y2,x2]=find(peak2==ss);
I2 = imcrop(ss,[x2-10 y2-10 21 21]);
subplot(1,3,2)
imshow(I2);
title('point 2');
xlabel('x');
ylabel('y');

peak3=max(max(ss(:,75:end)));
[y3,x3]=find(peak3==ss);
I3 = imcrop(ss,[x3-10 y3-10 21 21]);
subplot(1,3,3)
imshow(I3);
title('point 3');
xlabel('x');
ylabel('y');

% figure
% subplot(1,3,1)
% [fwhm1,fwtm1,peakc1]=plothpeak(I1,peak1,'x',1);
% subplot(1,3,2)
% [fwhm2,fwtm2,peakc2]=plothpeak(I2,peak2,'x',2);
% subplot(1,3,3)
% [fwhm3,fwtm3,peakc3]=plothpeak(I3,peak3,'x',3);
% figure
% subplot(1,3,1)
% [fwhm1,fwtm1,peakc1]=plothpeak(I1,peak1,'y',1);
% subplot(1,3,2)
% [fwhm2,fwtm2,peakc2]=plothpeak(I2,peak2,'y',2);
% subplot(1,3,3)
% [fwhm3,fwtm3,peakc3]=plothpeak(I3,peak3,'y',3);

figure
subplot(1,3,1)
[fwhm1]=plothpeak(I1,peak1,'x',1);
subplot(1,3,2)
[fwhm2]=plothpeak(I2,peak2,'x',2);
subplot(1,3,3)
[fwhm3]=plothpeak(I3,peak3,'x',3);

Zpls = fwhm1*cf;
Zcs = fwhm2*cf;
Zprs = fwhm3*cf;

figure
subplot(1,3,1)
[fwhm1]=plothpeak(I1,peak1,'y',1);
subplot(1,3,2)
[fwhm2]=plothpeak(I2,peak2,'y',2);
subplot(1,3,3)
[fwhm3]=plothpeak(I3,peak3,'y',3);

Ypls = fwhm1*cf;
Ycs = fwhm2*cf;
Yprs = fwhm3*cf;


            
