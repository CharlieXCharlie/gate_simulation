function [res1,res10,p]=SpaResCal(img,pixel_size_xy,pixel_size_z)
% =======================================================================
% Measurement of Spatial Resolution using FBP reconstructed image with no
% smothing or apodization.
% Input :
% 		img, all the reconstructed image.
% 		pixel_size_xy, the pixel size in the transaxial direction.
% 		pizel_size_z, the pizel size in the axial direction.
% Output : 
% 		res1, the spatial RESolution at 1 cm .
% 		res10, the spatial RESolution at 10 cm.
% 		p, the cropped point.
% =======================================================================

disp ':: Calculate Spatial Resolution'
%%  Initialization
res1 = zeros(1,4);
res10 = zeros(1,6);

%% Calculate each point's FWHM and FWTM
[ht,p]=RES3D(img,pixel_size_xy,pixel_size_z);

%% Report
% ht=[1hx,2hy,3hz,4tx,5ty,6tz];
% @1 cm
% Transverse FWHM
res1(1) = (ht(2,1)+ht(2,2)+ht(5,1)+ht(5,2))/4;
% Axial FWHM
res1(2) = (ht(2,3)+ht(5,3))/2;

% Transverse FWTM
res1(3) = (ht(2,4)+ht(2,5)+ht(5,4)+ht(5,5))/4;
% Axial FWTM
res1(4) = (ht(2,6)+ht(5,6))/2;

% @10 cm
% Transverse radial FWHM
res10(1) = (ht(1,2)+ht(3,1)+ht(4,2)+ht(6,1))/4;
% Transverse tangential FWHM
res10(2) = (ht(1,1)+ht(3,2)+ht(4,1)+ht(6,2))/4;
% Axial FWHM
res10(3) = (ht(1,3)+ht(3,3)+ht(4,3)+ht(6,3))/4;

% Transverse radial FWTM
res10(4) = (ht(1,5)+ht(3,4)+ht(4,5)+ht(6,4))/4;
% Transverse tangential FWTM
res10(5) = (ht(1,4)+ht(3,5)+ht(4,4)+ht(6,5))/4;
% Axial FWTM
res10(6) = (ht(1,6)+ht(3,6)+ht(4,6)+ht(6,6))/4;

%%
disp ':: Calculation over.'