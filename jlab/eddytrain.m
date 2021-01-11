function[u,v]=eddytrain(t,Uo,to,Ro,Vo,Do)
%EDDYTRAIN
%
%   EDDYTRAIN(t,Uo,to,Ro,Vo,Do)
%
%   'eddytrain --t' runs a test.
%
%   Usage: [u,v]=eddytrain(t,Uo,to,Ro,Vo,Do);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(t, '--t')
    eddytrain_test,return
end
 


dt=t(2)-t(1);  %in hours

u=Uo+zeros(size(t));
v=zeros(size(t));


t=t*3600;   %convert to seconds
to=to*3600; 
Ro=Ro*1e5;  %convert to centimeters
Do=Do*1e5; 

Lo=Ro./Uo;
for n=1:length(Ro(:))
    expcoeff=exp(-1/2*frac(t-to(n),Lo(n)).^2-1/2.*frac(Do(n),Ro(n)).^2);
    u=u+Vo(n).*frac(Do(n),Ro(n)).*expcoeff;
    v=v-Vo(n).*frac(t-to(n),Lo(n)).*expcoeff;
end

function[]=eddytrain_test

Do=[-20:2:20]';
Ro=10+zeros(size(Do));
Uo=50;
Vo=25+zeros(size(Do));
to=[200:400:8500]';
t=[1:9000]';
[u,v]=eddytrain(t,Uo,to,Ro,Vo,Do);
%reporttest('EDDYTRAIN',aresame())


