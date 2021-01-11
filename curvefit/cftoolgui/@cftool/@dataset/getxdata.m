function x = getxdata(ds,outlier)
%GETXDATA Get the X data not excluded by the specified excluded set

%   $Revision: 1.2.2.2 $  $Date: 2005/03/07 17:24:47 $
%   Copyright 2001-2005 The MathWorks, Inc.

if ~isequal(outlier,'(none)') && ~isempty(outlier)
   % For convenience, accept either an outlier name or a handle
   if ischar(outlier)
      outlier = find(getoutlierdb,'name',outlier);
   end
   evec = cfswitchyard('cfcreateexcludevector',ds,outlier);
   x = ds.x(~evec);
else
   x = ds.x;
end
