function[varargout]=jlab_jdatatest.m(varargin)
%JLAB_JDATATEST.M
%
%   JLAB_JDATATEST.M
%
%   'jlab_jdatatest.m --t' runs a test.
%
%   Usage: []=jlab_jdatatest.m();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    jlab_jdatatest.m_test,return
end
 
function[]=jlab_jdatatest.m_test
 
%reporttest('JLAB_JDATATEST.M',aresame())
