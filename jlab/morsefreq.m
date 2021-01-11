function [fm,fe,fi,cf] = morsefreq(ga,be)
%MORSEFREQ  Frequency measures for generalized Morse wavelets. [with F. Rekibi]
%
%   [FM,FE,FI]=MORSEFREQ(GAMMA,BETA) calculates three different
%   measures of the frequency of the lower-order generalized 
%   Morse wavelet specified by parameters GAMMA and BETA.
%
%   FM is the modal or peak, FE is the "energy" frequency, and 
%   FI is the instantaneous frequency at the wavelet center.
%
%   [FM,FE,FI,CF]=MORSEFREQ(GAMMA,BETA) also computes the 
%   curvature CF of the instantaneous frequency at the wavelet 
%   center. 
%
%   See Lilly and Olhede (2008b) for details.
%
%   Note that all frequency quantities here are *cyclic* as in
%   in cos(2 pi f t), and not radian as in cos(omega t).
%   
%   Specifially the cyclic frequency curvature CF is related to 
%   the radian frequency curvature RCF via RCF = 2*pi*CF. 
%
%   The input parameters must either be matrices of the same size,
%   or some may be matrices and the others scalars.   
%
%   See also MORSEBOX, MORSEWAVE.
%
%   'morsefreq --f' and 'morsefreq --f2' generate sample figures.
%   'morsefreq --t' runs a test.
%
%   Usage: fm = morsefreq(ga,be);
%          [fm,fe,fi] = morsefreq(ga,be);  
%          [fm,fe,fi,cf] = morsefreq(ga,be);  
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2008 J. M. Lilly and F. Rekibi
%                         --- type 'help jlab_license' for details    

if strcmp(ga,'--t')
  morsefreq_test;return
end

if strcmp(ga,'--f')
  morsefreq_fig;return
end

if strcmp(ga,'--f2')
  morsefreq_fig2;return
end

fm=frac(1,2*pi)*frac(be,ga).^frac(1,ga);

if nargout>1
    fe=frac(1,2*pi)*frac(1,2.^frac(1,ga)).*frac(gamma(frac(2*be+2,ga)),gamma(frac(2*be+1,ga)));
end

if nargout>2
    fi=frac(1,2*pi)*frac(gamma(frac(be+2,ga)),gamma(frac(be+1,ga)));
end

if nargout>2
    mo=morsemom(0,ga,be);
    m1=morsemom(1,ga,be);
    m2=morsemom(2,ga,be);
    m3=morsemom(3,ga,be);
    
    k1=frac(m1,mo);
    k2=frac(m2,mo)-frac(m1,mo).^2;
    k3=2*frac(m1.^3,mo.^3)-3.*frac(m1,mo).*frac(m2,mo)+frac(m3,mo);
    cf=-frac(1,2*pi).*frac(k3,sqrt(k2.^3));
end



if 0
%    C = morsecfun(A,ga,be);

%   MORSEFREQ uses the formula of Olhede and Walden (2002),
%   "Generalized Morse Wavelets", the first formula on page 2665.
%

    r=(2*be+1)./ga;
    coeff=gamma(r+(1./ga)).*2.^(-1./ga);
    fmin=coeff./(2*pi.*gamma(r).*(C+sqrt(C.^2-1)).^(1./ga));
    fmax=coeff./(2*pi.*gamma(r).*(C-sqrt(C.^2-1)).^(1./ga));

    if nargout >4
        fo=frac(1,2).*(fmax+fmin);
    end
    if nargout >5
        fw=frac(1,2).*(fmax-fmin);
    end
end


function[]=morsefreq_test
 


function[]=morsefreq_fig
ga=[2 3 4 8];
be=[1:.1:10];

[ga,be]=meshgrid(ga,be);
index=find(be<frac(ga-1,2));
be(index)=nan;

[fm,fe,fi,cf]=morsefreq(ga,be);

figure
subplot(221)
plot(be,fe./fm),linestyle k 2k k-- k-. 
title('Energy Frequency / Peak Frequency')
ylim([0.90 1.15]),xlim([1 10]),hlines(1,'k:'),xtick(1:10);ytick(0.8:0.05:1.2),
xlabel('Beta'),ylabel('Frequency Ratio')
fixlabels([0 -2])

subplot(222)
plot(be,fi./fm),linestyle k 2k k-- k-. 
title('Instantaneous / Peak Frequency')
ylim([0.90 1.15]),xlim([1 10]),hlines(1,'k:'),xtick(1:10);ytick(0.8:0.05:1.2),
xlabel('Beta'),ylabel('Frequency Ratio')
fixlabels([0 -2])

subplot(223)
plot(be,cf),linestyle k 2k k-- k-. 
title('Instantaneous Frequency Curvature')
ylim([-.04 .01]),xlim([1 10]),hlines(0,'k:'),xtick(1:10);
ytick([-.04:.01:.01])
xlabel('Beta'),ylabel('Dimensionless Curvature')
fixlabels([0 -2])

[p,dt,dom]=morsebox(ga,be);
subplot(224)
plot(be,p),linestyle k 2k k-- k-. 
title('Heisenberg Box Area')
ylim([.5 .56]),xlim([1 10]),hlines(0,'k:'),xtick(1:10);
ytick([.5:.01:.6])
xlabel('Beta'),ylabel('Area')
fixlabels([0 -2])


function[]=morsefreq_fig2
ga=[2 3 4 8];
be=[1:.1:10 10:.5:100];

[ga,be]=meshgrid(ga,be);
index=find(be<frac(ga-1,2));
be(index)=nan;

[fm,fe,fi,cf]=morsefreq(ga,be);

figure
p=frac(sqrt(be.*ga),pi);
subplot(221)
plot(p,fe./fm),linestyle k 2k k-- k-. 
title('Energy Frequency / Peak Frequency')
ylim([0.90 1.15]),xlim([0.25 3/2]*2),
hlines(1,'k:'),xtick([0:10]/2);ytick(0.8:0.05:1.2),
xlabel('Duration / Period Ratio'),ylabel('Frequency Ratio')
fixlabels([-1 -2])

subplot(222)
plot(p,fi./fm),linestyle k 2k k-- k-. 
title('Instantaneous / Peak Frequency')
ylim([0.90 1.15]),xlim([0.25 3/2]*2),
hlines(1,'k:'),xtick([0:10]/2);ytick(0.8:0.05:1.2),
xlabel('Duration / Period Ratio'),ylabel('Frequency Ratio')
fixlabels([-1 -2])

subplot(223)
plot(p,cf),linestyle k 2k k-- k-. 
title('Instantaneous Frequency Curvature')
ylim([-.15 .15]),xlim([0.25 3/2]*2),
hlines(0,'k:'),xtick([0:10]/2);
ytick([-.15:.05:.15])
xlabel('Duration / Period Ratio'),ylabel('Dimensionless Curvature')
fixlabels([-1 -2])

[a,dt,dom]=morsebox(ga,be);
subplot(224)
plot(p,a),linestyle k 2k k-- k-. 
title('Heisenberg Box Area')
ylim([.5 .55]),xlim([0.25 3/2]*2),
hlines(0,'k:'),xtick([0:10]/2);
ytick([.5:.01:.6])
xlabel('Duration / Period Ratio'),ylabel('Area')
fixlabels([-1 -2])



%/********************************************************************
%Mumerical computation of wavelet properties
m=[0.3:.05:2];
be=1:.1:6;

fs=1/100;

t=[-10000:10000]';

clear fm fe fi cf p a 
disp('Sorry, this might take a while...')
for i=1:length(m)    
    psi=morlwave(length(t),fs,m(i));
    [fm(i),fe(i),fi(i),cf(i),p(i),a(i)]=morsefreq_numerical(t,psi,fs);
end
%h=gcf;figure,plot(m,fm./fs,'+'),figure(h)

clear fm2 fe2 fi2 cf2 p2 a2 
for i=1:length(be)    
    psi=morsewave(length(t),1,3,be(i),fs);
    [fm2(i),fe2(i),fi2(i),cf2(i),p2(i),a2(i)]=morsefreq_numerical(t,psi,fs);
end
%\********************************************************************

letterlabels(2)

subplot(221)
plot(p2,fe2./fm2,'k.'),plot(p,fe./fm,'k:'),plot(p,fe./fm,'k+')

subplot(222)
plot(p2,fi2./fm2,'k.'),plot(p,fi./fm,'k:'),plot(p,fi./fm,'k+')

subplot(223)
plot(p2,cf2,'k.'),plot(p,cf,'k:'),plot(p,cf,'k+')

subplot(224)
plot(p2,a2,'k.'),plot(p,a,'k:'),plot(p,a,'k+')




function[fm,fe,fi,cf,p,a]=morsefreq_numerical(t,psi,fs)

om_axis=vshift(2*pi*fftshift(t./length(t)),-1,1);

psi=bandnorm(psi,fs);

[maxpsi,index]=max(abs(fft(psi)));
om=om_axis(index);    
%om=2*pi*fs;
fm=om./(2*pi);

[mut,sigma]=pdfprops(t,psi.*rot(-t.*fm*2*pi)); 
p=real(sigma).*(fm)*2;

dpsi=vdiff(imlog(psi),1);      

omi=dpsi((length(t)+1)/2,1);
fi=omi/(2*pi);

ddom=vdiff(vdiff(dpsi,1),1);

[mut,sigmat]=pdfprops(t,abs(psi).^2); 
[ome,sigmao]=pdfprops(om_axis,abs(fft(psi)).^2);
fe=ome/(2*pi);
cf=frac(ome.^3,ome.^2).*ddom((length(t)+1)/2,1)./sigmao.^3;
a=sigmao.*sigmat;


