function[varargout]=deg2rad(varargin)
%DEG2RAD  Converts degrees to radians.
%
%   [R1,R2,...RN]=DEG2RAD(D1,D2,...DN) converts the input angles from
%   degrees to radians.  Output angles are in the range [-pi,pi), that
%   is, +/-180 degrees is defined to corresponds to -pi radians.
%
%   NANs and INFs in the input arguments are preserved.
%
%   See also RAD2DEG, DEG180, DEG360. 
% 
%   'deg2rad --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    deg2rad_test,return
end

c=2*pi/360;

varargout=varargin;
for i=1:nargin;
    theta=angle(rot(varargin{i}.*c));
    index=find(theta==pi);
    if ~isempty(index)
        theta(index)=-pi;
    end
    theta(~isfinite(theta))=varargin{i}(~isfinite(theta));      
    varargout{i}=theta;
end

 
function[]=deg2rad_test
th  =[0 90   180 -90   0    360+90 inf nan];
th2= [0 pi/2 -pi -pi/2 0 pi/2 inf nan];
reporttest('DEG2RAD simple',aresame(deg2rad(th),th2))
 
