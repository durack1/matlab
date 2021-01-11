function thedsdb=getdsdb(varargin)
% GETDSDB is a helper function for CFTOOL

%   $Revision: 1.11.2.3 $  $Date: 2005/03/07 17:25:06 $
%   Copyright 2000-2004 The MathWorks, Inc.


thedsdb = cfgetset('thedsdb');

% Create a singleton class instance
if isempty(thedsdb)
   thedsdb = cftool.dsdb;
   cfgetset('thedsdb',thedsdb);
end


