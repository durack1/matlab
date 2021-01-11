function[b]=iscol(x)
%ISCOL   Tests whether the argument is a column vector
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002, 2004 J.M. Lilly --- type 'help jlab_license' for details  
b=(ndims(x)==2) && size(x,2)==1 && size(x,1)>1;
