function ftbbasis()
%
%BASIS refers to the basis or day-count convention for a bond. Basis is
%normally written as a fraction where the numerator prescribes the
%method for determining the number of days between two dates, and the
%denominator prescribes the number of days in the year. For example, the
%numerator of "ACTUAL/ACTUAL" means that when determining the number of days
%between two dates, one must count the actual number of days. The denominator
%means that the actual number of days in the given year should be used in any
%calculations (i.e. either 365 or 366 days depending on whether the given
%year is a leap year). Possible values include:
%     1) Basis = 0 - actual/actual (default for most functions)
%     2) Basis = 1 - 30/360 SIA
%     3) Basis = 2 - actual/360
%     4) Basis = 3 - actual/365
%     5) Basis = 4 - 30/360 PSA
%     6) Basis = 5 - 30/360 ISDA
%     7) Basis = 6 - 30/360 European
%     8) Basis = 7 - actual/365 Japanese
%     9) Basis = 8 - actual/actual ISMA
%    10) Basis = 9 - actual/360 ISMA
%    11) Basis = 10 - actual/365 ISMA
%    12) Basis = 11 - 30/360 ISMA
%    13) Basis = 12 - actual/365 ISDA 


disp(' ');
disp('Type "help ftbbasis" for an explanation of BASIS');
disp(' ');

%   Copyright 1995-2006 The MathWorks, Inc.
%$Revision: 1.6.2.6 $   $Date: 2007/11/07 18:29:05 $

