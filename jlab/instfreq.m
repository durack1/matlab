function[omega,upsilon]=instfreq(varargin)
%INSTFREQ  Instantaneous frequency and bandwidth.
%
%   OMEGA=INSTFREQ(X), where X is an analytic signal, computes the
%   instantaneous *angular* frequency OMEGA using the first central 
%   difference and assuming a unit sample rate. 
%
%   [OMEGA,UPSILON]=INSTFREQ(X) also returns the instantaneous 
%   bandwidth UPSILON.
%
%   ETA=INSTFREQ(X,'complex') optionally returns the complex-valued
%   instantaneous frequency ETA=OMEGA-i*UPSILON.
%
%   X is an array with the first dimension being "time".  Thus, X can
%   be a matrix of signals oriented as column vectors, or a 2- or 3-D
%   wavelet transform such as output by WAVETRANS.
%
%   The output arrays are the same size as X. 
%
%   X should be an analytic signal, such as that created with 
%   ANATRANS or Matlab's HILBERT, or the wavelet transform with an 
%   anayltic wavelet such as that produced by WAVETRANS. 
%
%   X may also be anti-analytic; see below.
%
%   INSTFREQ(DT,X) uses sample interval DT; DT=1 is the default.
%   ___________________________________________________________________
%
%   Definition
%
%   The instantaneous frequecy and bandwidth are defined as 
%
%                OMEGA  = d/dt Im ln X = d/dt angle X
%               UPSILON = d/dt Re ln X = d/dt ln abs X 
%   
%   while Lilly and Olhede (2008a) suggest grouping these as
%
%                  ETA  = OMEGA - SQRT(-1)* UPSILON
%  
%   where ETA is called the complex instantaneous frequency.
%   _________________________________________________________________
%
%   Anti-analytic (negatively rotating) signals
%
%   The convention is adopted that phase should be defined to increase
%   with time for both analytic and anti-analytic signals.  This 
%   follows the notation of Lilly and Gascard (2006).
%
%   To accomplish this, the sign of OMEGA is adjusted such that the
%   mean value of OMEGA is postive.  Thus, X should not contain a 
%   mixture of analytic and anti-analytic signals.
%   _________________________________________________________________
%
%   Usage: om=instfreq(x);
%          [om,up]=instfreq(dt,x);
%          eta=instfreq(dt,x,'complex');
%
%   See also BELLBAND, ANATRANS.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    instfreq_test,return
end

if ischar(varargin{end})
    str=varargin{end};
    varargin=varargin(1:end-1);
else
    str='real';
end

if length(varargin)==1
    dt=1;
    x=varargin{1};
else
    dt=varargin{1};
    x=varargin{2};
end

eta=vdiff(imlog(x)-sqrt(-1)*relog(x),1)./dt;
omega=real(eta);
upsilon=-imag(eta);

if vmean(omega(:),1)<0
    omega=-omega;
end

if strcmp(str(1:3),'com')
    omega=omega-sqrt(-1)*upsilon;
end

%function[]=instfreq_test
%reporttest('INSTFREQ',aresame())
