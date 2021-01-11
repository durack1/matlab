function[lap]=spherelap(lat,lon,f,R)
%SPHERELAP  Laplacian of a field on the surface of a sphere.
%
%   DEL2=SPHERELAT(LAT,LON,F) computes the Laplacian of the scalar
%   field F on the surface of the sphere, including the effects of 
%   the spherical geometry.  
%
%   DEL2 has units of F per invers meter squared.
%
%   LAT and LON are vectors specifing an evenly-spaced grid, and F 
%   is an array of size LENGTH(LON) x LENGTH(LAT) x M, where M is
%   greater than or equal to one.  LAT and LON are in degrees.
%
%   The radius of the Earth as specified by RADEARTH is used by default.
%   SPHERELAP(...,R) uses a sphere of radius R, in kilometers, instead.
%
%   See JSPHERE for related functions.
%
%   'spherelap --t' runs a test.
%
%   Usage: []=spherelap();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(lat, '--t')
    spherelap_test,return
end
if nargin==3
    R=radearth;
end

R=R*1000;  %Convert to meters

[phi,theta]=deg2rad(lat,lon);
dphi=phi(2)-phi(1);
dth=theta(2)-theta(1);
[lon,lat]=meshgrid(lon,lat);

if ~aresame(size(lon),[size(f,1),size(f,2)])
    error('F must be oriented with longitude in columns and latitude in rows.')
end

if dphi<0
    error('LAT should be ordered as an increasing array.')
end
    
if size(f,3)>1
    vrep(lon,lat,size(f,3),3);
end
[phi,theta]=deg2rad(lat,lon);


lapa=frac(1,sin(theta).^2).*frac(1,dphi.^2).*vdiff(vdiff(f.*cos(phi),1),1);
lapb=frac(1,sin(theta)).*frac(1,dth.^2).*vdiff(sin(theta).*vdiff(f,2),2);

lap=lapa+lapb;
tol=1e-6;
index=find(abs(cos(phi))<tol);
if ~isempty(index)
    lap(index)=nan;
end

function[]=spherelap_test
 
%reporttest('SPHERELAP',aresame())
