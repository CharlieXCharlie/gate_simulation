function [max] = maxfit(p,dir,pixel_size)
% ========================================================================
% Find the max value of the specific point in the specific direction
% by fit the peak and nearest points.
% Input : 
% 		p, the cropped point image.
% 		dir, the direction for the calculation, y or x.
% 		pixel_size, the pixel size of the image in the specific direction.
% Output :
% 		max, the fitted max value in the specific direction of this point.
% ========================================================================
x = [0,1*pixel_size,2*pixel_size];
c = ceil(size(p,1)/2);
if(strcmp(dir,'x')||strcmp(dir,'z'))
	y = [p(c,c-1),p(c,c),p(c,c+1)];
else
	y = [p(c-1,c),p(c,c),p(c+1,c)];
end
f = polyfit(x,y,2);
x_max = -f(2)/(2*f(1));
y_max = polyval(f,x_max);
max = y_max;
% figure
% plot(x,y,'o');
% hold on
% x1 = linspace(0,2*pixel_size);
% y1 = polyval(f,x1);
% plot(x1,y1);
% plot(x_max,max,'o');
% hold off