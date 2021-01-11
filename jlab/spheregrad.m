function[gradx,grady]=spheregrad(lat,lon,f,R)
%SPHEREGRAD  Gradient of a field on the surface of a sphere.
%
%   [FX,FY]=SPHEREGRAD(LAT,LON,F) computes the gradient of the scalar
%   field F on the surface of the sphere, including the effects of 
%   the spherical geometry.  
%
%   FX and FY are the components of the gradient of F in the zonal 
%   and meridional directions, respectively, with units of F per meter.
%
%   LAT and LON are vectors specifing an evenly-spaced grid, and F 
%   is an array of size LENGTH(LON) x LENGTH(LAT) x M, where M is
%   greater than or equal to one.  LAT and LON are in degrees.
%
%   The radius of the Earth as specified by RADEARTH is used by default.
%   SPHEREDIV(...,R) uses a sphere of radius R, in kilometers, instead.
%
%   See JSPHERE for related functions.
%
%   'spheregrad --t' runs a test.
%
%   Usage: grad=spheregrad(lat,lon,f);
%          grad=spheregrad(lat,lon,f,R);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(lat, '--t')
    spheregrad_test,return
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

gradx=frac(1,R.*cos(phi).*dth).*vdiff(f,2);
grady=frac(1,R.*dphi).*vdiff(f,1);

tol=1e-6;
index=find(abs(cos(phi))<tol);
if ~isempty(index)
    gradx(index)=nan;
end

function[]=spheregrad_test
 
lon=[0:2:358]-180;
lat=[-90:2:90];
[long,latg]=meshgrid(lon,lat);

f=latg*1e6;

df=2*1e6/(2*2*pi/360)/(1000*radearth);
 
[gradx,grady]=spheregrad(lat,lon,f);

tol=1e-6;
reporttest('SPHEREGRAD purely meridional gradient',maxmax(abs(grady-df))<tol)

f=long*1e6;
[gradx,grady]=spheregrad(lat,lon,f);
df=2*1e6./(2*2*pi/360)./(1000*radearth.*cos(deg2rad(latg)));
tol=1e-6;
%index=find(abs(cos(deg2rad(latg)))<tol);
%df(index)=nan;
reporttest('SPHEREGRAD purely zonal gradient',maxmax(abs(gradx-df))<tol)


f=latg.^2+long.^3;
u=1+0*latg;
v=1+0*latg;
div=spherediv(lat,lon,u,v);
[gradx,grady]=spheregrad(lat,lon,f);

x1=spherediv(lat,lon,f.*u,f.*v);
x2=f.*div+u.*gradx+v.*grady;

tol=1e-4;
reporttest('SPHEREGRAD, SPHEREDIV flux identity',aresame(x1,x2,tol))


