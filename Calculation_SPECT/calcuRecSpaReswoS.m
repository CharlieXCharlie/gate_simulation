function [ts,ss,cs,CTR,CAR,PRR,PTR,PAR]=calcuRecSpaReswoS(img,info)
% Calculate SPECT Reconstructed Spatial Resolution without Scatter.
% img, reconstructed image.
% info, the infomation of reconstructed image.
% ts, transverse slice.
% ss, sagittal slice.
% cs, coronal sclie.
% create T, S, C slice.
% T, transverse slice 130(5) mm, 130/2.5=52 pixels.
% S, Sagittal slice 180(5) mm, 180/2.5=72 pixels.
% C, coronal slice 30(5) mm, 30/2.5= 12 pixels.


% half pixels number
tp       = floor(130/info.ScalingFactorMmPixel3/2);
startnum = info.MatrixSize3/2-tp+1;
endnum   = info.MatrixSize3/2+tp;
ts = sum(img(:,:,startnum:endnum),3);

sp       = floor(180/info.ScalingFactorMmPixel1/2);
startnum = ceil(info.MatrixSize1/2)-sp+1;
endnum   = ceil(info.MatrixSize1/2)+sp;
ss = sum(img(:,startnum:endnum,:),2);
ss = squeeze(ss);

cp       = floor(180/info.ScalingFactorMmPixel2/2);
startnum = ceil(info.MatrixSize2/2)-cp+1;
endnum   = ceil(info.MatrixSize2/2)+cp;
cs = sum(img(startnum:endnum,:,:),1);
cs = squeeze(cs);

figure
subplot(1,3,1)
imshow(ts)
title('transverse slice');
xlabel(info.MatrixAxisLabel1);
ylabel(info.MatrixAxisLabel2);
subplot(1,3,2)
imshow(ss)
title('sagittal slice');
xlabel(info.MatrixAxisLabel3);
ylabel(info.MatrixAxisLabel2);
subplot(1,3,3)
imshow(cs)
title('coronal slice');
xlabel(info.MatrixAxisLabel3);
ylabel(info.MatrixAxisLabel1);

califactor = info.ScalingFactorMmPixel2;

[Xplt,Xct,Xprt,Yplt,Yct,Yprt]=cropts(ts,califactor);
[Zpls,Zcs,Zprs,Ypls,Ycs,Yprs]=cropss(ss,califactor);
[Zplc,Zcc,Zprc,Xplc,Xcc,Xprc]=cropcs(cs,califactor);

% calculate five average resolution 
% central transaxial
% central axial
% peripheral Radial
% peripheral Tangental
% peripheral Axial

CTR = (Xct+Xcc+Yct+Ycs)/4;
CAR = (Zcs+Zcc)/2;
PRR = (Xplt+Xplc+Xprt+Xprc)/4;
PTR = (Yplt+Ypls+Yprt+Yprs)/4;
PAR = (Zpls+Zplc+Zprs+Zprc)/4;






