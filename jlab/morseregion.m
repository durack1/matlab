function[t,f]=morseregion(C,ga,be)
%MORSEREGION  Generalized Morse wavelet time-frequency localization region.
%
%   [T,F]=MORSEREGION(C,GAMMA,BETA) describes the localization region of 
%   the generalized Morse wavelets specified by GAMMA and BETA.
%
%   C is a 'shape parameter' varying between zero and one.
%
%   T and F are parametric curves such that PLOT(T,F) shows the shape
%   of the time-frequency localization region.  
%
%   F is rescaled such that peak frequency of the lowest-order (K=1)
%   wavelet is at unity.
%
%   See Olhede and Walden (2002) for details.   
%
%   'morseregion --f' generates a sample figure.
%
%   Usage: [t,f]=morseregion(c,ga,be);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(C, '--f')
    morseregion_fig,return
end

fm = morsefreq(ga,be);
vcolon(C,ga,be,fm);
if length(C)==1
    C=C+zeros(size(ga));
elseif length(ga)==1
    ga=ga+zeros(size(C));
    be=be+zeros(size(C));
    fm=fm+zeros(size(C));
end

r=((2*be)+1)./ga;
c1=2.^(-1./ga).*frac(gamma(r+1./ga),gamma(r));
c2=frac(be,ga).*2.^(1./ga).*frac(gamma(r-1./ga),gamma(r));

coeff=gamma(r+(1./ga)).*2.^(-1./ga);
fmin=coeff./(2*pi.*gamma(r).*(C+sqrt(C.^2-1)).^(1./ga));
fmax=coeff./(2*pi.*gamma(r).*(C-sqrt(C.^2-1)).^(1./ga));

N=1000;
f=zeros(N,length(C));
for i=1:length(C)
    f(:,i)=linspace(fmin(i),fmax(i),N)';
end

ga=oprod(ones(N,1),ga);
be=oprod(ones(N,1),be);
c1=oprod(ones(N,1),c1);
c2=oprod(ones(N,1),c2);
C=oprod(ones(N,1),C);
fm=oprod(ones(N,1),fm);

a=frac(c1,2*pi*f).^ga;
b=frac(a.^(1-1./ga),c2);
t=real(frac(sqrt(2*a.*C-1-a.^2),b));

f=f./fm;
t=t.*fm;

f=[f;flipud(f)];
t=[-t;flipud(t)];

function[]=morseregion_fig
 
figure
ga1=[1.5 2 3 4 6];
be1=[2 4 8];
[ga,be]=meshgrid(ga1,be1);
[t,f]=morseregion(10,ga,be);
vcolon(ga,be);
dt=2*oprod(ones(size(t,1),1),be);
df=oprod(ones(size(t,1),1),ga);
h=plot(t+dt,f,'k');
kk=find(ga==3);linestyle(h(kk),'2k-')
kk=find(ga==1.5);linestyle(h(kk),'2k--')
kk=find(ga==6);linestyle(h(kk),'k--')
title('Morse wavelet localization regions')
xlabel('Normalized Time')
ylabel('Normalized Frequency'),
hlines(1,':')
xlim([2 21])
disp('Localization regions for GAMMA=[1.5 2 3 4 6] and BETA=[2 4 8].')
disp('Values of GAMMA are nested, values of BETA are offset horizontally.')
disp('The peak frequency is shown with a horizontal line.')



figure
ga1=[1.5 2 3 6];
be1=[2 4 8];
[ga,be]=meshgrid(ga1,be1);
[t,f]=morseregion(10,ga,be);
vcolon(ga,be);

subplot(211)
h=plot(t.*oprod(ones(size(t(:,1))),1./(be(:))),f,'k');
kk=find(be==2);linestyle(h(kk),'k-.')
kk=find(be==4);linestyle(h(kk),'k-')
kk=find(be==8);linestyle(h(kk),'k')
title('Morse wavelet localization regions')
xlabel('Normalized Time')
ylabel('Normalized Frequency, Linear Axis'),
hlines(1,':'),vlines(0,':')
ytick([0 1:9]),xtick([-1:.2:1])
xlim([-.6 .6]),ylim([0 8.5])

subplot(212)
h=plot(t.*oprod(ones(size(t(:,1))),1./(be(:))),f,'k');
kk=find(be==2);linestyle(h(kk),'k-.')
kk=find(be==4);linestyle(h(kk),'k--')
kk=find(be==8);linestyle(h(kk),'k')
xlabel('Normalized Time')
ylabel('Normalized Frequency, Logarithmic Axis'),
ylog
hlines(1,':'),vlines(0,':')
ytick([ 1/2 1:8])
ylim([0.1359 10]),xtick([-1:.2:1])
xlim([-.6 .6])

letterlabels(1)

packrows(2,1)

orient tall
set(gcf,'paperposition',[2 2 3.5 6])
fontsize 12 10 10 10

%if strcmp(str,'print')
   print -dpsc morsieregions.eps
%end




if 0
subplot(212)
ga=[1.5 3 6 ];
be=[6./ga 12./ga 24./ga];
ga=[ga ga ga];
[t,f]=morseregion(10,ga,be);
vcolon(ga,be);
t(:,1:3:end)=t(:,1:3:end)+8;
t(:,2:3:end)=t(:,2:3:end)+12;
t(:,3:3:end)=t(:,3:3:end)+16;
h=plot(t,f,'k');
kk=find(be.*ga==12);linestyle(h(kk),'2k-')
kk=find(be.*ga==6);linestyle(h(kk),'2k--')
kk=find(be.*ga==24);linestyle(h(kk),'k--')
title('Morse wavelet localization regions')
xlabel('Normalized Time')
ylabel('Normalized Frequency'),
hlines(1,':')
end
%reporttest('MORSEREGION',aresame())
