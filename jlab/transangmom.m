function[m3,m1,m2]=transangmom(wx,wy,wz)
%TRANSANGMOM  Wavelet transform angular momentum.
%
%   TRANSANGMOM
%
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(wx, '--t')
    transangmom_test,return
end
 
m3=transangmom1(wx,wy);
    
if nargin ==3
    m1=transangmom1(wy,wz);   
    m2=transangmom1(wz,wx);
end

function[m]=transangmom1(wx,wy)

[a,b,theta,phi]=ellconv(wx,wy,'xy2ab');
[a2,b2,theta2,phi2]=elldiff(a,b,theta,phi);
wdiff=ellsig(a2,b2,theta2,phi2);
m=real(sqrt(-1)*(real(wx)+sqrt(-1)*real(wy)).*conj(wdiff));


function[]=transangmom_test
 
%reporttest('TRANSANGMOM',aresame())
