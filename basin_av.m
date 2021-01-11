function [tot,pac,ind,atl,aa,apa,ain,aat] = basin_av(x,y,fl)
% [tot,pac,ind,atl,aa,apa,ain,aat] = basin_av(x,y,fl)
% averages the  field values fl zonally over the ocean basins
% Assumes that x,y are the midpoints of boxes to which fl
% is assigned, and that the values are in units/m^2; fl is
% assumed to be zero over the land
%
%  x, y   grid on which fl(x,y) is centred in degrees E, N
%  tot    - total meridional flux cumulated from North pole
%  pac    - meridional flux in the Pacific cumulated from 65N
%  ind    - meridional flux in the Indian cumulated from 20N
%  atl    - meridional flux in the Atlantic cumulated from 90N
%  aa     - area mask in m^2
%  apa    - pacific area mask
%  ain    - indian area mask
%  aat    - atlantic area mask
%
% Basin definition in Southern Ocean:
% Atlantic  290E -  20E
% Indian     20E - 147E
% Pacific   147E - 290E

% Susan Wijffels - harvested from Susan 16 Aug 2007: /home/wijffels/work/global_thermal/matlab
% PJD 16 Aug 2007   - Updated indents to reflect loop depth
% PJD  1 Oct 2019   - Updates to deal with matlab arg format changes

warning off all % Include this to suppress divide by zero alerts
% check orientation of things
nx = length(x); ny = length(y);
%[tot,pac,ind,atl] = deal(NaN(y,1));
[tot,pac,ind,atl] = deal(NaN(ny,1));
%[aa,apa,ain,aat] = deal(NaN(length(x),length(y)));
%[aa,apa,ain,aat] = deal(NaN(nx,ny));


%[n1,n2] = size(fl);
[n1,~] = size(fl);
if n1 ~= nx, fl = fl'; end

y = y(:);

% coast line has been found from 1degree bathy: getcoasts.m
getcoasts;

km2 = (111e3)^2;
% set the area map: 2 degree squares
nlon = length(x);
nlat = length(y);
dxd = mean(abs(diff(x)));
dx = dxd*(2*pi)/360.*6371e3*cos(abs(y)/180.*pi);
dy = diff(y);dy = [dy(1);dy(:)];
dy = dy/360.*6371e3*(2*pi);
size(dy);
size(dx);
aa = dy(:).*dx(:)*ones(1,nlon);
aa = aa';

apa = 0*aa;
ain = 0*aa;
aat = 0*aa;

% do the totals
junk = fl; ajunk = aa;

ibad = find(junk > 1.e10 | isnan(junk));
junk(ibad) = zeros(size(ibad));
ajunk(ibad) = zeros(size(ibad));
junk = aa.*junk;

[ys,js] = sort(-y);
ys = -ys;
tot(js) = (sum(junk(:,js)))./sum(ajunk(:,js));

% project Pacific coastlines to flux grid
xE = interp1(flipud(yd),fliplr(xpacE),y);
xW = interp1(flipud(yd),fliplr(xpacW),y);

pac = zeros(size(y));

ilat = js(find(ys <= 65.));
for i = ilat(:)'
    ii = find(x >= xW(i) & x <= xE(i) & ~isnan(fl(:,i)'));
    if length(ii)
        apa(ii,i) = ones(length(ii),1);
        pac(i) = sum(junk(ii,i))/sum(ajunk(ii,i));
    end
end

% now do the Indian Ocean
xE = interp1(flipud(yd),fliplr(xpacW),[-89.5;y(2:length(y))]);
xW = interp1(flipud(yd),fliplr(xindW),[-89.5;y(2:length(y))]);

ind = zeros(size(y));

ilat = js(find(ys <= 30. ));
for i = ilat(:)'
    ii = find(x >= xW(i) & x <= xE(i) & ~isnan(fl(:,i)'));
    if length(ii)
        ain(ii,i) = ones(length(ii),1);
        ind(i) = sum(junk(ii,i))/sum(ajunk(ii,i));
    end
end

% now do the Atlantic Ocean

xE = interp1(flipud(yd),fliplr(xindW),[-89.5;y(2:length(y))]);
xW = interp1(flipud(yd),fliplr(xpacE),[-89.5;y(2:length(y))]);

atl = zeros(size(y));

ilat = js(find(ys <= 70));
xa = rem(x+180,360);
xEa = rem(xE+180,360);
xWa = rem(xW+180,360);
for i = ilat(:)'
    %ii = find([x <= xE(i) | x >= xW(i)] & ~isnan(fl(:,i)'));
    ii = find(xa >= xWa(i) & xa <= xEa(i) & ~isnan(fl(:,i)'));
    if length(ii)
        aat(ii,i) = ones(length(ii),1);
        atl(i) = sum(junk(ii,i))/sum(ajunk(ii,i));
    end
end

return