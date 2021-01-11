function evec = getexcluded(ds,outlier)
%GETEXCLUDED Get an exclusion vector for this dataset/outlier combination

%   $Revision: 1.2.2.3 $  $Date: 2006/01/18 21:58:47 $
%   Copyright 2001-2005 The MathWorks, Inc.

if ~isequal(outlier,'(none)') && ~isempty(outlier)
   % For convenience, accept either an outlier name or a handle
   if ischar(outlier)
      outlier = find(getoutlierdb,'name',outlier);
   end
   evec = cfswitchyard('cfcreateexcludevector',ds,outlier);
else
   evec = false(length(ds.x),1);
end
