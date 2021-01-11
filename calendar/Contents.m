% Financial Toolbox calendar functions.
%
% Current Time And Date.
%   now                - Current date and time.
%   today              - Current date.
%   
% Date and Time Components and Formats.
%   datefind           - Indices of date numbers in matrix.
%   datevec            - Date components.
%   day                - Day of month.
%   eomdate            - Last date of month.
%   eomday             - Last day of month.
%   hour               - Hour of date or time.
%   lweekdate          - Date of last occurrence of weekday in month.
%   minute             - Minute of date or time.
%   month              - Month of date.
%   months             - Number of whole months between dates.
%   nweekdate          - Date of specific occurrence of weekday in month.
%   second             - Second of date or time.
%   weekday            - Day of the week.
%   year               - Year of date.
%   yeardays           - Number of days in year.
%
% Date Conversion.
%   date2time          - Time and frequency from dates.
%   datedisp           - Display a matrix containing date number entries.
%   datenum            - Create date number.
%   datestr            - Create date string.
%   dec2thirtytwo      - Decimal quotation to thirty-second.
%   m2xdate            - MATLAB date to Excel date.
%   thirtytwo2dec      - Thirty-second quotation to decimal.
%   time2date          - Dates from time and frequency.
%   x2mdate            - Excel date to MATLAB date.   
%   
% Financial dates.
%   busdate            - Next or previous business day.
%   busdays            - Business days in serial date format.
%   datemnth           - Date of day in future or past month.
%   datewrkdy          - Date of future or past workday.
%   daysadd            - Days into future or past from any day count basis.
%   days252bus         - Business days between dates.
%   days360            - Days between dates based on 360 day year (SIA).
%   days360e           - Days between dates based on 360 day year (Europe).
%   days360isda        - Days between dates based on 360 day year (ISDA).
%   days360psa         - Days between dates based on 360 day year (PSA).
%   days365            - Days between dates based on 365 day year.
%   daysact            - Days between dates based on actual year.
%   daysadd            - Date away from a starting date for any day-count basis.
%   daysdif            - Days between dates for any day count basis.
%   fbusdate           - First business date of month.
%   holidays           - Holidays and non-trading days.
%   isbusday           - True for dates that are business days.
%   lbusdate           - Last business date of month.
%   thirdwednesday     - Third-Wednesday of the month.
%   wrkdydif           - Number of working days between dates.
%   yearfrac           - Fraction of year between dates.
%   
% Coupon bond dates.
%   accrfrac           - Accrued interest coupon period fraction.
%   cfamounts          - Cash flow amounts for a security.
%   cfdates            - Cash flow dates for a security.
%   cfport             - Portfolio form of cash flows.
%   cftimes            - Cash flow time factors for a security.
%   cpncount           - Coupons payable between dates.
%   cpndaten           - Next coupon date after date.
%   cpndatenq          - Next quasi-coupon date after date.
%   cpndatep           - Previous coupon date before date.
%   cpndatepq          - Previous quasi-coupon date before date.
%   cpndaysn           - Number of days between date and next coupon date.
%   cpndaysp           - Number of days between date and previous coupon date.
%   cpnpersz           - Size in days of period containing date.
%
%  Calendar (Graphical User Interface).
%   uicalendar         - Graphical calendar that interfaces with uicontrols.

% $Revision: 1.15.2.2 $   $Date: 2009/05/07 18:23:03 $
% Copyright 1995-2007 The MathWorks, Inc. 

% Exposed private functions
%   chkbonddateparams - used for cfprice and cfyield in finance 

% Private functions
%   scaleupvarg
