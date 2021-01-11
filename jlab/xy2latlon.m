function[lat,lon]=xy2latlon(varargin)
% XY2LATLON  Converts local Cartesian coordinates into latitude and longitude.
%
%   [LAT,LON]=XY2LATLON(X,Y,LATO,LONO) converts (X,Y) position with 
%   units of kilometers, specifying a location in a plane tangent to 
%   the earth at the point (LATO,LONO), into latitude and logitude.  
%
%   [LAT,LON]=XY2LATLON(CX,LATO,LONO) with three input arguments 
%   specifies the location via the complex quantity CX=X+SQRT(-1)*Y.
%
%   LONO may each either be specified on the interval [-180, 180] or 
%   on the interval [0, 360].  Output longitudes LON are defined to be 
%   within the interval [-180, 180].
%
%   LAT and LON may be computed with either the full spherical geometry,
%   the default, or using a small angle approximation.  To specify the
%   small angle approximation use XY2LATLON(..., 'small').
%
%   LAT and LON are defined to be NAN for points with SQRT(X^2+Y^2)
%   exceeding the radius of the earth.
%
%   The radius of the earth is given by the function RADEARTH.
%
%   XY2LATLON is inverted by LATLON2XY.
%
%   See also LATLON2XY, LATLON2UV.
%
%   Usage:  [lat,lon]=xy2latlon(x,y,lato,lono);
%           [lat,lon]=xy2latlon(cx,lato,lono);
%
%   'xy2latlon --t' runs a test. 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2007 J.M. Lilly --- type 'help jlab_license' for details        
  
if strcmp(varargin{1}, '--t')
  xy2latlon_test,return
end
  
na=nargin;
if ischar(varargin{end})
    str=varargin{end};
    na=na-1;
else 
    str='sphere';
end

if na==3
   x=real(varargin{1});
   y=imag(varargin{1});
   lato=varargin{2};
   lono=varargin{3};
elseif na==4
   x=varargin{1};
   y=varargin{2};
   lato=varargin{3};
   lono=varargin{4};
end

[lato,lono]=deg2rad(lato,lono);

R=radearth;
index=find(sqrt(x.^2+y.^2)>=R);
if ~isempty(index)
    x(index)=nan;
    y(index)=nan;
end

if strcmp(str(1:3),'sma')
    [lat,lon]=xy2latlon_cartesian(x,y,lato,lono,R);
elseif strcmp(str(1:3),'sph')
    [lat,lon]=xy2latlon_sphere(x,y,lato,lono,R);
end


function[lat,lon]=xy2latlon_cartesian(x,y,lato,lono,R)

r1=R*cos(lato);

lat=y./R+lato;
lon=x./r1+lono;

[lat,lon]=rad2deg(lat,lon);

function[lat,lon]=xy2latlon_sphere(x,y,lato,lono,R)

r=sqrt(x.^2+y.^2);
%r  = distance in tangent plane

r1 = R - sqrt(R.^2 - r.^2);
%r1 = tangential distance from tangent plane to surface of earth
%     choosing smaller root, corresponding to near side of earth

%Now choose an xyz coordinate system with x=east, z= north

%tangent point = point on sphere at which plane is tangent
%contact point = point on sphere directly underneath (x,y) point in plane

R1 = sqrt((R-r1).^2+y.^2);
%R1 = distance from center of earth to contact point 
%projected onto the xz plane, i.e., looking down the y-axis

gamma=asin(frac(y,R1));
%gamma = angle spanned between contact point and tangent point
%projected onto the xz plane, i.e., looking down the y-axis

phi=lato+gamma;
%gamma = angle spanned between contact point and x-axis
%projected onto the xz plane, i.e., looking down the y-axis

xo=R1.*cos(phi);
zo=R1.*sin(phi);

yo=sqrt(R.^2-xo.^2-zo.^2);

index=find(x<0);
if ~isempty(x)
    yo(index)=-yo(index);
end
[lat,lon]=xyz2latlon(xo,yo,zo);
lon=rad2deg(angle(rot(deg2rad(lon)+lono)));

function[]=xy2latlon_test
latlon2xy --t
