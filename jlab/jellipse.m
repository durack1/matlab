%
% JELLIPSE  Elliptical (bivariate) time series analysis.
%     -- see Lilly and Gascard (2006), Nonlin. Proc. Geophys.
%
% Ellipse analysis of time series pairs 
%   ellridge   - Extract "elliptical" ridges for bivariate time series.
%   ellconv    - Converts between time-varying ellipse representations.
%   ellsig     - Creates an elliptical signal from ellipse parameters.
%
% Operations on elliptical time series
%   elldiff    - Ellipse differentiation.
%   ellrad     - Average and instantaneous ellipse radius.
%   ellvel     - Average and instantaneous ellipse velocities.
%   ellband    - Elliptical bandwidth of bivariate signal or wavelet transform.
%   ellipseplot   - Plot ellipses.
%
% Other conversions 
%   transconv  - Convert between widely linear transform pairs.
%   ecconv     - Convert between eccentricity measures.
%   kl2ab      - Converts ellipse parameters Kappa and Lambda to A and B.
%   ab2kl      - Converts A and B to ellipse parameters Kappa and Lambda.
%
% Polarization analysis of spectral matrices 
%   normform   - Convert a complex-valued vector into "normal form".
%   specdiag   - Diagonalize a 2 x 2 spectral matrix.
%   walpha     - Widely linear transform anisotropy parameters.
%   polparam   - Spectral matrix polarization parameters.
%
% Low-level ellipse code
%   ellipsetest - Run tests on ellipse code.  
%   randspecmat - Generates random 2x2 spectral matrices for testing.
%   mandn       - Widely linear transformation matrices M and N.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details      
