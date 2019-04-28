function [Xplt,Xct,Xprt,Yplt,Yct,Yprt]=cropts(ts,cf)

% cf, calibration factor
    
figure
peak1=max(max(ts(:,1:50)));
[y1,x1]=find(peak1==ts);
I1 = imcrop(ts,[x1-20 y1-20 41 41]);
subplot(1,3,1)
imshow(I1);
title('point 1');
xlabel('x');
ylabel('y');

peak2=max(max(ts(:,50:80)));
[y2,x2]=find(peak2==ts);
I2 = imcrop(ts,[x2-20 y2-20 41 41]);
subplot(1,3,2)
imshow(I2);
title('point 2');
xlabel('x');
ylabel('y');

peak3=max(max(ts(:,80:end)));
[y3,x3]=find(peak3==ts);
I3 = imcrop(ts,[x3-20 y3-20 41 41]);
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

Xplt = fwhm1*cf;
Xct = fwhm2*cf;
Xprt = fwhm3*cf;

figure
subplot(1,3,1)
[fwhm1]=plothpeak(I1,peak1,'y',1);
subplot(1,3,2)
[fwhm2]=plothpeak(I2,peak2,'y',2);
subplot(1,3,3)
[fwhm3]=plothpeak(I3,peak3,'y',3);

Yplt = fwhm1*cf;
Yct = fwhm2*cf;
Yprt = fwhm3*cf;

            
