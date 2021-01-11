function theoutlierdb=getoutlierdb(varargin)
% GETOUTLIERDB is a helper function for CFTOOL

%   $Revision: 1.4.2.2 $
%   Copyright 2001-2004 The MathWorks, Inc.

theoutlierdb = cfgetset('theoutlierdb');

% Create a singleton class instance
if isempty(theoutlierdb)
   theoutlierdb = cftool.outlierdb;
   cfgetset('theoutlierdb',theoutlierdb);
end


