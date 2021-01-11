function [y,ymean,ystd] = nannormal(x)
% function [y,ymean,ystd] = normal(x)
% demeans and normalizes the columns of matrix x 
% using the NaNsuite tools - Ignore NaN values
% Returns the mean, std and the demeaned data in y.
%
% Paul J. Durack 29 Aug 2007 - Updated name from normal.m to nannormal.m
%
[N,M] = size(x);
ymean = nanmean(x);
y = x - ones(N,1)*ymean;
ystd = nanstd(x);
y = y./(ones(N,1)*ystd);
