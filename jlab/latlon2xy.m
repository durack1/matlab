function[varargout]=latlon2xy(varargin)
% LATLON2XY  Converts latitude and longitude into local Cartesian coordinates.
%
%   [X,Y]=LATLON2XY(LAT,LON,LATO,LONO) converts (LAT,LON) with units
%   of degrees into displacements (X,Y) in a plane tangent to the 
%   earth at the point (LATO, LONO). X and Y have units of kilometers.
%
%   CX=LATLON2XY(LAT,LON,LATO,LONO) with one output argument returns 
%   the location as a complex-valued quantity X+SQRT(-1)*Y. NANs in
%   LAT or LON become NAN+SQRT(-1)*NAN.
%
%   LATO and LONO are optional and default to the mean values of LAT 
%   and LON respectively.  [..., LATO,LONO]=LATLON2XY(LAT,LON) then 
%   returns the computed values.  
%
%   LON and LONO may each either be specified on the interval
%   [-180, 180] or on the interval [0, 360].
%
%   X and Y may be computed with either the full spherical geometry,
%   the default, or using a small angle approximation.  To specify the
%   small angle approximation use LATLON2XY(..., 'small');
%
%   The radius of the earth is given by the function RADEARTH.
%
%   LATLON2XY is inverted by XY2LATLON.
%
%   See also XY2LATLON, LATLON2UV.
%
%   Usage:  [x,y]=latlon2xy(lat,lon,lato,lono);
%           cx=latlon2xy(lat,lon,lato,lono);
%
%   'latlon2xy --t' runs a test.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2007 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(varargin{1}, '--t')
  latlon2xy_test,return
end

na=nargin;
if ischar(varargin{end})
    str=varargin{end};
    na=na-1;
else 
    str='sphere';
end

if na==2
   lat=varargin{1};
   lon=varargin{2};
   lono=vmean(lon(:),1);
   lato=vmean(lat(:),1);
elseif na==4
   lat=varargin{1};
   lon=varargin{2};
   lato=varargin{3};
   lono=varargin{4};
end


[lat,lon,lato,lono]=deg2rad(lat,lon,lato,lono);


if strcmp(str(1:3),'sma')
     [x,y]=latlon2xy_cartesian(lat,lon,lato,lono);
elseif strcmp(str(1:3),'sph')
     [x,y]=latlon2xy_sphere(lat,lon,lato,lono);
end


if nargout==1 || nargout==3
  cx=x+sqrt(-1)*y;
  index=find(isnan(real(cx))|isnan(imag(cx)));
  if ~isempty(index)
     cx(index)=nan+sqrt(-1)*nan;
  end
  varargout{1}=cx;
  varargout{2}=lato;
  varargout{3}=lono;
else
  varargout{1}=x;
  varargout{2}=y;  
  varargout{3}=lato;
  varargout{4}=lono;
end

function[x,y]=latlon2xy_cartesian(lat,lon,lato,lono)

R=radearth;
r1=radearth.*cos(lato);
dlon=angle(rot(lon-lono));
x=dlon.*r1;
y=(lat-lato).*R;

function[x,y]=latlon2xy_sphere(lat,lon,lato,lono)

R=radearth;
x=R*cos(lat).*sin(lon-lono);
y=-R*cos(lat).*sin(lato).*cos(lon-lono)+R.*cos(lato).*sin(lat);





function[]=latlon2xy_test
latlon2xy_sphere_test1
latlon2xy_sphere_test2
xy2latlon_test

function[]=latlon2xy_sphere_test1


N=100;
tol=1e-4;

lon=2*pi*rand(N,1)-pi;
lat=pi*rand(N,1)-pi/2;
[lat,lon]=rad2deg(lat,lon);

lat=lat/1000;
lon=lon/1000;

[x,y]=latlon2xy(lat,lon,0,0,'sphere');
[x2,y2]=latlon2xy(lat,lon,0,0,'small');

b=aresame(x,x2,tol) && aresame(y,y2,tol);
reporttest('LATLON2XY Cartesian and spherical algorithms match for small LAT and LON about zero',b);



function[]=latlon2xy_sphere_test2

N=100;
tol1=1e-1;
tol2=1e-1;

lon=2*pi*rand(N,1)-pi;
lat=pi*rand(N,1)-pi/2;
[lat,lon]=rad2deg(lat,lon);

lat=lat/1000;
lon=lon/1000;

lono=2*pi*rand(N,1)-pi;
lato=pi*rand(N,1)-pi/2;
[lato,lono]=rad2deg(lato,lono);

lat=lat+lato;
lon=lon+lono;

clear x y lat2 lon2

for i=1:length(lato)
    [x(i,1),y(i,1)]=latlon2xy(lat(i),lon(i),lato(i),lono(i),'sphere');
    [lat2(i,1),lon2(i,1)]=xy2latlon(x(i),y(i),lato(i),lono(i),'sphere');
end

[x2,y2]=latlon2xy(lat,lon,lato,lono);

b=aresame(x,x2,tol1) && aresame(y,y2,tol1);
reporttest('LATLON2XY Cartesian and spherical algorithms match for small LAT and LON perturbations',b);

b=aresame(lat,lat2,tol2) && aresame(lon,lon2,tol2);
reporttest('XY2LATLON Cartesian and spherical algorithms match for small LAT and LON perturbations',b);



function[]=xy2latlon_test

latc=44;
lonc=0;
N=100;

x=randn(N,1)*5;
y=randn(N,1)*5;
[lat,lon]=xy2latlon(x,y,latc,lonc,'small');
[x2,y2]=latlon2xy(lat,lon,latc,lonc,'small');

tol=1e-10;
bool=aresame(x2,x,tol).*aresame(y2,y,tol);
reporttest('XY2LATLON / LATLON2XY conversion', bool)

latc=-44;
lonc=180;
N=100;

x=randn(N,1)*5;
y=randn(N,1)*5;
[lat,lon]=xy2latlon(x,y,latc,lonc,'small');
[x2,y2]=latlon2xy(lat,lon,latc,lonc,'small');

tol=1e-10;
bool(2)=aresame(x2,x,tol).*aresame(y2,y,tol);
reporttest('XY2LATLON / LATLON2XY conversion at 180', bool)

N=100;
tol=1e-6;

R=radearth;
x=frac(R,sqrt(2)).*(2.*rand(N,1)-1);
y=frac(R,sqrt(2)).*(2.*rand(N,1)-1);

lato=2*pi*rand(N,1)-pi;
lono=pi*rand(N,1)-pi/2;
[lato,lono]=rad2deg(lato,lono);

clear lat lon x2 y2

for i=1:length(lato)
    [lat(i,1),lon(i,1)]=xy2latlon(x(i),y(i),lato(i),lono(i),'sphere');
    [x2(i,1),y2(i,1)]=latlon2xy(lat(i),lon(i),lato(i),lono(i),'sphere');
    [x3(i,1),y3(i,1)]=latlon2xy(lat(i),lon(i),lato(i),lono(i));
%    [lat2(i,1),lon2(i,1)]=xy2latlon(x(i),y(i),lato(i),lono(i));
%    [x4(i,1),y4(i,1)]=latlon2xy(lat2(i),lon2(i),lato(i),lono(i),'sphere');
end
%plot(lon,lat,'o')


b=aresame(x,x2,tol) && aresame(y,y2,tol);
reporttest('LATLON2XY spherical algorithm inverts XY2LATLON spherical algorithm',b);





