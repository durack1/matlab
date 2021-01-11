function[p,skew,kurt]=morseprops(ga,be)
%MORSEPROPS  Properties of the demodulated generalized Morse wavelets. 
%
%   [P,SKEW,KURT]=MORSEPROPS(GAMMA,BETA) returns properties of the 
%   demodulated generalized Morse wavelet specified by GAMMA and BETA.
%  
%   P is the dimensionless time-domain window width.
%
%   SKEW is the imaginary part of normalized third moment of the 
%   time-domain demodulate, or 'demodulate skewness'.
%
%   KURT is the normalized fourth moment of the time-domain demodulate, 
%   or 'demodulate kurtosis'.
%
%   See Lilly and Olhede (2008b) for details.
%
%   'morseprops --t' runs a test.
%
%   Usage: [p,skew,kurt]=morseprops(ga,be);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(ga, '--t')
    morseprops_test,return
end
 
p=sqrt(be.*ga);
skew=frac(ga-3,p);
kurt=3-skew.^2-frac(2, p.^2);

function[]=morseprops_test
%Careful which (beta,gamma) values you choose, owing to slow 
%time decay for small values of beta

bool=morseprops_testthis(5,6,1/20,2e-3);
reporttest('MORSEPROPS gamma=5, beta=6',bool)
bool=morseprops_testthis(2,4,1/20,2e-3);
reporttest('MORSEPROPS gamma=2, beta=4',bool)

function[bool]=morseprops_testthis(ga,be,dt,tol)

om=2*pi.*morsefreq(ga,be);
fs=om/(2*pi)*dt;
psi=morsewave(512*4,1,ga,be,fs);

t=[1:length(psi)]'*dt;t=t-mean(t);

[p,skew,kurt]=morseprops(ga,be);
[mu,sigma,skew2,kurt2]=pdfprops(t,psi.*rot(-t*2*fs*pi./dt));

tol=2e-3;
bool=aresame(skew,imag(skew2),tol)&&aresame(kurt,kurt2,tol);
