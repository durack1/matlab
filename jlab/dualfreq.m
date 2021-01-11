function[z]=dualfreq(x,psi,N1,N2)
%DUALFREQ
%
%   DUALFREQ
%
%   'dualfreq --t' runs a test.
%
%   Usage: []=dualfreq();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(x, '--t')
    dualfreq_test,return
end
 
z0=mtrans(x,psi);
if nargin==2
    N1=1;
    N2=1;
elseif nargin==3
    N2=1;
end

z1=z0(1:N1:end,:);
z2=z0(1:N2:end,:);
clear z0
K=size(psi,2);
z=zeros(size(z1,1),size(z2,1));
for i=1:K
    z=z+frac(1,K)*oprod(z1(:,i),conj(z2(:,i)));
end
s1=zeros(size(z1,1),1);
s2=zeros(size(z2,1),1);
for i=1:K
    s1=s1+frac(1,K).*abs(z1(:,i)).^2;
    s2=s2+frac(1,K).*abs(z2(:,i)).^2;
end
%size(s1),size(s2),size(z)
z=z./sqrt(vrep(s1,size(z,2),2).*vrep(s2',size(z,1),1));
%z=z./sqrt(vrep(s1,size(z,2),2));

function[]=dualfreq_test
 
%reporttest('DUALFREQ',aresame())
