function[wu,wv]=traintrans(u,v,beta,f,str)
%TRAINTRANS
%
%   TRAINTRANS
%
%   'traintrans --t' runs a test.
%
%   Usage: []=traintrans();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(u, '--t')
    traintrans_test,return
end
 

cbeta=trainconst(beta);
wu=cbeta*wavetrans(u,{1,2,beta,f,'ban'},str);
%s=om./(2*pi*fs)
s=frac(morsefreq(2,beta),2*pi*f);
s=s(:)';
s=vrep(s,length(v),1);
wv=-sqrt(-1)*cbeta*frac(morsea(2,beta),morsea(2,beta-1)).*s.*wavetrans(v,{1,2,beta-1,f,'ban'},str);

function[]=traintrans_test
 

Do=[-20:2:20]';
Ro=10+zeros(size(Do));
Uo=50;
Vo=25+zeros(size(Do));
to=[200:400:8500]';
t=[1:9000]';
[u,v]=eddytrain(t,Uo,to,Ro,Vo,Do);

fs=1./(logspace(log10(10),log10(100),50)');

%[psi,psif]=morsewave(length(u),1,2,2,fs);

[wu,wv]=traintrans(u,v,2,fs,'zeros');

%reporttest('TRAINTRANS',aresame())
