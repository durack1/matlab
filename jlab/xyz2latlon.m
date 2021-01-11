function[lat,lon]=xyz2latlon(x,y,z,R)
%XYZ2LATLON  Converts 3D Cartesian coordinates into latitude and longitude.
%
%   [LAT,LON]=XYZ2LATLON(X,Y,Z) converts Cartesian coordinates of a
%   position on the surface of a sphere into latitude and longitude. 
%
%   LAT and LON are in degrees and X, Y, and Z are in kilometers.  
%   LON is in the range [-180,180].
%
%   The Cartesian coordinate system is a right-handed system whose
%   origin lies at the center of the sphere.  It is oriented with the
%   Z-axis passing though the poles and the X-axis passing through
%   the point LAT=0, LON=0.  
%
%   By default, the radius of the sphere is taken as RADEARTH.
%   XYZ2LATLON(X,Y,Z,R) uses a sphere of radius R, in kilometers,
%   instead.
%
%   XYZ2LATLON is inverted by LATLON2XYZ.
%
%   See JSPHERE for related functions.
%
%   'xyz2latlon --t' runs a test.
%
%   Usage: [lat,lon]=xyz2latlon(x,y,z);
%          [lat,lon]=xyz2latlon(x,y,z,R);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(x, '--t')
    xyz2latlon_test,return
end

if nargin==3
    R=radearth;
end

phi=asin(z./R);
th=imlog(x+sqrt(-1).*y);

[lat,lon]=rad2deg(phi,th);

function[]=xyz2latlon_test
 
lon=[1e-10:2:360]-180;
lat=[-90:2:90];
[lon,lat]=meshgrid(lon,lat);

[x,y,z]=latlon2xyz(lat,lon);
[lat1,lon1]=xyz2latlon(x,y,z);

reporttest('XYZ2LATLON inverts LATLON2XY',aresame(lon1,lon,1e-10) && aresame(lat1,lat,1e-10))


