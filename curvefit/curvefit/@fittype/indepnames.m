function names = indepnames(fun)
%INDEPNAMES Independent parameter names.
%   INDEPNAMES(FUN) returns the names of the independent parameters of the
%   FITTYPE object FUN as a cell array of strings.
%
%   See also FITTYPE/DEPENDNAMES, FITTYPE/FORMULA.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2005/03/07 17:26:08 $

names = cellstr(fun.indep);