function [sino]=sinogene(image,info,slice)
% create sinogram
% image : all data
% slice : slice to create ainogram (e.g.75)
% view_num : the number of view
% sino : sinogram

if nargin<3
    slice=info.MatrixSize1/2;
end

view_num = info.NumberOfProjections;
for i=1:view_num
    sino(i,:) = image(slice,:,i);
end



