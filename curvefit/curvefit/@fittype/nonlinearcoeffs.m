function cella = nonlinearcoeffs(model)
%NONLINEARCOEFFS array of indices of nonlinear coefficients.
%   NONLINEARCOEFFS(FITTYPE) returns the array of indices of 
%   nonlinear coefficients of FITTYPE.
%
%   See also FITTYPE/COEFFNAMES.

%   Copyright 2001-2006 The MathWorks, Inc. 
%   $Revision: 1.2.2.2 $  $Date: 2006/12/15 19:26:16 $

cella = model.nonlinearcoeffs;
