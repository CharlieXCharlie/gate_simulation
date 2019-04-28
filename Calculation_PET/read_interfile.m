function [info,img_flip]=read_interfile(filepath,type)
% ====================================================================
% Read Interfile to calculate the spatial resolution, scatter fraction
% and sensitivity. The STIR reconstructed images are stored using the
% Interfile formate.
% Input :
%       filepath, the folder contains the folders which have the 
%                 rebinned and reconstructed images.
%       type, the rebinned and reconstructed images' type, also the
%             name of the image file.
% Output :
%       info, the infomatio about the loaded interfile.
%       img_filp, the image after or not filp, it dependes on the type
% ====================================================================

if strcmp(type,'user_ssrb')
    % For the sinogram image using Single-Slice Rebinning
    source_file = [filepath,'\sinogram\',type,'.s'];
    source_file_ID = fopen(source_file,'r');
    
    info.NumberFormat ='int';
    info.MatrixSize1 = 624;
    info.MatrixSize2 = 312;
    info.MatrixSize3 = 77;
    
    img=fread(source_file_ID,info.NumberFormat);
    img=reshape(img,info.MatrixSize1,info.MatrixSize2,info.MatrixSize3);
    img_flip=img;

elseif strcmp(type,'FORE')
    % For the sinogram image using Fourier rebinning
    source_file = [filepath,'\sinogram\',type,'.s'];
    info.NumberFormat ='float';
    info.MatrixSize1 = 624;
    info.MatrixSize2 = 77;
    info.MatrixSize3 = 512;
    
    source_file_ID = fopen(source_file,'r');
    img=fread(source_file_ID,info.NumberFormat);

    img=reshape(img,info.MatrixSize1,info.MatrixSize2,info.MatrixSize3);
    img_flip=permute(img,[1,3,2]);

elseif strcmp(type,'counts')
    % For the file contains counts in each slice.
    source_file = [filepath,'\sinogram\',type,'.s'];
    info.NumberFormat ='int';

    source_file_ID = fopen(source_file,'r');
    img=fread(source_file_ID,info.NumberFormat);
    img_flip=img;
else
    % For the reconstructed image.
    source_file = [filepath,'\image\',type,'.v'];
    header_file = [filepath,'\image\',type,'.hv'];

    info = interfileinfo(header_file);
    source_file_ID = fopen(source_file,'r');
    img=fread(source_file_ID,info.NumberFormat);

    img=reshape(img,info.MatrixSize1,info.MatrixSize2,info.MatrixSize3);
    img_flip=flip(rot90(img),2);
    % img_flip=flip(img_flip,3);
end

