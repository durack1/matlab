function names = indepnames(fun)
%INDEPNAMES Independent parameter names.
%   INDEPNAMES(FUN) returns the names of the independent parameters of the
%   CFIT object FUN as a cell array of strings.
%
%   See also CFIT/DEPENDNAMES.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2005/03/07 17:25:16 $

names = indepnames(fun.fittype);