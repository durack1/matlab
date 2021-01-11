function[cbeta]=trainconst(be)
%TRAINCONST  Normalizing constant for wavelet eddy train analyisis.
%
%   CBETA=TRAINCONST(BETA) returns the normalizing constant used in the 
%   eddy train analysis of Lilly and Olhede (2008).
%
%   'trainconst --t' runs a test.
%
%   Usage: cebta=trainconst(be);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
x=frac(be+1,2);
cbeta=(frac(1,sqrt(2*pi)).*exp(be/2).*(1./x).^(x+1/2).*frac(1,2*pi).*gamma(x)).^(-1);
