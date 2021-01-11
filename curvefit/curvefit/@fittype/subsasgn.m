function c = subsasgn(FITTYPE_OBJ_, varargin)
%SUBSASGN    subsasgn of fittype objects.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2005/03/07 17:26:43 $

error('curvefit:fittype:subsasgn:subsasgnNotAllowed', ...
   '%s objects can''t be assigned to using subscripts.\n',class(FITTYPE_OBJ_));