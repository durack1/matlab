%
% JSATFUN  Satellite data treatment and design.
% 
% Loading satellite altimetry data
%   pf_extract - Extract alongtrack Pathfinder data from specified region.   
%   pf_params  - Load satellite parameters from Pathfinder format file.
%
% Alongtrack satellite data
%   trackfill     - Despiking and filling for alongtrack satellite data.   
%   track2grid    - Interpolate alongtrack satellite data onto a grid.            
%   turningpoint  - Find turning points, i.e. local extrema, in time series.
%   orbitbreaks   - Separate orbit into passes based on turning points.
%
% Basic satellite geometry                        
%   ze2dist    - Converts beam zenith angle into distance to surface.          
%   ze2inc     - Converts beam zenith angle into incidence angle.              
%   latlon2zeaz  - Compute zenith and azimuth angles for satellite beam.
%   zeaz2latlon  - Compute latitude and longitude viewed by satellite beam.
%
% Aquarius satellite functions
%   aquaplot   - Plot Aquarius satellite radiometer footprint.
%   aquaprint  - Compute Aquarius satellite radiometer footprints.
%   aquasal    - Aquarius salinity change with brightness temperature.
%   ________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details   

help jsatfun