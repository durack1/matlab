function[struct,bool]=ridgewalk(varargin)
% RIDGEWALK  Extract wavelet transform ridges.
%  
%   STRUCT=RIDGEWALK(W,FS) where W is a wavelet transform matrix at
%   frequecies FS, returns the wavelet ridges of transform W organized
%   as a ridge structure STRUCT.  
%
%   Note W must be a complex-valued wavelet transform, not a transform 
%   modulus.  The frequency array FS assumes a unit sample rate.
%
%   The columns of W correspond to different frequencies, specified by
%   the array FS, at which the wavelet transform was performed.  The
%   frequencies FS are considered to be always positive.  The third 
%   dimension of WR, if it has greater than unit length, corresponds to
%   the different elements of a multi-component time series.  
% 
%   STRUCT has the following format:
%
%    Transform and sampling information
%
%       STRUCT.SIZ    Size of original data
%       STRUCT.DT     Sample rate (default=1)
%       STRUCT.FS     Array of frequencies at transform scales
%       STRUCT.ALG    Ridge algorithm name; see below    
%
%    Transform quantities along ridges
%
%       STRUCT.WR     Transform values
%       STRUCT.FR     Transform frequency values in cyclic frequency
%
%    Ridge indices
%
%       STRUCT.IR     Ridge indices into rows of W (time) 
%       STRUCT.JR     Ridge indices into columns of W (scale)
%       STRUCT.KR     Ridge indices into pages of W (time series number)
%
%   The five ridge variables IR, JR, KR, WR, and FR are matrices of the 
%   same size, and contain one column per ridge.  Since the lengths of 
%   the ridges varies, missing values are filled with NANs. 
%
%   Typing 'use struct' maps all fields of the structure called 'struct'
%   into the current workspace, i.e. into variables 'sz', 'fs', etc.
%   _______________________________________________________________
%
%   Signal estimation
%
%   The analytic signals is estimated by WR, while the real-valued signal
%   is estimated by REAL(WR).
% 
%   The de-biased signal estimator of Lilly and Olhede (2007a) is created
%   by RIDGEDEBIAS.
%   _______________________________________________________________
%
%   Options
%
%   STRUCT=RIDGEWALK(W,FS,{N,ALPHA,CHI,ALG}) specifies options for the
%   ridge computation.
%
%        N  -- Removes all ridges of less than N periods in length
%      CHI  -- Removes all small amplitude ridge points having |W|<CHI
%    ALPHA  -- Controls agressiveness of chaining across scales; see below
%      ALG  -- String specifying algorithm; see below
%
%   STRUCT=RIDGEWALK(W,FS,{ 1.5,   0.5,    0    ,'amp'}) is the default.
%                            |      |      |       | 
%                            N    ALPHA   CHI     ALG
%   ___________________________________________________________________
%
%   Frequencies and angles
% 
%   RIDGEWALK uses the mixed convention that all angles are angular or 
%   radian as in cos(phi), whereas all frequecies are *cyclic* as in 
%   cos(2 pi f t) and not radian frequencies as in cos(omega t).  
%
%   Note that the Lilly et. al published papers use radian frequency.
%
%   The ridge frequencies FR are the values of the transform frequency F, 
%   as computed by TRANSFREQ, along the ridges. The sample rate DT is 
%   accounted for.
%   ___________________________________________________________________
%
%   Ridge types
%
%   Several different definitions may be used to locate the ridges.
%
%   ALG chooses the ridge type, where ALG may be any of the following:
%
%         'phase'       Rate of transform change of phase definition
%         'amplitude'   Maxima of transfom amplitude definition
% 
%   If ALG is not specified, 'amplitude' is used by default.
%
%   See Lilly and Olhede (2007a) for details.
%   ___________________________________________________________________
%
%   Sample rate
%
%   STRUCT=RIDGEWALK(DT,...) uses timestep DT to compute the transform
%   frequency array F and the ridge frequencies FR.  The default value of 
%   DT is unity.  
%
%   Note that the scale frequecies FS always assume a unit sample rate.
%   ___________________________________________________________________
%
%   Chaining parameter
%
%   The chaining parameter ALPHA specifies the agressiveness with which
%   ridge points are chained across scales.  
%
%   The default value of ALPHA is one-half.
%
%   Increase ALPHA to chain ridges more agressively across scales; 
%   decrease ALPHA to supress chaining across scales.
%
%   See Lilly and Olhede (2007c) for a definition of and motivation 
%   behind ALPHA.
%   ___________________________________________________________________
%
%   Interscale interpolation
%   
%   RIDGEWALK interpolates among discrete scale levels to yield more
%   accurate values for the ridge quantities WR and FR using a fast
%   quadratic interpolation.  
%   
%   See RIDGEINTERP and QUADINTERP for details.
%   ___________________________________________________________________
%
%   See also WAVETRANS, RIDGEMAP, RIDGEDEBIAS.
%
%   'ridgewalk --t' runs a test.
%
%   Usage: struct=ridgewalk(w,fs);
%          struct=ridgewalk(w,fs,{N,ALPHA,CHI,'amp'});
%          struct=ridgewalk(dt,w,fs,{N,ALPHA,CHI,'amp'});
%          struct=ridgewalk(dt,w,fs,{1.5,0.5,0,'amp'});
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details        


%   ______________________________________________________________
%
%   ALPHA is defined as a normalized frequency difference
%
%         ALPHA  =  DOMEGA / OMEGA.^2
%
%   where OMEGA is the transform frequency, and DOMEGA is the difference
%   between the frequency predicted for the next point based on the
%   transform at a "tail", and the actual frequency at prospective "heads". 
%
%   The chaining parameter is defined in such a way that it does not
%   need to be changed as time sampling or frequency sampling changes.
%   However, for strongly chirping signals or weakly chirping, noisy 
%   signals, better performance may be obtianed by adjusting it.
%   ______________________________________________________________
%
%   Spurious ridge points
%
%   RIDGEWALK has a continigency for rejecting spurious ridge points.
%   These tend to occur on the flanks of interesting signals, and 
%   reflect the wavelet structure rather than the signal structure.
%
%   See ISRIDGEPOINT for details.


%         'groove'      Joint amplitude / phase defintion

if strcmp(varargin{1}, '--t')
    ridgewalk_test,return
end

if length(varargin{1})==1
    dt=varargin{1};
    varargin=varargin(2:end);
else
    dt=1;
end

w=varargin{1};
varargin=varargin(2:end);

[N,alpha,chi,alg,fs]=ridgewalk_argsort(varargin);

disp('RIDGEWALK locating ridge points...')
bool=isridgepoint(w,fs,chi,alg);

disp('RIDGEWALK creating ridge structure...')
struct=ridgestruct(w,fs,dt,bool,N,alpha,alg);

disp('RIDGEWALK finished.')


function[]=ridgewalk_test

use npg2006

%Decide on frequencies
fs=1./(logspace(log10(10),log10(100),50)');

%Compute wavelet transforms using generalized Morse wavelets
wx=wavetrans(real(cx),{1,2,4,fs,'bandpass'},'mirror');
wy=wavetrans(imag(cx),{1,2,4,fs,'bandpass'},'mirror');
[wp,wn]=transconv(wx,wy,'uv2pn');

%Form ridges of component time series
nstruct=ridgewalk(dt,wn,fs,{1.5,0.5,0,'phase'}); 
nstruct2=ridgewalk(dt,wn,fs,{1.5,0.5,0,'amplitude'});

err=vmean((abs(nstruct.wr-nstruct2.wr)./abs(nstruct.wr)).^2,1);
reporttest('RIDGEWALK phase and amplitude signal estimation error test for NPG-06',err<1e-3)
