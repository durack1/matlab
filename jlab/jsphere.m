%
% JSPHERE  Spherical geometry and derivatives.  
%
% These functions are in *Beta version*.  Let me know if you have troubles.
%
% Distances
%   spheredist    - Computes great circle distances on a sphere.
%   neareastpoint - Finds the nearest point to a specified point on the sphere.
%   inregion      - Tests whether lat/lon points lie within a specified box.
%   lonshift      - Shifts longitude origin for plotting purposes.
%   [-- see also JOCEANS]
%
% Spherical geometry
%   xyz2latlon - Converts 3D Cartesian coordinates into latitude and longitude.
%   latlon2xyz - Converts latitude and longitude into 3D Cartesian coordinates.
%   uvw2sphere - Converts a 3D Cartesian vector to a 3D spherical vector.
%   sphere2uvw - Converts a 3D spherical vector to a 3D Cartesian vector.
%   uvw2hor    - Projects a 3D Cartesian vector into a horizontal vector on a sphere.
%   hor2uvw    - Converts a horizontal vector on a sphere into a 3D Cartesian vector.
%
% Div, curl, and grad
%   spherediv  - Divergence of a vector field on the surface of a sphere.
%   spheregrad - Gradient of a field on the surface of a sphere.
%   ________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details   

help jsphere