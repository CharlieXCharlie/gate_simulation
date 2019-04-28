function [Rcorr0,mu]=Rfit(Rcorrj,Xj)
% ===================================================================
% This function is for the fit of count rate with no attenuation.
% For Sensitivity.
% Input:	Rcorrj, 5*1, contains the count rate in each acquisition
% 			Xj, 5*1, contains the accumulated sleeve wall thickness 
% 				of each acquisition.
% Output:	Rcorr0, the count rate with no attenuation.
% 			mu, the fitted mu value of the attenuation material (Al).
% ===================================================================

px = log(Rcorrj);
x = Xj;
p = polyfit(x,px,1);
Rcorr0 = exp(p(2));
mu = p(1)/(-2)