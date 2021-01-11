nobs=10; 
xobs=rand(nobs,1);xobs = 0.5;
yobs=rand(nobs,1);yobs=0.5;
zobs=rand(nobs,1);zobs=0.5;
data=sin(xobs*pi).*sin(yobs*pi).*sin(zobs*pi);data=1;

% data=data*0; data(1)=1;

Lx=0.8; Ly=0.4; Lz=0.5;
obs_error_std=0.1;
F = OI(xobs,yobs,zobs,data,[0:0.1:1],[0:0.1:1],[0:0.1:1],Lx,Ly,Lz,obs_error_std,55);
% hold on; surfc(xobs,yobs,zobs,'w*'); hold off

for k=1:11
    contourf([0:0.1:1],[0:0.1:1],F(:,:,k),[0:0.1:1]); 
    caxis([0 1]);
    colorbar;
    title(['depth',int2str(k)]);
    pause
end