function[x]=ridgequantity(w,fs,str)
%RIDGEQUANTITY  Returns the quantity to be minimized for ridge analysis.
%
%   X=RIDGEQUANTITY(W,FS,STR) where W is a wavelet transform matrix at
%   *cyclic* frequecies FS, returns the quantity X to be minimized for
%   several different wavelet ridge definitions, specified by STR.
%
%   X is the same size as W.
% 
%   STR may be either of the following:
%
%        'phase'       Rate of transform change of phase definition
%        'amplitude'   Maxima of transfom amplitude definition
%
%   For details, see Lilly and Olhede (2007).
% 
%   See also ISRIDGEPOINT, RIDGEWALK.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 

%        'groove'      Joint amplitude / phase defintion

if strcmp(w, '--f')
    ridgequantity_figure,return
end

if nargin==2
    error('Ridge type must be specified.')
end

f=instfreq(w); 
if ~aresame(size(fs),size(w))
    fsmat=osum(zeros(size(w(:,1))),2*pi*fs(:));
else
    fsmat=2*pi*fs;
end

%dads=-frac(fsmat.^2,2*pi).*frac(vdiff(abs(w),2),vdiff(fsmat,2));
dads=frac(fsmat.^2,2*pi).*frac(vdiff(abs(w),2),vdiff(fsmat,2)).*frac(1,abs(w));

if strcmp(str(1:3),'pha')
    %x=(f-fsmat)./fsmat;
    x=f-fsmat;
elseif strcmp(str(1:3),'amp')
    x=dads;
elseif strcmp(str(1:3),'gro')
    x=(f-fsmat)+sqrt(-1)*dads./fsmat;
end
    


function[]=ridgequantity_figure
 
%reporttest('RIDGEQUANTITY',aresame())

xamp=ridgequantity(w,fs,'amp');
xpha=ridgequantity(w,fs,'pha');
xgro=ridgequantity(w,fs,'gro');
figure,
subplot(311),pcolor(abs(xamp')),shading interp,flipy
subplot(312),pcolor(abs(xpha')),shading interp,flipy
subplot(313),pcolor(abs(xgro')),shading interp,flipy

