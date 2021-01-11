function[bcell]=bellband(varargin)
%BELLBAND Computes Bell bandwidths quantifying signal variability.
%
%   RHOCELL=BELLBAND(X,N) computes the first N Bell bandwidths 
%   associated with the analytic (or anti-analytic) signal X.
%   
%   RHOCELL is an N-element cell array in which each element 
%   is the same size as X. RHOCELL{P} is the Pth Bell bandwidth.
%
%   X should be an analytic signal, such as that created with 
%   ANATRANS or Matlab's HILBERT, or the wavelet transform with an 
%   anayltic wavelet such as that produced by WAVETRANS. 
%
%   BELLBAND uses a fast algorithm for N<=4, but a much slower
%   algorithm for higher-order terms.  See BELLPOLY for details.
%
%   The Bell bandwidths were shown by Lilly & Olhede (2008a) to
%   be fundamental functions quantifying signal time variability. 
%
%   BELLBAND(DT,X,N) specifies the sample interval to be DT, set to 
%   be DT=1 by default. 
%
%   See also BELLPOLY.
%
%   'bellband --f' generates two sample figures.
%
%   Usage: rhocell=bellband(x,n);
%          rhocell=bellband(dt,x,n);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--f')
   bellband_figure,return
elseif strcmp(varargin{1}, '--f1')
   bellband_figure1,return
elseif strcmp(varargin{1}, '--f2')
   bellband_figure2,return
end

if nargin==2
    x=varargin{1};
    nmax=varargin{2};
elseif nargin==3
    dt=varargin{1};
    x=varargin{2};
    nmax=varargin{3};
else
    error('BELLBAND takes two or three arguments.')
end

if isreal(x)
    error('X should be an analytic signal, which means it should be complex-valued.')
end

eta=instfreq(dt,x,'complex');

clear etadiff bell polyargs

etadiff=cell(nmax,1);
polyargs=cell(nmax,1);
bcell=cell(nmax,1);

etadiff{1}=vdiff(eta,1)./dt;
polyargs{1}=-imag(eta)./real(eta);
bcell{1}=bellpoly(polyargs(1));

for n=2:nmax
    etadiff{n}=vdiff(etadiff{n-1},1)./dt;
    polyargs{n}=sqrt(-1)*etadiff{n-1}./real(eta).^n;
    bcell{n}=bellpoly(polyargs(1:n));
end

varargout{n}=bellpoly(polyargs(1:n));
% 
function[]=bellband_figure
bellband_figure1
bellband_figure2
 
function[]=bellband_figure1
dt=0.5;
t=[-50:dt:50]';
x=10*morsexpand(200,t,7,2,1/20);
rho=bellband(dt,x,4);
eta=instfreq(dt,x,'complex');


figure,
subplot(231),uvplot(t,x); ylim([-.8 .8]),hlines(0),linestyle 2k k-- k:
title('Analytic Signal \psi_{2,7}(t)'),xtick([-40:20:40]),ytick([-.8:.4:.8]),fixlabels([0 -1])
subplot(232),uvplot(t,rho{1}),ylim([-.4 .4]),hlines(0),linestyle 2k k-- k:
title('Bell Bandwidth #1 \rho_1(t)'),xtick([-40:20:40]),fixlabels([0 -1])
subplot(233),uvplot(t,rho{3}),ylim([-.15 .15]),hlines(0),linestyle 2k k-- k:
title('Bell Bandwidth #3 \rho_3(t)'),xtick([-40:20:40]),ytick([-.15:.05:.15]),fixlabels([0 -2])
subplot(234),uvplot(t,eta);ylim([-.24 .24]*2),hlines(0),linestyle 2k k-- k:
title('Complex Instantaneous Frequency \eta(t)'),xtick([-40:20:40]),fixlabels([0 -1])
subplot(235),uvplot(t,rho{2}),ylim([-.15 .15]),hlines(0),linestyle 2k k-- k:
title('Bell Bandwidth #2 \rho_2(t)'),xtick([-40:20:40]),ytick([-.15:.05:.15]),fixlabels([0 -2])
subplot(236),uvplot(t,rho{4}),ylim([-.15 .15]),hlines(0),linestyle 2k k-- k:
title('Bell Bandwidth #4 \rho_4(t)'),xtick([-40:20:40]),ytick([-.15:.05:.15]),fixlabels([0 -2])
letterlabels(4)

function[]=bellband_figure2

dt=0.5;
t=[-50:dt:50]';
x=10*morsexpand(200,t,7,2,1/20);
rhon=bellband(dt,x,4);

[om,up]=instfreq(dt,x);
eta=om-sqrt(-1)*up;


tmid=round(length(t)/2);
%rhoo=zeros(4,1);

xo=x(tmid);
omo=om(tmid);


xhat=zeros(length(x),5);
xhat(:,1)=xo.*rot(t.*omo);
for n=1:4
    xhat(:,n+1)=xhat(:,1).*frac(1,factorial(n)).*((omo.*t).^n).*rhon{n}(tmid);
end

xhat=cumsum(xhat,2);

figure
subplot(121),plot(t,real(x)),hold on,plot(t,real(xhat(:,3:2:end))),xlim([-33 33]),hlines(0)
ylim([-.8 .8]),ytick([-.8:.4:.8]),xtick([-30:10:30]),fixlabels([0 -1]),linestyle 2k k k-- k:
title('Bell Bandwidth Expansion of \Re\{\psi_{2,7}(t)\}')

subplot(122),plot(t,imag(x)),hold on,plot(t,imag(xhat(:,3:2:end))),xlim([-33 33]),hlines(0)
ylim([-.8 .8]),ytick([-.8:.4:.8]),xtick([-30:10:30]),fixlabels([0 -1]),linestyle 2k k k-- k:
title('Bell Bandwidth Expansion of \Im\{\psi_{2,7}(t)\}')

letterlabels(4),packcols(1,2)

