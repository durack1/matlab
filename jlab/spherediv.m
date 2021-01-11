function[div]=spherediv(lat,lon,uh,vh,R)
%SPHEREDIV  Divergence of a vector field on the surface of a sphere.
%
%   DIV=SPHEREDIV(LAT,LON,U,V) computes the divergence of the vector
%   field (U,V) on the surface of the sphere, including the effects
%   of the spherical geometry. 
%
%   U and V are eastward and northward velocities in meters per second,
%   and DIV is in inverse seconds.
%
%   LAT and LON are vectors specifing an evenly-spaced grid, and U 
%   and V are arrays of size LENGTH(LON) x LENGTH(LAT) x M, where M
%   is greater than or equal to one. LAT and LON are in degrees.
%
%   The radius of the Earth as specified by RADEARTH is used by default.
%   SPHEREDIV(...,R) uses a sphere of radius R, in kilometers, instead.
%
%   See JSPHERE for related functions.
%
%   'spherediv --t' runs a test.
%
%   Usage: div=spherediv(lat,lon,u,v);
%          div=spherediv(lat,lon,u,v,R);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(lat, '--t')
    spherediv_test,return
end

if nargin==4
    R=radearth;
end
R=R*1000;

[phi,theta]=deg2rad(lat,lon);
dphi=phi(2)-phi(1);
dth=theta(2)-theta(1);
[lon,lat]=meshgrid(lon,lat);

if ~aresame(size(lon),[size(uh,1),size(uh,2)])
    error('U and V must be oriented with longitude in columns and latitude in rows.')
end
if ~aresame(size(uh),size(vh))
    error('U and V must be the same size.')
end
if dphi<0
    error('LAT should be ordered as an increasing array.')
end
    
if size(uh,3)>1
    vrep(lon,lat,size(uh,3),3);
end

[phi,theta]=deg2rad(lat,lon);
[u,v,w]=hor2uvw(lat,lon,uh,vh);
[v1,v2,v3]=uvw2sphere(lat,lon,u,v,w);


div=frac(1,R.*cos(phi).*dphi).*vdiff(v3.*cos(phi),1)+frac(1,R.*cos(phi).*dth).*vdiff(v2,2);
%DIV = 1 / (R cos(phi) dphi)  * d/dphi vphi*cos(phi) + 1 / (R cos(phi) dth)* d/dth vth

function[]=spherediv_test
 
lon=[1e-10:2:360]-180;
lat=[-90:2:90];
[long,latg]=meshgrid(lon,lat);

u=1+0*latg;
v=0*latg;

div=spherediv(lat,lon,u,v);
tol=1e-6;
reporttest('SPHEREDIV divergenceless eastward velocity field',maxmax(abs(div))<tol)

[phi,theta]=deg2rad(latg,long);
u=0*latg;
v=1./cos(phi);

div=spherediv(lat,lon,u,v);
tol=1e-6;
reporttest('SPHEREDIV divergenceless northward velocity field',maxmax(abs(div))<tol)

u=0*latg;
v=1+0*latg;

[phi,theta]=deg2rad(lat,lon);
dphi=phi(2)-phi(1);
[phi,theta]=deg2rad(latg,long);
div2=frac(1,1000*radearth.*cos(phi).*dphi).*vdiff(v.*cos(phi),1);

div=spherediv(lat,lon,u,v);
tol=1e-6;
reporttest('SPHEREDIV constant northward velocity field',maxmax(abs(div2-div))<tol)
