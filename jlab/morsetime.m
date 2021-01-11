function[psi]=morsetime(K,ga,be,s,t)
%MORSETIME  Morse wavelets computed as an explicit function of time.
%
%   MORSETIME(K,GA,BE,S,T)
%
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(K, '--t')
    morsetime_test,return
end

if  issing(ga)||issing(be)
    [ga,be]=meshgrid(ga,be);
end

N=1000;
a=morsea(ga,be);
%omo=

omo=vrep(omo,N,3); 
be=vrep(be,N,3);
ga=vrep(ga,N,3);
s=vrep(s,N,3);
a=vrep(a,N,3);


om=zeros(1,1,N);
om(1:end)=linspace(0,1-1./N,N)';  
om=vrep(om,size(be,1),1);
om=vrep(om,size(be,2),2);
om=om./omo./2;

dom=vdiff(om,3);
Psi=a.*((s.*om).^be).*exp(-(s.*om).^ga);

psi=frac(1,2*pi).*vsum(Psi.*exp(sqrt(-1)*om.*t).*dom,3);



function[]=morsetime_test
 
%reporttest('MORSETIME',aresame())

ga=[2:1:10];
be=[1:1:10];

