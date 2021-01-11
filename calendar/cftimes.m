function TFactors = cftimes(varargin)
%CFTIMES Time to Cash Flow in Fractional Coupon Periods.  
%   This function determines the time factors for NUMBONDS fixed income
%   securities. The term "time factors" refers to the time to cash flow  
%   in fractional semi-annual coupon periods.
%
%   TFactors = cftimes(Settle, Maturity)
%
%   TFactors = cftimes(Settle, Maturity, Period, Basis, EndMonthRule,...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
%   TFactors = cftimes(Settle, Maturity,'Param1','Value1',...)
%
%   Optional Inputs: Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,
%                    LastCouponDate, StartDate, CompoundingFrequency, DiscountBasis
%   
%   Note:    
%   - All non-scalar or empty matrix input arguments must be either NUMBONDSx1
%     or 1xNUMBONDS conforming vectors.
%   - Fill unspecified entries in input vectors with NaN.
%   - Dates can be serial date numbers or date strings.
%   - Optional inputs can be specified as parameter value pairs.  If
%     LastCouponInterest, CompoundingFrequency or DiscountBasis are input,
%     optional inputs must be specified as parameter value pairs.
%     Otherwise, optional inputs may be specified by order according to the
%     help.
%   
%   Required Inputs:
%     Settle - Settlement date
%     Maturity - Maturity date
%
%   Optional Inputs:
%     Period - Coupons payments per year; default is 2
%     Basis - Day-count basis; default is 0 (actual/actual) 
%     EndMonthRule - End-of-month rule; default is 1 (in effect)
%     IssueDate - Bond issue date
%     FirstCouponDate - Irregular or normal first coupon date
%     LastCouponDate - Irregular or normal last coupon date
%     StartDate - Forward starting date of payments
%
%   Outputs: 
%     TFactors - Time to cash flow. TFactors will have NUMBONDS rows, and 
%     the number of columns will be determined by the maximum number of cash 
%     flow payment dates required to hold the bond portfolio. NaN's are padded 
%     for bonds which have less than the maximum number of cash flow payment dates.
%
%   See also CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%            CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CPNPERSZ.
 
%   Copyright 1995-2009 The MathWorks, Inc.
%   $Revision: 1.8.2.6 $   $Date: 2011/02/28 01:21:02 $ 

%Checking input arguments and set defaults
if (nargin < 2) 
     error(message('finance:cftimes:missingInputs'));
end 

%Call cfamounts to calculate the time factors
[~, ~, TFactors] = cfamounts(0, varargin{:});

% Strip the settlement date from the TFactors matrix.
TFactors = TFactors(:,2:end);


