function c = vertcat(varargin)
%VERTCAT Vertical concatenation of FITTYPE objects (disallowed)

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2005/03/07 17:26:47 $

error('curvefit:fittype:vertcat:catNotAllowed', ....
      'Concatenation of %s objects not permitted.\n',class(varargin{1}));