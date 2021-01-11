function[varargout]=makefigs_whoi07talk(varargin)
%MAKEFIGS_WHOI07TALK
%
%   MAKEFIGS_WHOI07TALK
%
%   'makefigs_whoi07talk --t' runs a test.
%
%   Usage: []=makefigs_whoi07talk();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    makefigs_whoi07talk_test,return
end




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

titlestr{1}='';
titlestr{2}='Three contributions to ellipse variation';
titlestr{3}='';
xstr{1}='Magnitude';
xstr{2}='Eccentricity';
xstr{3}='Precession';
figure
for i=1:3
    subplot(1,3,i)
    plot(cxe(:,i)),hold on
    plot(cxe(1:200,i)),linestyle 1k 2r
    axis([-3.2 3.2 -3.2 3.2])
    title(titlestr{i})
   %xlabel('Displacement East'),axis equal,axis square
    xlabel(xstr{i})
    xtick([-4:4])   
    ytick([-4:4])
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    axis equal,axis square
end
packcols(1,3)

transparency
print -dpng stability_schematic_trans.png
%\****************************************************************


%/****************************************************************
figure

subplot(121)
dt=1;
t=[1:dt:dt*3000]';
x=randn(50,1);
x=[0*x x];

for i=1:length(x)
    plot([i i]-25.5+sqrt(-1)*x(i,:)),hold on
end

linestyle default, linestyle thick
title('Time Basis'),xlim([-25 25]),ylim([-2.5 2.5]),axis square,xtick([-20:10:20])

subplot(122)

t=[-25:.1:25]';T=50;

for i=1:3
    plot(t,cos(2*pi*i*t./T).*randn(1)),hold on
    plot(t,sin(2*pi*i*t./T).*randn(1)),hold on
end
linestyle default, linestyle thick,xlim([-25 25]),ylim([-2.5 2.5]),axis square,xtick([-20:10:20])

title('Fourier Basis')
%packcols(1,2)

transparency
print -dpng basis_schematic_trans.png



%\****************************************************************


%/****************************************************************
figure

dt=1;
t=[1:dt:dt*3000]';
om=2*pi/40;
xo=10*rot(t.*om)*(dt./om)./6.366;
U=[2.5 5 10 20 40]./6.366;
x=zeros(length(xo),length(U));

for i=1:length(U)
    x(:,i)=xo+U(i).*t;
end

axis equal
plot(x),yoffset(25)
ylim([-20 120])
xlim([20 300])
linestyle thick
title('Trajectory variation with increasing mean flow')

transparency
print -dpng trajectory_schematic_trans.png

%\****************************************************************



%/****************************************************************
figure

subplot(121)
t=[-25:.1:25]';
plot([0+sqrt(-1)*0;0+sqrt(-1)*10],'b'),hold on
plot(t,1./t,'r')
linestyle 2b 2r
ylim([-1 1])
hlines(0,'k:'),vlines(0,'k:')
text(-20,.8,'Real part','color','b')
text(-20,.6,'Imag part','color','r')
title('Analytic filter --- time domain')
xlim([-25 25]),xtick([-20:10:20]),axis square,plot(0,1,'b^','markersize',15)
plot(0,1,'b^','markersize',15,'markerfacecolor','b')

subplot(122)
t=[-25:.1:25]';
x=0*t;
x(t>0)=2;
plot(t./25/2,x),linestyle 2k
title('Analytic filter --- Fourier domain')
ylim([-2.2 2.2]),xtick([-0.5:.25:.5])
hlines(0,'k:'),vlines(0,'k:'),axis square

transparency
orient landscape
print -dpng analytic_schematic_trans.png

%\****************************************************************



load ebasn_bandwidth
load ebasn_bandwidth_ridges