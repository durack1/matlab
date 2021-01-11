function c = cat(varargin)
%CAT    N-D concatenation of FITTYPE objects (disallowed)

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2005/03/07 17:25:55 $

error('curvefit:fittype:cat:catNotPermitted', ...
      'Concatenation of %s objects not permitted.\n', class(varargin{1}))
