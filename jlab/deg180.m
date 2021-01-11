function[varargout]=deg180(varargin)
%DEG180  Converts degrees to the range [-180,180].
%
%   [TH1,TH2,...THN]=DEG180(TH1,TH2,...THN) converts the input
%   angles, which are measured in degrees, to the range [-180, 180].
%
%   See also DEG360.
%
%   'deg180 --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    deg180_test,return
end
 
varargout=varargin;
for i=1:nargin;
    varargout{i}=rad2deg(deg2rad(varargin{i}));
end


function[]=deg180_test
thi=[359 181 nan inf];
tho=[-1 -179 nan inf];
tol=1e-10;
reporttest('DEG180 simple',aresame(deg180(thi),tho,tol))
