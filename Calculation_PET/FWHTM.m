function [fwhm,fwtm]=FWHTM(p,max_p,dir,pixel_size)
% ==================================================================
% Calculate each point's FWHM and FWTM.
% For Spatial Resolution
% Input : 
% 		p, the cropped point image.
% 		max_p, the max value of each point.
% 		dir, the direction for the calculation of Space Resolution
% 		pixel_size, the pixel size in the specific direction.
% Output :
% 		fwhm, the fwhm of the point 'p'.
% 		fwtm, the fwtm of the point 'p'.
% ==================================================================

%% Initialization
if (dir=='x'||dir=='z')
	LSF = p(ceil(size(p,1)/2),:);
else
	LSF = p(:,ceil(size(p,1)/2))';
end

% min_p = min(LSF);
min_p = 0;
figure
plot(LSF)
hold on
%% FWHM
hmax = max_p/2;
p1 	 = [0,0];
p2	 = p1;
p3	 = p1;
p4	 = p1;
for i=1:size(p,1)-1
	if LSF(i)<=hmax && LSF(i+1)>=hmax
		p1 = [i,LSF(i)];
		p2 = [i+1,LSF(i+1)];
	elseif LSF(i)>=hmax && LSF(i+1)<=hmax
		p3 = [i,LSF(i)];
		p4 = [i+1,LSF(i+1)];
		break
	end
end
plot(p1(1),p1(2),'*')
plot(p2(1),p2(2),'*')
plot(p3(1),p3(2),'*')
plot(p4(1),p4(2),'*')		

h1 = p1(1)+(p2(1)-p1(1))*((hmax-p1(2))/(p2(2)-p1(2)));
h2 = p3(1)+(p4(1)-p3(1))*((p3(2)-hmax)/(p3(2)-p4(2)));
fwhm = (h2-h1)*pixel_size;

plot([h1 h1 h2 h2],[min_p hmax hmax min_p])
xlabel(dir);
%% FWTM
tmax = max_p/10;
for i=1:size(p,1)-1
	if LSF(i)<=tmax && LSF(i+1)>=tmax
		p1 = [i,LSF(i)];
		p2 = [i+1,LSF(i+1)];
	elseif LSF(i)>=tmax && LSF(i+1)<=tmax
		p3 = [i,LSF(i)];
		p4 = [i+1,LSF(i+1)];
		break
	end
end
plot(p1(1),p1(2),'*')
plot(p2(1),p2(2),'*')
plot(p3(1),p3(2),'*')
plot(p4(1),p4(2),'*')		

h1 = p1(1)+(p2(1)-p1(1))*((tmax-p1(2))/(p2(2)-p1(2)));
h2 = p3(1)+(p4(1)-p3(1))*((p3(2)-tmax)/(p3(2)-p4(2)));
fwtm = (h2-h1)*pixel_size;

plot([h1 h1 h2 h2],[min_p tmax tmax min_p])
%% Display
% Open it when check 
% plot([0 21],[max_p,max_p]);
% title(['FWHM = ',num2str(fwhm),' | FWTM = ',num2str(fwtm),' | Pixel Size = ',num2str(pixel_size)]);
