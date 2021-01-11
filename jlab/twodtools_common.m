function[mat,index,matz]=twodtools_common(xdata,ydata,xbin,ybin,matz)
%TWODTOOLS_COMMON  Low-level common element of twod-functions.
%
%   [MAT,INDEX]=TWODTOOLS_COMMON(X,Y,XBIN,YBIN) returns the index
%   INDEX mapping X and Y into matrix MAT, of size LENGTH(YBIN) 
%   rows by LENGTH(XBIN) columns.
%
%   [MAT,INDEX,MATZ]=TWODTOOLS_COMMON(X,Y,XBIN,YBIN,Z) where Z is
%   the same size as X and Y, also returns MATZ which has the Z 
%   data appropriately ordered.
%
%   Called by twodhist, twodmed, twodmean.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if nargin==4
    matz=[];
end
if isempty(matz)
    vcolon(xdata,ydata,xbin,ybin);
else
    vcolon(xdata,ydata,matz,xbin,ybin);
end

index=find(isfinite(xdata)&isfinite(ydata));
if isempty(matz)
    vindex(xdata,ydata,index,1);
else
    vindex(xdata,ydata,matz,index,1);
end

[xbinb,ybinb]=vshift(xbin,ybin,1,1);

dxa=osum(xdata,-xbin);
dxb=osum(xdata,-xbinb);
boolx=(dxa>0&dxb<=0);
[iix,jjx]=ind2sub(size(boolx),find(boolx));

dya=osum(ydata,-ybin);
dyb=osum(ydata,-ybinb);
booly=(dya>0&dyb<=0);
[iiy,jjy]=ind2sub(size(booly),find(booly));
  
matx=nan*xdata;
maty=nan*ydata;
matx(iix)=jjx;
maty(iiy)=jjy;

if  isempty(matz)
    vcolon(matx,maty);
else
    vcolon(matx,maty,matz);
end

index=find(isfinite(matx)&isfinite(maty));


if isempty(matz)
    vindex(matx,maty,index,1);
else
    vindex(matx,maty,matz,index,1);
end

mat=zeros(length(ybin),length(xbin));
index=sub2ind(size(mat),maty,matx);

if ~isempty(index)
    [index,sorter]=sort(index);
    if ~isempty(matz)
        matz=matz(sorter);
    end
end

