function[a,sigt,sigo]=morsebox(ga,be)
%MORSEBOX  Heisenberg time-frequency box for generalized Morse wavelets.
%
%   A=MORSEBOX(GAMMA,BETA) returns the time-bandwidth product of the
%   a generalized Morse wavelet, that is, the area of its Heisenberg box.
%
%   [A,SIGT,SIGO]=MORSEBOX(GAMMA,BETA) also returns the box width in time 
%   SIGT and in frequency SIGO, with A=SIGT*SIGO. 
%
%   Note that SIGO is the box width in radian, not cyclic, frequency.
%
%   See Lilly and Olhede (2008b) for details.
%
%   See also MORSEFREQ, MORSEWAVE.
%
%   'morsebox --t' runs a test.
%   'morsebox --f' generates a sample figure.
%
%   Usage: a=morsebox(ga,be);
%          [a,sigt,sigo]=morsebox(ga,be);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(ga, '--t')
    morsebox_test,return
end
if strcmp(ga, '--f')
    morsebox_fig,return
end

[mo,no]=morsemom(0,ga,be);
[m1,n1]=morsemom(1,ga,be);
[m2,n2]=morsemom(2,ga,be);
[m3,n3]=morsemom(3,ga,be);


[ma,na]=morsemom(0,ga,be-1);
[mb,nb]=morsemom(0,ga,be-1+ga);
[mc,nc]=morsemom(0,ga,be-1+ga/2);

rata=frac(morsea(ga,be),morsea(ga,be-1)).^2;
ratb=frac(morsea(ga,be),morsea(ga,be-1+ga)).^2;
ratc=frac(morsea(ga,be),morsea(ga,be-1+ga/2)).^2;


om = 2*pi*morsefreq(ga,be);

sigo=frac(1,om).*sqrt(frac(n2,no)-frac(n1,no).^2);
sig2a=  rata.*be.^2.*frac(na,no);
sig2b=  ratb.*ga.^2.*frac(nb,no);
sig2c=2*ratc.*be.*ga.*frac(nc,no);
sigt=om.*sqrt(sig2a+sig2b-sig2c);


%frac(be,sqrt(2.^(1./ga)));
a=sigt.*sigo;



function[]=morsebox_test
 
t=[-500:500]';
n=0;
ga1=[2:2:10];
be1=[2:2:10];
clear sigmat sigmao
for i=1:length(ga1)
    for j=1:length(be1)
        n=n+1;
        fs=1/20;
        psi=morsewave(length(t),1,ga1(i),be1(j),fs);
        psi=bandnorm(psi,fs);
        [mut,sigmat(j,i)]=pdfprops(t,abs(psi).^2); 
        sigmat(j,i)=sigmat(j,i).*2*pi.*fs;
    
        fs=1/5;
        psi=morsewave(length(t),1,ga1(i),be1(j),fs);
        psi=bandnorm(psi,fs);
        [muo,sigmao(j,i)]=pdfprops(2*pi*fftshift(t./length(t)),abs(fft(psi)).^2); 
        sigmao(j,i)=sigmao(j,i)./(2*pi.*fs);
    end
end


[ga,be]=meshgrid(ga1,be1);
[a,sigt,sigo]=morsebox(ga,be);

reporttest('MORSEBOX numerical trials for SIGT',aresame(sigt,sigmat,1e-5))
reporttest('MORSEBOX numerical trials for SIGO',aresame(sigt,sigmat,1e-3))


function[]=morsebox_fig


ga1=[1:.1:11];
be1=[1:.1:10];

[ga,be]=meshgrid(ga1,be1);
[fm,fe,fi,cf] = morsefreq(ga,be);
a=morsebox(ga,be);

figure
contourf(ga1,be1,a,[.5:.01:.6])
hold on, contour(ga1,be1,a,[.500:.002:.51],'k:')
colormap gray,flipmap,
axis([1 10 1 10])
xtick([1:10]),ytick([1:10])
ax=gca;
hc=colorbar;hc=discretecolorbar(hc,[.5 .6],[.5:.01:.6]);
axes(hc),hlines([.500:.002:.51],'k:')
axes(ax)

contour(ga1,be1,fm-fe,[ 0 0],'k','linewidth',2)
contour(ga1,be1,fm-fi,[ 0 0],'k','linewidth',2)
contour(ga1,be1,cf,[ 0 0],'k','linewidth',2)
caxis([.5 .6])
vlines(3,'k--')
plot(ga1,12./ga1,'k')
 
title('Morse Wavelet Area and Transitions')
xlabel('Gamma Parameter')
ylabel('Beta Parameter')
plot([1+sqrt(-1)*0 10+sqrt(-1)*9/2],'k','linewidth',3)
plot([1+sqrt(-1)*0 10+sqrt(-1)*9/2],'w--','linewidth',2)



