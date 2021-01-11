function[eps1,eps2,eps3,eps0]=transerr(ga,be,eta,s)
%TRANSERR
%
%   TRANSERR(GAMMA,BETA,ETA,S);
%
%   Usage: [eps1,eps2,eps3,eps0]=transerr(ga,be,eta,s);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(ga, '--t')
    transerr_test,return
end
 

seta=s.*eta;
psi=morsea(ga,be).*(seta.^be).*exp(-seta.^ga);
[psi1,psi2,psi3,psi4]=morsederiv(ga,be,seta);

eta1=vdiff(eta,1);
eta2=vdiff(eta1,1);
eta3=vdiff(eta2,1);

funo=              frac(1,2)*psi;
fun1= -1* sqrt(-1)*frac(1,2)*psi2.*frac(eta1,eta.^2);
fun2=           -1*frac(1,6)*psi3.*frac(eta2,eta.^3 );
fun3=     sqrt(-1)*frac(1,24)*psi4.*(frac(eta3,eta.^4 )+3*sqrt(-1)*frac(eta1,eta.^2 ).^2);
 
eps1=funo.*(1+fun1)-1;
eps2=funo.*(1+fun1+fun2)-1;
eps3=funo.*(1+fun1+fun2+fun3)-1;
eps0=funo-1;



function[]=transerr_test
load npg2006
use npg2006

NF=50;
fs=1./(logspace(log10(10),log10(100),NF)');
psi=morsewave(length(cx),1,2,4,fs);
psi=bandnorm(psi,fs);

%Compute wavelet transforms
wx=wavetrans(real(cx),psi,'mirror');
%wy=wavetrans(imag(cx),psi,'mirror');
%[wp,wn]=transconv(wx,wy,'uv2pn');

%Uncomment to see plots of Cartesian and rotary transforms
%h=wavespecplot(d,cx,dt./fs,wx,wy,0.5);
%h=wavespecplot(d,cx,dt./fs,wp,wn,0.5);

%Form ridges of component time series
%pstruct=ridgewalk(dt,wp,fs,1,1.5./fs,'phase');   
%nstruct=ridgewalk(dt,wn,fs,1,1.5./fs,'phase');
xstruct=ridgewalk(dt,wx,fs,1,1.5./fs,'phase');   
%ystruct=ridgewalk(dt,wy,fs,1,1.5./fs,'phase'); 
%reporttest('TRANSERR',aresame())

use xstruct
eta=-sqrt(-1)*vdiff(real(log(wr))+sqrt(-1)*unwrap(imag(log(wr))),1);
om=real(eta);


 [eps1,eps2,eps3,eps0]=transerr(2,4,eta,2*pi*morsefreq(2,4)./om);
 
