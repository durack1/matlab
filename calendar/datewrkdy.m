function EndDate = datewrkdy(StartDate, NumberWorkDays, NumberHolidays) 
%DATEWRKDY Date of Future or Past Workday 
%
%   EndDate = datewrkdy(StartDate, NumberWorkDays, NumberHolidays)  
%
%   Summary: This function determines the date of a future or past date given
%              a number of days movement in terms of work days and holidays.
%
%   Inputs: 
%     StartDate - Nx1 or 1xN vector containing the date string or serial
%       date number for the start date
%     NumberWorkDays - Nx1 or 1xN vector containing values for the number
%       of work or business days movement into the future (if positive)
%       or past (if negative)
%     NumberHolidays - Nx1 or 1xN vector containing values for the number
%       of days movement in terms of holidays into the future (if positive)
%       or past (if negative)
%
%   Outputs: 
%     EndDate - Nx1 or 1xN vector containing the serial date number of the
%       resulting future or past date
%
%   Example: 
%     StartDate = '20-Dec-1994';
%     NumberWorkDays = 16;
%     NumberHolidays = 2;
%
%     datewrkdy(StartDate, NumberWorkDays, NumberHolidays)
%
%     returns:  
%
%     EndDate = 728671 (12-Jan-1995) 
% 
%   See also WRKDYDIF. 
  
%   Copyright 1995-2006 The MathWorks, Inc.
%$Revision: 1.10.2.6 $   $Date: 2011/02/28 01:21:06 $ 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 3)
     NumberHolidays = 0; 
end 
if (nargin < 2)
     error(message('finance:datewrkdy:missingInputs')) 
end

if (ischar(StartDate))
     StartDate = datenum(StartDate); 
end

if (abs(NumberHolidays) > abs(NumberWorkDays))
     error(message('finance:datewrkdy:tooManyHolidays'))
end

if ((sign(NumberHolidays) ~= sign(NumberWorkDays)) & ((NumberWorkDays ~= 0) & ...
          (NumberHolidays ~= 0)))
     error(message('finance:datewrkdy:signMismatch'))
end


%Get the size of all input arguments; scale up any scalars
sz = [size(StartDate); size(NumberWorkDays); size(NumberHolidays)]; 

if (length(StartDate) == 1)
     StartDate = StartDate * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(NumberWorkDays) == 1)
     NumberWorkDays = NumberWorkDays * ones(max(sz(:,1)), max(sz(:,2))); 
end 

if (length(NumberHolidays) == 1)
     NumberHolidays = NumberHolidays * ones(max(sz(:,1)), max(sz(:,2))); 
end 


%Make sure all input arguments are of the same size and shape
sizes = [size(StartDate); size(NumberWorkDays); size(NumberHolidays)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
     error(message('finance:datewrkdy:invalidInputDims'))
end


%get the shape of the inputs to reshape the output later
[RowSize, ColumnSize] = size(StartDate);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Preallocate the output variable
EndDate = zeros(size(StartDate));
     
for i = 1 : length(StartDate(:)) 
     %Create vector of serial dates
     Days = (StartDate(i) : sign(NumberWorkDays(i)) : StartDate(i) + NumberWorkDays(i)...
          * 3 + NumberHolidays(i))';
     
     %If number of working days is negative, flip vector from left to right
     if (sign(NumberWorkDays(i)) == -1)
          Days = fliplr(Days);
     end
     
     %Convert date numbers to weekday values
     DaysWeek = weekday(Days);
     
     %Lose Sat and Sun
     Weekdays = Days((DaysWeek ~= 1 & DaysWeek ~= 7));
     
     if (~isempty(Weekdays))
          %Index into Weekdays to find date.
          EndDate(i) = Weekdays(abs(NumberWorkDays(i)) + abs(NumberHolidays(i)));
     else
          EndDate(i) = StartDate(i);
     end
end

EndDate = reshape(EndDate, RowSize, ColumnSize); 


