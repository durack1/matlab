function[f]=morsemax(varargin)
%MORSEMAX  High-frequency cutoff of the generalized Morse wavelets.
%
%   FMAX=MORSEMAX(GAMMA,BETA,ALPHA) returns the high frequency cutoff
%   FMAX of the generalized Morse wavelet specified by GAMMA and BETA, 
%   with cutoff level ALPHA.
%
%   Specifically, if PSI is the wavelet and PSIMAX is its maximum value, 
%   then FMAX is the highest cyclic frequency at which 
%
%      PSI(FMAX)/PSIMAX > ALPHA.
%
%   This gives a way to choose the high-frequency cutoff in the wavelet
%   transform.  See Lilly and Olhede (2008) for details.
%
%   Note that all frequency quantities here are *cyclic* as in
%   in cos(2 pi f t), and not radian as in cos(omega t).     
%  
%   The input parameters may either all be scalars, or GAMMA and BETA
%   may be scalars of the same size with scalar ALPHA.
%   ___________________________________________________________________
%
%   Precision vs. speed
%
%   MORSEMAX(..., N) uses 1/N times the peak frequency MORSEFREQ as the
%   numerical interval.  N=100 is the default; choose a smaller value
%   for faster speed but diminished precision. 
%   ___________________________________________________________________
%  
%   See also MORSEFREQ, MORSEWAVE.
%
%   'morsemax --f' generates a sample figure.
%   'morsemax --t' runs a test.
%
%   Usage: fmax=morsemax(ga,be,alpha);
%          fmax=morsemax(ga,be,alpha,N);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--f')
    morsemax_figure,return
elseif strcmp(varargin{1}, '--t')
    morsemax_test,return
end

gamma=varargin{1};
beta=varargin{2};
alpha=varargin{3};
if nargin>3
    N=varargin{4};
end
    
if nargin~=3&&nargin~=4;
    error('MORSEMAX takes either three or four input arguments.')
end


ompeak=2*pi*morsefreq(gamma,beta);
N=100;

dom=vrep(ompeak/N,10*N,3);
dom(:,:,1)=ompeak;

ommat=cumsum(dom,3);

amat=vrep(morsea(gamma,beta),10*N,3);
betamat=vrep(beta,10*N,3);
gammamat=vrep(gamma,10*N,3);

morse=frac(1,2)*amat.*(ommat.^betamat).*exp(-ommat.^gammamat);

kk=vsum(morse>alpha,3);
ii=vrep([1:size(gamma,1)]',size(gamma,2),2);
jj=vrep(1:size(gamma,2),size(gamma,1),1);

index=sub2ind(size(morse),ii,jj,kk);

f=frac(1,2*pi)*ommat(index);



function[]=morsemax_figure
 
ga1=[1:.1:11];
be1=[1:.1:10];

[ga,be]=meshgrid(ga1,be1);

ompeak=2*pi*morsefreq(ga,be);
ommax=2*pi*morsemax(ga,be,0.1,10);

figure
contourf(ga1,be1,log(ommax./ompeak),20),colorbar,nocontours

title('Morse Wavelet Log ( f_{max} / f_{peak})')
xlabel('Gamma Parameter')
ylabel('Beta Parameter')



function[]=morsemax_test

ga=3;
be=4;
alpha=0.1;
ompeak=2*pi*morsefreq(ga,be);
N=100;

dom=ompeak/N+zeros(11*N,1);
om=cumsum(dom,1);

morse=frac(1,2)*morsea(ga,be).*(om.^be).*exp(-om.^ga);

ommax=2*pi*morsemax(ga,be,0.1);

%figure,plot(om,morse),hold on,vlines(ommax),hlines(alpha)

reporttest('MORSEMAX',aresame(ommax,om(max(find(morse>alpha))),1e-4))
