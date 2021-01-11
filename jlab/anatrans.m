function[zp,zn]=anatrans(x)
%ANATRANS  Analytic part of signal.
%
%   Z=ANATRANS(X) returns the analytic part of the real-valued signal 
%   X, which is a column vector or a matrix with 'time' in columns. 
%
%   Z is defined such that X = REAL(Z) = 1/2*(Z+CONJ(Z)).
%
%   [ZP,ZN]=ANATRANS(Z) returns the analytic part ZP and anti-analytic 
%   part of the ZN of the complex-valued signal Z.  
%
%   ZP and ZN are defined such that Z=ZP+ZN.
% 
%   Note that the analytic part of a real-valued signal and that of
%   of a complex-valued signal are thus defined differently by a factor
%   of two, following the convection of Lilly and Gascard (2006).
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        


if isreal(x)
    zp=x+sqrt(-1)*hiltrans(x);
else
    zp=frac(1,2)*(x+sqrt(-1)*hiltrans(x));
    zn=frac(1,2)*(x-sqrt(-1)*hiltrans(x));
end
