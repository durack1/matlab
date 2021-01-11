function date = daysadd(d1,num,basis)
%DAYSADD Date from a starting date for any day count basis.
%   DAYSADD returns a date, NUM number of days from D1, using the given
%   day count BASIS. Enter dates as serial date numbers or date strings.
%
%   Date = daysadd(D1, NUM)
%   Date = daysadd(D1, NUM, BASIS)
%
%   Optional Inputs: BASIS
%
%   Inputs:
%      D1    - NDATESx1 or 1xNDATES matrix of serial date or date strings
%      NUM   - NNUMx1 or 1xNNUM matrix of integer number of days.
%
%   Optional Inputs:
%      BASIS - NBASISx1 or 1xNBASIS matrix of day-count basis.
%
%      Valid Basis are:
%            0 = actual/actual (default)
%            1 = 30/360 SIA
%            2 = actual/360
%            3 = actual/365
%            4 - 30/360 PSA
%            5 - 30/360 ISDA
%            6 - 30/360 European
%            7 - act/365 Japanese
%            8 - act/act ISMA
%            9 - act/360 ISMA
%           10 - act/365 ISMA
%           11 - 30/360 ISMA
%           12 - act/365 ISDA
%           13 - bus/252
%
%   Output:
%      Date  -  Nx1 matrix of serial dates of new date
%
%   Note: Due to the nature of the 30/360 day-count basis, it may not be
%        possible to find the exact date, NUM number of days away because
%        of a known disconuity in the method of counting days.  A warning
%        will be displayed in that event.
%
%  Example:
%
%      startDt = datenum('5-Feb-2004');
%      num     = 26;
%      basis   = 1;
%
%      newDt   = daysadd(startDt,num,basis)
%
%      newDt   =
%               732007
%
%  See also DAYSDIF

% Copyright 1995-2010 The MathWorks, Inc.
% $Revision: 1.1.8.14 $   $Date: 2011/02/28 01:21:08 $

% Error check
if nargin < 2
    error(message('finance:daysadd:invalidNumberOfInputs'));
end
if ischar(d1) || iscell(d1)
    d1 = datenum(d1);
end

if any(rem(num,1)>0)
    error(message('finance:daysadd:invalidNumber'));
end

if nargin < 3
    basis = zeros(size(d1));
end

if any(~isvalidbasis(basis))
    error(message('finance:daysadd:invalidBasis'));
end

% columnize inputs
try
    [d1,num,basis] = finargsz(1, d1(:),num(:),basis(:));
catch ME
    throwAsCaller(ME)
end

% Add the number of days based on basis
date = zeros(size(d1));
% act/act, act/360, act/365, act/act ISMA
i = (basis == 0 | basis == 2 | basis == 3 | basis == 8 | basis == 9 | basis == 10 | basis == 12);
if any(i)
    date(i) = d1(i) + num(i);
end

isday1LeapYear = (mod(year(d1),4) == 0 & mod(year(d1),100) ~= 0) | mod(year(d1),400) == 0;
isday1_31 = day(d1) == 31;

% 30/360 SIA, 30/360 PSA, 30/360 ISDA, 30E/360
i = (basis == 1 | basis == 4 | basis == 5 | basis == 6 | basis == 11);

if any(i)
    
    % Modify any days that are 31 to be 30
    d1(i & isday1_31) = d1(i & isday1_31) - 1;
    
    % Modify d1 for PSA day count when d1 is Feb 28 or Feb 29
    Feb28Index = (basis == 1 | basis == 4) & day(d1) == 28 & month(d1) == 2 & ~isday1LeapYear;
    num(Feb28Index) = num(Feb28Index) + 2;
    
    Feb29Index = (basis == 1 | basis == 4) & day(d1) == 29 & month(d1) == 2 & isday1LeapYear;
    num(Feb29Index) = num(Feb29Index) + 1;
    
    numYears = fix(num(i)./360);
    numMonths = fix(rem(num(i),360)./30);
    numDays = rem(num(i),30);
    
    tmpNewDay = numDays+day(d1(i));
    newDay = tmpNewDay;
    monthAdd = zeros(size(tmpNewDay));
    
    dayOverFlow = tmpNewDay > 30;
    if any(dayOverFlow)
        newDay(dayOverFlow) = tmpNewDay(dayOverFlow) - 30;
        monthAdd(dayOverFlow) = 1;   
    end
    
    tmpNewMonth = monthAdd + numMonths + month(d1(i));
    
    newMonth = tmpNewMonth;
    yearAdd = zeros(size(tmpNewMonth));
    
    monthOverFlow = newMonth > 12;
    if any(monthOverFlow)
        newMonth(monthOverFlow) = tmpNewMonth(monthOverFlow) - 12;
        yearAdd(monthOverFlow) = 1;   
    end
    
    newYear = year(d1(i)) + numYears + yearAdd;
    
    isLeapYear = (mod(newYear,4) == 0 & mod(newYear,100) ~= 0) | mod(newYear,400) == 0;
    
    if any(newMonth == 2 & newDay == 30) || any(newMonth == 2 & newDay == 29 & ~isLeapYear)
        warning(message('finance:daysadd:noSuchDate'));
    end
    
    date(i) = datenum(newYear,newMonth,newDay);
    
end

% act/365 japanese
i = (basis == 7);
if any(i)
    date(i) = d1(i) + num(i);
    tmpDiff = days365(d1(i),date(i));
    if any(tmpDiff~=num(i))
        date(i) = date(i) + num(i) - tmpDiff;
    end
end

i = (basis == 13);
if any(i)
    tmpNewday = floor(d1(i) + num(i)*1.4);
    tmpDiff = days252bus(d1(i),tmpNewday);
    while any(tmpDiff~= num(i))
        tmpNewday = tmpNewday + num(i) - tmpDiff;
        tmpDiff = days252bus(d1(i),tmpNewday); 
    end
    baddayidx = ~isbusday(tmpNewday);
    tmpNewday(baddayidx) = busdate(tmpNewday(baddayidx),-1);
    date(i) = tmpNewday;
end
