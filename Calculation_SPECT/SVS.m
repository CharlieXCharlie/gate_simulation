function [svs,vsac]=SVS(tc,tt,sa)
% calculate the system volume sensitivity and the average volume
% sensitivity per axial centimeter.
% tt, total time in s.
% tc, total count.
% sa, source activity.
% A, average count per min
% B, source activity / volume at time T
% Bc, source activity after decay correction.

R = 100; %mm
h = 200; %mm
tt = tt/60;
length = 200; %mm

A = tc/tt;
B = sa/(pi*(R/10)^2*(h/10));
Bc = B; % no need to correct.
svs = A/Bc;
vsac = svs/(length/10);