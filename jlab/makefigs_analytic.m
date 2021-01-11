function[]=makefigs_analytic(str)
%MAKEFIGS_ANALYTIC  Makes figures for Lilly and Olhede (2008a).
%
%   MAKEFIGS_ANALYTIC  Makes all figures for 
%
%                       Lilly & Olhede (2008a)
%               "On the analytic wavelet transform"
%         Submitted to IEEE Transactions on Information Theory
%
%   Type 'makefigs_analytic' at the matlab prompt to make all figures for
%   this and print them as .eps files into the current directory.
%  
%   Type 'makefigs_analytic noprint' to supress printing to .eps files.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if nargin==0
  str='print';
end
cd_figures


%/********************************************************
%Bell bandwidth illustration figure

%The code for this figure is embedded in BELLBAND
bellband --f1

fontsize jpofigure
set(gcf,'paperposition',[1 1 9 5.5])

if strcmp(str,'print')
   print -deps bell-bandwidths.eps
end
%\********************************************************

%/********************************************************
%Bell bandwidth signal expansion figure

%The code for this figure is embedded in BELLBAND
bellband --f2

fontsize jpofigure
set(gcf,'paperposition',[1 1 7 3.5])

if strcmp(str,'print')
   print -deps bell-expansion.eps
end
%\********************************************************  


%/********************************************************
%Wavelet ridge debiasing figure

%The code for this figure is embedded in RIDGEDEBIAS
ridgedebias --f


fontsize jpofigure
set(gcf,'paperposition',[1 1 7 5])

if strcmp(str,'print')
   print -deps bell-ridge.eps
end
%\********************************************************  


