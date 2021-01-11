function[ii,dist]=nearestpoint(lat,lon,lato,lono)
%NEARESTPOINT  Finds the nearest point to a specified point on the sphere.
%
%   II=NEARESTPOINT(LAT,LON,LATO,LONO) where LAT and LON are column vectors
%   finds the II such that the distance between the point [LAT(II),LON(II)] 
%   and [LATO,LONO] is minimized.  
%
%   [II,DIST]=NEARESTPOINT(...) also returns the value of this minimum 
%   distance, in kilometers.
%
%   If LAT and LON are matrices with M columns, then NEARESTPOINT acts on 
%   each column, separately, and II and DIST are of length M.
%
%   Distances are great circle distances on the sphere computed using via
%   SPHEREDIST.
%
%   'nearestpoint --t' runs a test.
%
%   Usage: ii=nearestpoint(lat,lon,lato,lono);
%          [ii,dist]=nearestpoint(lat,lon,lato,lono);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(lat, '--t')
    nearestpoint_test,return
end

d=spheredist(lat,lon,lato,lono);
[dist,ii]=min(d);

function[]=nearestpoint_test
 
%reporttest('NEARESTPOINT',aresame())
