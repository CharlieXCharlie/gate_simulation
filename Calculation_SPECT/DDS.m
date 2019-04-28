function [dds]=DDS(count,detector_num)
% Calculate the relative difference in sensitivity of the individual
% detectors, for multi-detector gamma camera systems.

% C, total counts in the same deetector.

if nargin <2
    detector_num = 2;
end

proj_num = size(count,2);
for i=1:detector_num
    C(i)=sum(count(1+proj_num/detector_num*(i-1):proj_num/detector_num*i));
end

Cmax = max(C)
Cmin = min(C)
dds = 100*(Cmax-Cmin)/Cmax;


