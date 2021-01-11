function[struct]=ridgedebias(varargin)
%RIDGEDEBIAS  De-biased wavelet ridge estimator of an oscillatory signal.
%
%   STRUCT=RIDGEDEBIAS(W,STRUCT,P) implements the debiasing algorithm
%   of Lilly and Olhede (2008a), removing the lowest-order effect of
%   signal modulation in the wavelet ridge-based signal estimator.
%
%   Here W is a wavelet transform matrix using the generalized Morse
%   wavelets, STRUCT is the wavelet ridge structure output by RIDGEWALK,
%   and P=SQRT(BETA*GAMMA) is a measure of the Morse wavelet width.  
%   
%   STRUCT is modified to have the de-biased versions of the following
%   quantities
%
%       STRUCT.WR     Transform values, or estimated analytic signal
%       STRUCT.FR     Estimated signal instantaneous frequency (cyclic)
%
%   and also to include the following new quantities
%
%       STRUCT.P1R     Estimated first-order Bell bandwidth
%       STRUCT.P2R     Estimated second-order Bell bandwidth.
%   
%   See Lilly and Olhede (2008a) for details.
%
%   See also MORSEWAVE, WAVETRANS, RIDGEWALK.
%
%   'ridgedebias --f' generates a sample figure.
%
%   Usage: struct_debias=ridgedebias(w,struct,p);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007--2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--f')
    ridgedebias_figure,return
end


w=varargin{1};
struct=varargin{2};
p=varargin{3};
dt=struct.dt;


eta=instfreq(dt,w,'complex'); %Complex-valued transform frequency
deta=vdiff(eta,1)./dt;        %Complex-valued frequency derivative
p1=frac(imag(eta),real(eta));
p2=bellpoly(-frac(imag(eta),real(eta)),sqrt(-1)*frac(deta,real(eta).^2));

use struct
struct=ridgeinterp(struct,w,p1,p2);
use struct
struct.wr=real(wr.*(1-frac(1,2).*p2r.*p.^2));
struct.fr=real(fr.*(1-frac(1,2).*p2r.*p.^2));
struct.alg=[struct.alg(1:3) '-db'];

function[]=ridgedebias_figure
 
dt=0.5;
t=[-50:dt:50]';
x=10*morsexpand(200,t,7,2,1/20);
rhon=bellband(dt,x,5);
ga=3;
be=1.5;
psin=morsederiv(5,ga,be);

xhat=zeros(length(x),5);
xhat(:,1)=x;

for n=2:5
    xhat(:,n)=xhat(:,n-1)+x.*(-sqrt(-1)).^n*frac(1,factorial(n)).*psin{n}.*rhon{n};
end

NF=50;fs=1./(logspace(log10(10),log10(200),NF)');

%Compute wavelet transforms
wx=wavetrans(real(x),{1,ga,be,fs,'bandpass'},'mirror');

%Form ridges of component time series
xstruct=ridgewalk(dt,wx,fs,{1.5,0.5,0,'phase'});   
xstruct_debias=ridgedebias(wx,xstruct,sqrt(ga*be));
use xstruct

tr=0*ir;tr(find(~isnan(ir)))=t(nonnan(ir));

ii=1:2:length(tr);
figure
%subplot(121),
plot(t,real(x)),hold on,plot(t,real(xhat(:,2:2:end))),xlim([-33 33]),hlines(0)
ylim([-.52 .72]),ytick([-.4:.2:.6]),xtick([-30:10:30]),fixlabels([0 -1]),linestyle 2k 0.5k  k-- k: 
plot(tr(ii),real(wr(ii)),'w.','markersize',15)
plot(tr(ii),real(wr(ii)),'k.','markersize',10)
title('Wavelet Ridge Estimate of \Re\{\psi_{2,7}(t)\} vs. Localized Analytic Signal'),


use xstruct_debias
plot(tr,wr,'k-.')
