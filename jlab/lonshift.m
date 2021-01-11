function[varargout]=lonshift(varargin)
%LONSHIFT  Shifts longitude origin for plotting purposes.
%
%   LON=LONSHIFT(LONO,LON) shifts the array LON such that its first
%   point its just greater than LONO. This is used for controlling
%   where the longitude break occurs on a map of the earth.
%
%   [LON,X1,X2,...XN]=LONSHIFT(LONO,LON,X1,X2,...XN) also shifts the
%   N matrices X1...XN.  These matrices must be oriented such that 
%   their number of columns is the same as the length of LON. 
%
%   'lonshift --t' runs a test.
%
%   Usage:  lon=lonshift(lono,lon);
%           [lon,x1,x2,x3]=lonshift(lono,lon,x1,x2,x3);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    lonshift_test,return
end

clon=varargin{1};
lon=varargin{2};
na=nargin-2;
varargin=varargin(3:end);

[lon,clon]=deg180(lon,clon);

if anyany(lon<clon)
   index=min(find(clon<lon))-1;
else
   index=min(find(deg360(clon)<deg360(lon)))-1;
end

lon=row2col(lon);
lon=vshift(lon,index,1);

lon=frac(360,2*pi)*(unwrap(deg2rad(lon)));
lon=deg180(lon);

varargout{1}=lon;

for i=1:na;
   varargout{i+1}=vshift(varargin{i},index,2);
end


function[]=lonshift_test

lon=[-179.5:1:179.5]';
lat=[-59.5:1:59.5]';
[lonmat,latmat]=meshgrid(lon,lat);

[lon1,lonmat1,latmat1]=lonshift(30,deg360(lon),lonmat,latmat);
[lon2,lonmat2,latmat2]=lonshift(-180,lon1,lonmat1,latmat1);

tol=1e-10;
reporttest('LONSHIFT reversibility',aresame(lon,lon2,tol)&&aresame(latmat,latmat2)&&aresame(lonmat,lonmat2))
