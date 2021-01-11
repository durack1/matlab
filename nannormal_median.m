function [y,ymedian,ystd] = nannormal_median(x)
% function [y,ymedian,ystd] = normal_median(x)
% Demeans and normalizes the columns of matrix x
% using the NaNsuite tools - Ignore NaN values
% Returns the median, st.dev and the demeaned data in y.
%
% Paul J. Durack 10 May 2007 - Created file from normal.m
% PJD 29 Aug 2008	- Updated name from normal_median.m to nannormal_median.m
%
[N,M] = size(x);
ymedian = nanmedian(x);
y = x - ones(N,1)*ymedian;
ystd = nanstd(x);
y = y./(ones(N,1)*ystd);
