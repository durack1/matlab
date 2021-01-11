function type = prettyname(fittype)
%PRETTYNAME Typename of FITTYPE.
%   PRETTYNAME(F) returns the nicely formatted name of the 
%   FITTYPE object F.
%
%   See also FITTYPE/ARGNAMES, FITTYPE/CHAR.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.5.2.2 $  $Date: 2005/03/07 17:26:17 $

type = fittype.typename;
