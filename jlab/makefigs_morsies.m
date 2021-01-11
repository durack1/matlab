function[varargout]=makefigs_morsies(str)
%MAKEFIGS_MORSIES  Makes figures for Lilly and Olhede (2008b).
%
%   MAKEFIGS_MORSIES Makes all figures for 
%
%                       Lilly & Olhede (2008b)
%            "On the design of optimal analytic wavelets"
%         Submitted to IEEE Transactions on Signal Processing
%
%   Type 'makefigs_morsies' at the matlab prompt to make all figures for
%   this and print them as .eps files into the current directory.
%  
%   Type 'makefigs_morsies noprint' to supress printing to .eps files.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
if nargin==0
  str='print';
end


%/************************************************************

if 0
%\************************************************************
N=20;
ga1=[0.25 0.5 1:1:9];
be1=[0.5 1:1:10];
[ga,be]=meshgrid(ga1,be1);
p=morseprops(ga,be);
p=vswap(p,0,nan);
dcell=morsederiv(N,ga,be);
x=zeros([size(ga) N]);
y=zeros([size(ga) N]);
for n=1:length(dcell);
   x(:,:,n)=dcell{n}./((p.^2).^(n/2))./factorial(n);
   if iseven(n)
       fact=n/2;
   else
       fact=(n-1)/2;
   end
   y(:,:,n)=dcell{n}./((p.^2).^fact)./factorial(n);
end

[ymax,kmax]=max(abs(y),[],3);

figure
contourf(ga1,be1,ymax,[0:.05:1]),colorbar
hold on
plot(ga(kmax==2),be(kmax==2),'ro')
plot(ga(kmax==3),be(kmax==3),'ko')
xlabel('Gamma Parameter')
ylabel('Beta Parameter')
title('Verification of bounded derivative growth; see notes in display.')

disp('This figure does not appear in the paper, but verifies a statement')
disp('regading the growth of wavelet derivatives.  The plot shows the left-')
disp('hand side of Lilly and Olhede eqn (24) divided by the right-hand side')
disp('for the choice P=sqrt(1/delta).  The maximum of this quantity for any')
disp('derivative number n up to n=20, and is shown to be less than one.')
disp('The maximum occurs at either n=2 (red circles) or n=3 (black circles).')

x1=reshape(x,size(x,1)*size(x,2),size(x,3))';
y1=reshape(y,size(y,1)*size(y,2),size(y,3))';
index=find(ga(:)==11);x1(:,index)=nan;
bool1=(be(:)<(ga(:)-1)/2&ga(:)>1);
bool2=(be(:)>(ga(:)-1)/2&ga(:)>1);
bool3=(ga(:)<=1);

figure,plot(1:N,abs(y1(:,bool2)),'ko')
hold on,plot(1:N,abs(y1(:,bool1)),'k*')
%hold on,plot(1:N,abs(y1(:,bool3)),'k+')  %Note ga<1 have huge derivatives at large order

%hold on,plot(1:10,abs(x1(:,bool3)),'k--')
xlim([2 20]),ylim([0 0.55])
title('Generalized Morse Wavelet Derivative Decay; see notes in display')
xlabel('Derivative number')
ylabel('Normalized magnitude')

disp('This figure does not appear in the paper, but verifies a statement')
disp('regading the growth of wavelet derivatives.  The plot shows the left-')
disp('hand side of Lilly and Olhede eqn (24) divided by the right-hand side')
disp('for the choice P=sqrt(1/delta).  A variety of values of beta>1, gamma>1')
disp('are shown.  The quantity decays rapidly with increasing derivative order.')

%\*****************************************
end


%/************************************************************
figure

N=512*2*4;
fs=1/8/4/2;
t=1:N;t=t-mean(t);t=t.*fs;
clear psi psif 
P=zeros(4,4);
for i=1:4
    for j=0:3
        P(i,j+1)=sqrt(i*j);
        [psi(:,i,j+1) psif(:,i,j+1)]=morsewave(N,1,i,j,fs,'bandpass');
        %morsexpand(t,i,j,fs);
    end
end
psi=reshape(psi,size(psi,1),16);
psif=reshape(psif,size(psif,1),16);
P=P(:);
P(1:4)=P(5:8);
for i=1:16
    subplot(4,4,i)
    plot(t./P(i),[real(psi(:,i)) imag(psi(:,i)) abs(psi(:,i))]./max(abs(psi(:,i)))),xlim([-1.5 1.5]),box on
    linestyle k k-- 1.5k
    hlines(0,'k:')
    set(gca,'xtick',[]), set(gca,'ytick',[])
    set(gca,'xcolor','w')
    set(gca,'ycolor','w')
    xlim([-1.5 1.5]/2)
end
subplot(4,4,1),title('Cauchy Family (\gamma=1)')
subplot(4,4,2),title('Gaussian Family (\gamma=2)')
subplot(4,4,3),title('Airy Family (\gamma=3)')
subplot(4,4,4),title('Hypergaussian Family (\gamma=4)')
subplot(4,4,1),text(-1.4,.8,'\beta=0')
subplot(4,4,5),text(-1.4,.8,'\beta=1')
subplot(4,4,9),text(-1.4,.8,'\beta=2')
subplot(4,4,13),text(-1.4,.8,'\beta=3')


packboth(4,4)

fontsize 14 12 12 12
orient landscape
set(gcf,'paperposition',[1 1 10 7])

if strcmp(str,'print')
    print -deps morsie_families.eps
end
%\*********************************************************


%/********************************************************************

%The code for this figure is embedded within MORSEFREQ
morsefreq --f2
orient tall
set(gcf,'paperposition',[0.25 1 7 7])
letterlabels(2)

fontsize 12 12 12 12
if strcmp(str,'print')
    print -deps morsie_frequencies.eps
end


%The code for this figure is embedded within WIGDIST
wigdist --f1
set(gcf,'paperposition',[0.25 1 7 5])
fontsize 12 10 10 10
if strcmp(str,'print')
    print -deps morsie_morlet_wigdist.eps
end

%The code for this figure is embedded within WIGDIST
wigdist --f2
orient landscape
set(gcf,'paperposition',[1 1 10 6])
fontsize 12 10 8 10
if strcmp(str,'print')
    print -deps morsie_wigdist_three.eps
end
%/*****************************************

%/*****************************************
%The code for this figure is embedded within MORSEBOX
morsebox --f

orient portrait
set(gcf,'paperposition',[2 2 4 3.4])
fontsize 14 12 12 12 
if strcmp(str,'print')
    print -depsc morsie_schematic.eps
end
%\*****************************************


