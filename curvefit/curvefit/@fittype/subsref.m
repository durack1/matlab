function FITTYPE_OUT_ = subsref(FITTYPE_OBJ_, FITTYPE_SUBS_)
%SUBSREF Evaluate FITTYPE object.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.5.2.3 $  $Date: 2005/03/07 17:26:44 $

if (FITTYPE_OBJ_.isEmpty)
    error('curvefit:fittype:subsref:fcnEmpty', ...
          'Can''t call an empty FITTYPE function.');
end

switch FITTYPE_SUBS_.type
case '()'
    FITTYPE_INPUTS_ = FITTYPE_SUBS_.subs;
    FITTYPE_OUT_ = feval(FITTYPE_OBJ_,FITTYPE_INPUTS_{:});
otherwise % case '{}', case '.'
    error('curvefit:fittype:subsref:noFieldAccess', ...
          'Cannot access fields of fittype using . notation')
end


