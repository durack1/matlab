function[psi]=morsexpand(varargin)
%MORSEXPAND  Generalized Morse wavelets via time-domain Taylor series.
%
%   PSI=MORSEXPAND(T,GAMMA,BETA,FS) computes the lowest-order
%   generalized Morse wavelet specified by parameters GAMMA and BETA
%   and localized at frequency FS using a time-domain Taylor series.
%
%   PSI=MORSEXPAND(N,...) specifies computing the wavelet using a
%   Taylor-series expansion keeping terms up to power T^N.  N is 
%   optional and defaults to N=100.
%
%   There are no contraints on the size of T nor its ordering.  
%
%   All input parameters other than T should be scalars.
%   __________________________________________________________________
%
%   Taylor-series expansion
%
%   Normally one would use MORSEWAVE to compute the wavelets in
%   the frequency domain, but it is sometimes useful to have an 
%   explicit time-domain representation.
%
%   See Lilly and Olhede (2008b) for details.
%
%   Use of say N=100 leads to an extremely accurate representation of
%   the wavelet within the central time window where its amplitude is
%   substantially different from zero.
%
%   Note however that any Taylor series representation will break down
%   sufficiently far from the wavelet center.  Thus in the long time-
%   domain tails, where the wavelet should have very small values, 
%   MORSEXPAND will incorrectly give unrealistically large values.  
%
%   To remove effects of the Taylor series expansion leading to 
%   incorrect values far from the wavelet center, any coefficients 
%   exceeding the central wavelet maximum value by more than five 
%   percent are set to NaNs.
%   __________________________________________________________________
%
%   See also MORSEWAVE, WAVETRANS.
%   
%   'morsexpand --t' runs a test.
%
%   Usage: psi=morsexpand(t,gamma,beta,fs);
%          psi=morsexpand(n,t,gamma,beta,fs);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin(1), '--t')
    morsexpand_test,return
end

if length(varargin{1})==1
    nmax=varargin{1};
    varargin=varargin(2:end);
else 
    nmax=100;
end

t=varargin{1};
ga=varargin{2};
be=varargin{3};
if anyany(be==0)
    error('Sorry, BETA must be greater than zero.')
end
if length(varargin)>3
    fs=varargin{4};
end
psi=zeros(length(t(:)),nmax+1);
if be~=0
    s=2*pi*morsefreq(ga,be)./(fs*2*pi);
else
    s=1;
end

for n=0:nmax;
    psi(:,n+1)=frac(1,s).*frac((sqrt(-1)*(t./s)).^n,factorial(n)).*morsemom(n,ga,be);
end
psi=vsum(psi,2);

psi0=frac(1,s).*morsemom(0,ga,be);

index=find(abs(psi)>abs(psi0)*1.05);
if ~isempty(index)
    psi(index)=nan;
end

function[]=morsexpand_test
morsexpand_test_frequency

function[]=morsexpand_test_frequency
t=[-500:500]';
fs=1/20; 
gamma=3;
beta=6;

psi=morsexpand(t,gamma,beta,fs);
psi2=morsewave(length(t),1,gamma,beta,fs,'bandpass');

dabs=vdiff(abs(psi),1);
index1=find(dabs.*t>0|isnan(dabs));
if ~isempty(index1)
    psi(index1)=nan;
end
psi([1 end])=nan;
err=vsum(abs(psi-psi2).^2,1);

tol=1e-6;
reporttest('MORSEXPAND versus frequency-domain definition',err<tol)
%figure,uvplot(psi),ylim([-1 1]/4),hold on, uvplot(psi2,'g')


