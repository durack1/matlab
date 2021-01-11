function NumCouponsRemaining = cpncount(varargin)
%CPNCOUNT Number of coupon payments remaining until maturity.
%   This function determines the number of coupon payments remaining from 
%   settlement until maturity for NBONDS fixed income securities.  
% 
%   NumCouponsRemaining = cpncount(Settle, Maturity)
%
%   NumCouponsRemaining = cpncount(Settle, Maturity, Period, Basis, ...
%          EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%          StartDate)
%
%   Inputs: All required inputs are NBONDS by 1 vectors or scalars.
%     Optional inputs can also be passed as empty matrices or omitted at 
%     the end of the argument list.  The value NaN in any optional input
%     invokes the default value for that entry.  Date arguments can be
%     serial date numbers or date strings.  For SIA bond argument descriptions,
%     type "help ftb".  For a detailed  description of a particular 
%     argument, for example Settle, type "help ftbSettle". 
%
%     Settle     (Required) - Settlement date.
%     Maturity   (Required) - Maturity date.
%   
%   Optional Inputs:
%     Period - Coupon frequency; default is "2" for semi-annual.
%     Basis  - Bond basis; default is "0" for Actual/Actual.
%     EndMonthRule - End of month rule; default is "1" meaning "in effect".
%     IssueDate - Date of issue and interest accrual.
%     FirstCouponDate - First actual coupon date.
%     LastCouponDate - Last actual coupon date.
%     StartDate - Starting date (Argument reserved for future implementation).
%
%
%   Outputs: 
%     NumCouponsRemaining - NBONDS x 1 vector containing the number of coupons
%     remaining after settlement. Coupons falling on or before settlement are
%     not counted, except for the maturity payment which is always counted.
%
%   See also CPNCDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, 
%            CPNPERSZ, CFDATES, CFAMOUTNS, ACCRFRAC, CFTIMES.
 
%   Copyright 1995-2006 The MathWorks, Inc.
%$Revision: 1.15.2.6 $   $Date: 2010/10/08 16:42:31 $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Checking the input arguments and set defaults
if (nargin < 2) 
  error(message('finance:cpncount:missingInputs'));
end 

% There are no default values for settle or maturity.
% Check to see if either or both settle and maturity are empty; if so set
% the output matrices to empties and return
if (isempty(varargin{1}) || isempty(varargin{2}))
  NumCouponsRemaining = [];
  return
end

[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
 FirstCouponDate, LastCouponDate, StartDate] = instargbondmod(0, varargin{:}); %#ok



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Call CFDATES to get the number of coupons remaining
CashFlowDates = cfdates(Settle, Maturity, Period, Basis,...
     EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, StartDate);


NotNaNMask = ~isnan(CashFlowDates);

NumCouponsRemaining = sum(NotNaNMask, 2);

%Reshape output
% NumCouponsRemaining = reshape(NumCouponsRemaining, RowSize, ColumnSize);

%end of function

