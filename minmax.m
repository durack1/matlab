function y = MINMAX(x,dim)
%MINMAX  Sample range.
%   Y = MINMAX(X) returns the minimum and maximum values in X.  For a vector
%   input, Y is a two value vector of the minimum and maximum values.  For a
%   matrix input, Y is a vector containing the minimum and maximum for each
%   column.  For N-D arrays, RANGE operates along the first non-singleton
%   dimension.
%
%   MINMAX treats NaNs as missing values, and ignores them.
%
%   Y = MINMAX(X,DIM) operates along the dimension DIM.
%
%   See also RANGE, IQR, MAD, MAX, MIN, STD.

%   Paul Durack 15:13 3-4-2007

if nargin < 2
    y = [min(x), max(x)];
else
    y = [min(x,[],dim), max(x,[],dim)];
end

