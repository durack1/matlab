function[K,L]=ab2kl(A,B)
%AB2KL  Converts A and B to ellipse parameters Kappa and Lambda.
%
%   [K,L]=AB2KL(A,B)  Convert ellipse semi-major and semi-minor
%   axes A and B to ellipse amplitude K and ellipse parameter L.
%
%   K and L are related to A and B by
%
%          K   = SQRT( (A^2 +B^2) / 2 )
%          L   = SIGN(B) * (A^2 - B^2 ) / (A^2 + B^2)
%
%   as discussed in Lilly and Gascard (2006).  
%
%   Usage: [kappa,lambda]=ab2kl(a,b)
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(A, '--t')
    ab2kl_test,return
end


L=sign(B).*frac(A.^2-B.^2,A.^2+B.^2);
K=sqrt(frac(A.^2+B.^2,2));

function[]=ab2kl_test

x=rand(100,1)*2-1;

[a,b]=kl2ab(1,x);
[k,l]=ab2kl(a,b);
l2=ecconv(b./a,'ell2lam');

tol=1e-6;
reporttest('AB2KL matches ECCONV',aresame(l,l2,tol))
