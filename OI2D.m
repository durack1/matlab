function theta=OI2D(x,y,data,xg,yg,Lx,Ly,sigobs,pltplease)

% Contouring of Irregularly Spaced Data using optimal interpolation

x=x(:); y=y(:);

[X,Y]=meshgrid(xg,yg); 
[m,n]=size(X);
X=X(:); Y=Y(:);

d2=(x*ones(size(x'))-ones(size(x))*x').^2/Lx^2+(y*ones(size(y'))-ones(size(y))*y').^2/Ly^2;
D2=(X*ones(size(x'))-ones(size(X))*x').^2/Lx^2+(Y*ones(size(y'))-ones(size(Y))*y').^2/Ly^2;

w=exp(-d2)+sigobs^2*eye(size(d2));
W=exp(-D2);

theta=W*inv(w)*data;
theta=reshape(theta,m,n);

% if nargin==9
%      surfc(xg,yg,zg,theta); shading interp; colorbar('horiz')
%     hold on
%     surf(x,y,z,'w.'); 
%     hold off
% end

