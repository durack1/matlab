function[x,y,z]=latlon2xyz(lat,lon,R)
%LATLON2XYZ  Converts latitude and longitude into 3D Cartesian coordinates.
%
%   [X,Y,Z]=LATLON2XYZ(LAT,LON) converts latitude and longitude of 
%   a position on the surface of a sphere into Cartesian coordinates.  
%
%   LAT and LON are in degrees and X, Y, and Z are in kilometers.
%
%   The Cartesian coordinate system is a right-handed system whose
%   origin lies at the center of the sphere.  It is oriented with the 
%   Z-axis passing though the poles and the X-axis passing through
%   the point LAT=0, LON=0.  
%
%   By default, the radius of the sphere is taken as RADEARTH.
%   LATLON2XYZ(LAT,LON,R) uses a sphere of radius R, in kilometers,
%   instead.
%
%   LATLON2XYZ is inverted by XYZ2LATLON.
%
%   See JSPHERE for related functions.
%
%   'latlon2xyz --t' runs a test.
%
%   Usage: [x,y,z]=latlon2xyz(lat,lon);
%          [x,y,z]=latlon2xyz(lat,lon,R);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(lat, '--t')
    latlon2xyz_test,return
end

if nargin==2
    R=radearth;
end

phi=deg2rad(lat);
th=deg2rad(lon);

x=R.*cos(phi).*cos(th);
y=R.*cos(phi).*sin(th);
z=R.*sin(phi);

function[]=latlon2xyz_test
lat=[0 0  45         45        -90]';
lon=[0 90 0         -90         0 ]';
x=  [1 0  sqrt(2)/2  0          0 ]';
y=  [0 1  0         -sqrt(2)/2  0 ]';
z=  [0 0  sqrt(2)/2  sqrt(2)/2 -1]';

[x2,y2,z2]=latlon2xyz(lat,lon,1);
tol=1e-6;
reporttest('LATLON2XYZ example points',aresame(x,x2,tol)&&aresame(y,y2,tol)&&aresame(z,z2,tol))
