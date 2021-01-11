function fitdb=getfitdb(varargin)
% GETFITDB A helper function for CFTOOL

% $Revision: 1.7.2.2 $  $Date: 2005/03/07 17:25:07 $
% Copyright 2000-2004 The MathWorks, Inc.


thefitdb = cfgetset('thefitdb');

% Create a singleton class instance
if isempty(thefitdb)
   thefitdb = cftool.fitdb;
end

cfgetset('thefitdb',thefitdb);
fitdb=thefitdb;
