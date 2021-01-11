function error_stipple(nfig,x,y,z,ze,marksz,colour)
% function error_stipple(nfig,x,y,z,ze,marksz,colour)
% 
% stipple where signal less than error
% overplot on figure(nfig), a stippling in colour
% where abs(z) < ze
% input: x,y is vector grid of z, ze
%        marksz is the size of the stipple
%        colour is colour of stippling [r g b]

% SEW, CMAR 2008
% PJD 25 November 2009  - Grabbed from /home/wijffels/matlab/susan/error_stipple.m
%                       - Reversed grid creation (y,x) -> (x,y)
%                       - Added marksz argument (was set to 0.5)
% PJD 26 November 2009  - Function resets figure variable ('visible' to 'on')

% error_stipple.m

figure(nfig)
hold all
ib = find(abs(z) < ze);
%[yy,xx] = meshgrid(y,x); 
[xx,yy] = meshgrid(x,y); % Required reversing for my data
if nargin < 6, marksz = 0.3; end % Default to small marker
if nargin < 7, colour = [0 0 0]; end % Default to black
plot(xx(ib),yy(ib),'o','markersize',marksz,'color',colour,'markerfacecolor',colour);

return

