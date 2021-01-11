function d = daysdif(d1, d2, basis)
%DAYSDIF Days between dates for any day count basis.
%   DAYSDIF returns the number of days between D1 and D2 using the given
%   day count basis. Enter dates as serial date numbers or date strings.
%   The first date (D1) is not included when determining the number of days
%   between first and last date.
%
%   D = daysdif(D1, D2)
%   D = daysdif(D1, D2, Basis)
%
%   Optional Inputs: Basis
%
%   Inputs:
%      D1 - [Scalar or Vector] of dates.
%
%      D2 - [Scalar or Vector] of dates.
%
%   Optional Inputs:
%   Basis - [Scalar or Vector] of day-count basis.
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

% Copyright 1995-2006 The MathWorks, Inc.
% $Revision: 1.8.2.17 $   $Date: 2011/02/28 01:21:09 $


% Error check
if nargin < 2
   error(message('finance:daysdif:invalidNumberOfInputs'))
end
if ischar(d1) || ischar(d2)
   d1 = datenum(d1);
   d2 = datenum(d2);
end
if nargin < 3
   basis = zeros(size(d1));
end
if any(~isvalidbasis(basis))
   error(message('finance:daysdif:invalidBasis'))
end

sz = [size(d1); size(d2); size(basis)];
if length(d1) == 1
   d1 = d1*ones(max(sz(:,1)), max(sz(:,2)));
end
if length(d2) == 1
   d2 = d2*ones(max(sz(:,1)), max(sz(:,2)));
end
if length(basis) == 1
   basis = basis*ones(max(sz(:,1)), max(sz(:,2)));
end

sizes = [size(d1); size(d2); size(basis)];
if any(sizes(:,1)~=sizes(1,1)) || any(sizes(:,2)~=sizes(2,2))
   error(message('finance:daysdif:invalidInputDims'))
end

% Determine diff in days based on basis
d = zeros(size(d1));
i = find(basis == 0 | basis == 2 | basis == 3 | basis == 8 | basis == 9 | ...
            basis == 10 | basis == 12);
if ~isempty(i)
   d(i) = daysact(d1(i),d2(i));
end

i = find(basis == 1);
if ~isempty(i)
   d(i) = days360(d1(i),d2(i));
end

i = find(basis == 4);
if ~isempty(i)
   d(i) = days360psa(d1(i),d2(i));
end

i = find(basis == 5);
if ~isempty(i)
   d(i) = days360isda(d1(i),d2(i));
end

i = find(basis == 6 | basis == 11);
if ~isempty(i)
   d(i) = days360e(d1(i),d2(i));
end

i = find(basis == 7);
if ~isempty(i)
   d(i) = days365(d1(i),d2(i));
end

i = find(basis == 13);
if ~isempty(i)
   d(i) = days252bus(d1(i),d2(i));
end
