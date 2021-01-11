function[varargout]=jmedian(varargin)
%JMEDIAN
%
%   JMEDIAN
%
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    jmedian_test,return
end
 
function[]=jmedian_test
 
%reporttest('JMEDIAN',aresame())
