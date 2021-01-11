function mm = months(d1, d2, eom)
%MONTHS Number of whole months between dates.
%   Determine the number of whole months between dates.
%
%   MM = months((D1, D2)
%   MM = months((D1, D2, EOM)
%
%   Optional Inputs: EOM
%
%   Inputs:
%   D1  - Scalar, vector, or matrix of starting date(s).
%
%   D2  - Scalar, vector, or matrix of ending date(s).
%
%   Optional Inputs:
%   EOM - Determines if dates corresponding to the last day of the month are
%         treated as an additional whole month (EOM = 1, default) or not
%         (EOM = 0).
%
%   Outputs:
%   MM  - Scalar, vector, or matrix of the number of whole months between dates
%         D1 and D2.
%
%   Example:
%      mm = months('31-march-1997', '30-Jun-1997', 1)
%      mm =
%           3
%
%      mm = months('31-march-1997','30-Jun-1997', 0)
%      mm =
%           2
%
%   See also YEARFRAC.

%   Copyright 1995-2006 The MathWorks, Inc.
%   $Revision: 1.7.2.8 $   $Date: 2011/02/28 01:21:16 $

if nargin < 2
    error(message('finance:months:tooFewInputs'))
end

% Default EOM value is 1
if nargin < 3
    eom = 1;
end

if eom ~= 1 & eom ~= 0
    error(message('finance:months:invalidEOM'))
end

% Convert date strings if necessary
if ischar(d1) || ischar(d2)
    dat1 = datenum(d1);
    dat2 = datenum(d2);

elseif iscell(d1) || iscell(d2)
    try
        dat1 = datenum(d1);
        dat2 = datenum(d2);

    catch

        error(message('finance:months:invalidDateType'))
    end

else
    dat1 = d1;
    dat2 = d2;
end

% Scalar expansion
if length(dat1) == 1,   dat1    = dat1(ones(size(eom))); end
if length(dat2) == 1,   dat2    = dat2(ones(size(dat1))); end
if length(eom)  == 1,   eom     = eom(ones(size(dat2))); end
if length(dat1) == 1,   dat1    = dat1(ones(size(eom))); end

sizes = [size(dat1); size(dat2); size(eom)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
    error(message('finance:months:invalidInputDims'))
end

% Manipulate data for negative output
nindex = find(dat2 < dat1);
temp1 = dat1(nindex);
temp2 = dat2(nindex);
dat1(nindex) = temp2;
dat2(nindex) = temp1;

% Find the years and months between the specified dates
[year2, mont2, day2] = datevec(dat2);
[year1, mont1] = datevec(dat1);

yrs = (year2 - year1) * 12;
mts = mont2 - mont1;

% Find last day of month of D2
ld = eomday(year2, mont2);

% Do not subtract month if applicable
mincr = -ones(size(day2));
index = (day2 >= day(dat1) | (ld == day2 & eom == 1));
mincr(index) = 0;

% Months calculation
mm = mts + yrs + mincr;

% Make negative if D2 < D1
mm(nindex) = -mm(nindex) .* ones(size(nindex));


% [EOF]
