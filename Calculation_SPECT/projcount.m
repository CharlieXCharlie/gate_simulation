function [count,tc,ac]=projcount(img,info)

% calculate the number of count in each projection

numproj = info.NumberOfProjections;
count = zeros(1,numproj);
for i=1:numproj
    count(1,i) = sum(sum(img(:,:,i)));
end

disp 'total counts of the acquired data'
tc = sum(count);
disp(tc)

disp 'average per projection'
ac = tc/info.NumberOfProjections;
disp(ac)

figure
plot(count);
hold on
plot([1 info.NumberOfProjections],[ac ac]);
xlabel('projection');
ylabel('total counts');
title('total counts at each projection');


