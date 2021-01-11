function [YearFraction] = yearfrac(Date1, Date2, Basis)
%YEARFRAC Fraction of Year Between Dates.
%   This function determines the fraction of a year occurring between two
%   dates based on the number days between those dates using a specified
%   day count basis.
%
%   [YearFraction] = yearfrac(Date1, Date2, Basis)
%
%   Inputs:
%   Date1 - [Nx1 or 1xN] vector containing values for Date 1 in either date
%           string or serial date form
%
%   Date2 - [Nx1 or 1xN] vector containing values for Date 2 in either date
%           string or serial date form
%
%   Basis - [Nx1 or 1xN] vector containing values that specify the Basis for
%           each set of dates.
%
%           Possible values include:
%           0 - actual/actual(default)
%           1 - 30/360 SIA
%           2 - actual/360
%           3 - actual/365
%           4 - 30/360 PSA
%           5 - 30/360 ISDA
%           6 - 30/360 European
%           7 - actual/365 Japanese
%           8 - actual/actual ISMA
%           9 - actual/360 ISMA
%          10 - actual/365 ISMA
%          11 - 30/360 ISMA
%          12 - actual/365 ISDA
%          13 - bus/252
%
%   Outputs:
%   YearFraction - [Nx1 or 1xN] vector of real numbers identifying the
%                  interval, in years, between Date1 and Date2.
%
%   See also: YEAR

% Copyright 1995-2006 The MathWorks, Inc.
% $Revision: 1.15.2.14 $   $Date: 2011/02/28 01:21:23 $

% Check the number of arguments being passed in and set defaults
if nargin < 3
    Basis = 0;
end

if nargin < 2
    error(message('finance:yearfrac:tooFewInputs'))
end

% Parse inputs as necessary
if ischar(Date1) || iscell(Date1)
    Date1 = datenum(Date1);
end

if ischar(Date2) || iscell(Date2)
    Date2 = datenum(Date2);
end

% Parse Basis argument
if ischar(Basis)
    Basis = str2double(Basis);
end

if any(~isvalidbasis(Basis))
    error(message('finance:yearfrac:invalidBasis'))
end

% Scalar expansion
try
    [Date1, Date2, Basis] = finargsz('scalar', Date1, Date2, Basis);

catch E
    error(message('finance:yearfrac:invalidInputDims', E.message));
end

% Preallocate the output variable
YearFraction = zeros(size(Date1));

% Find cases where Basis is actual/actual and determine the year fraction
Ind = find(Basis == 0 | Basis == 8);
if (~isempty(Ind))
    YearFraction(Ind) = daysact(Date1(Ind), Date2(Ind)) ./...
        daysact(datenum(year(Date1(Ind)), month(Date1(Ind)), ...
        day(Date1(Ind))), ...
        datenum(year(Date1(Ind)) + 1, month(Date1(Ind)), ...
        day(Date1(Ind))));
end

% Find cases where Basis is 30/360 and determine the year fraction
Ind = find(Basis == 1);
if (~isempty(Ind))
    YearFraction(Ind) = days360(Date1(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is actual/360 and determine the year fraction
Ind = find(Basis == 2 | Basis == 9);
if (~isempty(Ind))
    YearFraction(Ind) = daysact(Date1(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is actual/365 and determine the year fraction
Ind = find(Basis == 3 | Basis == 10);
if (~isempty(Ind))
    YearFraction(Ind) = daysact(Date1(Ind), Date2(Ind)) ./ 365;
end

% Find cases where Basis is 30/360 PSA and determine the year fraction
Ind = find(Basis == 4);
if (~isempty(Ind))
    YearFraction(Ind) = days360psa(Date1(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is 30/360 ISDA and determine the year fraction
Ind = find(Basis == 5);
if (~isempty(Ind))
    YearFraction(Ind) = days360isda(Date1(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is 30/360 E and determine the year fraction
Ind = find(Basis == 6 | Basis == 11);
if (~isempty(Ind))
    YearFraction(Ind) = days360e(Date1(Ind), Date2(Ind)) ./ 360;
end

% Find cases where Basis is actual/365 Japanese and determine the year
% fraction
Ind = find(Basis == 7);
if (~isempty(Ind))
    YearFraction(Ind) = days365(Date1(Ind), Date2(Ind)) ./ 365;
end

% Find cases where Basis is actual/365 ISDA and determine the year
% fraction
Ind = find(Basis == 12);
if (~isempty(Ind))
    D1_frac = (1 + daysact(Date1(Ind),datenum(year(Date1(Ind)),12,31))) ...
                        ./yeardays(year(Date1(Ind)));
    D2_frac = daysact(datenum(year(Date2(Ind)),1,1),Date2(Ind)) ...
                        ./yeardays(year(Date2(Ind)));
    YearFraction(Ind) = D1_frac + D2_frac - year(Date1(Ind)) + year(Date2(Ind))-1;
end

Ind = find(Basis == 13);
if (~isempty(Ind))
    YearFraction(Ind) = days252bus(Date1(Ind), Date2(Ind)) ./ 252;
end
