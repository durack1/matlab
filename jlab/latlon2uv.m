function[u,v]=latlon2uv(num,lat,lon)
%LATLON2UV  Converts latitude and logitude to velocity.
%
%   [U,V]=LATLON2UV(MJD,LAT,LON) where MJD is the data in DATENUM format
%   and LAT and LON are the latitude and longitude in degrees, outputs the
%   eastward and northward velocity components U and V in cm/s, computed
%   using the first central difference.
%
%   CV=LATLON2UV(...) with one output argument returns the complex- valued
%   velocity CV=U+SQRT(-1)*V. NANs in LAT or LON become NAN+SQRT(-1)*NAN.
%
%   MJD is a column vector or a matrix of the same size as LAT and LON.  
%   LAT and LON are matices having SIZE(NUM,1) rows.  U and V are the same 
%   size as LAT and LON.  
%  
%   LATLON2UV computes the velocity components from the distance travelled
%   across the surface of the sphere and the heading, taking account of 
%   the sphericity of the earth.
%
%   The radius of the earth is given by the function RADEARTH.
%
%   See also XY2LATLON, LATLON2XY.
%
%   Usage:  [u,v]=latlon2uv(mjd,lat,lon);
%           cv=latlon2uv(mjd,lat,lon);
%
%   'latlon2uv --t' runs a test.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        
  

if strcmp(num, '--t')
    latlon2uv_test,return
end

a=radearth;

if size(num,2)==1
  num=osum(num,zeros(size(lat,2),1));
end
dt=vdiff(num*24*3600);

%[phi,th]=deg2rad(lat,lon);
[x,y,z]=latlon2xyz(lat,lon);

dx=vshift(x,1,1)/2-vshift(x,-1,1)/2;
dy=vshift(y,1,1)/2-vshift(y,-1,1)/2;
dz=vshift(z,1,1)/2-vshift(z,-1,1)/2;

xm=vshift(x,1,1)/2+vshift(x,-1,1)/2;
ym=vshift(y,1,1)/2+vshift(y,-1,1)/2;
zm=vshift(z,1,1)/2+vshift(z,-1,1)/2;

[latm,lonm]=xyz2latlon(xm,ym,zm);
[phim,thm]=deg2rad(latm,lonm);

%Now perform a local rotation
dx2=dx.*cos(-thm)-dy.*sin(-thm);
dy2=dx.*sin(-thm)+dy.*cos(-thm);
dz2=dz;

%dx3=dx2.*cos(-phim)-dz2.*sin(-phim);    %Correct but not needed
dy3=dy2; 
dz3=dx2.*sin(-phim)+dz2.*cos(-phim);

[lat1,lon1]=vshift(lat,lon,1,1);
[lat2,lon2]=vshift(lat,lon,-1,1);

dr=spheredist(lat1,lon1,lat2,lon2)/2;  
gamma=imlog(dy3+sqrt(-1)*dz3);

%vsize(dr,dt,gamma)

%Convert to centimeters
c=100*1000;

u=c.*dr./dt.*cos(gamma);
v=c.*dr./dt.*sin(gamma);

if nargout==1
   u=u+sqrt(-1)*v;
   index=find(isnan(real(u))|isnan(imag(u)));
   if ~isempty(index)
      u(index)=nan+sqrt(-1)*nan;
   end
  u(end,:)=nan+sqrt(-1)*nan;
  u(1,:)=nan+sqrt(-1)*nan;
end

function[]=latlon2uv_test
latlon2uv_dlat_test
latlon2uv_dlon_test
latlon2uv_small_test
latlon2uv_displacement_test
latlon2uv_npg2006_test


function[]=latlon2uv_dlat_test


N=100;
tol=1e-3;

lono=2*pi*rand(1,N)-pi;
lato=pi*rand(1,N)-pi/2;
[lato,lono]=rad2deg(lato,lono);

dlat=[rand(1,N)-1/2]/10;

lat=[lato-dlat;lato;lato+dlat];
lon=[lono;lono;lono];

num=[-1+0*lato;0*lato;1+0*lato];
index=find(max(lat)<90&min(lat)>-90);
vindex(num,lat,lon,dlat,index,2);

u1=0*dlat;
v1=100*1000*2*pi*radearth/360.*dlat/(3600*24);

[u,v]=latlon2uv(num,lat,lon);

b=aresame(u(2,:),u1,tol) && aresame(v(2,:),v1,tol);
reporttest('LATLON2UV small delta latitude',b);



function[]=latlon2uv_dlon_test


N=100;
tol=1e-3;

lono=2*pi*rand(1,N)-pi;
lato=pi*rand(1,N)-pi/2;
[lato,lono]=rad2deg(lato,lono);

dlon=[rand(1,N)-1/2]/10;

lat=[lato;lato;lato];
lon=[lono-dlon;lono;lono+dlon];

num=[-1+0*lato;0*lato;1+0*lato];

u1=100*1000*2*pi*radearth/360.*dlon/(3600*24).*cos(deg2rad(lato));
v1=0*lato;

[u,v]=latlon2uv(num,lat,lon);

b=aresame(u(2,:),u1,tol) && aresame(v(2,:),v1,tol);
reporttest('LATLON2UV small delta longitude',b);


function[]=latlon2uv_small_test


N=100;
tol=1e-3;

lono=2*pi*rand(1,N)-pi;
lato=pi*rand(1,N)-pi/2;
[lato,lono]=rad2deg(lato,lono);

dlon=[rand(1,N)-1/2]/10;
dlat=[rand(1,N)-1/2]/10;

lat=[lato-dlat;lato;lato+dlat];
lon=[lono-dlon;lono;lono+dlon];

num=[-1+0*lato;0*lato;1+0*lato];
index=find(max(lat)<90&min(lat)>-90);
vindex(num,lat,lon,dlat,dlon,lato,index,2);

u1=100*1000*2*pi*radearth/360.*dlon/(3600*24).*cos(deg2rad(lato));
v1=100*1000*2*pi*radearth/360.*dlat/(3600*24);

[u,v]=latlon2uv(num,lat,lon);

b=aresame(u(2,:),u1,tol) && aresame(v(2,:),v1,tol);
reporttest('LATLON2UV small displacements',b);


function[]=latlon2uv_displacement_test


N=100;
tol=1e-3;

lon=2*pi*rand(N,1)-pi;
lat=pi*rand(N,1)-pi/2;

num=[1:N]';
[u,v]=latlon2uv(num,lat,lon);

dr=sqrt(u.^2+v.^2).*(3600.*24)./(100*1000);

[lat1,lon1]=vshift(lat,lon,1,1);
[lat2,lon2]=vshift(lat,lon,-1,1);

dr1=spheredist(lat1,lon1,lat2,lon2)/2;

b=aresame(dr(2:end-1),dr1(2:end-1),tol);
reporttest('LATLON2UV displacement matches SPHEREDIST',b);


function[]=latlon2uv_npg2006_test
load npg2006
use npg2006
cv1=latlon2uv(d,lat,lon);
cv2=vdiff(cx,1).*100.*1000./(3600.*24.*dt);
tol=1/2;
b=aresame(cv1,cv2,tol);
reporttest('LATLON2UV matches VDIFF of Cartesian position for NPG2006 data',b);

