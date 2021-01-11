function[]=safeindex(varargin)
%SAFEINDEX
%
%   SAFEINDEX
%
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    safeindex_test,return
end
 
function[]=safeindex_test;
 
%reporttest(' SAFEINDEX ',aresame())
