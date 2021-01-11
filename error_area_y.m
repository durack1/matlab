function h = error_area_y(x,y,yerr,cc)
% function error_area_y(y,x,xerr,cc)
% plots x+xerr and x-xerr with shading between
% using colour cc
%
% SEW CSIRO March 2006
% SEW adapted from error_area Oct 5, 2006
% PJD Nicked from SEW 24 Jun 2008

if nargin < 4, cc = [.7 .7 .7]; end % set default light grey

% toss NaNs:
isgood = find(~[isnan(y) | yerr == 0 | isnan(yerr)]);
x = x(isgood);
y = y(isgood);
yerr = yerr(isgood);
if length(isgood) > 2
    % make poly
    xp = [x(:);flipud(x(:))];
    yp_upper = y + yerr;
    yp_lower = y - yerr;
    yp = [yp_upper(:); flipud(yp_lower(:))];

    h = fill(yp,xp,cc);
    set(h,'edgecolor',cc,'FaceColor',cc)

else
    disp(' error_area_y : not enough good data')
end

return

