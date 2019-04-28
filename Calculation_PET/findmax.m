function [pos]=findmax(img,pixel_size_xy)
% ==========================================================================
% This function is used to find the max values and their position in the all 
% slice
% For Spatial Resolution.
% Input:
% 		img, all the reconstructed image slice.
% 		pixel_size_xy, the size of pixel in the transaxial direction
% Output:
% 		pos, the position of each point source's max value.
% ==========================================================================

%% Initialization
[row_num, col_num, slice_mun] = size(img);
half_slice = ceil(slice_mun/2); % 39
fourth_slice = ceil(half_slice/2); % 20
slice_cut = ceil((half_slice+fourth_slice)/2); % 30

point_dis = 100; % the distance bettween two point
hw = ceil(point_dis/4/pixel_size_xy);
cut_line_row = ceil(row_num/2)-hw;
cut_line_col = ceil(col_num/2)+hw;

%% Crop the point source
% find the peakvalue and its position
p1_peak = max(max(max(img(1:cut_line_row,1:cut_line_col,slice_cut:end))));
[r1,c1] = find(img(1:cut_line_row,1:cut_line_col,(slice_cut+1):end)==p1_peak);
s1 = ceil(c1/cut_line_col)+slice_cut;
c1 = mod(c1,cut_line_col);

p2_peak = max(max(max(img(cut_line_row+1:end,1:cut_line_col,slice_cut+1:end))));
[r2,c2] = find(img(cut_line_row+1:end,1:cut_line_col,slice_cut+1:end)==p2_peak);
r2 = r2+cut_line_row;
s2 = ceil(c2/cut_line_col)+slice_cut;
c2 = mod(c2,cut_line_col);

p3_peak = max(max(max(img(:,cut_line_col+1:end,slice_cut+1:end))));
[r3,c3] = find(img(:,cut_line_col+1:end,slice_cut+1:end)==p3_peak);
s3 = ceil(c3/(col_num-cut_line_col))+slice_cut;
c3 = mod(c3,(col_num-cut_line_col));
c3 = c3+cut_line_col;

p4_peak = max(max(max(img(1:cut_line_row,1:cut_line_col,1:slice_cut))));
[r4,c4] = find(img(1:cut_line_row,1:cut_line_col,1:slice_cut)==p4_peak);
s4 = ceil(c4/cut_line_col);
c4 = mod(c4,cut_line_col);

p5_peak = max(max(max(img(cut_line_row+1:end,1:cut_line_col,1:slice_cut))));
[r5,c5] = find(img(cut_line_row+1:end,1:cut_line_col,1:slice_cut)==p5_peak);
r5 = r5+cut_line_row;
s5 = ceil(c5/cut_line_col);
c5 = mod(c5,cut_line_col);

p6_peak = max(max(max(img(:,cut_line_col+1:end,1:slice_cut))));
[r6,c6] = find(img(:,cut_line_col+1:end,1:slice_cut)==p6_peak);
s6 = ceil(c6/(col_num-cut_line_col));
c6 = mod(c6,(col_num-cut_line_col));
c6 = c6+cut_line_col;
% the position of the six max point
pos = [r1,c1,s1;r2,c2,s2;r3,c3,s3;r4,c4,s4;r5,c5,s5;r6,c6,s6];