disp '>>>> Clear Work Space'

%% set the info about the file
disp '>>>>Initialization'
folder = input('> Input the folder number : ');
rec_meth = input('> Input the reconstructed method or iter number : ');
folder = num2str(folder);
if isempty(folder)
    folder = '201901141';
end
if isempty(rec_meth)
    rec_meth = 'FBP';
end
if rec_meth ~= 'FBP'
    rec_meth=['OSEM_2DPSF_',num2str(rec_meth)];
end

%% load the projection data
disp '>>>> Load Data'
[img,info]=loaddata(folder);

%% generate sinogram from the projection data
disp '>>>> Generate Sinogram'
figure
[sino]=sinogene(img,info);
subplot(1,2,1)
imshow(sino);
title('sinogram without normalization');
xlabel('bin');
ylabel('theta');
subplot(1,2,2)
imshow(sino/max(max(sino)));
title('sinogram with normalization')
xlabel('bin');
ylabel('theta');

%% load the reconstructed image
disp '>>>> Load Reconstructed Image'
figure
[recimg,recinfo]=loadRecImg([folder,'/out'],rec_meth);
subplot(1,2,1)
imshow(recimg(:,:,64));
title('recon image at 64th sclice wo norm')
xlabel('x');
ylabel('y');
subplot(1,2,2)
imshow(recimg(:,:,64)/max(max(recimg(:,:,64))))
title('recon image at 64th sclice w norm')
xlabel('x');
ylabel('y');   

%% calculate the count related information
[count,tc] = projcount(img,info);

%% calculate the system volume sensitivity (SVS) and the average volume sensitivity per axial centimeter (VSAC)
disp '>>>>calculate sensitivity'
tt = 1800;
sa = 60/1000; %MBq
[svs,vsac] = SVS(tc,tt,sa);

%% Calculate the detector sensitivity variation
detector_num = 2;
[dds]=DDS(count,detector_num);
dds

%% calculate spatial resolution without scatter
disp '>>>> Calculate SPECT reconstructed Spatial resolution without Scatter'
[ts,ss,cs,CTR,CAR,PRR,PTR,PAR] = calcuRecSpaReswoS(recimg,recinfo);

%% calculate spatial resolution with scatter
% disp 'Calculate SPECT reconstructed Spatial Resolution with Scattr'
% [slice1,slice2,slice3,RR,TR,CR] = calcuRecSpaReswS(recimg,recinfo);


%% the end
disp '>>>> Finish'