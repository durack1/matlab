function conbold(nfig,x,y,zz,cl,cb,col);
% function conbold(nfig,x,y,zz,cl,cb);
% 
% adds line contours of zz to figure(nfig) in colour col [r g b]
% - bold contours in cb with labels
% - unbolded contours in cl
% 
% SEW, CMAR, June 23, 2008
figure(nfig)
 
if nargin < 7,col = [1 1 1]*1e-4;end
 
hold on
[val,ib]=intersect(cl,cb);
cl(ib) = [];
[c,h]=contour(x,y,zz,cl);
set(h,'linecolor',col),
[c,h]=contour(x,y,zz,cb);
set(h,'linewidth',1,'color',col)
clabel(c,h,'fontsize',8,'color',col,'lablespacing',200)
return