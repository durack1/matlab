function[mat,xmid,ymid]=twodmed(xdata,ydata,zdata,xbin,ybin,flag)
%TWODMED  Median value of a function of two variables.
%
%   TWODMED computes the median value of a function of two variables, 
%   and also its standard deviation.  This is done using a fast 
%   (exact) algorithm which is particularly efficient for large arrays.
%
%   MED=TWODMED(X,Y,Z,XBIN,YBIN) where X, Y and Z are arrays of the same
%   length, forms the median of Z over the XY plane. 
%
%   The values of Z are sorted into bins according to the associated 
%   (X,Y) value, with bin edges specified by XBIN and YBIN, and the mean
%   of all finite values of Z in each bin is returned as MZ.
%
%   If XBIN and YBIN are length N and M, respectively, then MED is of 
%   size M-1 x N-1.  Bins with no data are assigned a value of NAN.
%
%   XBIN and YBIN must be monotonically increasing. 
%
%   [MED,XMID,YMID]=TWODMED(...) optionally returns the midpoints XMID
%   and YMID of the bins.
%
%   See also TWODHIST, TWODMEAN.
%   
%   'twodmed --t' runs a test.
%
%   Usage: med=twodmed(x,y,z,xbin,ybin);
%          [med,xmid,ymid]=twodmed(x,y,z,xbin,ybin);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details    


if strcmp(xdata,'--t')
   twodmed_test;return
end

if nargin==5
  flag=1;
end

xbin=xbin(:);
ybin=ybin(:);
if any(diff(xbin)<0)
  error('XBIN must be monotonically increasing')
end
if any(diff(ybin)<0)
  error('YBIN must be monotonically increasing')
end

if ~aresame(size(xdata),size(zdata))
     error('X, Y, and Z should all have the same size.')
end

if anyany(~isnan(xdata.*ydata.*zdata))
    if flag
      mat=twodmed_fast(xdata,ydata,zdata,xbin,ybin);
    else
      mat=twodmed_slow(xdata,ydata,zdata,xbin,ybin);
    end
else
    warning('Data contains only NaNs.')
    mat=0*osum(ybin(1:end-1),xbin(1:end-1)); 
end

if nargout>1
  xmid=(xbin+vshift(xbin,1,1))./2;
  xmid=xmid(1:end-1);
end
if nargout>2
  ymid=(ybin+vshift(ybin,1,1))./2;
  ymid=ymid(1:end-1);
end

hist=twodhist(xdata,ydata,xbin,ybin);
index=find(hist==0);
if ~isempty(index)
    mat(index)=nan;
end

function[mat]=twodmed_fast(xdata,ydata,zdata,xbin,ybin)

[mat,index,matz]=twodtools_common(xdata,ydata,xbin,ybin,zdata);

if ~isempty(index)
    [L,ia,ib,numblock]=blocklen(index);
    L=L(ia);
    
    colbreaks(numblock,matz);
    col2mat(numblock,matz);
    matz=sort(matz,1);
    
    medz=zeros(size(ia));
    
    colindex=find(isodd(L));
    if ~isempty(colindex)
        ijindex=sub2ind(size(matz),(L(colindex)+1)/2,colindex);
        medz(colindex)=matz(ijindex);
    end

    colindex=find(iseven(L));
    if ~isempty(colindex)
        ijindex1=sub2ind(size(matz),L(colindex)/2,colindex);
        ijindex2=sub2ind(size(matz),L(colindex)/2+1,colindex);
        medz(colindex)=matz(ijindex1)/2+matz(ijindex2)/2;
    end
    mat(index(ia))=medz;
end

mat=mat(1:end-1,:);
mat=mat(:,1:end-1);

function[mat]=twodmed_slow(xdata,ydata,zdata,xbin,ybin)
vcolon(xdata,ydata,zdata,xbin,ybin);
index=find(isfinite(xdata)&isfinite(ydata)&isfinite(zdata));
vindex(xdata,ydata,zdata,index,1);

mat=0*osum(ybin,xbin); 
[xbinb,ybinb]=vshift(xbin,ybin,1,1);
for i=1:length(xbin)
   for j=1:length(ybin)
         index=find(xdata>xbin(i)&xdata<=xbinb(i)&ydata>ybin(j)&ydata<=ybinb(j));
         if ~isempty(index)
             mat(j,i)=median(zdata(index));
         end
   end
end
mat=mat(1:end-1,:);
mat=mat(:,1:end-1); 

function[]=twodmed_test
L=1000;
xdata=2*abs(rand(L,1));
ydata=2*abs(rand(L,1));
zdata=randn(L,1);
xbin=[0:.01:2];
ybin=[0:.02:2];
tic;
mat1=twodmed(xdata,ydata,zdata,xbin,ybin,1);
dt1=toc;
tic
mat2=twodmed(xdata,ydata,zdata,xbin,ybin,0);
dt2=toc;
bool=aresame(mat1,mat2,1e-10);
reporttest('TWODMED fast vs. slow algorithm',bool)
disp(['TWODMED fast algorithm was ' num2str(dt2./dt1) ' times faster than direct algorithm.'])

xdata=-2*abs(rand(L,1));
ydata=-2*abs(rand(L,1));
xbin=[-2:.01:0];
ybin=[-2:.02:0];
mat1=twodmed(xdata,ydata,zdata,xbin,ybin,1);
mat2=twodmed(xdata,ydata,zdata,xbin,ybin,0);
bool=aresame(mat1,mat2,1e-10);
reporttest('TWODMED fast vs. slow algorithm, negative bins',bool)




