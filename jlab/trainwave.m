function[phi]=trainwave(varargin)
%TRAINWAVE  Returns modified wavelet occurring in eddy train analysis.
%
%   PHI=TRAINWAVE(BETA,T,S) gives the time-domain form of the modified
%   wavelet PHI at time T and scale S occurring in eddy train analysis.
% 
%   The wavelet is based on a genealized Morse wavelet with parameters 
%   gamma=2 and beta=BETA.
%
%   See Lilly and Olhede 2008 for details.
%
%   T and S must be arrays of the same size, and BETA can either be a 
%   scalar or an array of the same size as T and S.  PHI is also the 
%   same size as T and S.
%
%   TRAINWAVE(N,BETA,T,S) uses N terms in a Taylor-series expansion to
%   obtain the time-domain form of PHI.  N defaults to 100. 
%   
%   See also MORSEWAVE, MORSEXPAND.
%
%   'trainwave --t' runs a test.
%
%   Usage: phi=trainwave(be,t,s);
%          phi=trainwave(n,be,t,s);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin, '--t')
    trainwave_test,return
end
 
if nargin==4;
    nmax=varargin{1};
    varargin=varargin(2:end);
else 
    nmax=100;
end

be=varargin{1};
t=varargin{2};
s=varargin{3};

if allall(t==0)
    nmax=1;
end

if length(be)==1
    be=be+zeros(size(t));
end

if ~aresame(size(t),size(s))
    error('T and S must be the same size')
end

cbeta=trainconst(be);
ssqrt=sqrt(1+frac(1,2*s.^2));
%fs=om_{be,ga}/(2*pi*s)
om=2*pi*morsefreq(2,be);
fs=om./(2*pi*s.*ssqrt);
phi=cbeta.*(1./s).*frac(1,ssqrt.^(be+1)).*morsexpand(nmax,t,2+0*be,be,fs);

function[]=trainwave_test
be=[1:.25:20]';
om=2*pi*morsefreq(2,be);
phi=trainwave(be,0*be,om);
reporttest('TRAINWAVE modified wavelet at 0 equals sqrt(2*pi)',aresame(phi,sqrt(2*pi)+0*phi,1e-6))
