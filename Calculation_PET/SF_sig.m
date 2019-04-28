function [Crs,Ctot,sino_post_shift] = SF_sig(sino,bin_size,xp)
% ======================================================================
% This function is only for the calculation of single slice's counts.
% Input:
%       sino, sinogram of single slice.
% 		bin_size, bin size of sinogram.
% 		xp, sino position.
% Output:	
%       Crs, the random and scattered counts.
% 		Ctot, the total counts, sum of all pixels in the sum projection.
%       sino_post_shift, the sinogram after shift.
% ======================================================================

%% Initialization
center_pos = max(size(xp))/2+1;
band = 120; % mm
strip_width = 20; % mm
% xp_corr = xp*bin_size;
xp_corr = xp';
band_pixel = ceil(band/(bin_size*2));
edge_up = center_pos-band_pixel*2;
edge_down = center_pos+band_pixel*2;

%% Calculation
% All pixels in each sinogram i of acquisition j located farther than 12 cm frm the centre of the phantom shall be set to zero.
sino_post = sino;
sino_post(1:(edge_up-1),:)=0;
sino_post((edge_down+1):end,:)=0;
% Find the max value's position
max_pos = zeros(1,size(sino,2));
for i=1:size(sino,2)
	m = find(sino(:,i)==max(sino(:,i)));
	max_pos(i) = m(1);
end
% shift sino
shift_size = center_pos-max_pos;
sino_post_shift = zeros(size(sino,1),size(sino,2));
for i=1:size(sino,2)
	sino_post_shift(:,i) = circshift(sino_post(:,i),shift_size(i));
end

sino_sum = sum(sino_post_shift,2);
% find the strip edge
pos=zeros(1,4);
for i=1:(size(xp_corr,2)-1)
    if xp_corr(i) <= (-strip_width) && xp_corr(i+1) >= (-strip_width)
		pos(1) = i;
		pos(2) = i+1;
        continue;
    elseif xp_corr(i) <= strip_width && xp_corr(i+1) >= strip_width
        pos(3) = i;
        pos(4) = i+1;
        break;
    end
end
% fit the point @20 mm offset
x = xp_corr(pos'); % 4*1
y = sino_sum(pos'); % 4*1

q(1,1) = (-20-x(1))/(x(2)-x(1))*abs(y(2)-y(1))+y(1);
q(2,1) = (20-x(3))/(x(4)-x(3))*abs(y(3)-y(4))+y(4);
p = [-20; 20];
% % test display
figure
plot(xp_corr,sino_sum);
title('Sum of all sinogram')
xlabel('radial distance from max pixel');
ylabel('total counts per slice');
hold on
plot(x,y,'o');
plot(p,q,'-*');
hold off

% Caluculation
CL = q(1);
CR = q(2);
Cout = sum(sino_sum(1:pos(1)))+sum(sino_sum(pos(4):end));
Crs = (CL+CR)./2*(2*strip_width/(bin_size*2))+Cout;

Ctot = sum(sino_sum);




