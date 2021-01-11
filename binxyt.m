function [zi,n,zstd,xm,ym,tm] = binxyt(x,y,t,z,xi,yi,ti,iscreen);
% function [zi,n,zstd,xm,ym,tm] = binxyt(x,y,t,z,xi,yi,ti,iscreen)
% bins and averages the random data by distance
% from bin centers xi, yi, ti
% zi = mean
% n = number averaged for that point
% zstd = standard deviation
%
% NOTE: ignores NaNs
% if iscreen == 1, will toss data > iscreen*std out!

if nargin < 9, iscreen = 0.;end
ib = find(isnan(x.*y.*z.*t));
x(ib) = [];
y(ib) = [];
z(ib) = [];
t(ib) = [];
jt = length(z);
[n,zi,tm,xm,ym] = deal(zeros(length(xi),length(yi),length(ti)));zstd = nan*n;
nx = zeros(size(z));
ny = zeros(size(z));
nt = zeros(size(z));
zi = n;
for j=1:jt;
    [val,ix]=min(abs(x(j)-xi));
    [val,iy]=min(abs(y(j)-yi));
    [val,it]=min(abs(t(j)-ti));
    nx(j)=ix;ny(j)=iy;nt(j) = it;

    n(ix,iy,it)=n(ix,iy,it) + 1;
    zi(ix,iy,it) = zi(ix,iy,it) + z(j);
    xm(ix,iy,it) = xm(ix,iy,it) + x(j);
    ym(ix,iy,it) = ym(ix,iy,it) + y(j);
    tm(ix,iy,it) = tm(ix,iy,it) + t(j);
end

% do statistics:
ig = find(n>0);
zi(ig) = zi(ig)./n(ig);
xm(ig) = xm(ig)./n(ig);
ym(ig) = ym(ig)./n(ig);
tm(ig) = tm(ig)./n(ig);

% std

for ix=1:length(xi);
    for iy=1:length(yi);
        for it = 1:length(ti);
            ig = find( nx == ix & ny==iy & nt == it);
            if ( length(ig) ~= n(ix,iy,it) )
                print 'no agreement'
            end
            if (~isempty(ig) )
                zstd(ix,iy,it) = std(z(ig));
            else
                zstd(ix,iy,it) = NaN;
            end
            if iscreen,
                za = [z(ig) - zi(ix,iy,it)]/zstd(ix,iy,it);
                iok = find(abs(za) > iscreen);
                zi(ix,iy,it) = nanmean(z(ig(iok)));
                zstd(ix,iy,it) = nanstd(z(ig(iok)));
                xm(ix,iy,it) = nanmean(z(ig(iok)));
                ym(ix,iy,it) = nanmean(z(ig(iok)));
                tm(ix,iy,it) = nanmean(z(ig(iok)));

            end
        end
    end
end
ibad = find(n==0);
%size(n),size(zi)
zi(ibad)=NaN*ones(size(ibad));

return