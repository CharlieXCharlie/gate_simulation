function [SF,SFi] = SFCal(sino,bin_size,xp)
% ====================================================================
% This functio is for the calculation of Scatter Fraction.
% Input :
% 		sino, all sinogram.
%       bin_size, sinogram bin size.
% 		xp, the position of each bin.
% Output:
% 		SF, system Scatter Fraction
%		SFi, Scatter Fraction in each slice
% ====================================================================

%% Initialization
slice_num = size(sino,3);
SFi = zeros(1,slice_num);
Crs = zeros(1,slice_num);
Ctot = zeros(1,slice_num);

%% Calculate Scatter Fraction of each slice
for i = 1: slice_num
	[Crs(i),Ctot(i)] = SF_sig(sino(:,:,i),bin_size,xp);
	SFi(i) = Crs(i)/Ctot(i);
end

%% Calculate the System Scatter Fraction
SF = sum(Crs)/sum(Ctot);

%% Display the result
% disp ':: Report:'
figure
plot(SFi);
title('Scatter Fraction @ each slice');
xlabel('slice');
ylabel('SF');
disp([':: System Scatter Fraction : ',num2str(SF*100),'%']);
