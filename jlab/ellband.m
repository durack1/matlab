function[xixy,xi,xia,xib,xic]=ellband(zx,zy)
%ELLBAND  Bandwidth of ''elliptical'' or bivariate analytic signals.
%
%   XIXY=ELLBAND(ZX,ZY) computes the bivariate instantaneous bandwidth 
%   of the bivariate analytic signal (ZX,ZY).  ZX and ZY are both 
%   analytic signals, such as those output by ANATRANS or WAVETRANS.
%
%   See Lilly and Olhede (2008c) for details.
%
%   [XIXY,XI]=ELLBAND(ZX,ZY) also returns the elliptical modulation rate
%   XI, a close relative of the bivariate bandwidth.
%
%   [XIXY,XI,XIA,XIB,XIC]=ELLBAND(ZX,ZY) also returns the components of 
%   the elliptical modulation rate.  These are: XIA, the relative 
%   amplitude modulate rate; XIB, due to changing eccentricity; and XIC, 
%   due to precession.  They satisfy XI^2=XIA^2+XIB^2+XIC^2.
%
%   See also ANATRANS, WAVETRANS, and INSTFREQ.
%
%   Usage:  xi=ellband(zx,zy);
%           [xixy,xi,xia,xib,xic]=ellband(zx,zy);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2008 J.M. Lilly --- type 'help jlab_license' for details
 

if strcmp(zx, '--t')
    ellband_test,return
end
 
ax=abs(zx);
ay=abs(zy);

[zp,zn]=transconv(zx,zy,'xy2pn');

omx=instfreq(zx);
omy=instfreq(zy);
etax=instfreq(zx,'complex');
etay=instfreq(zy,'complex');
ombar=frac(1,ax.^2+ay.^2).*(ax.^2.*omx+ay.^2.*omy);
%xixy=frac(1,2)*frac(abs(etax-ombar).^2+abs(etay-ombar).^2,ombar.^2);
xixy=sqrt(frac(1,ax.^2+ay.^2).*frac(ax.^2.*abs(etax-ombar).^2+ay.^2.*abs(etay-ombar).^2,ombar.^2));

[a,b,theta,phi]=ellconv(zp,zn,'pn2ab');
[kappa,lambda]=ab2kl(a,b);

omp=instfreq(zp);
omn=instfreq(zn);

omg=0*omp;
omg(b>0)=omp(b>0);
omg(b<0)=omn(b<0);

omtheta=omp-omn;

xia=abs(frac(1,omg).*vdiff(log(kappa),1));
xib=abs(frac(1,2)*frac(1,omg).*vdiff(lambda,1));
xic=abs(lambda.*frac(omtheta,omg));

xi=sqrt(xia.^2+xib.^2+xic.^2);

function[]=ellband_test

if 0
[xi,xik,xil,lambda2]=ellband(X.*rot(phix),Y.*rot(phiy));
figure, plot([xi xik xil lambda])
 
xix=bandwidth(X.*rot(phix));
xiy=bandwidth(Y.*rot(phiy));

figure, plot([xi xix xiy])
figure, plot([xi.^2 xix xiy])
%reporttest('ELLBAND',aresame())
end