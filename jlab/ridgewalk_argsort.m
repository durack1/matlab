function[N,alpha,chi,alg,fs]=ridgewalk_argsort(struct)
%RIDGEWALK_ARGSORT  Sorts out input arguments for RIDGEWALK.
%
%   [N,ALPHA,CHI,STR,FS]=RIDGEWALK_ARGSORT(VARARGIN);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
fs=struct{1};
if length(struct)>1
    params=struct{2};
else
    params={1.5,0.5,0,'amp'};
end
        
N=params{1};
alpha=params{2};
chi=params{3};
alg=params{4};

%/********************************************************
%Enforce convention of small scales first
fs=fs(:);
if length(fs)>1
  if fs(1)-fs(2)<0
    fs=flipud(fs);
  end
end
%\********************************************************

