function error_area(x,y,yerr,cc)
% function range_area(x,y,yerr,cc)
% plots yhigh and ylow with shading between
% using colour cc
%
% SEW CSIRO March 2006
% PJD Nicked from SEW 24 Jun 2008

if nargin < 4, cc = [.7 .7 .7]; end % set default light grey

% toss NaNs:
isgood = find(~[isnan(y) | yerr == 0 | isnan(yerr)]);
x = x(isgood);
y = y(isgood);
yerr = yerr(isgood);
if length(isgood) > 2
    % make poly
    xp = [x(:);flipud(x(:));x(1)];
    yo_upper = y + yerr;
    yo_lower = y - yerr;
    yp = [yo_upper(:);flipud(yo_lower(:));yo_upper(1)];

    hh = fill(xp,yp,cc);

    set(hh,'FaceColor',cc,'EdgeColor',cc);
else
    disp(' error_area : not enough good data')
end

return

