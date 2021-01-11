function d = nweekdate(n,wkd,y,m,g)
%NWEEKDATE Date of specific occurrence of weekday in month.
%   D = NWEEKDATE(N,WKD,Y,M,G) returns the serial date for a specific 
%   occurrence of a given weekday, in a given year and month.
%   N is the nth occurrence of the desired weekday, (an integer from 1 to 5),
%   WKD is the weekday, (1 through 7 equal Sunday through Saturday), Y is the
%   year, M is the month, and G is an optional specification of another weekday 
%   that must fall in the same week as WKD. The default value is G = 0.
%  
%   For example, to find the first Thursday in May 1997:
%
%   d = nweekdate(1,5,1997,5) returns d = 729511 which is
%       the serial date corresponding to May 01, 1997. 
%   
%   See also FBUSDATE, LBUSDATE, LWEEKDATE.

%   Copyright 1995-2006 The MathWorks, Inc.
%   $Revision: 1.8.2.5 $   $Date: 2011/02/28 01:21:17 $

if nargin < 4 
  error(message('finance:nweekdate:missingInputs')) 
end 

if nargin < 5
  g = 0;
end

if any(any(n > 5 | n < 1)) 
  error(message('finance:nweekdate:invalidOccurrence')) 
end 

if any(any(m > 12 | m < 1)) 
  error(message('finance:nweekdate:invalidMonth')) 
end 

if any(any(wkd > 7 | wkd < 1))
  error(message('finance:nweekdate:invalidWeekday'))
end 

if any(any(g > 7 | g < 0))
  error(message('finance:nweekdate:invalidWeekdayConstraint'))
end 


% Scalar expansion
if length(n)==1, n = n(ones(size(g))); end
if length(wkd)==1, wkd = wkd(ones(size(n))); end
if length(y)==1, y = y(ones(size(wkd))); end
if length(m)==1, m = m(ones(size(y))); end
if length(g)==1, g = g(ones(size(m))); end
if length(n)==1, n = n(ones(size(g))); end
if length(wkd)==1, wkd = wkd(ones(size(n))); end
if length(y)==1, y = y(ones(size(wkd))); end
if length(m)==1, m = m(ones(size(y))); end
sizes = [size(n);size(wkd);size(y);size(m);size(g)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
  error(message('finance:nweekdate:invalidInputDims'))
end
  
d = zeros(size(n));
for i = 1:length(n(:))
  prelim1 = -ones(42,1);
  prelim2 = prelim1;
  firsd = datenum(y(i),m(i),1);
  lastd = eomdate(y(i),m(i));
  stard = weekday(firsd);
  numdays = length(firsd:lastd);
  prelim1(stard:numdays+stard-1) = firsd:lastd; 
  prelim2(stard:numdays+stard-1) = weekday(firsd:lastd);
  dayind = find(prelim2 == wkd(i));
  tind = ceil(dayind/7);
  mint = min(tind);
  if g(i) == 0 | wkd(i) < g(i)
    minat = mint;
  else
    adayind = find(prelim2 == g(i));
    atind = ceil(adayind/7);
    minat = min(atind);
  end
  if mint ~= minat
    if max(tind) < n(i)+1
      d(i) = 0;
    else
      d(i) = prelim1(dayind(n(i)+1));
    end
  else
    if max(tind) < n(i) | length(dayind) < n(i)
      d(i) = 0;
    else
      d(i) = prelim1(dayind(n(i)));
    end
  end
end
