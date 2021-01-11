function bd = busdate(d, dirFlag, hol, weekend)
%BUSDATE Next or previous business day.
%
%   BD = busdate(D)
%   BD = busdate(D, DIREC, HOL, WEEKEND)
%
%   Optional Inputs: DIREC, HOL, WEEKEND
%
%   Inputs:
%         D - Scalar, vector, or matrix of reference business dates as serial
%             date numbers or date strings.
%
%   Optional Inputs:
%   DIRFLAG - String or cell array of strings of business day convention.
%             Possible values are follow, modifiedfollow, previous, modifiedprevious
%
%             Legacy convention is also supported, which is the following:
%             Scalar, vector, or matrix of search directions:
%             Next (DIREC = 1, default) or Previous (DIREC = -1)
%
%       HOL - Scalar or vector of non-trading day dates as serial date
%             numbers or date strings. If HOL is not specified the non-trading
%             day data is determined by the routine, HOLIDAYS. At this time
%             only NYSE holidays are supported in HOLIDAYS.
%
%   WEEKEND - Vector of length 7 containing 0's and 1's. The value 1 indicates
%             weekend day(s). The first element of this vector corresponds
%             to Sunday. For example, when Saturday and Sunday are weekend
%             days (default) then WEEKEND = [1 0 0 0 0 0 1].
%
%   Outputs:
%        BD - Scalar, vector, or matrix of the next or previous business day(s)
%             depending on HOL.
%
%   Example:
%      bd = busdate('3-jul-1997', 1)
%      bd =
%          729578 % 07-Jul-1997
%
%  See also HOLIDAYS, ISBUSDAY.

%  Copyright 1995-2009 The MathWorks, Inc.
%  $Revision: 1.9.2.15 $   $Date: 2011/02/28 01:20:59 $

if nargin < 1
    error(message('finance:busdate:invalidInputs'))
end

if nargin < 2 || isempty(dirFlag)
    dirFlag = 1;
end

if nargin < 3 || isempty(hol)
    hol = holidays;
end

if nargin < 4 || isempty(weekend)
    weekend = [1 0 0 0 0 0 1];
end

if ischar(dirFlag)
    switch dirFlag
        case {'modifiedfollow','follow'}
            direc = 1;
        case {'modifiedprevious','previous'}
            direc = -1;
        otherwise
            error(message('finance:busdate:invalidDirectionString'))
    end
elseif isnumeric(dirFlag)
    direc = dirFlag;
    if any(any(direc ~= 1 & direc ~= -1))
        error(message('finance:busdate:invalidDirection'))
    end
elseif iscell(dirFlag)
    direc = zeros(size(dirFlag));
    direc(ismember(lower(dirFlag),{'follow','modifiedfollow'})) = 1;
    direc(ismember(lower(dirFlag),{'previous','modifiedprevious'})) = -1;
            
    if ~all(all(direc == -1 | direc == 1))
        error(message('finance:busdate:invalidCellArray'))
    end
else
    error(message('finance:busdate:invalidDirectionType'))
end

if ~isempty(d)
    % Parse dates
    if isnumeric(d)
        % Save original dimensions
        origDims = size(d);
        
        dt = d(:);
        
    elseif ischar(d)
        % Char matrices will always generate column.
        dt = datenum(d);
        
        origDims = size(dt);
        
    elseif iscell(d)
        % Save original dimensions
        origDims = size(d);
        
        dt = datenum(d(:));
    end
    
    % Parse holidays
    if ischar(hol) || iscell(hol)
        h = datenum(hol);
        
    else
        h = hol(:);
    end
    
    % Parse direction.
    % 1) Let directions that are same length vectors pass (legacy behavior)
    % 2) If direction is not a scalar it must be the same size as the dates
    %    input.
    direcSize = numel(direc);
    origDirecSize = size(direc);
    if direcSize == numel(dt) && (min(origDims) == 1 && min(origDirecSize) == 1)
        % Do nothing
        
    elseif direcSize ~= 1 && ~all(origDirecSize == origDims)
        error(message('finance:busdate:invalidDim'))
    end
    
    % Scalar expand
    direc = direc(:);
    if max(size(dt)) == 1, dt = dt(ones(size(direc)));end
    if max(size(direc)) == 1, direc = direc(ones(size(dt)));end
    
    % Parse weekend
    if numel(weekend) ~= 7 || all(size(weekend) > 1)
        error(message('finance:busdate:invalidWeekendDim'))
    end
    
    
    rng = 1:7;                            % numbers to be added to dates
    rng = rng(ones(length(direc),1),:);   % expand rng for vectorization
    [rr,cr] = size(rng); %#ok
    direc = direc(:,ones(1,cr));          % expand direc for vectorization
    mat = rng.*direc;                     % date projection based on direc
    newdt = dt(:,ones(1,cr));             % expand dt for vectorization
    total = newdt+mat;                    % create new dates
    ind = isbusday(total,h,weekend);      % find valid business days
    diffmat = newdt-total;                % difference between dt and new dates
    diffmat = abs(diffmat);
    nonday = find(~ind);                  % index of non-business days
    diffmat(nonday) = (1e+8)*ones(size(nonday));  % set nondays to large numbers
    
    % Special case where all the future/past dates appear in the holiday
    % vector
    specCaseIdx = sum(diffmat ~= (1e+8), 2);
    noDateIdx = specCaseIdx == 0;
    dateIdx = specCaseIdx ~= 0;
    direcHold = direc(noDateIdx);
    posDirec = direcHold > 0;
    negDirec = ~posDirec;
    
    % Get the non business day subset
    partialTotal = total(noDateIdx, :);
    
    % Pre-allocate vectors
    bd = zeros(size(specCaseIdx));
    newDates = zeros(size(partialTotal, 1), 1);
    
    % Special case. This handles large consecutive holiday vectors.
    if any(noDateIdx)
        
        % Add/remove day and keep doing this till we find all the next/prev
        % busdays.
        newDates(posDirec) = partialTotal(posDirec, end) + direcHold(posDirec, 1);
        newDates(negDirec) = partialTotal(negDirec, 1) + direcHold(negDirec, 1);
        
        % Initial check to see if the new dates are business days.
        busIdx = isbusday(newDates, hol, weekend);
        
        % Iteratively find busdays
        while any(~busIdx)
            % Generate 'future/past' indices
            posDirec = (posDirec - busIdx);
            negDirec = (negDirec - busIdx);
            
            posDirec(posDirec ~= 0 & posDirec ~= 1) = 0;
            negDirec(negDirec ~= 0 & negDirec ~= 1) = 0;
            
            posDirec = logical(posDirec);
            negDirec = logical(negDirec);
            
            % Add/remove day. Using var(idx, 1) even though newDates is scalar
            % so we can get Empty matrix: 0-by-1 outputs instead of [].
            % direcHold(negDirec, 1) and direcHold(posDirec, 1) could be
            % Empty matrix: 0-by-1 and the addition of newDates requires it
            % to also be Empty matrix: 0-by-1.
            newDates(posDirec) = newDates(posDirec, 1) + direcHold(posDirec, 1);
            newDates(negDirec) = newDates(negDirec, 1) + direcHold(negDirec, 1);
            
            % Check to see if the new dates are business days.
            busIdx = isbusday(newDates, hol, weekend);
        end
        
        bd(noDateIdx) = newDates;
    end
    
    % Standard case
    if any(dateIdx)
        c = min(diffmat(dateIdx, :), [], 2);
        r = 1:numel(c);
        t = total(dateIdx, :);
        
        idx = sub2ind(size(t), r(:), c);
        
        bd(dateIdx) = t(idx);
    end
    
    % Reshape results back to input dims
    bd = reshape(bd, origDims);
    
else
    bd = [];
end

mfidx = strcmpi(dirFlag,'modifiedfollow');
if any(mfidx)
    monthidx = month(bd) ~= month(d);
    bd(mfidx & monthidx) = busdate(d(mfidx & monthidx),-1,hol,weekend);
end

mpidx = strcmpi(dirFlag,'modifiedprevious');
if any(mpidx)
    monthidx = month(bd) ~= month(d);
    bd(mpidx & monthidx) = busdate(d(mpidx & monthidx),1,hol,weekend);
end