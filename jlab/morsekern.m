function[J]=morsekern(K,ga,be,dt,s1,s2)
%MORSEKERN
%
%   MORSEKERN(K,GAMMA,BETA,DT,S1,S2)
%
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(K, '--t')
    morsekern_test,return
end
 

if  issing(ga)&&issing(be)
    [ga,be]=meshgrid(ga,be);
end

vsize(ga,be)
[om,a,b,c]=morsecoeff(ga,be);

[om2,a2,b2,c2]=morsecoeff(ga,2.*be);

const=frac(1,c.*(a2.^2));

%gamma-power mean frequency
sm=(s1.^ga+s2.^ga).^frac(1,ga);

sfact=frac(s1.*s2,sm.^2).^frac(be+1,2);
psi=morsetime(K,ga,2*be,sm,dt);

J=const.*sfact.*psi;

function[]=morsekern_test
 
%reporttest('MORSEKERN',aresame())
