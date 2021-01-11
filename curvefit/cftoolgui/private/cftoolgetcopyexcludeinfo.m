function [name, dL, dH, dLLE, dHLE, rL, rH, rLLE, rHLE, ds] = cftoolgetcopyexcludeinfo(outlier)
%CFTOOLGETCOPYEXCLUDEINFO Get information needed to copy a cftool exclusion rule 

%   $Revision: 1.1.6.2 $  $Date: 2006/10/02 16:31:33 $
%   Copyright 2004-2006 The MathWorks, Inc.

outlier = handle(outlier);

name = outlier.name;

dL = outlier.domainLow;
dH = outlier.domainHigh;
dLLE = outlier.domainLowLessEqual;
dHLE = outlier.domainHighLessEqual;

rL = outlier.rangeLow;
rH = outlier.rangeHigh;
rLLE = outlier.rangeLowLessEqual;
rHLE = outlier.rangeHighLessEqual;

ds = outlier.dataset;

    


