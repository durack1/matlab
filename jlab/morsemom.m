function[m,n]=morsemom(p,ga,be)
%MORSEMOM  Frequency-domain moments of generalized Morse wavelets.
%
%   [MP,NP]=MORSEMOM(P,GAMMA,BETA) computes the Pth order frequency-
%   domain moment M and energy moment N of the lower-order generalized 
%   Morse wavelet specified by parameters GAMMA and BETA.
%
%   The Pth moment and energy moment are defined as
%
%           mp = 1/(2 pi) int omega^p  psi(omega)     d omega 
%           np = 1/(2 pi) int omega^p |psi(omega)|.^2 d omega 
%
%   respectively, where omega is the radian frequency.  These are 
%   evaluated using the normalization that max(abs(psi(omega)))=2.
%
%   See Lilly and Olhede (2008b) for details.
%
%   The input parameters must either be matrices of the same size, or
%   some may be matrices and the others scalars.    
%
%   See also MORSEWAVE and MORSEDERIV.
%
%   'morsemom --t' runs some tests.
%
%   Usage:  [mp,np]=morsemom(p,ga,be);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details

if strcmp(p, '--t')
    morsemom_test,return
end


m=morsemom1(p,ga,be);

if nargout>1
    n=frac(morsea(ga,be).^2,morsea(ga,2*be)).*frac(1,2.^(frac(2*be+1+p,ga))).*morsemom1(p,ga,2*be);
    n=frac(2,2.^(frac(1+p,ga))).*morsemom1(p,ga,2*be);
end


function[m]=morsemom1(p,ga,be)
m=morsea(ga,be).*morsef(ga,be+p);

function[f]=morsef(ga,be)
%MORSEF  Returns the generalized Morse wavelet first moment "f".
%
%   F=MORSEF(GAMMA,BETA) returns the normalized first frequency-
%   domain moment "F_{BETA,GAMMA}" of the lower-order generalized 
%   Morse wavelet specified by parameters GAMMA and BETA.
%
%   See Lilly (2007) for details.

f=frac(1,2*pi*ga).*gamma(frac(be+1,ga));

function[]=morsemom_test
morsemom_test_expression;
morsemom_test_numerical;

function[]=morsemom_test_expression
ga=[2:.1:10];
be=[1:.1:10];
[ga,be]=meshgrid(ga,be);

clear bool
for p=1:10
    [mp,np]=morsemom(p,ga,be);
    mp2=2*frac(exp(1)*ga,be).^(be./ga).*frac(1,2*pi*ga).*gamma(frac(be+1+p,ga));
    bool(p)=aresame(mp,mp2,1e-10);
end

reporttest('MORSEMOM analytic expression',all(bool))

function[]=morsemom_test_numerical

ga1=[2:2:12];
be1=[1:2:10];

%n=0;
omi=[0:.01:20]';
dom=omi(2)-omi(1);
                
[m1c,n1c,m2c,n2c]=vzeros(length(ga1),length(be1));
clear m1c n1c m2c n2c
for i=1:length(ga1)
    for j=1:length(be1)
        ompsi=morsefreq(ga1(i),be1(j));
        
        psi=morsea(ga1(i),be1(j)).*(omi.*ompsi).^be1(j).*exp(-(omi.*ompsi).^ga1(i));
        %n=n+1;
        %psiall(:,n)=psi;
        
        m1c(j,i)=frac(dom,2*pi).*ompsi.^2.*vsum(omi.*psi,1);
        n1c(j,i)=frac(dom,2*pi).*ompsi.^2.*vsum(omi.*psi.^2,1);
        m2c(j,i)=frac(dom,2*pi).*ompsi.^3.*vsum(omi.^2.*psi,1);
        n2c(j,i)=frac(dom,2*pi).*ompsi.^3.*vsum(omi.^2.*psi.^2,1);
    end
end

[ga,be]=meshgrid(ga1,be1);
[m1,n1]=morsemom(1,ga,be);
[m2,n2]=morsemom(2,ga,be);

tol=2*10.^(-2);
bool=aresame(m1,m1c,tol)&&aresame(n1,n1c,tol)&&aresame(m2,m2c,tol)&&aresame(n2,n2c,tol);

reporttest('MORSEMOM numerical calculation',all(bool))



