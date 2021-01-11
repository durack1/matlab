function c = redblue(m)

% Red/blue colormap of size M

if nargin < 1, m = size(get(gcf,'colormap'),1); end

m2=floor(m/2);
lin=0.2+0.8*[0:m2-1]'/max(m2,1);
rlin=flipud(lin);

if m2*2==m % even number
  c=[ones(m2,1) lin lin;...
    rlin rlin ones(m2,1)];
else
  c=[ones(m2,1) lin lin;...
    1 1 1;...
    rlin rlin ones(m2,1)];
end
