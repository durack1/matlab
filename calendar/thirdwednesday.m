function [BeginDates, EndDates] = thirdwednesday(month, year)
%THIRDWEDNESDAY Third-Wednesday date given month and year.
%    This function will find the Third-Wednesday of a given
%    month and year.
%
%   [BeginDates, EndDates] = thirdwednesday(Month, Year)
%
%   Inputs:
%     Month - [Nx1] vector of delivery months for 
%             Eurodollar futures/Libor contracts.
%             
%      Year - [Nx1] vector of 4-digit delivery years for 
%             Eurodollar futures/Libor contracts corresponding to Month. 
%
%   Outputs:
%      BeginDates - Third-Wednesday of the Month and Year. This is also the
%                   beginning of the 3 month period contract.
%
%        EndDates - The end of the 3 month period contract.
%
%   Note: 1. All dates are returned as serial dates. Use DATESTR to 
%            convert them into string dates.
%         2. Duplicate dates will be returned when identical months and
%            years are supplied.
%
%   Example:
%      Months = [10; 10; 10];
%      Year = [2002; 2003; 2004];
%
%      [BeginDates, EndDates] = thirdwednesday(Months, Year)
%      
%      BeginDates =
%            731505
%            731869
%            732240
%      EndDates =
%            731597
%            731961
%            732332

%   Copyright 2002-2006 The MathWorks, Inc.
%   $Revision: 1.2.8.8 $  $Date: 2011/02/28 01:21:19 $

% Input check
if nargin ~= 2
    error(message('finance:thirdwednesday:invalidNumberOfInputs'));
end

if any(month > 12 | month < 1)
    error(message('finance:thirdwednesday:invalidMonth'));
end

% Defaults
n = 3;      % 3rd date
theDay = 4; % Wednesday (1-7 = Sun-Sat)

% Input vaidation (linear expansion)
[month, year] = finargsz(1, floor(month(:)), floor(year(:)));

% 3rd Wednesday
BeginDates = nweekdate(n, theDay, year, month);

% EndDates are exactly 3 months into the future. Libor uses act/360.
dtComp = datevec(BeginDates);
dtComp(:, 2) = dtComp(:, 2) + 3;
EndDates = datenum(dtComp);


% [EOF]
