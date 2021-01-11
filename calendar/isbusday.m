function t = isbusday(varargin)
%ISBUSDAY True for dates that are business days.
%
% T = ISBUSDAY(Date, Holiday, Weekend)
%
% Inputs:
%        
%   Date    - a vector of dates in question.  Dates are assumed to be whole
%             date numbers or date stamps with no fractional or time
%             values.
%
% Optional Inputs:
%
%   Holiday - a user-defined vector of holidays. The default
%             is a predefined US holidays (in holidays.m)
%
%   Weekend - a vector of length 7, containing 0 and 1, with
%             the value of 1 to indicate weekend day(s). 
%             The first element of this vector corresponds 
%             to Sunday. 
%             Thus, when Saturday and Sunday are weekend
%             then WEEKEND = [1 0 0 0 0 0 1]. The default
%             is Saturday and Sunday weekend.
%
% Outputs:
%
%   T       - 1 if Date is business day and 0 if otherwise.
%
%   For example
%
%   Date = ['15 feb 2001'; '16 feb 2001'; '17 feb 2001'];
%
%   To instruct MATLAB to find the business day, with Sunday weekend only,
%   using the predefined US holiday vector (from holidays.m):
%
%   Busday = isbusday(Date, [], [1 0 0 0 0 0 0])
%
%   See also BUSDATE, FBUSDATE, HOLIDAYS, LBUSDATE. 

%   Copyright 1995-2010 The MathWorks, Inc.
%   $Revision: 1.8.2.9 $   $Date: 2010/10/08 16:42:51 $

%------------------------------------------------------------------------
% Checking input arguments
%------------------------------------------------------------------------
if (nargin < 1)
  error(message('finance:isbusday:NotEnoughArgs'))
end

% Convert to serial date number

if ischar(varargin{1})
  d = floor(datenum(varargin{1}));
else
  d = floor(varargin{1}(:));
end

% find the tabulated holidays - type "edit holidays" for complete listing
if nargin < 2 || isempty(varargin{2})
  h = holidays;
else
  if ischar(varargin{2})
    h = datenum(varargin{2});                   % Convert hol to date numbers if necessary
  else
    h = varargin{2}(:);                         % Make sure that hol is column vector
  end
  h = sort(h);
end

if nargin < 3 || isempty(varargin{3})
    wday = [1 0 0 0 0 0 1];
else
    %check for correct inputs: Size and Values
    if length([find(varargin{3}(:)==0);find(varargin{3}(:)==1)]) ~= 7 || all(size(varargin{3})~=1) || length(varargin{3}(:)) ~= 7
        error(message('finance:isbusday:InvalidSize'));
    end    
    wday = varargin{3}(:);
end


t = ones(size(d));                      % Initialize output matrix
DoW = weekday(d);                       % Find weekday number for elements of D

weindex = find(wday==1);                % Find which are the weekends

if ~isempty(weindex)
    
    WE_Ind = find(DoW == weindex(1));
    
    if length(weindex) > 1
    
        for i = 2:length(weindex)
            % Find Saturdays and Sundays (default), or any other weekend style, based on user input WEEKDAY
            WE_Ind = [WE_Ind ; find(DoW == weindex(i))];
        end
        
    end
    
    t(WE_Ind) = zeros(size(WE_Ind));        % Sat/Sun are zeros
    
end

% Now check for holidays
hpre = find(h < min(d));                % Find holidays preceding date data
hsuf = find(h > max(d));                % Find holidays following date data
if ~isempty(h)
  h(hpre) = [];                         % Set irrelevant data to null
end
if ~isempty(h)
  h(hsuf-length(hpre)) = [];
  num_h = length(h);                    % Find number of holidays in range
  for i = 1:num_h                       % Set t corresponding to holiday to 0
     H_ind = find(d == h(i));
     t(H_ind) = zeros(size(H_ind));
  end
end

% finally, use LOGICAL to convert ones and zeros to logical indices:
t = logical(t);
