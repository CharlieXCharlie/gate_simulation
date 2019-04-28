function [ht,p] = RES3D(img,pixel_size_xy,pixel_size_z)
% =========================================================================
% This function is for the measurement of FWHM and FWTM in three direction.
% Input:
% 		img, the reconstructed image containing all slices.
% 		pixel_size_xy, the pixel size in the transaxial direction.
% 		pizel_size_z, the pizel size in the axial direction.
% Output:
%		ht, set of FWHM and FWTM.
% 		p, the cropped point.
% =========================================================================

%% Initialization
point_num = 6;
PSF_size  = 20; % expected FWHM

crop_pixel_num = ceil(PSF_size/2/pixel_size_xy); % half pixel num to crop
p  = zeros(crop_pixel_num*2+1,crop_pixel_num*2+1,point_num*2); % save cropped point image [xy; zx]*6
ht = zeros(point_num,6);

%% Find the position of each peak value
[pos]=findmax(img,pixel_size_xy);

%% Crop the point source
for i = 1:point_num
	p(:,:,(i-1)*2+1) = imcrop(img(:,:,pos(i,3)),[pos(i,2)-crop_pixel_num pos(i,1)-crop_pixel_num 2*crop_pixel_num 2*crop_pixel_num]);
	p(:,:,(i-1)*2+2) = imcrop(squeeze(img(:,pos(i,2),:)),[pos(i,3)-crop_pixel_num pos(i,1)-crop_pixel_num 2*crop_pixel_num 2*crop_pixel_num]);
end

%% Show the cropped point
figure
for i = 1:point_num*2
	subplot(point_num/2,4,i)
	imshow(p(:,:,i),[])
	title(['Point ',num2str(ceil(i/2))]);
end

%% %% Calculate resolution
% Calculate the max value of the response function by parabolic fit
% using peak point and its nearest neibouring points
for i = 1:point_num
	point_xy = p(:,:,(i-1)*2+1);
	point_zx = p(:,:,(i-1)*2+2);
	max_x = maxfit(point_xy,'x',pixel_size_xy);
	max_y = maxfit(point_xy,'y',pixel_size_xy);
	max_z = maxfit(point_zx,'z',pixel_size_z);
	[ht(i,1),ht(i,4)]=FWHTM(point_xy,max_x,'x',pixel_size_xy);
	[ht(i,2),ht(i,5)]=FWHTM(point_xy,max_y,'y',pixel_size_xy);
	[ht(i,3),ht(i,6)]=FWHTM(point_zx,max_z,'z',pixel_size_z);
end
