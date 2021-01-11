function[x,X]=morsewave(varargin)
% MORSEWAVE  Generalized Morse wavelets of Olhede and Walden (2002). [with F. Rekibi]
%
%   PSI=MORSEWAVE(N,K,GAMMA,BETA,F) returns an N x K column vector PSI 
%   which contains time-domain versions of the first K generalized Morse
%   wavelets specified by GAMMA and BETA, concentrated at frequency F.
%
%   The frequency F is specfically the *cyclic* frequency at which the 
%   Fourier transform of the lowest-order (K=1) wavelet has its maximum
%   amplitude, assuming a unit sample rate.  If F has length L, PSI is 
%   of size N x L x K, with the columns in order of decreasing frequency.
%
%   Note that the wavelets are centered at the midpoint in time, row 
%   number ROUND(SIZE(PSI,1)/2).
%  
%   [PSI,PSIF]=MORSEWAVE(...) optionally returns a frequency-domain
%   version PSIF of the wavelets, in a matrix of size SIZE(PSI).
%   _________________________________________________________________
%
%   Sample rate
%
%   MORSEWAVE(N,K,GAMMA,BETA,F,DT) specifies the sample rate to be DT.
%   DT is optional with a default value of unity.
%   _________________________________________________________________
%
%   Normalization
%
%   MORSEWAVE supports two kinds of normalization for the wavelets.
%
%   MORSEWAVE(..., 'bandpass') uses "bandpass normalization", the 
%   default.  See Lilly and Gascard (2006).  This implies that the 
%   FFT of the lowest-order (K=1) generalized Morse wavlet, PSI * DT, 
%   has a maximum value of 2. 
%
%   MORSEWAVE(..., 'energy') uses the unit energy normlization.  The 
%   time-domain wavelet energy SUM(ABS(PSI).^2 * DT) is then unity. 
%
%   Note MORSEWAVE now uses bandpass-normalization by default, not 
%   energy normalization.
%   _________________________________________________________________
%
%   Background
%
%   Generalized Morse wavelets are described in Olhede and Walden
%   (2002), "Generalized Morse Wavelets", IEEE Trans. Sig. Proc., v50,
%   2661--2670.
%
%   See also Lilly & Olhede (2008b).
%   _________________________________________________________________
%
%   Usage: psi=morsewave(N,K,ga,be,f);
%          [psi,psif]=morsewave(N,K,ga,be,f);
%          [psi,psif]=morsewave(N,K,ga,be,f,'bandpass');
%
%   'morsewave --t' runs a test
%   'morsewave --f' generates a sample figure
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 F. Rekibi and J.M. Lilly 
%                         --- type 'help jlab_license' for details  
 


%   _________________________________________________________________
%
%   The zero beta case
%
%   It is unlikely that you will need to read this section, which is 
%   why the comment is hidden.  It describes a feature mostly used for 
%   testing purposes.
%
%   For BETA equal to zero, the generalized Morse wavelets describe
%   a non-zero-mean function which is not in fact a wavelet. 
%
%   Only 'bandpass' normalization is supported for this case.
%
%   Since the frequency of the BETA=0 wavelet is not defined, the
%   frequency associated with the BETA=1 wavelet with the same GAMMA
%   same GAMMA is used instead.
%
%   The frequency-domain definition of MORSEWAVE is not necessarily 
%   a good way to compute the zero-beta functions, however.  You will
%   probably need to take a very small DT.
%   _________________________________________________________________

  
if strcmp(varargin{1},'--t')
  morsewave_test;return
end
if strcmp(varargin{1},'--f')
  morsewave_fig;return
end

str='bandpass';
fam='first';

for i=1:2
if isstr(varargin{end})
    temp=varargin{end};
    if strcmp(temp(1:3),'fir')||strcmp(temp(1:3),'sec')
       fam=temp;
    elseif strcmp(temp(1:3),'ban')||strcmp(temp(1:3),'ene')
       str=temp;
    end
    varargin=varargin(1:end-1);
end
end

dt=1;
if length(varargin)==6
    dt=varargin{1};
    varargin=varargin(2:end);
end
N=varargin{1};
K=varargin{2};
ga=varargin{3};
be=varargin{4};
fs=varargin{5};


str=str(1:3);

if be==0&&strcmp(str,'ene')
    str='ban';
    disp('For BETA=0, energy normalization is not defined.  Using bandpass normalization.')
end
%/********************************************************
%Enforce convention of small scales first
fs=fs(:);
if length(fs)>1
  if fs(1)-fs(2)<0
    fs=flipud(fs);
  end
end
%\********************************************************

for n=1:length(fs)
    [X(:,:,n),x(:,:,n)]=morsewave1(N,K,ga,be,fs(n),dt,str,fam);
end

if size(x,3)>1
  x=permute(x,[1 3 2]);
  if nargout==2
    X=permute(X,[1 3 2]);
  end
end

function[X,x]=morsewave1(N,K,ga,be,fs,dt,str,fam)
    
if be==0
    fo=((be+1)/ga).^(1/ga)/(2*pi);
elseif be~=0
    fo=(be/ga).^(1/ga)/(2*pi);    
end

fact=fs/fo.*dt;
om=2*pi*linspace(0,1-1./N,N)'./fact;
psizero=(om.^be).*exp(-om.^ga);

if strcmp(fam(1:3),'fir')
   X=morsewave_first_family(dt,fact,N,K,ga,be,om,psizero,str); 
elseif strcmp(fam(1:3),'sec')
   X= morsewave_second_family(dt,fact,N,K,ga,be,om,psizero,str); 
end

for k=0:K-1
  Xr(:,k+1)= X(:,k+1).*rot(om*(N+1)/2*fact);  %ensures wavelets are centered 
end


x=ifft(Xr);
for i=1:size(x,2)
    if real(x(round(end/2),i))<0
       x(:,i)=-x(:,i);
       X(:,i)=-X(:,i);
    end
end
if 0
ii=find(abs(X(:,1))==max(abs(X(:,1))));
for i=2:size(x,2)
    %if real(x(round(end/2),i))<0
    if isodd(i)
       if X(ii,i)<0
           x(:,i)=-x(:,i);
           X(:,i)=-X(:,i);
       end
    elseif iseven(i)
       if X(ii+1,i)-X(ii,i)<0
           x(:,i)=-x(:,i);
           X(:,i)=-X(:,i);
       end
    end
end
end


function[]=morsewave_test
morsewave_test_unitenergy
morsewave_test_centering
morsewave_test_scorer
morsewave_test_cauchy
morsewave_test_gaussian
morsewave_test_dawson
morsewave_test_admiss

function[]=morsewave_test_unitenergy
fs=1./logspace(log10(5),log10(40))'; 
N=1023;
w=morsewave(N,2,2,4,fs,'energy');
energy=vsum(abs(w(:,:,1)).^2,1);
reporttest('MORSEWAVE unit energy for unit sample rate, K=1',maxmax(energy-1)<1e-4)
energy=vsum(abs(w(:,:,2)).^2,1);
reporttest('MORSEWAVE unit energy for unit sample rate, K=2',maxmax(energy-1)<1e-4)

dt=0.1;
w=morsewave(dt,N,2,2,4,fs./dt,'energy');
energy=vsum(abs(w(:,:,1)).^2,1);
reporttest('MORSEWAVE unit energy for non-unit sample rate, K=1',maxmax(energy-1)<1e-4)
energy=vsum(abs(w(:,:,2)).^2,1);
reporttest('MORSEWAVE unit energy for non-unit sample rate, K=2',maxmax(energy-1)<1e-4)


function[X]=morsewave_first_family(dt,fact,N,K,ga,be,om,psizero,str); 

r=(2*be+1)./ga;
c=r-1;
L=0*om;
index=[1:round(N/2)];

A0=(pi*ga*(2.^r)/gamma(r)).^(1/2);
for k=0:K-1
  A=(pi*ga*(2.^r)*gamma(k+1)/gamma(k+r)).^(1/2);
  if strcmp(str,'ene')
     coeff = dt.*sqrt(2./fact)*A;
  elseif strcmp(str,'ban')
     coeff= morsea(ga,be)./dt.*frac(A,A0);
  end
    L(index)=laguerre(2*om(index).^ga,k,c);
    X(:,k+1)=coeff.*psizero.*L;
end

%  See Olhede and Walden, "Noise reduction in directional signals
%  using multiple Morse wavelets", IEEE Trans. Bio. Eng., v50, 51--57.
%  The equation at the top right of page 56 is equivalent to the
%  preceding expressions. Morse wavelets are defined in the frequency  
%  domain, and so not interpolated in the time domain in the same way
%  as other continuous wavelets.


function[X]=morsewave_second_family(dt,fact,N,K,ga,be,om,psizero,str); 

dom=om(2)-om(1);
a0=morsea(ga,be,'energy');
index=[1:round(N/2)];
psi0=dt.*sqrt(1./fact).*a0.*psizero;

if K>3
    error('Sorry, can only compute the first 3 members of this family right now.');
end

phi=zeros(length(om),K);
    
for k=0:K-1
    ak=morsewave_ak(k,ga,be);
    for n=0:k
        cnk=morsewave_cnk(n,k,ga,be);
        phi(index,k+1)=phi(index,k+1)+ak.*cnk.*om(index).^(n.*ga-k).*psi0(index);
    end
end

%Ensure zero mean
if iseven(N)
    phi(1,:)=0;
end

psi=phi;
for k=0:K-1
    for n=0:k-1
        bnk=morsewave_bkl(k,n,ga,be);
        psi(:,k+1)=psi(:,k+1)-bnk.*phi(:,n+1);
    end
%   morsewave_atildek(k,ga,be)
    %psi(:,k+1)=morsewave_atildek(k,ga,be).*psi(:,k+1);
    psi(:,k+1)=psi(:,k+1)./sqrt(vsum(psi(:,k+1).^2,1))*sqrt(N);
end
X=psi;

%X=phi;


function[cnk]=morsewave_cnk(n,k,ga,be);
if k==0&&n==0
    cnk=1;
elseif k==1&&n==0||k==0&&n==1
     cnk=be;
elseif k==1&&n==1
     cnk=-ga;        
elseif k==2&&n==0||k==0&&n==2
     cnk=be.*(be-1);
elseif k==2&&n==1||k==1&&n==2
     cnk=-(ga.*(ga-1)+2.*be.*ga); 
elseif k==2&&n==2
     cnk=ga.^2;                     
end


function[ak]=morsewave_ak(k,ga,be);
akinv=0;

for n=0:k
    for p=0:k
        cnk=morsewave_cnk(n,k,ga,be);
        cpk=morsewave_cnk(p,k,ga,be);
        ratn=frac(morsea(ga,be,'energy'),morsea(ga,be+n*ga-k,'energy'));
        ratp=frac(morsea(ga,be,'energy'),morsea(ga,be+p*ga-k,'energy'));
        akinv=akinv+cnk.*cpk.*morseproj(ga,be+n*ga-k,be+p*ga-k).*ratn.*ratp;
    end
end
ak=sqrt(1./akinv);


function[bkl]=morsewave_bkl(k,l,ga,be);
bkl=0;
for n=0:k
    for p=0:l
        cnk=morsewave_cnk(n,k,ga,be);
        cpk=morsewave_cnk(p,l,ga,be);
        ratn=frac(cnk,morsea(ga,be+n*ga-k,'energy'));
        ratp=frac(cpk,morsea(ga,be+p*ga-l,'energy'));
        bkl=bkl+morseproj(ga,be+n*ga-k,be+p*ga-l).*ratn.*ratp;
    end
end
bkl=bkl.*morsea(ga,be,'energy').^2.*morsewave_ak(k,ga,be).*morsewave_ak(l,ga,be);
    

function[dnk]=morsewave_dnk(n,k,ga,be);

a1=morsewave_ak(1,ga,be);
a2=morsewave_ak(2,ga,be);
if k==0&&n==0
    dnk=1;
elseif k==1&&n==0
     dnk=-a1.*morsewave_cnk(0,1,ga,be);
elseif k==1&&n==1
     dnk=1;        
elseif k==2&&n==0
     dnk=(a2.*morsewave_cnk(0,2,ga,be).*a1-1).*morsewave_cnk(0,1,ga,be);
elseif k==2&&n==1
     dnk=-a2.*morsewave_cnk(1,2,ga,be).*a1;
elseif k==2&&n==2
     dnk=1;                     
end



%This is not yet working, and also, is really slow.
function[atildek]=morsewave_atildek(k,ga,be);

akinv=0;

for n=0:k
    for p=0:k
        dnk=morsewave_dnk(n,k,ga,be);
        dpk=morsewave_dnk(p,k,ga,be);
        %ratn=frac(morsea(ga,be,'energy'),morsea(ga,be+n*ga-k,'energy'));
        %ratp=frac(morsea(ga,be,'energy'),morsea(ga,be+p*ga-k,'energy'));
        akinv=akinv+dnk.*dpk.*morsewave_bkl(n,p,ga,be);%.*ratn.*ratp;
    end
end
atildek=sqrt(1./akinv);


function[]=morsewave_test_centering
fs=1./logspace(log10(5),log10(40))'; 
N=1023;
w=morsewave(N,1,2,4,fs);
bool=0*fs;
for i=1:size(w,2)
   bool(i)=max(abs(w(:,i)))==abs(w(N/2+1/2,i));
end
reporttest('MORSEWAVE centered for odd N',all(bool))

N=1024;
w=morsewave(N,1,2,4,fs);
bool=0*fs;
for i=1:size(w,2)
   bool(i)=max(abs(w(:,i)))==abs(w(N/2,i)) || max(abs(w(:,i)))==abs(w(N/2+1,i));
end
reporttest('MORSEWAVE centered for even N',all(bool))


function[]=morsewave_test_scorer

dt=1;
t=[-50:dt:50]';
psi1=morsewave(dt,length(t),1,3,0,morsefreq(3,1),'bandpass');
c=3.^(1/3);
psi2=(1./c).*scorer(sqrt(-1)*t./c,1000);
%figure,uvplot(psi1),
%figure,uvplot(psi2)

err=vsum(abs(psi1-psi2).^2,1)./vsum(abs(psi1).^2,1);
reporttest('MORSEWAVE for GAMMA=3 wavelet versus Scorer function expression',err<1e-1)

function[hi]=scorer(z,n)
%This is not a very good way to compute the Scorer functions.
%Need to set n really high to have to integal behave nicely.
%Only used for testing purposes.

z=z(:);
u=linspace(0,10,n)';
du=u(2)-u(1);
umat=osum(0*z,u);

%aiz=airy(0,z);
%biz=airy(2,z);
%gi=frac(1,pi).*vsum(sin(frac(tmat.^3,3)+oprod(z,t)),2).*dt;
hi=frac(1,pi).*vsum(exp(-frac(umat.^3,3)+oprod(z,u)),2).*du;


function[]=morsewave_test_cauchy


dt=.01;
t=[-25:dt:25]';
psi1=morsewave(dt,length(t),1,1,0,morsefreq(1,1),'bandpass');
psi2=frac(1,pi).*frac(1,1-sqrt(-1)*t);

err=vsum(abs(psi1-psi2).^2,1)./vsum(abs(psi1).^2,1);
reporttest('MORSEWAVE for GAMMA=1 wavelet versus Cauchy function expression',err<1e-1)


function[]=morsewave_test_gaussian

dt=.1;
t=[-50:dt:50]';
psi1=morsewave(dt,length(t),1,2,0,morsefreq(2,1),'bandpass');
psi2=frac(1,2*sqrt(pi)).*(exp(-(t/2).^2)+sqrt(-1)*dawson(t/2)*frac(2,sqrt(pi)));
err=vsum(abs(psi1-psi2).^2,1)./vsum(abs(psi1).^2,1);
reporttest('MORSEWAVE for GAMMA=2 wavelet versus Gaussian function expression',err<1e-1)

function[]=morsewave_test_dawson
dt=0.01;
t=[-15:dt:15]';

n=5;
herm=hermpoly(t(:)/2,n+1);
herm=herm(:,2:end);
g=exp(-frac(t.^2,4));

[psi1,psi2]=vzeros(length(t),5);
for k=1:5
    dk=dawsonderiv(t/2,k);
    coeffk=frac(1,4*sqrt(pi)).*morsea(2,k).*frac(sqrt(-1),2).^k;
    tic
    psi1(:,k)=morsewave(dt,length(t),1,2,k,morsefreq(2,k),'bandpass');
    toc
    tic
    psi2(:,k)=coeffk*(g.*herm(:,k)+sqrt(-1)*(-1).^k.*dk*frac(2,sqrt(pi)));
    toc
    err=vsum(abs(psi1(:,k)-psi2(:,k)).^2,1)./vsum(abs(psi1(:,k)).^2,1);
    reporttest(['MORSEWAVE for GAMMA=2 derivatives matches Dawson expression for n=' int2str(k)],err<1e-3)
end


function[]=morsewave_test_admiss
ga1=[1:1:11];
be1=[1:1:10];
[ga,be]=meshgrid(ga1,be1);
vcolon(ga,be);

N=1000;
psi2om=zeros(N,length(ga));
dt=1/10;
om=[0:N-1]'./N;om(1)=1e-4;
for i=1:length(ga)
    [psii,psifi]=morsewave(dt,N,1,ga(i),be(i),morsefreq(ga(i),be(i)),'bandpass');
    psi2om(:,i)=(psifi.*dt).^2./om;
end
cpsi1=vsum(psi2om,1).*(1/N);
cpsi1=reshape(cpsi1,length(be1),length(ga1));
cpsi2=morsea(ga,be).^2.*frac(1,ga.*2.^(2*be./ga)).*gamma(frac(2*be,ga));
cpsi2=reshape(cpsi2,length(be1),length(ga1));
        
[p,dt,dom]=morsebox(ga,be);

reporttest('MORSEWAVE admissibility matches analytic expression',aresame(cpsi1,cpsi2,1e-2));
%ga1=[0.1:0.1:11];
%be1=[0.1:0.1:10];
%[ga,be]=meshgrid(ga1,be1);
%cpsi=morsea(ga,be).^2.*frac(1,ga.*2.^(2*be./ga)).*gamma(frac(2*be,ga));


function[]=morsewave_fig

N=256*4;

be=5;
ga=2;
K=3;
fs=1/8/4;

[x,X]=morsewave(N,K,ga,be,fs,'energy');
%[fmin,fmax,fc,fw] = morsefreq(1/10000,ga,be);
%fc=fc./ao;

f=[0:1:N-1]'./N;

figure
t=[1:length(x)]'-length(x)/2;
ax=[-60 60 -maxmax(abs(x))*1.05 maxmax(abs(x))*1.05];
subplot 321
  uvplot(t,x(:,1));axis(ax)
  title('Morse wavelets, time domain')
subplot 323
  uvplot(t,x(:,2));axis(ax)
subplot 325
  uvplot(t,x(:,3));axis(ax)

ax=[0 120./N -maxmax(abs(X))*1.05 maxmax(abs(X))*1.05];
subplot 322
  plot(f,abs(X(:,1))),axis(ax),vlines(fs);
title('Morse wavelets, frequency domain')
subplot 324
  plot(f,abs(X(:,2))),axis(ax),vlines(fs);
subplot 326
  plot(f,abs(X(:,3))),axis(ax),vlines(fs);
  
  

function[]=morsewave_figure2
fs=0.05;N=1000;

[x,X]=morsewave(N,3,3,4,fs,'energy','first');
[y,Y]=morsewave(N,3,3,4,fs,'energy','second');

subplot(121),plot([1:length(X)]/N,X), xlim([0 .15]),vlines(fs,'k:'),hlines(0,'k:')
title('First Family | \gamma=3, \beta=4')
subplot(122),plot([1:length(X)]/N,Y), xlim([0 .15]),vlines(fs,'k:'),hlines(0,'k:')
title('Second Family | \gamma=3, \beta=4')

packcols(1,2);

if 0
    cd_figures
    orient landscape
    fontsize 14 14 14 14
    print -depsc morsefamilies.eps
end

