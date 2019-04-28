function [Stot,Si] = SenCal(Cji,Tacq,Tcal,Acal,sleeve_num,Tj)
% ======================================================================
% This function is for the calculation of scanner' Sensitivity.
% Input:	
% 		Cji, set contains all the slices' counts @ each acquisition.
% 		Tacq, the time of acquisition.
% 		Tcal, the time of initial activity was measured by dose 
% 			  calibrator.
% 		Acal, the activity measured by calibrator at start time.
% 		sleeve_num, the number of the sleeve = 5.
% 		Tj, the acquisition start time.
% Output:	Stot, system sensitivity.
% 			Si, the sensitivty of each slice.
% ======================================================================

%% Initialization
thickness = 2.5; % mm
Thalf = 6588;
slice_num = size(Cji,2);
Rji = zeros(sleeve_num,slice_num); % count rate
Rcorrji = zeros(sleeve_num,slice_num); % rate after isotope decay correction
Rcorr0 = 0; % unknown, need fit, count rate with no attenuation
Xj=[1:sleeve_num].*thickness./10; % cm
Xj = Xj';% Accumulated sleeve wall thickness
%% Caluculate System Sensitivity
% calculate count rate for each sleeves and for each slice.
Rji = Cji/Tacq;
for i = 1:sleeve_num
    Rcorrji(i,:) = Rji(i,:).*(2^((Tj(i)- Tcal)/Thalf));
end
Rcorrj = sum(Rcorrji,2);

[Rcorr0]=Rfit(Rcorrj,Xj);
Stot = Rcorr0./Acal;

%% Calculate Axial Sensitivity only for sleeve 1
Si=Rcorrji(1,:)./Rcorrj(1).*Stot;
% Display the Axial Sensitivity Profile
figure
plot(Si);
title('Axial Sensitivity Profile');
xlabel('Slice');
ylabel('Sensitivity');

