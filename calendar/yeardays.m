function nd = yeardays(y, basis)
%YEARDAYS Number of days in year.
%
%   ND = YEARDAYS(Y)
%   ND = YEARDAYS(Y, Basis)
%
%   Optional Inputs: Basis
%
%   Inputs:
%   Y     - [Scalar or Vector] of year(s).
%           For example:
%              Y = 1999;
%              Y = 1999:2010;
%
%   Optional Inputs:
%   Basis - [Scalar or Vector] of day count convention(s) to be used.
%           Possible values are:
%              0 - actual/actual   (default)
%              1 - 30/360 SIA
%              2 - actual/360
%              3 - actual/365
%              4 - 30/360 PSA
%              5 - 30/360 ISDA
%              6 - 30/360 European
%              7 - actual/365 Japanese
%              8 - actual/actual ISMA
%              9 - actual/360 ISMA
%             10 - actual/365 ISMA
%             11 - 30/360 ISMA
%             12 - actual/365 ISDA
%             13 - bus/252
%
%   Outputs:
%   ND    - [Scalar or Vector] of the number of days in year Y.
%
%   For example:
%      >> nd = yeardays(2000)
%
%      nd =
%
%         366
%
%   See also DAYS360, DAYS365, DAYSACT, YEAR, YEARFRAC.

%   Copyright 1995-2006 The MathWorks, Inc.
%   $Revision: 1.7.2.13 $   $Date: 2011/05/09 00:47:42 $

if ischar(y)
    error(message('finance:yeardays:invalidInput'));
end

if  nargin < 2 || isempty(basis)
    basis = 0;
end

% Check to see that years is a vector
[i, j] = size(y);
if (i ~= 1 && j ~= 1)
    error(message('finance:yeardays:invalidYDim'))
end

% Check to make sure that basis is the same length as years.
[ib, jb] = size(basis);
if numel(basis) ~= 1
    if (ib ~= 1 && jb ~= 1)
        error(message('finance:yeardays:invalidBasisDim'))
    end
    
    if numel(basis) ~= numel(y)
        error(message('finance:yeardays:invalidNumelBasis'))
    end
    
    if any(~isvalidbasis(basis))
        error(message('finance:yeardays:invalidBasis'))
    end
    
else
    
    if any(~isvalidbasis(basis))
        error(message('finance:yeardays:invalidBasis'));
    end
    
    % Linearly expand the basis
    basis = repmat(basis, i, j);
end

if any((mod(y,1)~=0))
    error(message('finance:yeardays:invalidYear'))
end

% Month and day values to pass to datenum function
mts_dys = ones(size(y));

% Next year values
next_y = y+1;

% Start date
first = datenum(y, mts_dys, mts_dys);

% End date
last = datenum(next_y, mts_dys, mts_dys);

% Initialize nd
nd = nan(size(first));

% Generate number of days in year.
bidx = (basis == 0 | basis == 8 | basis == 10 | basis == 12);
nd(bidx) = daysact(first(bidx), last(bidx));

bidx = (basis == 1 | basis == 2 | basis == 4 | basis == 5 | basis == 6 | basis == 9 | basis == 11);
nd(bidx) = days360(first(bidx), last(bidx));

bidx = (basis == 3 | basis == 7);
nd(bidx) = days365(first(bidx), last(bidx));