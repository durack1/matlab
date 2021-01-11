function [area_ratio,area_fraction,area_km2] = area_weight(longitude,latitude)
%
% [area_ratio,area_fraction,area_km2] = area_weight(longitude,latitude)
%
% Determines surface area ratios, fractional and global area (km2), using
% longitude and latitude provided.
%
% Function assumes that grid represents entire globe in output for variable 
% area_km2 (total Earth surface area/fractional components)
%
% inputs:   longitude   - monotonic vector of longitude values
%           latitude    - monotonic vector of latitude values
%
% outputs:  area_ratio      - matrix(longitude x latitude) containing grid
%                             cells representing size ratio (max = 1)
%           area_fraction   - matrix(longitude x latitude) containing grid
%                             cells representing size fraction (sum = 1)
%           area_km2        - matrix(longitude x latitude) containing grid
%                             cells representing area (km2; sum = 510072000)

% If an optional third argument [matrix] is included then instead return
% the area-weighted global/regional mean.
% Need to consider for e.g. ocean mask which includes missing values - so
% only sum area which contains a valid sample, not entire grid
% [area_km2,area_fraction,area_ratio] = area_weight(longitude,latitude,matrix)
%           matrix      - optional 2D (or 3D) matrix which shares the
%                         dimensions of longitude/latitude above

% Paul Durack 7 May 2010
% PJD  7 May 2010   - Works for regular longitude values only
% PJD  7 May 2010   - Removed matrix argument option (may consider
%                     including in future implementation)
% PJD  9 May 2010   - Checked against 3 CMIP3 model telescoping grids
% PJD 10 May 2010   - Fixed issue with lon_1x1 & lat_1x1 grid (make_basins.mat [lon,lat])
%                     added dimensions to area_weight.mat test suite
% PJD 10 May 2010   - Cleaned up error returns (outputs assigned NaN value)
% PJD 10 May 2010   - Tidied up input conversion to column vector; lat' -> lat(:)
% PJD 10 May 2010   - Removed dependence on mapping toolbox (degtorad -> (pi/180)*degrees)
% PJD 10 May 2010   - TODO: along with matrix argument, consider valid mask input
%                     too (ocean mask for e.g.)

% Check input arguments
if nargin  < 1, disp('ERROR AREA_WEIGHT.M: invalid arguments');
    [area_ratio,area_fraction,area_km2] = deal(NaN(1,1));
    return
end
if nargin == 1, disp('ERROR AREA_WEIGHT.M: invalid arguments');
    [area_ratio,area_fraction,area_km2] = deal(NaN(1,1));
    return
end
if nargin == 2 % Test for lon/lat vectors
    if ~isvector(latitude) || ~isvector(longitude);
        disp('ERROR AREA_WEIGHT.M: invalid lon/lat arguments');
        [area_ratio,area_fraction,area_km2] = deal(NaN(1,1));
        return
    end
    % Force inputs to column vectors
    longitude = longitude(:); latitude = latitude(:);
    %size(longitude), size(latitude) % Check inputs
end
if nargin > 2, disp('ERROR AREA_WEIGHT.M: invalid arguments'); end
% Consider including matrix argument; process weight on matrix and return
%{
if nargin == 3 % Test dimensions agree, invert if incorrect, abort if incorrect
    if ndims(matrix) ~= 2
        disp('ERROR AREA_WEIGHT.M: invalid matrix argument - check size'); return
    end
    lon_size = length(longitude); lat_size = length(latitude);
    if size(matrix) == [lat_size lon_size]
        matrix = matrix'; % Flip dimensions of matrix
    elseif size(matrix) ~= [lon_size lat_size]
        disp('ERROR AREA_WEIGHT.M: invalid matrix argument - check size'); return
    end
end
if nargin > 3, disp('ERROR AREA_WEIGHT.M: invalid arguments'); end
%}

% Declare variables
earth_surface_area_km2 = 510072000;
lon_dupe = 0; % Assume longitude doesn't repeat values (0 && 360)

% Check longitude values
lon_range = range(longitude);
if (lon_range(1) < -180 || lon_range(2) > 360)
    disp('ERROR AREA_WEIGHT.M: invalid longitude values');
    [area_ratio,area_fraction,area_km2] = deal(NaN(1,1));
    return
else % Convert to standard lons (0:360)?
    %{
    lon0 = rem((longitude(1) + 180),(360 - 180));
    if lon0 ~= 0, lon0 = 0; end % Ensure -180 <= x(1) < 180
    n = numel(longitude);
    d = rem((longitude(2:n) - longitude(1:(n-1))),360);
    longitude = cumsum([lon0, d']);
    %}
end
% Fix longitude - duplication of 0 & 360
if ~isempty(find(longitude == 0) & find(longitude == 360))
    lon_dupe = 1; longitude_dupe = longitude; % Case my observations
    longitude(longitude == 0) = [];
    disp('AREA_WEIGHT.M: longitude duplication corrected');
end; clear ind

% Check latitude values
lat_range = range(latitude);
if (lat_range(1) < -90 || lat_range(2) > 90)
    disp('ERROR AREA_WEIGHT.M: invalid latitude values');
    [area_ratio,area_fraction,area_km2] = deal(NaN(1,1));
    return
end

% Determine latitude boundaries - assume grid points are centre of boxes
lat_bounds = NaN((size(latitude,1)+1),1);
for x = 1:length(latitude);
    if x == length(latitude) % Exit when last latitude reached
        lat_bounds(x) = latitude(x)-lat_range/2;        
        lat_bounds(x+1) = latitude(x)+lat_range/2;
        continue
    end
    lat_range = abs(latitude(x)-latitude(x+1));
    lat_bounds(x) = latitude(x)-lat_range/2;
end; %[[0; latitude] lat_bounds]
% Determine meridional area weight from radians
weight_lat_area = NaN((size(latitude,1)),1);
for x = 1:length(latitude)
    weight_lat_area(x) = cos((pi/180) * (latitude(x)))'.*abs((pi/180) *(lat_bounds(x,:)-lat_bounds(x+1,:)));
end
% Convert to fraction of largest grid box
weight_lat_area = weight_lat_area./max(weight_lat_area);

% Determine longitude boundaries - assume grid points are centre of boxes
lon_bounds = NaN((size(longitude,1)+1),1);
for x = 1:length(longitude);
    if x == length(longitude) % Exit when last latitude reached
        lon_bounds(x) = longitude(x)-lon_range/2;        
        lon_bounds(x+1) = longitude(x)+lon_range/2;
        continue
    end
    lon_range = abs(longitude(x)-longitude(x+1));
    lon_bounds(x) = longitude(x)-lon_range/2;
end; %[[0; longitude'] lon_bounds]
% Determine zonal area weight from radians
weight_lon_area = NaN((size(longitude,1)),1);
for x = 1:length(longitude)
    weight_lon_area(x) = abs((pi/180) * (lon_bounds(x,:)-lon_bounds(x+1,:)));
end
% Convert to fraction of largest grid box
weight_lon_area = weight_lon_area./max(weight_lon_area);

% Assume regular gridded longitude - replicate vector across global surface
if lon_dupe % Case my observations
    weight_lat_area_mat = repmat(weight_lat_area,[1,length(weight_lon_area)+1]);
    weight_lon_area = [weight_lon_area; weight_lon_area(end)];
    weight_lon_area_mat = repmat(weight_lon_area,[1,length(weight_lat_area)]);
    longitude = longitude_dupe(:); clear longitude_dupe
else
    weight_lat_area_mat = repmat(weight_lat_area,[1,length(weight_lon_area)]);
    weight_lon_area_mat = repmat(weight_lon_area,[1,length(weight_lat_area)]);
end
%size(weight_lat_area_mat),size(weight_lon_area_mat) % Check outputs
area_ratio = weight_lat_area_mat'.*weight_lon_area_mat;
area_fraction = area_ratio./sum(area_ratio(:));
area_km2 = area_fraction*earth_surface_area_km2;

%% Obsolete code - check function above
% Plot output of function
%{
close all, handle = figure('units','centimeters','visible','on','color','w','posi',[3 3 25 25]); set(0,'CurrentFigure',handle)
subplot(3,1,1);pcolor(longitude,latitude,area_ratio'); shading flat; clmap(27); colorbar; title('ratio')
subplot(3,1,2);pcolor(longitude,latitude,area_fraction'); shading flat; clmap(27); colorbar; title('fraction')
subplot(3,1,3);pcolor(longitude,latitude,area_km2'); shading flat; clmap(27); colorbar; title('km2')
%}
% Check code to ensure that models' telescoping grids work - only ocean component of those below
%{
% CNRM
latitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.cnrm_cm3.picntrl.run1.monthly.sos_O1c_1930-2429.nc','lat');
longitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.cnrm_cm3.picntrl.run1.monthly.sos_O1c_1930-2429.nc','lon');
% GFDL2.1
latitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.gfdl_cm2_1.picntrl.run1.monthly.sos_O1c_1861-2160.nc','lat');
longitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.gfdl_cm2_1.picntrl.run1.monthly.sos_O1c_1861-2160.nc','lon');
% MIROC Medres
latitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.miroc3_2_medres.picntrl.run1.monthly.sos_O1c_2300-2799','lat');
longitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.miroc3_2_medres.picntrl.run1.monthly.sos_O1c_2300-2799','lon');
% NCAR CCSM3.0
latitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.ncar_ccsm3_0.picntrl.run2.monthly.sos_O1c_300-799.nc','lat');
longitude = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_sos/pcmdi.ipcc4.ncar_ccsm3_0.picntrl.run2.monthly.sos_O1c_300-799.nc','lon');
%}
% Compare matlab solution to tcl function
%{
load /home/dur041/bin/area_weight.mat
% My obs
[area_ratio,area_fraction,area_km2] = area_weight(obs_lon,obs_lat);
area_frac_nc = getnc('/home/dur041/Shared/global_area.nc','global_fractional_area_2x1');
area_frac_nc = [area_frac_nc, area_frac_nc(:,1)];
area_km2_nc = getnc('/home/dur041/Shared/global_area.nc','global_area_km2_2x1');
area_km2_nc = [area_km2_nc, area_km2_nc(:,1)];
figure(2), pcolor(area_km2'); shading flat, clmap(27); colorbar, title('nap')
figure(3), pcolor(area_km2_nc-area_km2'); shading flat, clmap(27); colorbar, title('diff')
format long
disp(num2str(sum(area_km2_nc(:)))) % 512905733.3333 % NAP
disp(num2str(sum(area_km2(:)))) % 510072000 % Matlab
% HadCRUT3
[area_ratio,area_fraction,area_km2] = area_weight(had3_lon,had3_lat);
area_frac_nc = getnc('/home/dur041/Shared/global_area.nc','global_fractional_area_HadCRUT3');
area_km2_nc = getnc('/home/dur041/Shared/global_area.nc','global_area_km2_HadCRUT3');
figure(2), pcolor(area_km2'); shading flat, clmap(27); colorbar, title('nap')
figure(3), pcolor(area_km2_nc-area_km2'); shading flat, clmap(27); colorbar, title('diff')
format long
disp(num2str(sum(area_km2_nc(:)))) % 510072000 % NAP
disp(num2str(sum(area_km2(:)))) % 510072000 % Matlab
% NOC Flux
[area_ratio,area_fraction,area_km2] = area_weight(noc_lon,noc_lat);
area_frac_nc = getnc('/home/dur041/Shared/global_area.nc','global_fractional_area_flux');
area_km2_nc = getnc('/home/dur041/Shared/global_area.nc','global_area_km2_flux');
figure(2), pcolor(area_km2'); shading flat, clmap(27); colorbar, title('nap')
figure(3), pcolor(area_km2_nc-area_km2'); shading flat, clmap(27); colorbar, title('diff')
format long
disp(num2str(sum(area_km2_nc(:)))) % 510071999.9999 % NAP
disp(num2str(sum(area_km2(:)))) % 510071999.9998 % Matlab
%}
% Get input lon/lat vectors to test
%{
% Obs grid
load([home_dir,'/090605_FLR2_sptg/090605_190300_local_robust_1950_FLRdouble_sptg_79pres1000_v7.mat'], 'xi', 'yi');
% Random model grid
giss_lon = getnc('/home/dur041/_links/c000574-hf/dur041/working/20c3m_1950-1999_pr/pcmdi.ipcc4.giss_model_e_r.20c3m.run7.monthly.pr_A1a_1950-1999.nc','lon');
giss_lat = getnc('/home/dur041/_links/c000574-hf/dur041/working/20c3m_1950-1999_pr/pcmdi.ipcc4.giss_model_e_r.20c3m.run7.monthly.pr_A1a_1950-1999.nc','lat');
csm35_lon = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_pr/csiro.ipcc4.csiro_mk3_5.picntrl.run1.monthly.pr_A1a_1781-3000.nc','lon');
csm35_lat = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_pr/csiro.ipcc4.csiro_mk3_5.picntrl.run1.monthly.pr_A1a_1781-3000.nc','lat');
%}
% Get lat/lon_bounds info from model files to understand what is going on here?
%{
% Processed files
lat_bnds = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_pr/csiro.ipcc4.csiro_mk3_5.picntrl.run1.monthly.pr_A1a_1781-3000.nc','lat_bnds');
lon_bnds = getnc('/home/dur041/_links/c000574-hf/dur041/working/PICNTRL_dawn2end_pr/csiro.ipcc4.csiro_mk3_5.picntrl.run1.monthly.pr_A1a_1781-3000.nc','lon_bnds');
% Origin files
lat_bnds_orig = getnc('/home/dur041/_links/c000574-hf/dur041/working/_downloads/csiro/csiro_mk3_5_PICNTRL_pr/pr_A1a_1781-1790_PIcntrl_mk3.5_run1.nc','lat_bnds');
lon_bnds_orig = getnc('/home/dur041/_links/c000574-hf/dur041/working/_downloads/csiro/csiro_mk3_5_PICNTRL_pr/pr_A1a_1781-1790_PIcntrl_mk3.5_run1.nc','lon_bnds');
%}