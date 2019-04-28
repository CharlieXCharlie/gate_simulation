function [img,info,stats]=loaddata(folder,filename)

if nargin<2
    filename = 'my_input';
end
if nargin<1
    folder = '201901114';
    filename = 'my_input';
end

dire = 'E:\Database\GATE_simulation_data';
suffix = 'hs';
suffixbin = 's';
file=[filename,'.',suffix];
filebin=[filename,'.',suffixbin];
filetxt='stats.txt';

filepath = fullfile(dire,folder,file);
filebinpath = fullfile(dire,folder,filebin);
filetxtpath = fullfile(dire,folder,filetxt);

if exist(pwd,'file')==2
    delete(filebin);
    disp 'delete my_input.s in pwd'
end

if exist(filebinpath,'file')~=2
    error([filebinpath,' not exist']);
    return;
end

if exist(filetxtpath,'file')~=2
    error([filetxtpath,' not exist']);
else
    copyfile(filetxtpath,pwd);
end
% read stats.txt
stats = statsread(filetxt);
% copy file to pwd
copyfile(filebinpath,pwd);
copyfile(filepath,pwd);

if exist(filepath,'file')~=2
    error([filepath,' not exist']);
    return;
end

% read data
info = interfileinfo(filepath);
img = interfileread(filepath);

disp(['> Finish load : ',file,' ',filebin,' ',filetxt]);