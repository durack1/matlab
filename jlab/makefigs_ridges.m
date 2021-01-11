function[]=makefigs_ridges(str)
%MAKEFIGS_RIDGES  Makes figures for Lilly and Gascard (2006).
%
%   MAKEFIGS_RIDGES  Makes all figures for 
%
%                       Lilly & Gascard (2006)
%    "Wavelet ridge diagonisis of time-varying elliptical signals 
%                with application to an oceanic eddy"
%         Nonlinear Processes in Geophysics 13, 467--483.
%
%   Type 'makefigs_ridges' at the matlab prompt to make all figures for
%   this and print them as .eps files into the current directory.
%  
%   Type 'makefigs_ridges noprint' to supress printing to .eps files.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2007 J.M. Lilly --- type 'help jlab_license' for details        

if nargin==0
  str='print';
end

%/********************************************************
%Load and prepare data

load npg2006
use npg2006

% Please note that this data has not been released for public use.
% Contact Jean-Claude.Gascard@lodyc.jussieu.fr for details.

% num   -  Date in day number of 2001
% dt    -  Time step in days
% lat   -  Latitude
% lon   -  Longitude
% p     -  Pressure in decibar
% t     -  Potential temperature
% cx    -  Complex-valued position x+iy
% cv    -  Complex-valued displacement velocity u+iv

%Decide on frequencies
fs=1./(logspace(log10(10),log10(100),50)');

%Compute wavelet transforms using generalized Morse wavelets
wx=wavetrans(real(cx),{1,2,4,fs,'bandpass'},'mirror');
wy=wavetrans(imag(cx),{1,2,4,fs,'bandpass'},'mirror');
[wp,wn]=transconv(wx,wy,'uv2pn');

%Uncomment to see plots of Cartesian and rotary transforms
%h=wavespecplot(num,cx,dt./fs,wx,wy,0.5);
%h=wavespecplot(num,cx,dt./fs,wp,wn,0.5);

%Form ridges of component time series
pstruct=ridgewalk(dt,wp,fs,{2,1,1,'phase'});   
nstruct=ridgewalk(dt,wn,fs,{2,1,1,'phase'});   
xstruct=ridgewalk(dt,wx,fs,{2,1,1,'phase'});   
ystruct=ridgewalk(dt,wy,fs,{2,1,1,'phase'});    

%Map ridges onto original time series
[wmp,fmp]=ridgemap(pstruct);
[wmn,fmn]=ridgemap(nstruct);
[wmx,fmx]=ridgemap(xstruct);
[wmy,fmy]=ridgemap(ystruct);

%Positive transform has multiple ridge pieces --  add these
vsum(wmp,fmp,3);

%Convert xy transforms to ellipse forms
[X,Y,phix,phiy]=ellconv(wmx,wmy,'xy2xy'); 
[P,N,phip,phin]=ellconv(wmx,wmy,'xy2pn'); 
[a,b,theta,phi]=ellconv(wmx,wmy,'xy2ab');

%Other ellipse properties from xy transforms
[kappa,lambda]=ab2kl(a,b);
[ri,ra,rm]=ellrad(a,b,phi);
[vi,vphi,va,vm]=ellvel(a,b,theta,phi,4*3600,1e5);

%Other frequencies
[fphi,fth,fmp2,fmn2]=vdiff(phi,theta,phip,phin,1,2*pi*dt);

%Elliptical signal
cxe=ellsig(a,b,theta,phi);
cxr=cx-cxe;

L=54;  %approximate region of edge-effects
%fc=sw_f(43.5)*3600*24;  Coriolis frequency


%/********************************************************  
figure,
subplot(221),plot(num,[fmx fmy]),linestyle 2k k--
title('Diagnosed frequencies') 
axis([min(num) max(num) -.05 .37]),fixlabels([0 -2]),hlines(0,'k:'),vlines(num([L length(cx)-L]),'k:')
ylabel('Frequency (Cycles / day)'),
subplot(223),plot(num,[fmp fmn fmn2]),linestyle 2k k-- k-.
xlabel('Day of 2001'),ylabel('Frequency (Cycles / day)')
axis([min(num) max(num) -.05 .37]),fixlabels([0 -2]),hlines(0,'k:'),vlines(num([L length(cx)-L]),'k:')

eps=.01/2;
subplot(222),plot(num,[fmp+eps fmp2-eps]),linestyle 2k k--
title('Inferred frequencies') ,
axis([min(num) max(num) -.05 .37]),fixlabels([0 -2]),hlines(0,'k:'),noylabels,vlines(num([L length(cx)-L]),'k:')
%ylabel('\omega_+/2\pi (Cycles / day)'),
subplot(224),plot(num, [fphi fth]),linestyle 2k k--
%ylabel('\omega_\phi/2\pi and \omega_\theta/2\pi (Cycles / day)'),
axis([min(num) max(num) -.05 .37]),fixlabels([0 -2]),hlines(0,'k:'),noylabels,vlines(num([L length(cx)-L]),'k:')

letterlabels(2)
xlabel('Day of 2001'),packboth(2,2)
fontsize jpofigure
set(gcf,'paperposition',[1 1 7 4])

if strcmp(str,'print')
   print -deps npg-2006-0054-f04.eps
end
%\********************************************************  

%/********************************************************  
figure
subplot(211)
plot(num,[ri rm rm ra abs(wn(:,27))/sqrt(2)]),linestyle  0.5k 3w 1.5k  0.5k-- k-.
ylabel('Radius (kilometers)'),
axis([min(num) max(num) 0 25]),vlines(num([L length(cx)-L]),'k:')
title('Radius and Temperature') ,
subplot(212)
plot(num,[t vfilt(t,12) vfilt(t,12)]),linestyle  0.5k 4w 1.5k  
xlabel('Day of 2001'),ylabel('Temperature ( ^\circ C)'),
axis([min(num) max(num) 12.1 12.86 ]),vlines(num([L length(cx)-L]),'k:')

letterlabels(1)
packrows(2,1)
fontsize jpofigure
set(gcf,'paperposition',[1 1 7 4])

if strcmp(str,'print')
   print -deps npg-2006-0054-f05.eps
end
%\********************************************************  

%/\********************************************************  
figure

index=L:length(cx)-L;

r1=[1e-10:.1:25]';

subplot(121)
plot(ri(index),-vphi(index),'k'),hold on,
xlabel('Radius (kilometers)'),
ylabel('Azimuthal velocity (cm/s)'),
title('Instantaneous properties') ,
plot(r1,100./r1,'k:'),plot(r1,200./r1,'k:'),plot(r1,400./r1,'k:'),plot(r1,50./r1,'k:')
axis([0 22 0 25])
%plot(r1,-vq,'k--'),

subplot(122)
plot(ri(index),-vphi(index),'k'),hold on,linestyle 0.5D
plot(rm(index),-vm(index),'ko','markersize',2,'markerfacecolor','k'),
xlabel('Radius (kilometers)'),
title('Geometric mean properties') ,
plot(r1,100./r1,'k:'),plot(r1,200./r1,'k:'),plot(r1,400./r1,'k:'),plot(r1,50./r1,'k:')
axis([0 22 0 25])
%plot(r1,-vq,'k--'),


letterlabels(1)
packcols(1,2)

fontsize jpofigure
set(gcf,'paperposition',[1 1 7 3])

if strcmp(str,'print')
   print -depsc npg-2006-0054-f06.eps
end
%\*****************************************************  


%/********************************************************
figure,
subplot(121)
h=plot(cx,'k');hold on
axis equal,axis([-90 80 -80 65]),
title('Eddy-trapped float')
xtick([-75:25:75]),ytick([-75:25:75])
ylabel('Displacement North (km)')
xlabel('Displacement East (km)')
plot(cx(1),'k*','markersize',10)
subplot(122)
index=[6*4:6*4:length(a)-6*4];
ellipseplot(index,a,b,theta,cxr,'npoints',64)
hold on,linestyle k,plot(cxr,'k:') 
axis equal,axis([-90 80 -80 65]),
xtick([-75:25:75]),ytick([-75:25:75])
title('Ellipse extraction')
xlabel('Displacement East (km)')
letterlabels(1)
packcols(1,2)

fontsize jpofigure
set(gcf,'paperposition',[1 1 7 4])

if strcmp(str,'print')
   print -deps npg-2006-0054-f01.eps
end
%\********************************************************  


%/********************************************************
figure
subplot(121),plot(num,real([cx cxe-100 cxr cxr]))
linestyle 0.5k 0.5k 3w 1.5k
hlines(-100,'k:')
title('Float displacement East')
ylabel('Kilometers')
xlabel('Day of 2001')
axis([min(num) max(num) -120 80]),vlines(num([L length(cx)-L]),'k:')
subplot(122),plot(num,imag([cx cxe-100*sqrt(-1) cxr cxr]))
linestyle 0.5k 0.5k 3w 1.5k
hlines(-100,'k:')
axis([min(num) max(num) -120 80]),vlines(num([L length(cx)-L]),'k:')
title('Float displacement North')
xlabel('Day of 2001')
letterlabels(1)
packcols(1,2)

fontsize jpofigure
set(gcf,'paperposition',[1 1 7 3])

if strcmp(str,'print')
   print -deps npg-2006-0054-f02.eps
end
%\********************************************************  


%/********************************************************
%Ellipsesketch

a=3;
b=2;

phi=pi/4;
th=pi/6;

figure
ellipseplot(a,b,th,'npoints',64,'phase',phi),hold on,linestyle k
plot(rot(th+pi/2)*[0 1]*b,'k--')
plot(rot(th)*[0 1]*a,'k--')
plot(rot(th)*(a*cos(phi)+sqrt(-1)*b*sin(phi)),'k*')

title('Sketch of ellipse')
axis equal
axis([-3 3 -3 3])
vlines(0,':'),hlines(0,':')
ytick(1),xtick(1)

xi=[0:.1:th];
plot(1.25*rot(xi),'k');

xi=[th:.01:pi/2.8];
plot(1.5*rot(xi),'k');

text(2,1,'a')
text(-1,1.1,'b')
text(1.2,1.2,'\phi')
text(1.4,0.35,'\theta')

%fixlabels(-1)
fontsize jpofigure
set(gcf,'paperposition',[2 2 3.5 3.5])

if strcmp(str,'print')
   print -deps npg-2006-0054-f03.eps
end
%!gv ellipsesketch.eps &  
%\********************************************************


