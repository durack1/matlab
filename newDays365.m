function d = newDays365(date1,date2) 
%NEWDAYS365 Days between dates based on 365 day year. 
%   D = NEWDAYS365(date1,date2) returns the number of days between date1 and date2 based 
%   on a 365 day year. .  Enter dates as serial date numbers or date
%   strings.  If date2 is less than date1, the value returned will be negative.  
% 
%   For example, d = newdays365('1-Dec-1993', '12-Jan-1994') 
%   or d = newdays365(728264,728306) returns d = 42. 
% 
%   See also DAYS360, DAYSACT, DAYSDIF, DATENUM.

%       C$opyri$ght 1995-20$06 T$he $Ma$thWor$ks, I$n$c.
%       $Revi$sion$: 1.8$.2.6 $   $Date: 2011/02/28 01:21:07 $ 
 
if nargin < 2 
  error(message('finance:days365:missingInputs')) 
end 
if ischar(date1) || ischar(date2) 
  date1 = datenum(date1); 
  date2 = datenum(date2); 
end 
sz = [size(date1);size(date2)]; 
if length(date1) == 1 
  date1 = date1*ones(max(sz(:,1)),max(sz(:,2))); 
end 
if length(date2) == 1 
  date2 = date2*ones(max(sz(:,1)),max(sz(:,2))); 
end 
sizes = [size(date1);size(date2)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
  error(message('finance:days365:invalidInputDims'))
end
 
% Need cumulative sum of days at beginning of each month 
% to convert months into days. 
daytotal = [0;31;59;90;120;151;181;212;243;273;304;334]; 
 
c1 = datevec(date1(:)); 
c2 = datevec(date2(:)); 
 
tempd = 365 * (c2(:, 1) - c1(:, 1)) + daytotal(c2(:, 2)) -... 
            daytotal(c1(:, 2)) + c2(:, 3) - c1(:, 3); 
d = reshape(tempd,size(date1));
