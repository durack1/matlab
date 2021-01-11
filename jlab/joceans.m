%
% JOCEANS   Oceanography-specific functions
%
% Date conversion 
%   yf2num     - Converts date in 'year.fraction' format to 'datenum' format.
%   num2yf     - Converts date in 'datenum' format to 'year.fraction' format.
%   mjd2num    - Converts Modified Julian Dates to 'datenum' format.
%
% Latitude and longitude
%   spheredist - Computes great circle distances on a sphere.
%   inregion   - Tests whether lat/lon points lie within a specified box.
%   latlon2xy  - Converts latitude and longitude into local Cartesian coordinates.
%   xy2latlon  - Converts local Cartesian coordinates into latitude and longitude.
%   latlon2uv  - Converts latitude and logitude to velocity.
%   deg360     - Converts degrees to the range [0, 360].
%   deg180     - Converts degrees to the range [-180, 180].
%   lonshift   - Shifts longitude origin for plotting purposes.
%   [-- see also JSPHERE]
%
% Plotting functions
%   stickvect  - Plots "stick vectors" for multicomponent velocity time series.
%   denscont   - Density contour overlay for oceanographic T/S plots.
%   uvplot     - Plot u and v components of velocity on the same axis.
%   provec     - Generate progressive vector diagrams (simple and fancy).
%   hodograph  - Generate hodograph plots (simple and fancy).
%   latratio   - Set plot aspect ratio for latitude / longitude plot.
%   timelabel  - Put month, day, or hour labels on a time axes.
%
% Eddy modelling
%   rankineeddy  - Velocity and streamfunction for a Rankine vortex.
%   gaussianeddy - Velocity and streamfunction for a Gaussian vortex.
%   twolayereddy - Velocity and streamfunction for a 2-layer Rankine vortex.
%
% Water mass analysis
%   heatstorage  - Water column heat storage from 1-D mixing.
%
% Miscellaneous functions
%   radearth     - The radius of the earth in kilometers. 
%   tidefreq     - Frequencies of the eight major tidal compenents.
%   heat2evap    - Transform latent heat loss into units of evaporation.
%   ________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details        
 
help joceans
 

