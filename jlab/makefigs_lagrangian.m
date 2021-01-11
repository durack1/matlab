function[varargout]=makefigs_lagrangian(varargin)
%MAKEFIGS_LAGRANGIAN
%
%   MAKEFIGS_LAGRANGIAN
%
%   'makefigs_lagrangian --t' runs a test.
%
%   Usage: []=makefigs_lagrangian();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    makefigs_lagrangian_test,return
end


load ebasn
use ebasn
cx=latlon2xy(lat,lon,31,-24);

cv=latlon2uv(num,lat,lon);
cv=vswap(cv,nan,0);
%ddcv=vdiff(vdiff(cv,1),1);
ddcv=vdiff(cv,1);
vswap(ddcv,nan,0);


[psi,lambda]=sleptap(length(cv),16); 
[f,spp,snn,spn]=mspec(ddcv,psi);


figure,
subplot(131),plot(f,spp),xlog,ylog,axis tight,ylim([10^-4 10^3])
subplot(132),plot(f,snn),xlog,ylog,axis tight,ylim([10^-4 10^3])
subplot(133),plot(f,abs(spn)),xlog,ylog,axis tight,ylim([10^-4 10^3])

figure,plot(f,abs(spn)./sqrt(spp.^2+snn.^2)),xlog,axis tight


 
function[]=makefigs_lagrangian_test
 
%reporttest('MAKEFIGS_LAGRANGIAN',aresame())
