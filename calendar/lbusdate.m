function dates = lbusdate(y, m, hol, weekend)
%LBUSDATE Last business date of month.
%
%   D = lbusdate(Y, M)
%   D = lbusdate(Y, M, HOL, WEEKEND)
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
%         D - The last business day of the month(s) and year(s) specified.
%
%   Example:
%      D = lbusdate(1997, 5)
%      D =
%            729540   % May 30, 1997
%
%   See also BUSDATE, EOMDATE, FBUSDATE, HOLIDAYS, ISBUSDAY.

% Copyright 1995-2005 The MathWorks, Inc.
% $Revision: 1.7.2.6 $   $Date: 2011/02/28 01:21:13 $

% Input validation
if nargin < 3 || isempty(hol)
    hol = holidays;
end

if nargin < 4 || isempty(weekend)
    weekend = [1 0 0 0 0 0 1];
end

if nargin < 2
    error(message('finance:lbusdate:tooFewInputs'))
end

if any(any(m > 12 | m < 1)) | (mod(m, 1) ~= 0) %#ok
    error(message('finance:lbusdate:invalidMonth'))
end

% Scalar expansion
if length(y)==1; y = y(ones(size(m))); end
if length(m)==1; m = m(ones(size(y))); end

% Check input dims
sizes = [size(y); size(m)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
    error(message('finance:lbusdate:invalidInputDims'))
end

% Get actual eom dates
dates = eomdate(y, m);

% Find the previous business days.
nonBusdayIdx = ~isbusday(dates, hol, weekend);
if any(nonBusdayIdx)
  dates(nonBusdayIdx) = busdate(dates(nonBusdayIdx), -1, hol, weekend);
end


% [EOF]
