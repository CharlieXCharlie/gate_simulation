function [Zplc,Zcc,Zprc,Xplc,Xcc,Xprc]=cropcs(cs,cf)

% cf, calibration factor
    
figure

peak1=max(max(cs(:,1:55)));
[y1,x1]=find(peak1==cs);
I1 = imcrop(cs,[x1-10 y1-10 21 21]);
subplot(1,3,1)
imshow(I1);
title('point 1');
xlabel('x');
ylabel('y');

peak2=max(max(cs(:,55:75)));
[y2,x2]=find(peak2==cs);
I2 = imcrop(cs,[x2-10 y2-10 21 21]);
subplot(1,3,2)
imshow(I2);
title('point 2');
xlabel('x');
ylabel('y');

peak3=max(max(cs(:,75:end)));
[y3,x3]=find(peak3==cs);
I3 = imcrop(cs,[x3-10 y3-10 21 21]);
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

Zplc = fwhm1*cf;
Zcc = fwhm2*cf;
Zprc = fwhm3*cf;

figure
subplot(1,3,1)
[fwhm1]=plothpeak(I1,peak1,'y',1);
subplot(1,3,2)
[fwhm2]=plothpeak(I2,peak2,'y',2);
subplot(1,3,3)
[fwhm3]=plothpeak(I3,peak3,'y',3);

Xplc = fwhm1*cf;
Xcc = fwhm2*cf;
Xprc = fwhm3*cf;


            
