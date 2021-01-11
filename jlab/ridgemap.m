function[wmp,fmp,wmn,fmn,zeta]=ridgemap(struct,str)
% RIDGEMAP  Map wavelet ridge properties onto original time series.
%
%   [WM,FM]=RIDGEMAP(STRUCT) where STRUCT is a ridge structure as
%   output by RIDGEWALK, maps the ridge transform values into an 
%   array WM and the ridge frequencies into an array FM.  
%
%   WM and FM both have the same number of rows and columns as the 
%   original dataset, with each "page" corresponding to a different
%   ridge.  Thus, SIZE(WM,3) and SIZE(FM,3) equal the maximum number
%   of different ridges occurring at any dataset component.
%
%   If there occurs only one ridge at each data set components, then 
%   WM and FM are the same size as the original data matrix.
%
%   Note that, assuming the bandpass normaliztion of BANDNORM has 
%   been used, WM is an estimate of the underlying analytic signal.
%   _________________________________________________________________
%
%   Elliptical ridges
%
%   [WMP,FMP,WMN,FMN]=RIDGEMAP(STRUCT) for an elliptical ridge 
%   stucture STRUCT, as output by ELLRIDGE, returns both the positive
%   and negative rotary ridges and their corresponding frequencies.
%
%   [WMP,FMP,WMN,FMN,XZAT]=RIDGEMAP(STRUCT) also outputs the estimated
%   elliptical signal ZHAT = (WMP + WMN) / SQRT(2), again assuming 
%   BANDNORM has been used.
%   _________________________________________________________________
%
%   See also RIDGEWALK, RIDGE2SIG.
%
%   Usage:  [wm,fm]=ridgemap(struct);
%           [wmp,fmp,wmn,fmn]=ridgemap(struct);
%           [wmp,fmp,wmn,fmn,zhat]=ridgemap(struct);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details        

%   _________________________________________________________________
%
%   Collapsing
%
%   RIDGEMAP(STRUCT,'collapse') optionally collapses WM and FM 
%   along the third dimension, so that WM and FM are the same size as
%   the original dataset.  This is useful if there exists at most one
%   ridge at each time.

use struct

if nargin==1;
    str='all';
end

kn=kr(1,:);
for k=minmin(kr):maxmax(kr)
  index=find(kn==k|isnan(kn));
  if ~isempty(index)
     nridges(k)=length(index);
  end
end
maxk=maxmax(nridges);

if exist('wpr')
    [wmp,fmp]=ridgemap1(maxk,wpr,fpr,ir,kn,siz,str);
    [wmn,fmn]=ridgemap1(maxk,wnr,fnr,ir,kn,siz,str);
    zeta=(wmp+wmn)/sqrt(2);
    vswap(zeta,nan,0);
else
    [wmp,fmp]=ridgemap1(maxk,wr,fr,ir,kn,siz,str);
end


function[wm,fm]=ridgemap1(maxk,wr,fr,ir,kn,siz,str)

wm=nan*zeros(siz(1),siz(2),maxk);
fm=nan*zeros(siz(1),siz(2),maxk);

%Keep track of how many ridges at each data component
nk=zeros(siz(2),1);

for i=1:size(ir,2)
    index=find(isfinite(ir(:,i)));
    if ~isempty(index)
         %Add one to number of ridges at this data component
         nk(kn(i))=nk(kn(i))+1;
         wm(ir(index,i),kn(i),nk(kn(i)))=wr(index,i);
         fm(ir(index,i),kn(i),nk(kn(i)))=fr(index,i);
    end
end

if strcmp(str(1:3),'col')
    wm=vsum(wm,3);
    fm=vsum(fm,3);
end

% function[struct]=ridgemap_bandwidth_ellipse(struct)
% 
% use struct
% %ELLRIDGE structure case
% [zx,zy]=transconv(wpr,wnr,'pn2xy');
% [xi,xik,xil,lambda]=ellband(zx,zy);
% 
% xil_mean=vmean(xil,1)';
% 
% for i=1:size(ir,2)
%     xilr(:,i)=xil_mean(i)+0*ir(:,i);
% end
% 
% index=find(islargest(ir,kr,1./xilr));
% bool=zeros(size(ir));
% bool(index)=1;
% index=find(~bool);
% 
% wpr(index)=nan;
% wnr(index)=nan;
% fpr(index)=nan;
% fnr(index)=nan;
% ir(index)=nan;
% jr(index)=nan;
% kr(index)=nan;
% %xi(index)=nan;
% 
% make struct wp wn fs dt wpr wnr fpr fnr ir jr kr
%     
% 
% function[struct]=ridgemap_bandwidth_univariate(struct)
% %RIDGEWALK structure case
% 


