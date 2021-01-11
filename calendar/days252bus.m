function numdays = days252bus(d1,d2,holvec)
% DAYS252BUS Number of business days between dates
%
%   DAYS252BUS computes the number of business days (i.e.: non-holiday, 
%   non-weekend) between the two input dates.  Note that a holiday vector
%   may be optionally specified -- if it is not, then the HOLIDAYS.m file
%   is used to determine the holidays.
%
%   NumberDays = days252bus(StartDate, EndDate)
%
% Inputs: 
%   StartDate - Nx1 or 1xN vector or scalar value, in either serial date
%     number or date string form, representing the start date
%   EndDate - Nx1 or 1xN vector or scalar value, in either serial date
%     number or date string form, representing the end date
%   HolidayVector (Optional) - Nx1 or 1xN vector, in either serial date
%     number or date string form, representing holidays
% 
% Outputs: 
%   NumberDays - Nx1 or 1xN vector or scalar value for the number of
%     days between two dates
%
% Example: 
%
%   NumberDays = days252bus('1/1/2009', '8/1/2009')
%
%   returns:
%
%   NumberDays = 145
%
% See also DAYS360SIA, DAYS360PSA, DAYS365, DAYSACT, DAYSDIF.

%       Copyright 1995-2009 The MathWorks, Inc.
%$Revision: 1.1.6.5 $   $Date: 2010/11/08 02:21:40 $ 

if nargin < 2 
    error(message('finance:days252bus:missingInputs'));
end

if nargin == 2
    holvec = [];
end

d1 = datenum(d1);
d2 = datenum(d2);

sz1 = length(d1);
sz2 = length(d2);

if sz1 ~=1 && sz2 ~=1
    if sz1 ~= sz2
        error(message('finance:days252bus:mismatchDateVectors'))
    end
end

if sz1 == 1 
     d1 = d1*ones(sz2,1);
end

if sz2 == 1 
     d2 = d2*ones(sz1,1);
end

% Loop through each case
nRows = max(sz1,sz2);
numdays = zeros(nRows,1);
for loopidx=1:nRows
    numdays(loopidx) = length(busdays(d1(loopidx),d2(loopidx),'d',holvec)) - 1;
end