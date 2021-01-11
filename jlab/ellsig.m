function[z]=ellsig(a,b,theta,phi)
%ELLSIG  Creates an elliptical signal from ellipse parameters. 
%
%   Z=ELLSIG(A,B,THETA,PHI) creates a time-varying, complex-valued
%   elliptical signal Z characterized by semi-major axis A, semi-
%   minor axis B, orientation THETA, and particle position PHI.
%
%   See Lilly and Gascard (2006) for details.
% 
%   Usage:  z=ellsig(a,b,theta,phi);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(a, '--t')
    ellsig_test,return
end
z=rot(theta).*(a.*cos(phi)+sqrt(-1)*b.*sin(phi));
z=vswap(z,nan,0);
function[]=ellsig_test
 
%reporttest('ELLSIG',aresame())
