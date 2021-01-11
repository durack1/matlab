function[bool]=inregion(region,lat,lon)
% INREGION  Tests whether lat/lon points lie within a specified box.
%
%   BOOL = INREGION(REGION,LAT,LON), where LAT and LON are arrays having
%   the same size, returns an array BOOL which is true (=1) for all
%   LAT/LON pairs which lie inside REGION, and false (=0) otherwise.
%
%   REGION has the format [SOUTH NORTH WEST EAST];
%
%   All input arrays are in degrees, but all longitudes may either be 
%   specified on the interval [-180, 180] or on the interval [0, 360].
%
%   The region may overlap the prime meridian (LON=0) or the dateline
%   (LON=180).  Region boundaries are interpreted to exclude the poles. 
%
%   Usage:  bool=inregion(region,lat,lon);
%
%   'inregion --t' runs a test 
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(region,'--t')
     inregion_test,return
end

    
south=region(1);
north=region(2);
west=region(3);
east=region(4);

west=deg180(west);
east=deg180(east);
lon=deg180(lon);

boollat=(lat>=south)  & (lat<=north);
if west<east
    %Dateline is not inside region
    boollon=(lon>=west)  & (lon<=east);
elseif east<west 
    boollon=(lon>=west) | (lon<=east);
end

bool=boollat.*boollon;

function[]=inregion_test
lat=[58 76];
lon=[-52.5 -52.5];
region=[52 65 -63 -41];
ans1=inregion(region,lat,lon);
reporttest('INREGION Labrador Sea', aresame(ans1,[1 0]))

lat=[58 76];
lon=360+[-52.5 -52.5];
region=[52 65 -63 -41];
ans1=inregion(region,lat,lon);
reporttest('INREGION Labrador Sea, differing longitude conventions', aresame(ans1,[1 0]))

lat=[58 58];
lon=[170 150];
region=[52 65 160 -165];
ans1=inregion(region,lat,lon);
reporttest('INREGION enclosing dateline', aresame(ans1,[1 0]))

lat=[58 58];
lon=[170 150];
region=[52 65 160 195];
ans1=inregion(region,lat,lon);
reporttest('INREGION enclosing dateline', aresame(ans1,[1 0]))








