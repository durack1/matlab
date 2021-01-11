function theta=OI(x,y,z,data,xg,yg,zg,Lx,Ly,Lz,sigobs,pltplease)

% Contouring of Irregularly Spaced Data using optimal interpolation

x=x(:); y=y(:); z=z(:);

[X,Y,Z]=meshgrid(xg,yg,zg); 
[m,n,o]=size(X);
X=X(:); Y=Y(:); Z=Z(:);

d2=(x*ones(size(x'))-ones(size(x))*x').^2/Lx^2+(y*ones(size(y'))-ones(size(y))*y').^2/Ly^2+(z*ones(size(z'))-ones(size(z))*z').^2/Lz^2;
D2=(X*ones(size(x'))-ones(size(X))*x').^2/Lx^2+(Y*ones(size(y'))-ones(size(Y))*y').^2/Ly^2+(Z*ones(size(z'))-ones(size(Z))*z').^2/Lz^2;

w=exp(-d2)+sigobs^2*eye(size(d2));
W=exp(-D2);

theta=W*inv(w)*data;
theta=reshape(theta,m,n,o);

% if nargin==9
%      surfc(xg,yg,zg,theta); shading interp; colorbar('horiz')
%     hold on
%     surf(x,y,z,'w.'); 
%     hold off
% end

