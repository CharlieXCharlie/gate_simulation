function [fwhm,fwtm,peakcenter]=plothpeak(I,peak,ax,num)

% LSF, line spread function

if ax=='x'
    LSF = I(ceil(size(I,1)/2),:);
else
    LSF = I(:,ceil(size(I,1)/2))';
end

plot(LSF)
hold on
plot([0 size(I,2)],[0 0]);
hpeak =peak/2;
for i=1:size(I,1)-1
    if LSF(1,i)<hpeak && LSF(1,i+1)>hpeak
        p1=[i,LSF(1,i)];
        p2=[i+1,LSF(1,i+1)];
    elseif LSF(1,i)>hpeak && LSF(1,i+1)<hpeak
           p3=[i,LSF(1,i)];
           p4=[i+1,LSF(1,i+1)];
    end
end
% plot([1,size(I,1)],[hpeak,hpeak])
plot(p1(1),p1(2),'*')
plot(p2(1),p2(2),'*')
plot(p3(1),p3(2),'*')
plot(p4(1),p4(2),'*')

h1 = p1(1)+(p2(1)-p1(1))*((hpeak-p1(2))/(p2(2)-p1(2)));
h2 = p3(1)+(p4(1)-p3(1))*((p3(2)-hpeak)/(p3(2)-p4(2)));
fwhm = h2-h1;

plot([h1 h1 h2 h2],[0 hpeak hpeak 0])
title(['point ',num2str(num)]);
xlabel(ax);


m=0;
hpeak =peak/10;
for i=1:size(I,1)-1
    if LSF(1,i)<hpeak && LSF(1,i+1)>hpeak && i<size(LSF,2)/2
        p1=[i,LSF(1,i)];
        p2=[i+1,LSF(1,i+1)];

    elseif LSF(1,i)>hpeak && LSF(1,i+1)<hpeak && m~=1 && i>size(LSF,2)/2
           p3=[i,LSF(1,i)];
           p4=[i+1,LSF(1,i+1)];
           m=1;
    end
end
% plot([1,size(I,1)],[hpeak,hpeak])
plot(p1(1),p1(2),'*')
plot(p2(1),p2(2),'*')
plot(p3(1),p3(2),'*')
plot(p4(1),p4(2),'*')

h1 = p1(1)+(p2(1)-p1(1))*((hpeak-p1(2))/(p2(2)-p1(2)));
h2 = p3(1)+(p4(1)-p3(1))*((p3(2)-hpeak)/(p3(2)-p4(2)));
fwtm = h2-h1;
peakcenter=(h1+h2)/2;

plot([h1 h1 h2 h2],[0 hpeak hpeak 0])