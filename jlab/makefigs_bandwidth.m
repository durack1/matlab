function[]=makefigs_bandwidth(str)
%MAKEFIGS_BANDWIDTH  Makes all figures for Lilly and Olhede 2007
%  
%   MAKEFIGS_BANDWIDTH  Makes all figures for
% 
%
%   Type 'makefigs_bandwidth' at the matlab prompt to make all figures
%   for this and print them as .eps files into the current directory.
%
%   Type 'makefigs_bandwidth noprint' to supress printing to .eps files.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details           
 
if nargin==0
  str='print';
end





%/*************************************************
load ebasn

use ebasn
dt=num(2)-num(1);
fc=sw_f(vmean(lat(:),1))*3600*24/2/pi;
cx=fillbad(latlon2xy(lat,lon,vmean(lat(:),1),vmean(lon(:),1)));

jj=33;
%jj=[13 25 28 29 31 33 36 37 38];
%jj=[13 25 28];
vindex(num,lat,lon,p,t,s,w,cx,jj,2);

NF=100;
%Do not change these settings   ---fc/4/0.8
fs=flipud(logspace(log10(dt*fc/80),log10(dt*0.3),NF)'); 
be=2;ga=3; 
cv=fillbad(vdiff(cx,1)./(dt*24*3600)*1e5);
%[psi,psif]=morsewave(length(cx),1,ga,be,fs);
wx=wavetrans(real(cx),{1,ga,be,fs,'bandpass'},'mirror');
wy=wavetrans(imag(cx),{1,ga,be,fs,'bandpass'},'mirror');
ebasn_ridges=ellridge(dt,wx,wy,fs,{sqrt(be*ga),1/2,1,'amplitude'});
ebasn_xridges=ridgewalk(dt,wx,fs,{sqrt(be*ga),1/2,sqrt(1/2),'amplitude'});
ebasn_yridges=ridgewalk(dt,wy,fs,{sqrt(be*ga),1/2,sqrt(1/2),'amplitude'});


[wp,wn]=transconv(wx,wy,'uv2pn');
wxv=wavetrans(vswap(real(cv),nan,0),{1,ga,be,fs,'bandpass'},'mirror');
wyv=wavetrans(vswap(imag(cv),nan,0),{1,ga,be,fs,'bandpass'},'mirror');

h=wavespecplot(num2yf(num),cv,dt./fs,sqrt(abs(wxv).^2+abs(wyv).^2)/2,0.5);
plot(num2yf(num(nonnan(ir))),dt./fs(nonnan(jr)),'k','linewidth',2)
ylabel('Period (days)')
ytick([5 10 20 30 60])
axes(h(1))
title('A float in a Meddy')
ylabel('Velocity (cm/s)')
ytick([-15 -10 -5 0 5 10 15])
transparency
cd_figures
print -dpng eddyextraction_meddy



[zp,fp,zn,fn,zeta]=ridgemap(ebasn_ridges);
[a,b,theta,phi]=ellconv(zp,zn,'pn2ab');
cxr=cx-zeta;
figure,subplot(121)
%plot(cxr-vmean(cx,1),'r','linewidth',1.5),hold on
plot(cx-vmean(cx,1),'b','linewidth',1.5)
axis square,xlim([-200 400]-vmean(cx,1))
xtick([-300:100:300])

subplot(122)
plot(cxr-vmean(cx,1),'r','linewidth',2),hold on
index=[6*3:6*3:length(a)-6*3];
ellipseplot(index,a,b,theta,cxr-vmean(cx,1),'npoints',64)
linestyle b1.5
plot(cxr-vmean(cx,1),'r','linewidth',1.5),hold on
axis square,xlim([-200 400]-vmean(cx,1))
packcols(1,2)
xtick([-300:100:300])

transparency
cd_figures
print -dpng eddyextraction_map


%matsave ebasn_ridges
%\***************************


%test exact expression
figure,uvplot(abs(lambda).*rot(2*theta))
uvplot(abs(lambda).*rot(2*theta),'g--')

figure,plot(frac(abs(lambda),sqrt(1+lambda.^2)).*sin(2*theta))
hold on, plot(tan(abs(phix-phiy)-pi./2),'r')

figure,plot(abs(lambda).*cos(2*theta))
hold on, plot(frac(X.^2-Y.^2,X.^2+Y.^2),'r')






%/****************************************************************
t=[0:1:1000]';
kappa=3*exp(2*0.393*(t/maxmax(t)-1));
lambda=0.4;
a=kappa*sqrt(1+lambda);
b=kappa*sqrt(1-lambda);

phi=(t/maxmax(t)*5)*2*pi;
theta=pi/4;

cxe(:,1)=rot(theta).*(a.*cos(phi)+sqrt(-1)*b.*sin(phi));

[P,N,phip,phin]=ellconv(a,b,theta,phi,'ab2pn'); 
[xi,xia,xib,xic]=ellband(P.*rot(phip),N.*rot(-phin));
vmean(xi,xia,xib,xic,1);xi,xia,xib,xic
%0.025

kappa=2.5;
lambda=t/maxmax(t)/2*sqrt(2)*0.95;
a=kappa*sqrt(1+lambda);
b=kappa*sqrt(1-lambda);

cxe(:,2)=rot(theta).*(a.*cos(phi)+sqrt(-1)*b.*sin(phi));

[P,N,phip,phin]=ellconv(a,b,theta,phi,'ab2pn'); 
[xi,xia,xib,xic]=ellband(P.*rot(phip),N.*rot(-phin));
vmean(xi,xia,xib,xic,1);xi,xia,xib,xic
%0.025

a=3;
b=2;
theta=phi/15.1/4*2;
cxe(:,3)=rot(theta).*(a.*cos(phi)+sqrt(-1)*b.*sin(phi));

[P,N,phip,phin]=ellconv(a,b,theta,phi,'ab2pn'); 
[xi,xia,xib,xic]=ellband(P.*rot(phip),N.*rot(-phin));
vmean(xi,xia,xib,xic,1);xi,xia,xib,xic
%  0.025  but oscillates (asymmetrically) around +/- 0.003

titlestr{1}='Increasing Magnitude';
titlestr{2}='Increasing Eccentricity';
titlestr{3}='Precession';
figure
for i=1:3
    subplot(1,3,i)
    plot(cxe(:,i)),hold on
    plot(cxe(1:200,i)),linestyle 1k 2k
    axis([-3.2 3.2 -3.2 3.2])
    title(titlestr{i})
    xlabel('Displacement East'),axis equal,axis square
    ylabel('Displacement North')
    xtick([-3:3])   
    ytick([-3:3])
end
packcols(1,3)

orient landscape
fontsize 14 12 12 12
print -dpsc stability_schematic.eps
%\****************************************************************

%/*************************************************
%Load and prepare data
load ebasn

use ebasn
dt=num(2)-num(1);
fc=sw_f(vmean(lat(:),1))*3600*24/2/pi;
cx=latlon2xy(lat,lon,vmean(lat(:),1),vmean(lon(:),1));
cx=fillbad(cx);
cv=latlon2uv(num,lat,lon);
cv(1,:)=cv(2,:);

jj=[13 25 28 29 31 33 36 37 38];
vindex(num,lat,lon,cx,cv,jj,2);

make ebasn_bandwidth id num lat lon cx cv dt fc
matsave -v6 ebasn_bandwidth

load ebasn_bandwidth
use ebasn_bandwidth
NF=100;
fs=flipud(logspace(log10(dt*fc/80),log10(dt*fc/4),NF)');  %Need dt here=1

wx=wavetrans(real(cx),{1,3,3.5,fs,'bandpass'},'mirror');
wy=wavetrans(imag(cx),{1,3,3.5,fs,'bandpass'},'mirror');
[wp,wn]=transconv(wx,wy,'uv2pn');

ebasn_bandwidth_ridges=ellridge(dt,wx,wy,fs,{1.5,0.5,0,'phase'});  
matsave -v6 ebasn_bandwidth_ridges
%\*************************************************

%/*************************************************
load ebasn_bandwidth_ridges
use ebasn_bandwidth_ridges
[a,b,theta,phi]=ellconv(wpr,wnr,'pn2ab');

%Other ellipse properties from xy transforms
[kappa,lambda]=ab2kl(a,b);
[ri,ra,rm]=ellrad(a,b,phi);
[vi,vphi,va,vm]=ellvel(a,b,theta,phi,dt*24*3600,1e5);


fg=fpr;
fl=fnr;
index=find(b<0);
if ~isempty(index)
    fg(index)=fnr(index);
    fl(index)=fpr(index);
end

% [omp,omn]=vdiff(phi+theta,phi-theta,1);
% 
% omg=omp;
% oml=omn;
% index=find(b<0);
% if ~isempty(index)
%     omg(index)=omn(index);
%     oml(index)=omp(index);
% end

%\*************************************************

%/*************************************************
titlestr{1}='Instantaneous Properties';
titlestr{2}='Geometric Mean Properties';

figure
for i=1:2
    subplot(1,2,i)
    if i==1
        plot(ri,vi)
    else
        plot(rm,vm)
    end
    axis([0 65 -60 20]/2)
    hlines(0,'k')
    title(titlestr{i})
    xlabel('Radius (km)')
    ylabel('Velocity (cm/s)')
    xtick([0:10:60])   
    ytick([-60:10:50])
end
packcols(1,2)
letterlabels(4)

orient landscape
set(gcf,'paperposition',[1 1 8 5])
fontsize 14 12 12 12
if strcmp(str,'print')
    print -depsc bandwidth_scatter.eps
end
%\*************************************************

%/*************************************************
rbin=[0:1:60]'/2;
vbin=[0:1:60]'/2;

[xi,xik,xil,lambda]=ellband(wpr,wnr);

[matm,xmid,ymid]=twodhist(rm,abs(vm),rbin,vbin);
[ximed,xmid,ymid]=twodmed(rm,abs(vm),xik,rbin,vbin);

vswap(ximed,matm,0,nan);
z=log10(matm);
z(:,:,2)=ximed;


titlestr{1}='Geometric Mean Distribution';
titlestr{2}='Median of Stability \Xi';

figure
clear h
for i=1:2
    h(i)=subplot(1,2,i);
    pcolor(xmid,ymid,z(:,:,i))
    if i==1,
        caxis([0.3 1.3])
    elseif i==2
        caxis([0 .3])
    end
    shading flat,%colormap hot,flipmap
    axis([0 55 0 55]/2)
    title(titlestr{i})
    xlabel('Radius (km)'),axis equal,axis square,
    ylabel('Velocity (cm/s)')
    xtick([0:10:50]/2)   
    ytick([0:10:50]/2),    axis([0 55 0 55]/2),
end

orient landscape
letterlabels(h,1);
axes(h(1)),colorbar('eastoutside');
axes(h(2)),colorbar('eastoutside');

fontsize 14 12 12 12
set(gcf,'paperposition',[1 1 10 5])
if strcmp(str,'print')
    print -dpsc bandwidth_distribution.eps
end
%\*************************************************


%/*************************************************
kbin=[0:1:60]'/2;
fbin=[0:0.5:25]'/100;

[xi,xik,xil,lambda]=ellband(wpr,wnr);

[matm,xmid,ymid]=twodhist(fg,kappa,fbin,kbin);
[ximed,xmid,ymid]=twodmed(fg,kappa,xik,fbin,kbin);

vswap(ximed,matm,0,nan);
z=log10(matm);
z(:,:,2)=ximed;


titlestr{1}='Geometric Mean Distribution';
titlestr{2}='Median of Stability \Xi';

figure
clear h
for i=1:2
    h(i)=subplot(1,2,i);
    pcolor(xmid,ymid,z(:,:,i))
    if i==1,
        caxis([0.2 1.1])
    elseif i==2
        caxis([0 .3])
    end
    shading flat,%colormap hot,flipmap
    title(titlestr{i})
    xlabel('Frequency (cycles / day)'),axis equal,axis square,
    ylabel('Ellipse Magnitude')
    axis([0 .25 0 30])
    %xtick([0:10:50]/2)   
    %ytick([0:10:50]/2),    axis([0 55 0 55]/2),
end

orient landscape
letterlabels(h,1);
axes(h(1)),colorbar('eastoutside');
axes(h(2)),colorbar('eastoutside');

fontsize 14 12 12 12
set(gcf,'paperposition',[1 1 10 5])
if strcmp(str,'print')
    print -dpsc bandwidth_frequency_distribution.eps
end
%\*************************************************



%/*************************************************
use ebasn_bandwidth_ridges
[zp,fp,zn,fn,zeta]=ridgemap(ebasn_bandwidth_ridges,'collapse');


[a,b,theta,phi]=ellconv(zp,zn,'pn2ab');

figure,
subplot(131)
h=plot(cx);hold on
axis equal,axis([-400 500 -1200 600]),
title('Elliptical Bivariate Data')
xtick([-1200:200:400]),ytick([-1200:200:600])
ylabel('Displacement North (km)')
xlabel('Displacement East (km)')
plot(cx(1),'k*','markersize',10)
subplot(132),
h=plot(cx-zeta);hold on
axis equal,axis([-400 500 -1200 600]),
title('Residual Trajectories')
xtick([-1200:200:400]),ytick([-1200:200:600])
ylabel('Displacement North (km)')
xlabel('Displacement East (km)')
plot(cx(1),'k*','markersize',10)
subplot(133),
h=plot(cx-zeta);  linestyle(h,'C'),hold on
index=[6*4:6*4:length(a)-6*4];
h=ellipseplot(index,a,b,theta,cx-zeta);
axis equal,axis([-400 500 -1200 600]),
xtick([-1200:200:400]),ytick([-1200:200:600])
title('Estimated Local Ellipses')
xlabel('Displacement East (km)')
letterlabels(1)
packcols(1,3)


cd_figures
orient landscape
if strcmp(str,'print')
    print -depsc bivariate_loopers.eps
end
%\*************************************************


