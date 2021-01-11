function dates = fbusdate(y, m, hol, weekend)
%FBUSDATE First business date of month.
%
%   D = fbusdate(Y, M)
%   D = fbusdate(Y, M, HOL, WEEKEND)
%
%   Optional Inputs: HOL, WEEKEND
%
%   Inputs:
%         Y - Year (i.e. 2002)
%
%         M - Month (i.e. 12 <December>)
%
%   Optional Inputs:
%       HOL - A vector of non-trading day dates. If HOL is not specified, the
%             non-trading day data is determined by the routine HOLIDAYS. We
%             currently support NYSE holidays in HOLIDAYS.
%
%   WEEKEND - A vector of length 7 containing 0's and 1's that represent
%             non-weekend and weekend days respectively.  The first element of
%             WEEKEND always corresponds to Sunday. The default WEEKEND vector
%             is [1 0 0 0 0 0 1].
%
%   Outputs:
%         D - The first business day of the month(s) and year(s) specified.
%
%   Example:
%      D = fbusdate(1997, 11)
%      D =
%            729697   % November 03, 1997.
%
%   See also BUSDATE, EOMDATE, HOLIDAYS, ISBUSDAY, LBUSDATE.

% Copyright 1995-2005 The MathWorks, Inc.
% $Revision: 1.8.2.6 $   $Date: 2011/02/28 01:21:11 $

% Input validation
if nargin < 3 || isempty(hol)
    hol = holidays;
end

if nargin < 4 || isempty(weekend)
    weekend = [1 0 0 0 0 0 1];
end

if nargin < 2
    error(message('finance:fbusdate:tooFewInputs'))
end

if any(any(m > 12 | m < 1)) | (mod(m, 1) ~= 0) %#ok
    error(message('finance:fbusdate:invalidMonth'))
end

% Scalar expansion
if length(y)==1; y = y(ones(size(m))); end
if length(m)==1; m = m(ones(size(y))); end

% Check input dims
sizes = [size(y); size(m)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
    error(message('finance:fbusdate:invalidInputDims'))
end

% Get actual eom dates
dates = datenum(y, m, 1);

% Find the next business day.
nonBusdayIdx = ~isbusday(dates, hol, weekend);
if any(nonBusdayIdx)
    dates(nonBusdayIdx) = busdate(dates(nonBusdayIdx), 1, hol, weekend);
end


% [EOF]
