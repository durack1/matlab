function c = horzcat(varargin)
%HORZCAT Horizontal concatenation of FITTYPE objects (disallowed)

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2005/03/07 17:26:07 $

error('curvefit:fittype:horzcat:catNotPermitted', ...
      'Concatenation of %s objects not permitted.\n',class(varargin{1}));
