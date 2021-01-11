function [zi,n,zstd] = binxy(x,y,z,xi,yi,iscreen);
% function [zi,n,zstd] = binxy(x,y,z,xi,yi);
% bins and averages the random data by distance
% from bin centers xi, yi
% zi = mean
% zstd = standard deviation
%
% NOTE: ignores NaNs
% if iscreen == 1, will toss data > iscreen*std out!
if nargin < 7, iscreen = 0.;end
ib = find(isnan(x.*y.*z));
x(ib) = [];
y(ib) = [];
z(ib) = [];
jt = length(z);
n = zeros(length(xi),length(yi));
nx = zeros(size(z));
ny = zeros(size(z));
zi = n;
for j=1:jt;
[val,ix]=min(abs(x(j)-xi));
[val,iy]=min(abs(y(j)-yi));

nx(j)=ix;ny(j)=iy;

n(ix,iy)=n(ix,iy) + 1;
zi(ix,iy) = zi(ix,iy) + z(j);
end
% do statistics:
ig = find(n>0);

zi(ig) = zi(ig)./n(ig);
% std

for ix=1:length(xi);
for iy=1:length(yi);
ig = find( nx == ix & ny==iy);
if ( length(ig) ~= n(ix,iy) )
print 'no agreement'
end 
if (~isempty(ig) )
zstd(ix,iy) = std(z(ig));
else
zstd(ix,iy) = NaN;
end
if iscreen,
    za = [z(ig) - zi(ix,iy)]/zstd(ix,iy);
    iok = find(abs(za) > iscreen);
    zi(ix,iy) = nanmean(z(ig(iok)));
    zstd(ix,iy) = nanstd(z(ig(iok)));
end
end 
end
ibad = find(n==0);
%size(n),size(zi)
zi(ibad)=NaN*ones(size(ibad));
