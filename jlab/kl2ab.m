function[A,B]=kl2ab(K,L)
%KL2AB  Converts ellipse parameters Kappa and Lambda to A and B.
%
%   [A,B]=KL2AB(K,L) converts ellipse amplitude K and ellipse 
%   parameter L to semi-major and semi-minor axes A and B.
%
%   A and B are related to K and L by
%
%         A = SIGN(L) * K * SQRT(1 + ABS(L))
%         B = SIGN(L) * K * SQRT(1 - ABS(L))
%
%   as discussed in Lilly and Gascard (2006).  
%
%   Usage: [a,b]=kl2ab(kappa,lambda)
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(K, '--t')
    kl2ab_test,return
end

A=K.*sqrt(1+abs(L));
B=sign(L).*K.*sqrt(1-abs(L));

function[]=kl2ab_test

x=rand(100,1)*2-1;
%x(end+1,1)=1;  %Add an exact one
%x(end+1,1)=0;  %Add an exact zero

[a,b]=kl2ab(1,x);
[k,l]=ab2kl(a,b);

tol=1e-6;
reporttest('KL2AB and AB2KL invert each other',aresame(l,x,tol))
