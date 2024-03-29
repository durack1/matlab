function[d,f]=wigdist(x,nmin,nmax,N2,s)
% WIGDIST  Wigner distribtion (alias-free algorithm).
%
%   D=WIGDIST(X,NMIN,NMAX) returns the Wigner distrution of column
%   vector X at Fourier frequencies [NMIN/N:1/N:NMAX/N] where N equals
%   LENGTH(X). D is a matrix of dimension LENGTH(X) x [NMAX-NMIN+1].  
%   
%   Note that negative frequencies are permitted.
%  
%   D=WIGDIST(X,NMIN,NMAX,M) first zero-pads the data to length M,
%   where M>LENGTH(X). The Wigner distrution is then computed at
%   frequencies [NMIN/M:1/M:NMAX/M].  This is to give higher frequency
%   resolution.  
%
%   WIGDIST uses the alias-free Wigner distribution algorithm given in
%   Matllat (1999), second edition, section 4.5.4.
%
%   The Wigner distribution is computed using a fast alogorithm that is
%   an order of magnitude faster than the obvious algorithm.  The
%   difference between the two is at the level of numerical noise.  To
%   force use of the slow algorithm, use WIGDIST(X,NMIN,NMAX,M,1).
%
%   'wigdist --t' runs a test using the two different algorithms.
%   'wigdist --f' generates some sample figures.
%
%   Usage:  [d,f]=wigdist(x,nmin,nmax);
%           [d,f]=wigdist(x,nmin,nmax,m);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details        
 
if strcmp(x,'--t')
   wigdist_test;return
elseif strcmp(x,'--f')
   wigdist_figures;return
elseif strcmp(x,'--f1')
   wigdist_figure1;return
elseif strcmp(x,'--f2')
   wigdist_figure2;return
elseif strcmp(x,'--f3')
   wigdist_figure3;return
end
   
  
x=x(:);

N=length(x);
if isodd(N)
   error('The length M of X must be even.')
end

%/********************************************************
%Zero-pad to increase frequency resolution
if nargin==4
  if isodd(N2)
    error('The new length M must be even.')
  end
   x=[zeros(N2/2-N/2,1);x;zeros(N2/2-N/2,1)];
end
%\********************************************************

N=length(x);

%Frequency vector
k=[nmin:nmax]';
f=k./N;

if nargin<5
  s=2;  %Default to fast Fourier algorithm
end

if s==1
  %Use slow but obvious algorithm
  d=wigdist_version1(x,k);
elseif s==2
  %Use fast fourier-based algorithm (default)
  d=wigdist_version2(x,k);
end

%END wigdist body

tol=1e-12;
if maxmax(abs(imag(d))<tol)
  d=real(d);
end

%/********************************************************
function[d]=wigdist_version1(x,k)
%disp('Computing Wigner distribtution, summation algorithm');
N=length(x);
M=length(k);

f=doublen(x);

%Time index
n=[0:N-1]';
freqs=k./N;

%Dummy index of summation
p=[0:2*N-1]';
p=permute(p,[3 2 1]);

%Make 3-D n index varying along columns
nmat=ndrep(M,n,2);
nmat=ndrep(2*N,nmat,3);

%Make 3-D k index varying along rows
kmat1=ndrep(N,k',1);
kmat1=ndrep(2*N,kmat1,3);

%Make 3-D p index varying along pages
pmat1=ndrep(N,p,1);
pmat1=ndrep(M,pmat1,2);

%Plus one corrects for index change
index1=2*nmat+pmat1-N+1;
index2=2*nmat-pmat1+N+1;

%Locate points in range
bool=(index1>0)&(index1<2*N+1)&(index2>0)&(index2<2*N+1);
index=find(bool);

f1=f(index1(index));
f2=f(index2(index));
kk=kmat1(index);
pp=pmat1(index);

%Map in range values into gmat
phi=-frac(2.*pi.*(2.*kk).*pp,2.*N);
gmat=zeros(N,M,2*N);
gmat(index)=f1.*conj(f2).*rot(phi);

%Sum over third dimension 
d=sum(gmat,3);
%END version 1
%\********************************************************


%/********************************************************
function[d]=wigdist_version2(x,k)
%disp('Computing Wigner distribtution, Fourier algorithm');

N=length(x);
M=length(k);

indexneg=find(k<0);
if ~isempty(indexneg)
    k(indexneg)=N+k(indexneg);
end

f=doublen(x);

%Time index
n=[0:N-1];

%Dummy index of summation
p=[0:2*N-1]';

%Make 2-D n index varying along rows
nmat=ndrep(2*N,n,1);

%Make 2-D p index varying along columns
pmat1=ndrep(N,p,2);

%Plus one corrects for index change
index1=2*nmat+pmat1-N+1;
index2=2*nmat-pmat1+N+1;

%Locate points in range
bool=(index1>0)&(index1<2*N+1)&(index2>0)&(index2<2*N+1);
index=find(bool);

f1=f(index1(index));
f2=f(index2(index));

%Map in range values into gmat
gmat=zeros(2*N,N);
gmat(index)=f1.*conj(f2);

%Now fft, decimate, transpose
d=fft(gmat);
d=d(2*k+1,:);  %not 2k because fft computes at deltaf=1/(2*T)
d=conj(d)';
%END version 2
%\********************************************************



function[]=wigdist_test

[x,lambda,f]=slepwave(2,2.5,1,1,.05,.05); 

tic
[d1,f]=wigdist(x(:,1),0,20,3*length(x),1);
t1=toc;

tic
[d2,f]=wigdist(x(:,1),0,20,3*length(x),2);
t2=toc;

t=1:size(d1,1);t=t-mean(t);
tol=1e-10;
b=aresame(d1,d2,tol);
reporttest('WIGDIST two different algorithms match, positive frequencies only',b);
disp(['WIGDIST fast algorithm was ' num2str(t1./t2) ' times faster than slow alogirthm'])

[d1,f1]=wigdist(x(:,1),-5,5,3*length(x),1);
[d2,f2]=wigdist(x(:,1),-5,5,3*length(x),2);

t=1:size(d1,1);t=t-mean(t);
tol=1e-10;
b=aresame(d1,d2,tol)&&aresame(f1,f2);
reporttest('WIGDIST two different algorithms match, positive and negative frequencies',b);


function[]=wigdist_figures
wigdist_figure1;
wigdist_figure2;

function[]=wigdist_figure1

N=1000;
fs=0.01;
m=0.5;
w1=morlwave(N,fs,m);
%be=morsebeta(3,m);
w2=morsewave(N,1,3,1.38,fs,'energy');
om1=vdiff(unwrap(imag(log(w1))));
om2=vdiff(unwrap(imag(log(w2))));

[t,f]=morseregion(10,3,1.38);
fm=morsefreq(3,1.38)./fs;
t=t.*fm;
f=f./fm*1000;

[d1,f1]=wigdist(w1,-10,25);
[d2,f2]=wigdist(w2,-10,25);
d1=d1./maxmax(d1);
d2=d2./maxmax(d2);

t=1:size(d1,1);t=t-mean(t);

ci=logspace(-2,0,10);

figure

subplot(221)
plot(t,[real(w1) imag(w1) abs(w1)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
xlabel('Time')
title('Morlet with f_o=0.01 and m=0.5')
xlim([-90 90]),ylim([-.15 .15])
xtick([-80:20:80])
fixlabels([0 -2])

subplot(222)
plot(t,[real(w2) imag(w2) abs(w2)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
xlabel('Time')
title('Morse with f_o=0.01, \gamma=3, and \beta=1.38')
xlim([-90 90]),ylim([-.15 .15])
xtick([-80:20:80])


subplot(223)
contourf(t,1000*f1,abs(d1'),ci),hold on
hlines(0,'k:')
ylabel('Cyclic Frequency x 10^3')
xlabel('Time')
xlim([-90 90])
xtick([-80:20:80])
plot(t,1000*om1/2/pi,'w','linewidth',3)
plot(t,1000*om1/2/pi,'k--','linewidth',1.5)
colormap gray,flipmap,

subplot(224)
contourf(t,1000*f1,abs(d2'),ci),hold on
hlines(0,'k:')
xlabel('Time')
xlim([-90 90])
xtick([-80:20:80])
plot(t,1000*om2/2/pi,'w','linewidth',3)
plot(t,1000*om2/2/pi,'k--','linewidth',1.5)
colormap gray,flipmap,

letterlabels(1)
packboth(2,2)


function[]=wigdist_figure2

N=1000;
fs=0.01;
w1=morsewave(N,1,2,6,fs,'energy');
w2=morsewave(N,1,3,2*6./3,fs,'energy');
w3=morsewave(N,1,4,3,fs,'energy');

[d1,f1]=wigdist(w1,3,20);
[d2,f2]=wigdist(w2,3,20);
[d3,f3]=wigdist(w3,3,20);
d1=d1./maxmax(d1);
d2=d2./maxmax(d2);
d3=d3./maxmax(d3);
om1=vdiff(unwrap(imag(log(w1))));
om2=vdiff(unwrap(imag(log(w2))));
om3=vdiff(unwrap(imag(log(w3))));

t=1:size(d1,1);t=t-mean(t);
ci=logspace(-2,0,10);

figure
subplot(231)
plot(t,[real(w1) imag(w1) abs(w1)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Morse with \gamma=2 and \beta=6')
ylim([-.13 .13]),xlim([-190 190]),fixlabels([0 -2])
xtick([-200:40:200])

subplot(232)
plot(t,[real(w2) imag(w2) abs(w2)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Morse with \gamma=3 and \beta=4')
ylim([-.13 .13]),xlim([-190 190])
xtick([-150:50:150])

subplot(233)
plot(t,[real(w3) imag(w3) abs(w3)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Morse with \gamma=4 and \beta=3')
ylim([-.13 .13]),xlim([-190 190])
xtick([-150:50:150])

subplot(234)
contourf(t,1000*f1,abs(d1'),ci),hold on
hlines(0,'k:')
ylabel('Cyclic Frequency x 10^3')
ylim([0 19])
xlim([-190 190])
xtick([-150:50:150])
plot(t,1000*om1/2/pi,'w','linewidth',3)
plot(t,1000*om1/2/pi,'k--','linewidth',1.5)
colormap gray,flipmap,
xlabel('Time')

subplot(235)
contourf(t,1000*f2,abs(d2'),ci),hold on
hlines(0,'k:')
ylim([0 19])
xlim([-190 190])
xtick([-150:50:150])
plot(t,1000*om2/2/pi,'w','linewidth',3)
plot(t,1000*om2/2/pi,'k--','linewidth',1.5)
xlabel('Time')

subplot(236)
contourf(t,1000*f3,abs(d3'),ci),hold on
hlines(0,'k:')
ylim([0 19])
xlim([-190 190])
xtick([-150:50:150])
plot(t,1000*om3/2/pi,'w','linewidth',3)
plot(t,1000*om3/2/pi,'k--','linewidth',1.5)
xlabel('Time')

letterlabels(1)
packboth(2,3)

function[]=wigdist_figure3

N=1000;
fs=0.01;
w=morsewave(N,3,2,1,fs,'energy');
w1=w(:,1);
w2=w(:,2);
w3=w(:,3);
w(:,4)=morsewave(N,1,2,3,fs,'energy');
w4=w(:,4);


[d1,f1]=wigdist(w1,0,40);
[d2,f2]=wigdist(w2,0,40);
[d3,f3]=wigdist(w3,0,40);
[d4,f4]=wigdist(w4,0,40);

contourf((d1+d2+d2)',20),axis([400 600 0 40])
%d1=d1./maxmax(d1);
%d2=d2./maxmax(d2);
%d3=d3./maxmax(d3);
om1=vdiff(unwrap(imag(log(w1))));
om2=vdiff(unwrap(imag(log(w2))));
om3=vdiff(unwrap(imag(log(w3))));

t=1:size(d1,1);t=t-mean(t);
ci=logspace(-1,0,10);

figure
subplot(231)
plot(t,[real(w1) imag(w1) abs(w1)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Morse with \gamma=2, \beta=1, k=0')
ylim([-.17 .17]),xlim([-100 100]),fixlabels([0 -2])
xtick([-200:40:200])

subplot(232)
plot(t,[real(w2) imag(w2) abs(w2)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Morse with \gamma=2, \beta=1, k=1')
ylim([-.17 .17]),xlim([-100 100])
xtick([-150:50:150])

subplot(233)
plot(t,[real(w3) imag(w3) abs(w3)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Morse with \gamma=2, \beta=1, k=2')
ylim([-.17 .17]),xlim([-100 100])
xtick([-150:50:150])

subplot(234)
contourf(t,1000*f1,abs(d1'),ci),hold on
hlines(0,'k:')
ylabel('Cyclic Frequency x 10^3')
ylim([0 45]),xlim([-100 100])
xtick([-150:50:150])
plot(t,1000*om1/2/pi,'w','linewidth',3)
plot(t,1000*om1/2/pi,'k--','linewidth',1.5)
colormap gray,flipmap,
xlabel('Time')

subplot(235)
contourf(t,1000*f2,abs(d2'),ci),hold on
hlines(0,'k:')
ylim([0 45]),xlim([-100 100])
xtick([-150:50:150])
plot(t,1000*om2/2/pi,'w','linewidth',3)
plot(t,1000*om2/2/pi,'k--','linewidth',1.5)
xlabel('Time')

subplot(236)
contourf(t,1000*f3,abs(d3'),ci),hold on
hlines(0,'k:')
ylim([0 45]),xlim([-100 100])
xtick([-150:50:150])
plot(t,1000*om3/2/pi,'w','linewidth',3)
plot(t,1000*om3/2/pi,'k--','linewidth',1.5)
xlabel('Time')

letterlabels(1)
packboth(2,3)


function[]=wigdist_figure4

N=1000;
fs=0.02;%*5;

[x,X]=morsewave(N,3,3,4,fs,'energy','first');

w1=x(:,1);
w2=x(:,2);
w3=x(:,3);

[d1,f1]=wigdist(w1,0,40);
[d2,f2]=wigdist(w2,0,40);
[d3,f3]=wigdist(w3,0,40);

t=1:size(d1,1);t=t-mean(t);

ci=logspace(-2,0,10);

xax=[-235 235]/2;
xticks=[-200:100:200]/2;
figure

subplot(231)
plot(t,[real(w1) imag(w1) abs(w1)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('First Family | \gamma=3, \beta=4, k=0')
ylim([-.15 .15]),xlim(xax),fixlabels([0 -2]),xtick(xticks)

subplot(232)
plot(t,[real(w2) imag(w2) abs(w2)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('First Family | \gamma=3, \beta=4, k=1')
ylim([-.15 .15]),xlim(xax),xtick(xticks)

subplot(233)
plot(t,[real(w3) imag(w3) abs(w3)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('First Family | \gamma=3, \beta=4, k=2')
ylim([-.15 .15]),xlim(xax),xtick(xticks)

subplot(234)
contourf(t,1000*f1,abs(d1')./maxmax(d1),ci),hold on
hlines(0,'k:')
ylabel('Cyclic Frequency x 10^3')
ylim([0 40]),xlim(xax),xtick(xticks)
colormap gray,flipmap,
xlabel('Time')
hlines(fs*1000,'w'),vlines(0,'w')
hlines(fs*1000,'k:'),vlines(0,'k:')

subplot(235)
contourf(t,1000*f2,abs(d2')./maxmax(d2),ci),hold on
hlines(0,'k:')
ylim([0 40]),xlim(xax),xtick(xticks)
xlabel('Time')
hlines(fs*1000,'w'),vlines(0,'w')
hlines(fs*1000,'k:'),vlines(0,'k:')

subplot(236)
contourf(t,1000*f3,abs(d3')./maxmax(d3),ci),hold on
hlines(0,'k:')
ylim([0 40]),xlim(xax),xtick(xticks)
xlabel('Time')
hlines(fs*1000,'w'),vlines(0,'w')
hlines(fs*1000,'k:'),vlines(0,'k:')

letterlabels(1)
packboth(2,3)

if 0
    cd_figures
    orient landscape
    fontsize 14 14 14 14
    print -deps firstfamily.eps
end


function[]=wigdist_figure5

N=1000;
fs=0.02;

[x,X]=morsewave(N,3,3,4,fs,'energy','second');

w1=x(:,1);
w2=x(:,2);
w3=x(:,3);

[d1,f1]=wigdist(w1,0,40);
[d2,f2]=wigdist(w2,0,40);
[d3,f3]=wigdist(w3,0,40);

t=1:size(d1,1);t=t-mean(t);

ci=logspace(-2,0,10);

xax=[-235 235]/2;
xticks=[-200:100:200]/2;
figure

subplot(231)
plot(t,[real(w1) imag(w1) abs(w1)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Second Family | \gamma=3, \beta=4, k=0')
ylim([-.15 .15]),xlim(xax),fixlabels([0 -2]),xtick(xticks)

subplot(232)
plot(t,[real(w2) imag(w2) abs(w2)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Second Family | \gamma=3, \beta=4, k=1')
ylim([-.15 .15]),xlim(xax),xtick(xticks)

subplot(233)
plot(t,[real(w3) imag(w3) abs(w3)])
linestyle k- k-- 2k
hlines(0,'k:')
ylabel('Amplitude')
title('Second Family | \gamma=3, \beta=4, k=2')
ylim([-.15 .15]),xlim(xax),xtick(xticks)


subplot(234)
contourf(t,1000*f1,abs(d1')./maxmax(d1),ci),hold on
hlines(0,'k:')
ylabel('Cyclic Frequency x 10^3')
ylim([0 40]),xlim(xax),xtick(xticks)
colormap gray,flipmap,
xlabel('Time')
hlines(fs*1000,'w'),vlines(0,'w')
hlines(fs*1000,'k:'),vlines(0,'k:')

subplot(235)
contourf(t,1000*f2,abs(d2')./maxmax(d2),ci),hold on
hlines(0,'k:')
ylim([0 40]),xlim(xax),xtick(xticks)
xlabel('Time')
hlines(fs*1000,'w'),vlines(0,'w')
hlines(fs*1000,'k:'),vlines(0,'k:')

subplot(236)
contourf(t,1000*f3,abs(d3')./maxmax(d3),ci),hold on
hlines(0,'k:')
ylim([0 40]),xlim(xax),xtick(xticks)
xlabel('Time')
hlines(fs*1000,'w'),vlines(0,'w')
hlines(fs*1000,'k:'),vlines(0,'k:')

letterlabels(1)
packboth(2,3)

if 0
    cd_figures
    orient landscape
    fontsize 14 14 14 14
    print -deps secondfamily.eps
end
