function [CFAmounts, CFDates, CFTimes, CFFlags, CFPrincipal] = cfamounts(CouponData,...
    Settle, Maturity, varargin)
%CFAMOUNTS Cash flow and time mapping for each bond of a portfolio.
%   CFAMOUNTS returns the cash flows, dates when cash flows occur, and the
%   times suitable for discounting coupons.
%
%  [CFlowAmounts, CFlowDates, TFactors, CFlowFlags, CFPrincipal] = cfamounts(...
%       CouponRate, Settle, Maturity)
%
%  [CFlowAmounts, CFlowDates, TFactors, CFlowFlags, CFPrincipal] = cfamounts(...
%       CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
%       IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face)
%
%  [CFlowAmounts, CFlowDates, TFactors, CFlowFlags, CFPrincipal] = cfamounts(...
%       CouponRate, Settle, Maturity,'Param1','Value1',...)
%
%   Optional Inputs: Period, Basis, EndMonthRule, IssueDate, FirstCouponDate,
%                    LastCouponDate, StartDate, Face, CompoundingFrequency,
%                    DiscountBasis, AdjustCashFlowsBasis, Holidays,
%                    BusinessDayConvention, PrincipalType
%
%     Note that optional inputs can be specified as parameter value pairs.  If
%     CompoundingFrequency, DiscountBasis, AdjustCashFlowsBasis, Holidays,
%     BusinessDayConvention or PrincipalType are input, optional inputs must
%     be specified as parameter value pairs. Otherwise, optional inputs may
%     be specified by order according to the help.
%
%     Further note that all inputs, or optional inputs, can be specified as
%     a structure array where each field corresponds to the input name.
%
%   Inputs: [Scalar or vector of size NBONDS x 1]
%     CouponRate - Decimal coupon rate; 0 for zero coupon bonds.  Coupon
%     rate can also be specified as a schedule as outlined below.
%
%     Settle     - Settlement date.
%
%     Maturity   - Maturity date.
%
%   Optional Inputs: [Scalar or vector of size NBONDS x 1]
%     Period         - Coupon frequency. The default is semi-annual (2).
%
%     Basis          - Values specifying the basis for each bond in the
%                      portfolio.
%                      Possible values are:
%                      0 - actual/actual (default)
%                      1 - 30/360 SIA
%                      2 - actual/360
%                      3 - actual/365
%                      4 - 30/360 PSA
%                      5 - 30/360 ISDA
%                      6 - 30E /360
%                      7 - actual/365 Japanese
%                      8 - actual/actual ISMA
%                      9 - actual/360 ISMA
%                     10 - actual/365 ISMA
%                     11 - 30/360 ISMA
%                     12 - actual/365 ISDA
%                     13 - bus/252
%
%    EndMonthRule    - End of month rule. The default is "1" meaning "in
%                      effect".
%
%    IssueDate       - Date of issue
%
%    FirstCouponDate - First actual coupon date.
%
%    LastCouponDate  - Last actual coupon date.
%
%    StartDate       - Forward starting date of payments.
%
%    Face            - Face value. The default is 100.  Face can also be
%                      specified as a schedule as outlined below.
%
%    CompoundingFrequency - Compounding frequency for yield calculation.  By
%                          default, SIA bases (0-7) and BUS/252 use a semi-annual
%                          compounding convention and ISMA bases (8-12) use
%                          an annual compounding convention.
%
%    DiscountBasis - Basis used to compute the discount factors for
%                   computing the yield.  The default behavior is for SIA
%                   bases to use the actual/actual day count to compute
%                   discount factors, and for ISMA day counts and BUS/252
%                   to use the specified basis.
%
%    AdjustCashFlowsBasis - Adjusts cash flows according to the accrual
%                   amount - default is false
%
%    Holidays - Holidays to be used in computing business days - default is
%              to use the holidays in holidays.m
%
%    BusinessDayConvention - Business day convention to be used in computing
%                           payment dates - possible values are actual (default),
%                           follow, modifiedfollow, previous, modifiedprevious
%
%    PrincipalType - Type of principal for case when a face schedule is
%                    specified. Either Sinking (default) or Bullet. If
%                    Sinking, principal is returned throughout the life of
%                    the bond, if bullet, principal is only returned at
%                    maturity.
%
%   Schedules, for Coupon Rate and Face, can be specified with an NBONDS x 1 cell array
%   where each element is a NumDates x 2 matrix or cell array where the first
%   column is dates (either MATLAB date numbers or strings) and the second column
%   is associated rates.  The date indicates the last day that the coupon rate
%   or face value is valid.
%
%   Outputs: Outputs are NBONDS by NCFS (number of cash flows) matrices.
%            Each row lists the cash flows for a particular bond.
%            Shorter rows are padded with the value NaN.
%
%      CFlowAmounts  - Cash flow amounts. First entry in each row vector is
%                      the (negative) accrued interest due at settlement.
%                      If no accrued interest is due, the first column is
%                      zero.
%
%      CFlowDates    - Cash flow dates in serial date number form.  At
%                      least two columns are always present: one for
%                      settlement and one for maturity.
%
%      TFactors      - Time factors for price/yield conversion.
%                      Time factor for SIA semi-annual price/yield
%                      conversion: DiscountFactor = (1 +
%                      Yield/2).^(-TFactor).  Time factors are in units of
%                      whole semi-annual coupon periods plus any fractional
%                      period using an Actual day count.
%
%      CFlowFlags    - Cash flow flags indicating the type of payment.
%
%      CFPrincipal   - Principal cash flows returned. For sinking principal
%                      this output indicates when the principal is
%                      returned.
%
%  References:  Standard Securities Calculations Methods: Fixed Income
%              Securities Formulas for Analytic Measures, SIA Vol 2, Jan
%              Mayle, (c) 1994
%
%  See also CFDATES, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%           CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.

%  Copyright 1995-2011 The MathWorks, Inc.
%  $Revision: 1.26.2.32 $   $Date: 2011/05/09 00:47:39 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%           ************* GET/PARSE INPUT(S) **************             %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check case to see if first input argument is a structure
if isstruct(CouponData)
    inStruct = CouponData;
    if ~all(ismember({'CouponRate','Settle','Maturity'},fields(inStruct)))
        error(message('finance:cfamounts:invalidStructure'));
    end
    CouponData = inStruct.CouponRate;
    Settle = inStruct.Settle;
    Maturity = inStruct.Maturity;
    inStruct = rmfield(inStruct,'Settle');
    inStruct = rmfield(inStruct,'Maturity');
    inStruct = rmfield(inStruct,'CouponRate');
    varargin{1} = inStruct;
else
    if (nargin < 3)
        error(message('finance:cfamounts:missingInputs'));
    end
end

% There are no default values for settle or maturity.
% Check to see if either or both settle and maturity are empty;
% if so set the output matrices to empties and return
if (isempty(Settle) || isempty(Maturity))
    CFAmounts = [];
    CFDates = [];
    CFTimes = [];
    CFFlags = [];
    return
end

% Check to see if CouponRate is a cell array
if iscell(CouponData)
    isCouponSchedule = true;
    CouponRate = ones(size(CouponData));
elseif isnumeric(CouponData)
    isCouponSchedule = false;
    CouponRate = CouponData;
else
    error(message('finance:cfamounts:invalidCouponRate'));
end

% Parse optional PV pairs here
if ~isempty(varargin)
    if ischar(varargin{1}) || isstruct(varargin{1})
        p = inputParser;
        
        p.addParamValue('discountbasis',NaN,@(x) all(isvalidbasis(x)));
        p.addParamValue('compoundingfrequency',NaN,@(x) all(ismember(x,[1 2 3 4 6 12])));
        
        p.addParamValue('period',[]);
        p.addParamValue('basis',[]);
        p.addParamValue('endmonthrule',[]);
        p.addParamValue('issuedate', []);
        p.addParamValue('firstcoupondate', []);
        p.addParamValue('lastcoupondate', []);
        p.addParamValue('startdate', []);
        p.addParamValue('face',[]);
        p.addParamValue('adjustcashflowsbasis',false,@islogical);
        p.addParamValue('principaltype',{'sinking'},...
            @(x) all(ismember(lower(x),{'sinking','bullet'})))
        p.addParamValue('holidays',[]);
        p.addParamValue('businessdayconvention',{'actual'},...
            @(x) all(ismember(x,{'actual','follow','previous','modifiedfollow',...
            'modifiedprevious'})));
        
        try
            p.parse(varargin{:});
        catch ME
            newMsg = message('finance:cfamounts:optionalInputError');
            newME = MException(newMsg.Identifier,getString(newMsg));
            newME = addCause(newME,ME);
            throw(newME)
        end
        
        Period = p.Results.period;
        Basis = p.Results.basis;
        EndMonthRule = p.Results.endmonthrule;
        IssueDate = p.Results.issuedate;
        FirstCouponDate = p.Results.firstcoupondate;
        LastCouponDate = p.Results.lastcoupondate;
        StartDate = p.Results.startdate;
        Face = p.Results.face;
        
        DiscBasis = p.Results.discountbasis;
        CompFreq = p.Results.compoundingfrequency;
        AdjustCashFlowsBasis = p.Results.adjustcashflowsbasis;
        Holidays = p.Results.holidays;
        BusinessDayConvention = cellstr(p.Results.businessdayconvention);
        PrincipalType = cellstr(p.Results.principaltype);
        
        % Check to see if Face is a cell array
        if iscell(Face)
            FaceData = Face;
            isFaceSchedule = true;
            Face = ones(size(FaceData));
        elseif isnumeric(Face)
            isFaceSchedule = false;
        else
            error(message('finance:cfamounts:invalidFace'));
        end
        
        [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
            FirstCouponDate, LastCouponDate, StartDate, Face] = ...
            instargbondmod(CouponRate, Settle, Maturity,Period,Basis,EndMonthRule, IssueDate, ...
            FirstCouponDate, LastCouponDate, StartDate, Face);
        
        [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
            FirstCouponDate, LastCouponDate, StartDate, Face,DiscBasis,...
            CompFreq,AdjustCashFlowsBasis,BusinessDayConvention,PrincipalType] = ...
            finargsz(1, CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
            FirstCouponDate, LastCouponDate, StartDate, Face,DiscBasis,...
            CompFreq,AdjustCashFlowsBasis,BusinessDayConvention,PrincipalType);
        
    else
        DiscBasis = NaN;
        CompFreq = NaN;
        AdjustCashFlowsBasis = false;
        isFaceSchedule = false;
        Holidays = NaN;
        BusinessDayConvention = {'actual'};
        
        % Check to see if Face is a cell array
        if nargin >= 11
            Face = varargin{8};
            if iscell(Face)
                FaceData = Face;
                isFaceSchedule = true;
                varargin{8} = ones(size(FaceData));
            elseif isnumeric(Face)
                isFaceSchedule = false;
            else
                error(message('finance:cfamounts:invalidFace'));
            end
        end
        
        [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
            IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face] = ...
            instargbondmod(CouponRate,Settle, Maturity, varargin{:});
        
        PrincipalType = repmat({'sinking'},size(CouponRate));
    end
else
    DiscBasis = NaN;
    CompFreq = NaN;
    
    AdjustCashFlowsBasis = false;
    isFaceSchedule = false;
    Holidays = NaN;
    BusinessDayConvention = {'actual'};
    PrincipalType = NaN;
    
    [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
        IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face] = ...
        instargbondmod(CouponRate,Settle, Maturity);
end

% Scalar expansion for possible coupon and face schedules
if isCouponSchedule
    [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
        FirstCouponDate, LastCouponDate, StartDate, Face,DiscBasis,...
        CompFreq,AdjustCashFlowsBasis,BusinessDayConvention,CouponData] = ...
        finargsz(1, CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
        FirstCouponDate, LastCouponDate, StartDate, Face,DiscBasis,...
        CompFreq,AdjustCashFlowsBasis,BusinessDayConvention,CouponData);
    
    MaturityCoupon = zeros(size(CouponData));
    
    % Determine the coupon rate at settlement for each bond
    for bondidx=1:length(CouponData)
        if isscalar(CouponData{bondidx})
            CouponRate(bondidx) = CouponData{bondidx};
        else
            % Sort if necessary
            tmpData = CouponData{bondidx};
            
            if size(tmpData,2) ~= 2
                error(message('finance:cfamounts:invalidCouponRate'));
            end
            
            % If cell array, convert to be numeric
            if iscell(tmpData)
                try
                    tmpData = [datenum(tmpData(:,1)) cell2mat(tmpData(:,2))];
                catch ME
                    newMsg = message('finance:cfamounts:invalidCouponRateSchedule');
                    newME = MException(newMsg.Identifier,getString(newMsg));
                    newME = addCause(newME,ME);
                    throw(newME)
                end
            end
            
            % Check for duplicate dates
            if length(unique(tmpData(:,1))) ~= size(tmpData,1)
                error(message('finance:cfamounts:duplicateCouponDates'));
            end
            
            if ~issorted(tmpData(:,1))
                [newDates,newidx] = sort(tmpData(:,1));
                CouponData{bondidx} = [newDates tmpData(newidx,2)];
                tmpData = CouponData{bondidx};
            end
            
            % Check to make sure last date is on or after maturity
            if tmpData(end,1) < Maturity(bondidx)
                error(message('finance:cfamounts:incompleteCouponSchedule'));
            end
            
            % Set CouponRate to be a dummy value
            CouponRate(bondidx) = 1;
            
            % Find coupon rate at maturity
            maturityidx  = find(Maturity(bondidx) <= tmpData(:,1),1,'first');
            
            MaturityCoupon(bondidx) = tmpData(maturityidx,2);
        end
    end
end

if isFaceSchedule
    [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
        FirstCouponDate, LastCouponDate, StartDate, Face,DiscBasis,...
        CompFreq,AdjustCashFlowsBasis,BusinessDayConvention,CouponData,FaceData] = ...
        finargsz(1, CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
        FirstCouponDate, LastCouponDate, StartDate, Face,DiscBasis,...
        CompFreq,AdjustCashFlowsBasis,BusinessDayConvention,CouponData,FaceData);
    
    MaturityFace = zeros(size(FaceData));
    
    for bondidx=1:length(FaceData)
        if isscalar(FaceData{bondidx})
            Face(bondidx) = FaceData{bondidx};
        else
            % Sort if necessary
            tmpData = FaceData{bondidx};
            
            if size(tmpData,2) ~= 2
                error(message('finance:cfamounts:invalidFace'));
            end
            
            % If cell array, convert to be numeric
            if iscell(tmpData)
                try
                    tmpData = [datenum(tmpData(:,1)) cell2mat(tmpData(:,2))];
                catch ME
                    newMsg = message('finance:cfamounts:invalidFaceSchedule');
                    newME = MException(newMsg.Identifier,getString(newMsg));
                    newME = addCause(newME,ME);
                    throw(newME)
                end
            end
            
            if length(unique(tmpData(:,1))) ~= size(tmpData,1)
                error(message('finance:cfamounts:duplicateFaceDates'));
            end
            
            if ~issorted(tmpData(:,1))
                [newDates,newidx] = sort(tmpData(:,1));
                FaceData{bondidx} = [newDates tmpData(newidx,2)];
                tmpData = FaceData{bondidx};
            end
            
            % Check to make sure last date is on or after maturity
            if tmpData(end,1) < Maturity(bondidx)
                error(message('finance:cfamounts:incompleteFaceSchedule'));
            end
            
            % If sinking, then the face schedule values must be decreasing
            if strcmpi(PrincipalType(bondidx),'sinking') && ~issorted(flipud(tmpData(:,2)))
                error(message('finance:cfamounts:invalidSinkingFaceScheduleValues'));
            end
            
            % Set Face to be a dummy value
            Face(bondidx) = 1;
            
            % Find face at maturity
            maturityidx  = find(Maturity(bondidx) <= tmpData(:,1),1,'first');
            
            MaturityFace(bondidx) = tmpData(maturityidx,2);
        end
    end
end

% Record which outputs are requested
CFDatesRequest = (nargout >= 2);
CFTimesRequest = (nargout >= 3);
CFFlagsRequest = (nargout >= 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%             ************* GENERATE OUTPUT(S) **************            %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hit all the semi-annual dates when period is 0, 1, or 3
% Do not do this for Basis == 8, actual/actual ISMA
CommonPeriod = Period;
i = (~(isisma(Basis)) & Period == 3);
CommonPeriod(i) = 6;
i = (~(isisma(Basis)) & (Period == 1 | Period == 0));
CommonPeriod(i) = 2;
i = ((isisma(Basis)) & (Period == 0));
CommonPeriod(i) = 1;

%----------------------------------------------------------------------------
% Create padded date matrix (Settle - 1 year , Maturity + 1 year]
% CommonPeriod : Always has semi-annual dates (P=1,3,0) when Basis ~=
% 8,9,10,11
%
% PadCFDates : [NumBonds x PadCFCols] Padded common period quasi-dates
%              (Not including an unsynced maturity)
%----------------------------------------------------------------------------
% Create a padded matrix of coupon dates to figure time factors
% Roll back 1 year from Settlement in Actual/Actual basis
% Roll forward to get at least 1 coupon date after Maturity

NumEarlyDates = CommonPeriod;
NumLateDates = CommonPeriod;
PadCFDates = cfdatesq(Settle, Maturity, ...
    CommonPeriod, Basis, EndMonthRule, ...
    [], FirstCouponDate, LastCouponDate, ...
    NumEarlyDates, NumLateDates);

% Get the size of the Padded matrix
[NumBonds, PadCFCols] = size(PadCFDates);

%----------------------------------------------------------------------
% Create a mask of the actual dates and some bond-by-bond flags
%
% PadCFMask [NumBonds x PadCFCols] 1 if an actual cash flow date
% PadQDMask [NumBonds x PadCFCols] 1 if a c.f. quasi-date
%
% BondIsMatSynced [NumBonds x 1] 1 if maturity is synced
% BondIsZero      [NumBonds x 1] 1 if bond is a zero
% BondSkipsCFs    [NumBonds x 1] 1 if quasi-dates alternate in PadCFDates
% BondInLast      [NumBonds x 1] 1 if bond settles in last period
%
%----------------------------------------------------------------------
PadCFMask = true(NumBonds, PadCFCols);

% Kill entries which have no corresponding date
PadCFMask( isnan(PadCFDates) ) = false;

% Kill dates after the actual maturity date
PadCFMask( PadCFDates > Maturity(:,ones(1,PadCFCols)) ) = false;

% Kill dates after the actual last coupon date except maturity
if (~all(isnan(LastCouponDate)))
    AfterLCMask = ( PadCFDates > LastCouponDate(:,ones(1,PadCFCols)) );
    MaturityMask = ( PadCFDates == Maturity(:,ones(1,PadCFCols)) );
    
    PadCFMask( AfterLCMask & ~MaturityMask ) = false;
end

% Kill dates before the actual first coupon date
if (~all(isnan(FirstCouponDate)))
    PadCFMask( PadCFDates < FirstCouponDate(:,ones(1,PadCFCols)) ) = false;
end

% Kill dates before the actual starting Date
if (~all(isnan(StartDate)))
    PadCFMask( PadCFDates < StartDate(:,ones(1,PadCFCols)) ) = false;
end

% For zeros, kill dates before maturity
BondIsZero = ( Period==0 );
ZeroMask = BondIsZero(:, ones(1,PadCFCols));
PadCFMask( ZeroMask & (PadCFDates < Maturity(:,ones(1,PadCFCols))) ) = false;

% Remove alternating dates
BondSkipsCFs = ( (2*Period) == CommonPeriod );

% For Annual and Tri-annual bonds, every other time factor is not a
% quasi coupon date.  In cases where the coupon structure is synced to
% maturity and there is no odd last period, valid entries alternate
% back from maturity.  Otherwise you need to check if dates with
% CommonPeriod are actually coupon dates.
PadQDMask = true(NumBonds, PadCFCols);

if any(BondSkipsCFs)
    % Alternate back from the Maturity date if it is safe
    % An estimate of where is the Maturity date is only good for assuredly
    % Maturity synced bonds.  Otherwise Maturity could show up as a
    % quasi-coupon if First/LastCouponDate was 1/2 period off Maturity.
    % PadQDMask( BondSkipsCFs & ~BondCheckSync , end-1:-2:1 ) = 0;
    
    % Check the first date otherwise
    CkInd = find(BondSkipsCFs);
    if ~isempty(CkInd)
        RealQuasiDate = cpndatepq(PadCFDates(CkInd,1), Maturity(CkInd), ...
            Period(CkInd), Basis(CkInd), EndMonthRule(CkInd), [], ...
            FirstCouponDate(CkInd), LastCouponDate(CkInd));
        
        % The fake coupons are 2,4,6, ... if RealQuasiDate(i) == PadCFDates(i,1)
        I = (RealQuasiDate == PadCFDates(CkInd,1));
        PadQDMask( CkInd(I) , 2:2:end ) = false;
        
        % The fake coupons are 1,3,5, ... if RealQuasiDate(i) ~= PadCFDates(i,1)
        I = (RealQuasiDate ~= PadCFDates(CkInd,1));
        PadQDMask( CkInd(I) , 1:2:end ) = false;
    end
end

% Remove alternating dates from the actual cash flow dates
PadCFMask( ~PadQDMask ) = false;

% Look for the maturity date in the padded matrix after alternates are gone
CFMask = PadCFMask & ( PadCFDates == Maturity(:,ones(1,PadCFCols)) );
BondIsMatSynced = any( CFMask  , 2 );

% Kill dates on or before the actual settlement
% You do not get the cash flow on settlement
PadCFMaskNoSettle = PadCFMask;
PadCFMask( PadCFDates <= Settle(:,ones(1,PadCFCols)) ) = false;

% Check if there are any actual cash flow dates strictly before Maturity
% Bond settles in the last period if there are none
CFMask = PadCFMask & ( PadCFDates < Maturity(:,ones(1,PadCFCols)) );
BondInLast = ~any( CFMask, 2 );

%----------------------------------------------------------------------
% Create indices to change the padded matrices to non-padded matrices
%
% NumCFCols       [scalar] The squeezed matrices are NumBonds x NumCFCols
%                 after adding the accrued interest row.
%
% PadSqueezeMap   [NumEntries x 1]    : quasi-date cash flows
% SqueezeMap       [NumEntries x 1]    : quasi-date cash flows
% AddMatMap       [NumNonSynced x 1]  : non-synced maturity only
% BondAddMatMap   [NumNonSynced x 1]  : non-synced maturity only
% MatMap          [NumBonds x 1]      : all maturity
%
% For example, consider PadCFDates, CFDates, CFAmounts, Maturity, Settle, Face
% PadCFDates [NumBonds x PadCFCols]
% CFDates    [NumBonds x NumCFCols]
% CFAmounts  [NumBonds x NumCFCols]
% Maturity   [NumBonds x 1]
% Settle     [NumBonds x 1]
% Face       [NumBonds x 1]
%
% CFDates(:,1)        = Settle
% CFDates(SqueezeMap) = PadCFDates(PadSqueezeMap)
% CFDates(AddMatMap)  =   Maturity(BondAddMatMap)
%
% CFAmounts(MatMap) = CFAmounts(MatMap) + Face;
%
%----------------------------------------------------------------------

% Row and column within the Padded matrix (at locations in padded)
[RowInd, PadColInd] = ndgrid(1:NumBonds, 1:PadCFCols);

% Rows stay the same within the squeezed matrix
% column within the squeezed matrix (at locations in padded)
% columns are shifted back 1 to make room for accrued interest
ColInd = 1 + cumsum( PadCFMask , 2 );

% Create the mappings for all locations in padded
PadSqueezeMap = RowInd + NumBonds*(PadColInd - 1);
SqueezeMap = RowInd + NumBonds*(   ColInd - 1);

% Sample the mappings only where there is a real cash flow
PadSqueezeMap = PadSqueezeMap( PadCFMask );
SqueezeMap =    SqueezeMap( PadCFMask );

% Find out how many columns there are in the squeezed matrix
% Add one column if maturity is not in the padded matrix, unless maturity
% is excluded because settle falls on maturity
MaturityCol = ColInd(:,end) + ( ~BondIsMatSynced & (Settle ~= Maturity) );

% Find out where maturity would go in the squeezed matrix
MatMap = (1:NumBonds)' + NumBonds*(MaturityCol - 1);

% Sample the mapping only where there is unsynced maturity
AddMatMap = MatMap(~BondIsMatSynced);
BondAddMatMap = ~BondIsMatSynced;

% Record the number of columns in the squeezed matrix
NumCFCols = max(MaturityCol);

%----------------------------------------------------------------------
% Parse conditions for possible irregular first period, last period, and
% accrued interest fraction
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% Check if the bond settles in an irregular first period.
% Period is [IssueDate, CF1D] where CF1D is the first cash flow date
% strictly after Settlement
% We will need quasi-date before CF1D to check.
%
% settling in a long periods bounded by last coupon date is handled later
%
% BondHasCF1 [NumBonds x 1] : 1 if bond settles in an irregular first period
% CF1Flag : [NumBonds x 1] : CFlowFlag indicating status of irreg. CF1
%
% CF1D [NumBonds x 1] : First cash flow date after Settle
% CF1BackQD   [NumBonds x 1] : quasi-date before CF1D
%
% CF1BackQCol [NumBonds x 1] : column of CF1BackQD in PadCFDates
% CF1BackQInd [NumBonds x 1] : Index of CF1BackQD in PadCFDates
%
% CF1Col [NumBonds x 1] : column of CF1D in PadCFDates
% CF1Ind [NumBonds x 1] : Index of CF1D in PadCFDates
%
% IPrevQD [NumBonds x 1] : quasi-date <= Issue
% INextQD [NumBonds x 1] : quasi-date > Issue
%
% CF1QDates [(CF1Flag==2) x CFMCols] : extra quasi-dates from
% [INextQD to FirstCouponDate] to count periods in long last
%----------------------------------------------------------------------

% No special flags or dates are needed by default
CF1Flag = nan(NumBonds,1);
CF1D = nan(NumBonds,1);
CF1BackQD = nan(NumBonds,1);

% Determine if an irregular first period exists
BondHasCF1 = true(NumBonds,1) ;

% Zeros are out
BondHasCF1(BondIsZero) = false;

% Issue date must be present to consider an irregular first period
BondHasCF1(isnan(IssueDate)) = false;

% Check dates to determine nature of first period after settlement
if any(BondHasCF1)
    
    % Sweep for the location of the first cash flow entry
    CF1Col = nan(NumBonds,1);
    CF1Col(BondHasCF1) = findfirst(PadCFMask(BondHasCF1,:), 2);
    
    % Mark if there was no cash flows
    % (Settle==Maturity or unsynced last period)
    BondHasCF1(isnan(CF1Col)) = false;
    
    % The periodic quasi-date before the first cash flow date is located
    % either 1 or 2 back before the first cash flow date
    CF1BackQCol = CF1Col - 1 - BondSkipsCFs;
    
    % Use indices to extract the dates
    CF1Ind      = (1:NumBonds)' + NumBonds*(CF1Col - 1);
    CF1BackQInd = (1:NumBonds)' + NumBonds*(CF1BackQCol - 1);
    
    % Get the date where applicable
    CF1BackQD(BondHasCF1) = PadCFDates( CF1BackQInd(BondHasCF1) );
    CF1D(BondHasCF1)      = PadCFDates( CF1Ind(BondHasCF1) );
    
    % Check for a short first period (NaN comps always false)
    CF1Flag( IssueDate > CF1BackQD ) = 1;
    
    % Check for a long first period bounded by Issue
    CF1Flag( ( IssueDate < CF1BackQD ) & (FirstCouponDate==CF1D) ) = 2;
    
    % Update mask for irregular first period
    BondHasCF1 = ~isnan(CF1Flag);
    
end

% Get a bracket around Issue Date if the bond settles in an irregular
% first period.
IPrevQD = nan(NumBonds,1);
INextQD = nan(NumBonds,1);
if any(BondHasCF1)
    % look at short periods: bracketed by [CF1BackQD, CF1D]
    IPrevQD(CF1Flag==1) = CF1BackQD(CF1Flag==1);
    INextQD(CF1Flag==1) = CF1D(CF1Flag==1);
    
    % look at long periods
    Ind = (CF1Flag==2);
    if any(Ind)
        IPrevQD(Ind) = cpndatepq(IssueDate(Ind), Maturity(Ind), ...
            Period(Ind), Basis(Ind), EndMonthRule(Ind), ...
            [], FirstCouponDate(Ind), LastCouponDate(Ind));
        
        % compute extra quasi dates only when there is a long first period.
        CF1QDates = cfdates(IssueDate(Ind), FirstCouponDate(Ind), ...
            Period(Ind), Basis(Ind), EndMonthRule(Ind));
        
        % grab the quasi-date strictly after issue from CF1QDates
        INextQD(Ind) = CF1QDates(:,1);
    end
    
end

%----------------------------------------------------------------------
% Check if the bond has an irregular last period before maturity.
% If Maturity is synced to the coupon structure,
% 1) Issue date can create a short period, [IssueDate, Maturity] or
% 2) LastCouponDate can create a long period, [LastCouponDate, Maturity]
%
% If Maturity is not synced to the coupon structure, the last period is
% 1) short if the quasi-date before maturity is actually a c.f. date
%    [CFEndQ, Maturity]
% 2) long if the quasi-date is not a c.f. date [LastCouponDate, Maturity]
%
% BondHasCFM  [NumBonds x 1] : 1 if bond has an irregular last period
% CFMFlag : [NumBonds x 1] : CFlowFlag indicating status of Maturity cf
%
% Maturity is bracketed by CFMPrevQD and CFMNextQD
% If BondIsMatSynced = 1, CFMBackQD < CFMPrevQD = Maturity < CFMNextQD
% If BondIsMatSynced = 0, CFMBackQD = CFMPrevQD < Maturity < CFMNextQD
%
% CFMBackQD     [NumBonds x 1] : last quasi-date strictly before maturity
% CFMPrevQD     [NumBonds x 1] : last synced quasi-date <= maturity
% CFMNextQD     [NumBonds x 1] : first synced quasi-date > maturity
%
% CFMQDates [NumBonds x CFMCols] : extra quasi-dates from
%   [LastCouponDate to CFMNextQD] to count periods in long last Rows are
%   NaN unless CFMFlag=6
%----------------------------------------------------------------------

% Get columns of quasi-dates; Maturity location is needed for cf & flag
CFMask = PadQDMask & ( PadCFDates > Maturity(:,ones(1,PadCFCols)) );
CFMNextCol = findfirst( CFMask , 2 );

% Back up one quasi-period for the bracket
CFMPrevCol = CFMNextCol - (1 + BondSkipsCFs);

% Only back up again if Maturity==CFMPrevCol.
CFMBackCol = CFMPrevCol - (1 + BondSkipsCFs).*BondIsMatSynced;

% Compute indices for quasi-dates
CFMNextInd = (1:NumBonds)' + NumBonds*(CFMNextCol - 1);
CFMPrevInd = (1:NumBonds)' + NumBonds*(CFMPrevCol - 1);
CFMBackInd = (1:NumBonds)' + NumBonds*(CFMBackCol - 1);

% Put in this check to make sure that CFMBackInd is not 0
% This can occur when the Settle equals the Maturity
CFMBackInd = max(CFMBackInd,1);

% Pull out the quasi-dates themselves
CFMNextQD = PadCFDates( CFMNextInd );
CFMPrevQD = PadCFDates( CFMPrevInd );
CFMBackQD = PadCFDates( CFMBackInd );

% Usual flag is 4/7, short 5/8, long 6/9
CFMFlag = repmat(4,NumBonds,1);

% Determine if an irregular last period exists
BondHasCFM = true( NumBonds,1) ;

% Zeros are out
BondHasCFM(BondIsZero) = false;

% At least one of First, Last, or Issue date is required to create an
% irregular last period.
BondHasCFM( all(...
    isnan([ IssueDate, FirstCouponDate, LastCouponDate ]) , 2) ) = false;

% Look for short periods bounded by Issue
Ind = (BondHasCFM & BondIsMatSynced & (IssueDate > CFMBackQD) );
if any(Ind)
    CFMFlag(Ind) = 5;
end

% Look for long periods bounded by issue
Ind = ( (IssueDate < CFMBackQD) & (FirstCouponDate == Maturity) );
if any(Ind)
    CFMFlag(Ind) = 6;
end

% Look for short periods bounded by a cash flow
Ind = (BondHasCFM & ~BondIsMatSynced & PadCFMaskNoSettle(CFMPrevInd));
if any(Ind)
    CFMFlag(Ind) = 5;
end

% Look for long periods bounded by last
Ind = ( BondHasCFM & (LastCouponDate < CFMBackQD) );
if any(Ind)
    CFMFlag(Ind) = 6;
    
    % Create extra quasi-dates only for long last period to count the
    % number of whole periods before a maturity fraction
    CFMQDatesInd = cfdates(LastCouponDate(Ind), CFMNextQD(Ind), ...
        Period(Ind), Basis(Ind), EndMonthRule(Ind));
    
    % Pre-assign CFMQDates for speed
    CFMQDates = nan(NumBonds, size(CFMQDatesInd,2));
    
    % Assign dates to CFMQDates
    CFMQDates(Ind,:) = CFMQDatesInd;
end

% Update the cases where the last period is irregular
BondHasCFM( CFMFlag==4 ) = false;

% Adjust the flags if the bond is in it's last period
CFMFlag = CFMFlag + 3*BondInLast;

% Zeros are marked with 10
CFMFlag(BondIsZero) = 10;

%----------------------------------------------------------------------
% Check if accrued interest is regular
% Get a quasi-date bracket around settlement
%
% SPrevQD [NumBonds x 1] : quasi-date <= Settle
% SNextQD [NumBonds x 1] : quasi-date > Settle
%
%----------------------------------------------------------------------
CFMask = PadQDMask & ( PadCFDates > Settle(:,ones(1,PadCFCols)) );
SNextCol = findfirst( CFMask, 2 );
SPrevCol = SNextCol - ( 1 + BondSkipsCFs );

SNextInd = (1:NumBonds)' + NumBonds*(SNextCol - 1);
SPrevInd = (1:NumBonds)' + NumBonds*(SPrevCol - 1);

SPrevQD = PadCFDates( SPrevInd );
SNextQD = PadCFDates( SNextInd );

%----------------------------------------------------------------------
% Compute quantities
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% AICoupon = Face * CouponRate / Period;
% NominalCoupon = Face * CouponRate / Period (*)
%
% *For annual bonds actual/360, adjust the nominal coupon by 365/360
%----------------------------------------------------------------------
NominalCoupon = zeros(NumBonds,1);

% look at non-zero, non-nan coupon rates
Ind = ~BondIsZero & (CouponRate ~= 0);
NominalCoupon(Ind) = Face(Ind) .* CouponRate(Ind) ./Period(Ind);

AICoupon = NominalCoupon;

Ind = (Period==1 & Basis==2);
NominalCoupon(Ind) = NominalCoupon(Ind)*365/360;
%----------------------------------------------------------------------
% Accrued Interest
% AIFrac     [NumBonds x 1] = SettleFrac - IssueFrac + AIPeriods;
% SettleFrac [NumBonds x 1] : fraction of quasi-period before settle
% IssueFrac  [NumBonds x 1] : fraction of quasi-period before issue
% AIPeriods  [NumBonds x 1] : whole quasi-periods before settle
%----------------------------------------------------------------------

SettleFrac = zeros(NumBonds,1);
IssueFrac = zeros(NumBonds,1);
AIPeriods = zeros(NumBonds,1);

% SettleFrac is always needed as long as the bond is not a zero
% SPrevQD <= Settle < SNextQD

% Determine Normal Issue Date
% Need to convert Basis inputs into Rule for dateoffset
% Using only for actual/actual ISMA basis
OffsetRule = Basis;
i = (OffsetRule == 8);
OffsetRule(i) = 0;
j = (OffsetRule == 11);
OffsetRule(j) = 6;
k = (OffsetRule == 10);
OffsetRule(k) = 3;
if any(i | j | k)
    dateoffsetidx = i | j | k;
    [FCPYear,FCPMonth,FCPDay] = datevec(FirstCouponDate(dateoffsetidx));
    [NIDDay,NIDMonth,NIDYear] = dateoffset(FCPDay,FCPMonth,FCPYear,-(12./Period(dateoffsetidx)),OffsetRule(dateoffsetidx));
    NormalIssueDate = NaN*ones(size(FirstCouponDate));
    NormalIssueDate(dateoffsetidx) = datenum(NIDYear,NIDMonth,NIDDay);
end

Ind = (NominalCoupon ~= 0);
if any(Ind)
    SettleFrac(Ind) = daysdif(SPrevQD(Ind),  Settle(Ind), Basis(Ind)) ./ ...
        dayspersz(SPrevQD(Ind), SNextQD(Ind), Period(Ind),Basis(Ind));
end

% If Settle is in an irregular period created by issue,
% IPrevQD and INextQD have been created.
% IPrevQD <= Issue < INextQD
Ind = BondHasCF1;
if any(Ind)
    IssueFrac(Ind) = daysdif(IPrevQD(Ind), IssueDate(Ind), Basis(Ind)) ./ ...
        dayspersz(IPrevQD(Ind), INextQD(Ind), Period(Ind),Basis(Ind));
end

% If the first period is long, there could be extra periods
% Issue < CF1QDates(:,1)
Ind = (CF1Flag==2);
if any(Ind)
    
    CFMask = CF1QDates <= Settle(Ind, ones(1,size(CF1QDates,2)));
    AIPeriods(Ind) = sum( CFMask , 2 );
end

% There could also be a long period when lastcoupondate < settle
Ind = ( CFMFlag==9 ) & ~isnan(LastCouponDate);
if any(Ind)
    CFMask = CFMQDates(Ind,:) <= Settle(Ind, ones(1,size(CFMQDates,2)));
    AIPeriods(Ind) = sum( CFMask , 2 );
end

% Compute Accrued interest
AIFrac = (SettleFrac - IssueFrac);

% Compute accrued interest for special cases based on Basis argument
% actual/actual ISMA
if any(Basis == 8)
    
    % Normal Issue Date less than Issue Date
    i = (NormalIssueDate < IssueDate) & (Basis == 8) & (IssueDate > CF1BackQD);
    AIFrac(i) = (Settle(i) - IssueDate(i))./(INextQD(i) - IPrevQD(i));
    
    % Normal Issue Date greater than Issue Date and Settle greater than normal Issue Date
    i = ((NormalIssueDate > IssueDate) & (NormalIssueDate < Settle)) & (Basis == 8) ...
        & (IssueDate > CF1BackQD);
    AIFrac(i) = (INextQD(i) - IssueDate(i))./(INextQD(i) - IPrevQD(i)) + ...
        (Settle(i) - SPrevQD(i))./(SNextQD(i) - SPrevQD(i));
    
    % Normal Issue Date greater than Settle
    i = (NormalIssueDate > Settle) & (Basis == 8) & ~isnan(IssueDate);
    AIFrac(i) = (Settle(i) - IssueDate(i))./(SNextQD(i) - SPrevQD(i));
    
end

AccruedInterest = AIFrac .* AICoupon + ...
    AIPeriods .* NominalCoupon;

%----------------------------------------------------------------------
% First coupon payment before maturity
% Use the default values unless the payment is irregular (BondHasCF1).
% CF1Coupon  [NumBonds x 1] First coupon amount
% CF1Frac    [NumBonds x 1] = -IssueFrac + CF1Periods;
% IssueFrac  [NumBonds x 1] : fraction of quasi-period before issue
% CF1Periods [NumBonds x 1] : whole quasi-periods before first coupon
%----------------------------------------------------------------------

% IssueFrac is already computed in an irregular period
% IssueFrac already is set to zero otherwise

% There is normally 1 period elapsed in this coupon period
CF1Periods = ones(NumBonds,1);

% count long first periods
% CF1QDates is built IssueDate < CF1QDates <= FirstCouponDate
Ind = (CF1Flag==2);
if any(Ind)
    CF1Periods(Ind) = sum( ~isnan(CF1QDates) , 2 );
end

% compute first coupon amount
CF1Coupon = CF1Periods.*NominalCoupon - IssueFrac.*AICoupon;

%----------------------------------------------------------------------
% Coupon payment at maturity
% Non-issue bounded last periods are of length:
% CFMFrac = CFMPeriods - MaturityFrac
%
% Issue-bounded last period coupons are taken from CF1Coupon.
%
% In last period bounded by
% use default parameters
%
%----------------------------------------------------------------------

MaturityFrac = zeros(NumBonds,1);
CFMPeriods = ones(NumBonds,1);

% Pick up non-issue bounded irregular last periods
Ind = ( BondHasCFM & ~(BondHasCF1 & BondInLast) );
if any(Ind)
    % Find time in period cut off by early maturity
    MaturityFrac(Ind) = daysdif(Maturity(Ind),  CFMNextQD(Ind), Basis(Ind)) ...
        ./    dayspersz(CFMPrevQD(Ind), CFMNextQD(Ind), Period(Ind),Basis(Ind));
    
    % if the period is long, count whole periods after last coupon date
    IndLongLast = (Ind & ( CFMFlag==6 | CFMFlag==9 ));
    if any(IndLongLast)
        CFMPeriods(IndLongLast) = sum(~isnan(CFMQDates(IndLongLast,:)), 2);
    end
end

% Compute last period fraction good everywhere except issue-bounded
% irregular last (same as first) periods.

%Normal CFMFrac calculation
CFMFrac = CFMPeriods - MaturityFrac;

%ISMA - checking for long last coupon
LastCouponDate(LastCouponDate == Maturity) = NaN;
i = (isisma(Basis)) & (~isnan(LastCouponDate));
if any(i)
    
    %Get normal maturity date
    [LCDYear,LCDMon,LCDDay] = datevec(LastCouponDate(i));
    [NMDDay,NMDMon,NMDYear] = dateoffset(LCDDay,LCDMon,LCDYear,12./Period(i));
    NormalMaturityDate = datenum(NMDYear,NMDMon,NMDDay);
    
    %Get number of days in whole last two periods
    [NDAMDay,NDAMMon,NDAMYear] = dateoffset(NMDDay,NMDMon,NMDYear,12./Period(i));
    NextDateAfterMaturity = datenum(NDAMYear,NDAMMon,NDAMDay);
    FPDays = daysdif(LastCouponDate(i),NormalMaturityDate,Basis(i)).*Period(i);
    SPDays = daysdif(NormalMaturityDate,NextDateAfterMaturity,Basis(i)).*Period(i);
    
    %Calculate CMFrac for long last period
    CFMFrac(i) = daysdif(LastCouponDate(i),NormalMaturityDate,Basis(i))./ FPDays + daysdif(NormalMaturityDate,Maturity(i),Basis(i)) ./ SPDays;
    
end

CFMCoupon = NominalCoupon .* CFMFrac;

% In last period bounded by Issue if bond settles in its irregular first and
% the bond settles in the last period.  In that case, the first period
% and last period are the same, and first period is already computed.
Ind = ( BondHasCFM & (BondHasCF1 & BondInLast) );
if any(Ind)
    CFMCoupon(Ind) = CF1Coupon(Ind);
end

%----------------------------------------------------------------------
% Create padded cfamounts matrix
% PadCFAmounts [NumBonds x PadCFCols]
%----------------------------------------------------------------------

% Start with the nominal coupon
PadCFAmounts = NominalCoupon(:,ones(1,PadCFCols));

% Write in any special first coupon payment falling before Maturity
Ind = BondHasCF1 & ~BondInLast;
if any(Ind)
    PadCFAmounts( CF1Ind(Ind) ) = CF1Coupon(Ind);
end

%----------------------------------------------------------------------
% Create final cfamounts matrix
% Write in maturity directly
% Add accrued interest
%----------------------------------------------------------------------
CFAmounts = nan(NumBonds, NumCFCols);

% Write in coupons before maturity
CFAmounts(SqueezeMap) = PadCFAmounts(PadSqueezeMap);

% Write in maturity amount
CFAmounts(MatMap) = Face + CFMCoupon;

% Include negative accrued interest
CFAmounts(:,1) = -AccruedInterest;

% Use a convention that when Settle==Maturity, the settlement value is
% copied to the second column.  No coupon is paid, but you do get Face.
% This may expand the matrix columns
CFAmounts(Settle==Maturity,2) = Face(Settle==Maturity);

notactidx = find(~strcmpi(BusinessDayConvention,'actual'));
acfidx = find(AdjustCashFlowsBasis);

%----------------------------------------------------------------------
% Create final cfdates matrix if requested
% Write in unsynced maturity
%----------------------------------------------------------------------

% Check to see if we have a business day convention or cash flows from
% basis
if any(notactidx)
    % Loop through and call BUSDATE for each bond
    for jdx=1:length(notactidx)
        tmpIdx = notactidx(jdx);
        if any(~isbusday(PadCFDates(tmpIdx,:),Holidays))
            % Update PadCFDates for time factor computations
            PadCFDates(tmpIdx,~isbusday(PadCFDates(tmpIdx,:),Holidays)) = ...
                busdate(PadCFDates(tmpIdx,~isbusday(PadCFDates(tmpIdx,:),Holidays)),...
                BusinessDayConvention{tmpIdx},Holidays);
        end
    end
end

if CFDatesRequest || any(notactidx) || any(acfidx) || isCouponSchedule || isFaceSchedule
    CFDates = nan(NumBonds, NumCFCols);
    
    % Write in dates before maturity
    CFDates(SqueezeMap) = PadCFDates(PadSqueezeMap);
    
    % Write in maturity date
    CFDates(MatMap) = Maturity;
    
    % Include settlement for accrued interest
    CFDates(:,1) = Settle;
    
    % Use a convention that when Settle==Maturity, the settlement value is
    % copied to the second column.
    % This may expand the matrix columns
    CFDates(Settle==Maturity,2) = Settle(Settle==Maturity);
end

% Modify any cash flows that are computed with actual day count
if any(acfidx)
    for jdx=1:length(acfidx)
        tmpIdx = acfidx(jdx);
        [~,tmpMatIdx] = ind2sub(size(CFAmounts),MatMap(tmpIdx));
        tmpDates = CFDates(tmpIdx,2:tmpMatIdx);
        FixedTenor = yearfrac([SPrevQD(tmpIdx) tmpDates(1:end-1)],tmpDates,Basis(tmpIdx));
        CFAmounts(tmpIdx,2:tmpMatIdx) = Face(tmpIdx).*CouponRate(tmpIdx).*FixedTenor;
        CFAmounts(tmpIdx,tmpMatIdx) = CFAmounts(tmpIdx,tmpMatIdx).*CFMFrac(tmpIdx) + Face(tmpIdx);
    end
end


%----------------------------------------------------------------------
% Create padded cflowflags matrix if requested
%----------------------------------------------------------------------
if CFFlagsRequest || isCouponSchedule || isFaceSchedule
    
    % default is 3: a normal coupon
    PadCFFlags = repmat(3,NumBonds, PadCFCols);
    
    % Write in any special first coupon flag to a cash flow before maturity
    Ind = BondHasCF1 & ~BondInLast;
    if any(Ind)
        PadCFFlags( CF1Ind(Ind) ) = CF1Flag(Ind);
    end
    
    %----------------------------------------------------------------------
    % Create final cflowflags matrix if requested
    % Write in maturity and accrued interest
    %----------------------------------------------------------------------
    CFFlags = nan(NumBonds, NumCFCols);
    
    % Write in flags before maturity
    CFFlags(SqueezeMap) = PadCFFlags(PadSqueezeMap);
    
    % Write in maturity flag
    CFFlags(MatMap) = CFMFlag;
    
    % Include 0 for accrued interest
    CFFlags(:,1) = zeros(NumBonds,1);
    
    % Use a convention that when Settle==Maturity, the payment value is
    % copied to the second column.
    % This may expand the matrix columns
    CFFlags(Settle==Maturity,2) = 11;
end

% Check to see if coupon rates are on a schedule
if isCouponSchedule
    for bondidx=1:length(CouponData)
        if ~isscalar(CouponData{bondidx})
            CouponRates = CouponData{bondidx}(:,2);
            if iscell(CouponRates)
                CouponRates = cell2mat(CouponRates);
            end
            ConvDates = CouponData{bondidx}(:,1);
            ConvDates = datenum(ConvDates);
            
            for convidx=1:length(ConvDates)
                if convidx == 1
                    newidx = (CFDates(bondidx,:) <= ConvDates(convidx));
                elseif convidx == length(ConvDates)
                    newidx = (CFDates(bondidx,:) > ConvDates(convidx-1));
                else
                    newidx = (CFDates(bondidx,:) > ConvDates(convidx-1)) & (CFDates(bondidx,:) <= ConvDates(convidx));
                end
                CFAmounts(bondidx,newidx) = CFAmounts(bondidx,newidx).*CouponRates(convidx);
            end
            % Find maturity cash flow and modify
            maturityidx = find(CFFlags(bondidx,:) >= 4);
            
            CFAmounts(bondidx,maturityidx) = (CFAmounts(bondidx,maturityidx) - ...
                Face(bondidx)*MaturityCoupon(bondidx)) + Face(bondidx);
        end
    end
end

CFPrincipal = zeros(size(CFAmounts));
CFPrincipal(MatMap) = Face;
CFPrincipal(isnan(CFAmounts)) = NaN;

% If Settle = Maturity
CFPrincipal(Settle==Maturity,2) = Face(Settle==Maturity);
CFPrincipal(Settle==Maturity,1) = 0;

% Check to see if face values are on a schedule
if isFaceSchedule
    for bondidx=1:length(FaceData)
        if ~isscalar(FaceData{bondidx})
            isSinking = strcmpi(PrincipalType(bondidx),'sinking');
            FaceValues = FaceData{bondidx}(:,2);
            if iscell(FaceValues)
                FaceValues = cell2mat(FaceValues);
            end
            ConvDates = FaceData{bondidx}(:,1);
            ConvDates = datenum(ConvDates);
            
            if isSinking && any(~ismember(ConvDates(ConvDates < Maturity(bondidx)),CFDates(bondidx,:)))
                error(message('finance:cfamounts:invalidSinkingFaceSchedule'));
            end
            
            for convidx=1:length(ConvDates)
                if convidx == 1
                    newidx = (CFDates(bondidx,:) <= ConvDates(convidx));
                elseif convidx == length(ConvDates)
                    newidx = (CFDates(bondidx,:) > ConvDates(convidx-1));
                else
                    newidx = (CFDates(bondidx,:) > ConvDates(convidx-1)) & (CFDates(bondidx,:) <= ConvDates(convidx));
                end
                CFAmounts(bondidx,newidx) = CFAmounts(bondidx,newidx).*FaceValues(convidx);
                
                if isSinking
                    if ConvDates(convidx) < Maturity(bondidx)
                        LastIdx = find(newidx,1,'last');
                        CFAmounts(bondidx,LastIdx) = CFAmounts(bondidx,LastIdx) + FaceValues(convidx) - FaceValues(convidx+1);
                        CFPrincipal(bondidx,LastIdx) = FaceValues(convidx) - FaceValues(convidx+1);
                        CFFlags(bondidx,LastIdx) = CFFlags(bondidx,LastIdx) + 10;
                    end
                end
            end
            CFPrincipal(MatMap(bondidx)) = FaceValues(find(ConvDates >= Maturity(bondidx),1,'first'));
            if Settle(bondidx)==Maturity(bondidx)
                CFPrincipal(bondidx,2) = FaceValues(find(ConvDates <= Maturity(bondidx),1,'last'));
                CFPrincipal(bondidx,1) = 0;
            end
        end
    end
end

if CFTimesRequest
    
    %----------------------------------------------------------------------
    % Compute Time factors at all entries of PadCFDates
    %
    % All time factors will be correct for the date.  A maturity date
    % or last coupon date not in sync with the coupon structure will
    % not be in the list.
    %
    % Time factors use semi-annual windows and units for SIA conventions,
    % annual windows and units for ISMA conventions
    %
    % PrevCol [scalar]: column of quasi date previous to settle
    % NextCol [scalar]: column of quasi date previous to settle
    %
    % TimeFraction [NumCP x 1]     : fraction in each CommonPeriod for this SyncSet
    % SyncSetCols  [1 x NumTF]     : columns in PadCFDates corresponding to time
    %                                factors in this SyncSet
    % SyncSetFrac  [NumCP x NumTF] : Fraction for each time factor
    % SyncSetUnits [NumCP x NumTF] : whole number for each time factor
    %
    % PastUnits : number of saqd before settle
    %----------------------------------------------------------------------
    PadCFTimes = NaN*ones(NumBonds, PadCFCols);
    
    % Do each CommonPeriod together
    for CP = [1 2 4 6 12];
        
        CPInd = find(CommonPeriod==CP);
        if ( ~isempty(CPInd) )
            
            
            if (CP == 1) %annual
                PosPeriod = CP;
            else %semi annual
                PosPeriod = CP/2;
            end
            for SyncSet = 1:PosPeriod,
                % Position of saqd <= settle in PadCFDates
                PrevCol = PosPeriod + SyncSet;
                
                % Position of saqd > settle in PadCFDates
                NextCol = 2*PosPeriod + SyncSet;
                
                % Time factor fractions are always computed Actual/Actual
                % Compute DaysElapsed from Settle to the next quasi-date
                % **  See Standard Securities Calculations Methods: Fixed
                %     Income Securities Formulas for Analytic Measures, SIA
                %     Vol 2, Jan Mayle, (c) 1994, pg. 63
                
                % New code to handle discount basis
                if isnan(DiscBasis)
                    if (CP == 1) %annual
                        DaysElapsed  = daysact(     Settle(CPInd) , ...
                            PadCFDates(CPInd, PrevCol) );
                    else %semi annual
                        DaysElapsed  = daysact(     Settle(CPInd) , ...
                            PadCFDates(CPInd, NextCol));
                    end
                    DaysInterval = daysact( PadCFDates(CPInd, PrevCol), ...
                        PadCFDates(CPInd, NextCol) );
                else
                    if (CP == 1) %annual
                        DaysElapsed  = daysdif(     Settle(CPInd) , ...
                            PadCFDates(CPInd, PrevCol),DiscBasis(CPInd) );
                    else %semi annual
                        DaysElapsed  = daysdif(     Settle(CPInd) , ...
                            PadCFDates(CPInd, NextCol),DiscBasis(CPInd)  );
                    end
                    DaysInterval = daysact( PadCFDates(CPInd, PrevCol), ...
                        PadCFDates(CPInd, NextCol));
                    
                    % Compute coupon days for discount basis
                    if any(ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]))
                        
                        Ind = Period(CPInd) == 1 & ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]);
                        DaysInterval(Ind) = 360;
                        
                        Ind = Period(CPInd) == 2 & ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]);
                        DaysInterval(Ind) = 180;
                        
                        Ind = Period(CPInd) == 3 & ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]);
                        DaysInterval(Ind) = 120;
                        
                        Ind = Period(CPInd) == 4 & ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]);
                        DaysInterval(Ind) = 90;
                        
                        Ind = Period(CPInd) == 6 & ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]);
                        DaysInterval(Ind) = 60;
                        
                        Ind = Period(CPInd) == 12 & ismember(DiscBasis(CPInd),[1 2 4 5 6 9 11]);
                        DaysInterval(Ind) = 30;
                        
                    end
                    
                    % finally correct for those
                    idx365 = ismember(DiscBasis(CPInd),[3 7 10]);
                    
                    DaysInterval(idx365) = days365(PadCFDates(CPInd(idx365), PrevCol), ...
                        PadCFDates(CPInd(idx365), NextCol));
                    
                    if any(DiscBasis(CPInd) == 13)
                        idx252 = DiscBasis(CPInd) == 13;
                        
                        DaysInterval(idx252) = days252bus(PadCFDates(CPInd(idx252), PrevCol), ...
                            PadCFDates(CPInd(idx252), NextCol));
                    end
                    
                end
                
                TimeFraction = DaysElapsed./DaysInterval;
                
                % Find columns for time factor locations
                % The first time factor in the set is at the end of the window
                if (CP == 1) %annual
                    SyncSetCols = (PrevCol:PosPeriod:PadCFCols);
                else %semi annual
                    SyncSetCols = (NextCol:PosPeriod:PadCFCols);
                end
                TimeUnits = (0:length(SyncSetCols)-1);
                
                % Expand TimeFraction across the columns and Units down the rows
                [SyncSetFrac, SyncSetUnits] = ndgrid(TimeFraction, TimeUnits);
                
                % Write into the time factor matrix
                PadCFTimes(CPInd, SyncSetCols) = SyncSetFrac + SyncSetUnits;
                
            end
            
        end
    end
    
    % Computation of time factors for ISMA basis is slightly different
    if isnan(DiscBasis)
        DiscBasis = Basis;
    end
    isISMA = find(isisma(Basis));
    if any(isISMA)
        
        % Do each CommonPeriod together
        for CP = [1 2 4 6 12];
            
            CPInd = find(CommonPeriod(isISMA)==CP);
            if ( ~isempty(CPInd) )
                
                PosPeriod = CP;
                for SyncSet = 1:PosPeriod
                    
                    % Position of saqd <= settle in PadCFDates
                    PrevCol = SyncSet;
                    
                    % Position of saqd > settle in PadCFDates
                    NextCol = PosPeriod + SyncSet;
                    
                    if (CP == 1)
                        DaysElapsed  = daysdif(Settle(isISMA(CPInd)), ...
                            PadCFDates(isISMA(CPInd), NextCol),DiscBasis(isISMA(CPInd)));
                    else
                        DaysElapsed  = daysdif(     Settle(isISMA(CPInd)) , ...
                            PadCFDates(isISMA(CPInd), NextCol),DiscBasis(isISMA(CPInd)));
                    end
                    
                    % Make the coupon frequency 1 so that a year is used
                    % for the discounting denominator
                    DaysInterval = cpnpersz( PadCFDates(isISMA(CPInd), PrevCol), ...
                        PadCFDates(isISMA(CPInd), NextCol),1,DiscBasis(isISMA(CPInd)));
                    
                    TimeFraction = DaysElapsed./DaysInterval;
                    
                    % Check here for actual/365 ISDA
                    isISDA = DiscBasis(isISMA(CPInd)) == 12;
                    if any(isISDA)
                        D1_frac = (1 + daysact(Settle(isISMA(CPInd(isISDA))),...
                            datenum(year(Settle(isISMA(CPInd(isISDA)))),12,31))) ...
                            ./yeardays(year(Settle(isISMA(CPInd(isISDA)))));
                        D2_frac = daysact(datenum(year(PadCFDates(isISMA(CPInd(isISDA)),NextCol)),1,1),...
                            PadCFDates(isISMA(CPInd(isISDA)),NextCol)) ...
                            ./yeardays(year(PadCFDates(isISMA(CPInd(isISDA)),NextCol)));
                        TimeFraction(isISDA) = D1_frac + D2_frac + ...
                            year(PadCFDates(isISMA(CPInd(isISDA)),NextCol)) - ...
                            year(Settle(isISMA(CPInd(isISDA)))) -1;
                    end
                    
                    
                    % Find columns for time factor locations
                    % The first time factor in the set is at the end of the
                    % window
                    SyncSetCols = (NextCol:PosPeriod:PadCFCols);
                    
                    TimeUnits = (0:length(SyncSetCols)-1);
                    
                    % Expand TimeFraction across the columns and Units down the rows
                    [SyncSetFrac, SyncSetUnits] = ndgrid(TimeFraction, TimeUnits);
                    
                    % Write into the time factor matrix
                    PadCFTimes(isISMA(CPInd), SyncSetCols) = SyncSetFrac + SyncSetUnits;
                    
                end
                
            end
        end
    end
    
    %----------------------------------------------------------------------
    % Compute unsynced maturity time factors
    %----------------------------------------------------------------------
    CFMTime = nan(NumBonds,1);
    
    Ind = find(~BondIsMatSynced);
    if any(Ind)
        % Generate the regular coupon structure.
        % Runs from a year before settle to Maturity
        % Two quasi-dates occur before settle for SIA, one for
        % ISMA later
        i = (Basis(Ind) == 8 | Basis(Ind) == 9 | Basis(Ind) == 10 | Basis(Ind) == 11);
        cfPer = 2*ones(length(Ind),1);
        cfPer(i) = 1;
        MatCFDates = cfdatesq(Settle(Ind), Maturity(Ind), cfPer, ...
            Basis(Ind), EndMonthRule(Ind), [], ...
            [], [], cfPer, 0);
        
        if any(~i)
            PrevCol = 2; % PosPeriod + SyncSet = 1 + 1
            
            NextCol = 3; % 2*PosPeriod + SyncSet = 2*1 + 1
            
            % Time factor fractions are always computed Actual/Actual
            DaysElapsed  = daysact( Settle(Ind) , ...
                MatCFDates(:, NextCol) );
            
            DaysInterval = daysact( MatCFDates(:, PrevCol), ...
                MatCFDates(:, NextCol) );
            
            TimeFraction = DaysElapsed./DaysInterval;
            
            % Count the units out to maturity.  NextCol has a unit of zero.
            TimeUnits = sum(~isnan(MatCFDates), 2) - NextCol;
            
            CFMTime(Ind) = TimeFraction + TimeUnits;
        end
        
        % Check for ISMA, which use specified day count convention
        % for time factor and are annual
        if any(i)
            PrevCol = 1;
            
            NextCol = 2;
            
            DaysElapsed  = daysdif(     Settle(Ind(i)) , ...
                PadCFDates(Ind(i), NextCol),Basis(Ind(i)) );
            DaysInterval = daysdif( PadCFDates(Ind(i),PrevCol), ...
                PadCFDates(Ind(i),NextCol),Basis(Ind(i)));
            
            % Part 2 is the at the maturity
            DaysElapsedMat = daysdif(CFMBackQD(Ind(i)), ...
                Maturity(Ind(i)),Basis(Ind(i)));
            DaysIntervalMat = daysdif(CFMBackQD(Ind(i)), ...
                datemnth(CFMBackQD(Ind(i)),12),Basis(Ind(i)));
            
            TimeFraction = DaysElapsed./DaysInterval + ...
                DaysElapsedMat./DaysIntervalMat;
            
            % Count the units out to maturity.  NextCol has a unit of zero.
            TimeUnits = sum(~isnan(MatCFDates(i,:)), 2) - 2;
            
            % Check for case with a short last coupon
            TimeUnits(TimeFraction > 1) = TimeUnits(TimeFraction > 1) -1;
            
            CFMTime(Ind(i)) = TimeFraction + TimeUnits;
        end
        
    end
    
    %----------------------------------------------------------------------
    % Create final cftimes matrix if requested
    % Write in unsynced maturity and settlement time
    %----------------------------------------------------------------------
    CFTimes = nan(NumBonds, NumCFCols);
    
    % Write in Times before maturity
    CFTimes(SqueezeMap) = PadCFTimes(PadSqueezeMap);
    
    % Write in maturity flag for unsynced maturities
    CFTimes(AddMatMap) = CFMTime(BondAddMatMap);
    
    % Include 0 for accrued interest
    CFTimes(:,1) = zeros(NumBonds,1);
    
    % Use a convention that when Settle==Maturity,
    % the settlement value is copied to the second column.
    % This may expand the matrix columns
    CFTimes(Settle==Maturity,2) = 0;
    
    % Check here to square compounding frequency and time factors
    compfreqidx = ~isnan(CompFreq);
    if any(compfreqidx)
        InputFreq = 2*ones(NumBonds,1);
        InputFreq(isisma(Basis)) = 1;
        
        CFTimes(compfreqidx,:) = bsxfun(@times,CFTimes(compfreqidx,:),...
            (CompFreq(compfreqidx,:)./InputFreq(compfreqidx,:)));
    end
    
end

% Post process for business day conventions and cash flows

%----------------------------------------------------------------------------
% Subroutines
%----------------------------------------------------------------------------

function FirstInd = findfirst(X,Dim)
%FINDFIRST Find indices of first occurrence of nonzero elements.
%   I = FINDFIRST(X) returns the index of the first nonzero element of
%   the vector X.  If there are no nonzero elements, I = NaN.
%
%   I = FINDFIRST(X,1) returns the row indices of the first nonzero
%   element in each column of the matrix X.  The result is a row vector.
%
%   J = FINDFIRST(X,2) returns the column indices of the first nonzero
%   element in each row of the matrix X.  The result is a column vector.
%
%   See also FIND.

if nargin<2,
    % This should be the first-non-singleton dimension of X
    Dim = 1;
end

if isempty(X)
    FirstInd = zeros(size(X));
    return
end

X = (X~=0);
FirstInd = sum( cumsum(X,Dim) < 1 , Dim) + 1;
FirstInd( FirstInd > size(X,Dim) ) = NaN;

function d = dayspersz(d1,d2,period,basis)
%DAYSPERSZ Days between dates for any day count basis.
%       D = DAYSPERSZ(D1,D2,BASIS) returns the number of
%       days between D1 and D2 using the given day count
%       basis.

d = daysdif(d1,d2,basis);

i = find(basis==1 | basis==2 | basis==4 | basis==5 | basis==6 | basis == 9 | basis == 11);
if ~isempty(i);d(i) = 360./period(i);end

i = find(basis==3 | basis==10);
if ~isempty(i);d(i) = days365(d1(i),d2(i));end