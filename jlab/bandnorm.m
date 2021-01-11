function[w]=bandnorm(w,fs)
%BANDNORM  Applies a bandpass normalization to a wavelet matrix.
%
%   PSI=BANDNORM(W,F) for a cell array of wavelets PSI having central
%   frequencies F, applies a 'bandpass' normalization. The wavelets are
%   assumed to initially have a unit energy normalization.
%  
%   Specifically, the wavelets are rescaled by (scale)^(-1) instead of
%   (scale)^(-1/2).  Additionally, the wavelets are divided by a constant
%   such that the maximum magnitude of the Fourier transform of the
%   shortest wavelet equals 2.  Together these imply that the wavelet 
%   transform of a real-valued unit-amplitude sinusoid has a maximum 
%   amplitude of unity.  
%
%   For the generalized Morse wavelets, use MORSEWAVE(..., 'bandpass') 
%   instead of calling BANDNORM.
%
%   Usage: psi=bandnorm(psi,f);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(w,'--t')
  bandnorm_test;clear w;return
end

%/********************************************************
%Enforce convention of small scales first
fs=fs(:);
if length(fs)>1
  if fs(1)-fs(2)<0
    fs=flipud(fs);
  end
end
%\********************************************************

for i=1:size(w,2)
   w(:,i,:)=w(:,i,:).*sqrt(fs(i));
end

W=fft(fftshift(w(:,:,1)));
%fi=[0:size(w,1)-1]./size(w,1);
%[mtemp,index]=min(abs(fi-fs(1)));
cn1=2./maxmax(abs(W));
w=w.*cn1;

function[]=bandnorm_test
fs=1./logspace(log10(5),log10(40))'; 
N=1024;
w=morsewave(N,1,2,4,fs,'bandpass');
w2=morsewave(N,1,2,4,fs,'energy');
w2=bandnorm(w2,fs);
reporttest('BANDNORM bandpass matches analytic expression for MORSEWAVE',aresame(w,w2,1e-6))
