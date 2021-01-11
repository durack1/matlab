function[K]=morsewarp(ga,be)
%MORSEWARP
%
%   MORSEWARP
%
%   'morsewarp --t' runs a test.
%
%   Usage: []=morsewarp();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    morsewarp_test,return
end
 
%om=2*pi*morsefreq(ga,be);
om=linspace(0,10,1000)';
t=linspace(-10,10,100)';
u=t;

frac(1,2*pi)

function[]=morsewarp_test
 
%reporttest('MORSEWARP',aresame())
