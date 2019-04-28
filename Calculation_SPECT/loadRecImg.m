function [img,info]=loadRecImg(folder,filename)
if nargin<2
    filename = 'FBP';
end
if nargin<1
    folder = '201901114/out';
    filename = 'FBP';
end

if isempty(folder)
    folder = '201901114/out';
end

dire = 'E:\Database\GATE_simulation_data';
suffix = 'hv';
suffixbin = 'v';
file=[filename,'.',suffix];
filebin=[filename,'.',suffixbin];
filepath = fullfile(dire,folder,file);
filebinpath = fullfile(dire,folder,filebin);

if exist(filebinpath,'file')~=2
    error([filebinpath,' not exist']);
    return;
end

if exist(filepath,'file')~=2
    error([filepath,' not exist']);
    return;
end

info = interfileinfo(filepath);

fid = fopen(filebinpath,'r');
img_raw=fread(fid,info.NumberFormat);
img=reshape(img_raw,info.MatrixSize1,info.MatrixSize2,info.MatrixSize3);
img=flip(img,1);
img=flip(img,3);