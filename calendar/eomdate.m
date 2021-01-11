function d = eomdate(y,m) 
%EOMDATE Last date of month. 
%   D = EOMDATE(N) returns the last date of the month, in serial form,
%   given the date N.  N can be input as a serial date number or date
%   string.
%
%   D = EOMDATE(Y,M) returns the last date of the month, in serial
%   form, for the given year, Y, and month, M.  
% 
%   For example, d = eomdate(1997,2) returns d = 729449 which is the serial
%   date corresponding to February 28, 1997.
%
%   See also DAY, EOMDAY, LBUSDATE, MONTH, YEAR. 
 
%   Copyright 1995-2006 The MathWorks, Inc.
%        $Revision: 1.7.2.7 $   $Date: 2011/05/09 00:47:41 $

% Check number of input arguments
if nargin < 1
  error(message('finance:eomdate:missingInputs')) 
end 

% Date input
if nargin == 1
  [yr,mt] = datevec(y);
  ld = eomday(yr,mt);
  d = datenum(yr,mt,ld);
  return
end

% Year and month input
if any(m < 1) || any(m > 12)
    error(message('finance:eomdate:invalidMonth'))
end

if length(y)==1;y = y(ones(size(m)));end   % scalar expansion
if length(m)==1;m = m(ones(size(y)));end
if length(y)==1;y = y(ones(size(m)));end   
sizes = [size(y);size(m)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
  error(message('finance:eomdate:invalidInputDims'))
end

ld = eomday(y,m);
d = datenum(y,m,ld);
