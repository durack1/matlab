function[f,p]=mtfspec(x,N,ii,jj)
%MTFSPEC  Multitaper time-frequency spectrum.
%
%   [F,P]=MTFSPEC(X,K) returns the multitaper time-frequency spectrum P
%   using the baseband demodulate estimate of [XX], using K tapers, which is
%   evaluated at frequencies F.
%
%   F is N x 1 and P is N x N, where N is the length of X.
%
%   P=MTFSPEC(X,K,II,JJ) decimates P at an intermediate step in the algorithm.  
%   II is an index into time locations, and JJ is an index into frequencies.  
% 
%   In this case, F is LENGTH(JJ) x 1 and P will be LENGTH(II) x LENGTH(JJ).
%  
%   See also MSPEC.
%
%   'mtfspec --f' generates a sample figure.
%
%   Usage: [f,p]=mtfspec(x,n);
%          [f,p]=mtfspec(x,n,ii,jj);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(x, '--f')
    mtfspec_figure,return
end
 
deltat=1;
f=(1./deltat).*[0:1/size(x,1)/2:1/2-1./size(x,1)/2]';
%length(f)

[psi,lambda]=sleptap(size(x,1),N);
w=mtrans(x,psi); 

%size(w)
psi=psi(ii,:);
w=w(jj,:);
f=f(jj);
p=0;
for j=1:size(psi,2)
    p=p+oprod(psi(:,j),conj(w(:,j)));
end

function[]=mtfspec_figure
load bravo94

yearf=bravo.rcm.yearf;
x=real(bravo.rcm.cv(:,2));
ii=1:10:length(x);jj=1:1000;

[f,p]=mtfspec(x,8,ii,jj);
figure,
subplot(211),plot(yearf,vfilt(x,24)),axis tight
title('Time-frequency spectrum of Bravo mooring') 
subplot(212),pcolor(yearf(ii),f,log(abs(p))'),shading interp
packrows(2,1),caxis([-5 3])


%reporttest('MTFSPEC',aresame())
