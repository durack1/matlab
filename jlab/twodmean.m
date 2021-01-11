function[mat,xmid,ymid,num,std]=twodmean(xdata,ydata,zdata,xbin,ybin,flag)
%TWODMEAN  Mean value (& std) of a function of two variables.
%
%   TWODMEAN computes the mean value of a function of two variables, 
%   and also its standard deviation.  This is done using a fast 
%   (exact) algorithm which is particularly efficient for large arrays.
%
%   MZ=TWODMEAN(X,Y,Z,XBIN,YBIN) where X, Y and Z are arrays of the same
%   length, forms the mean of Z over the XY plane.  
%
%   The values of Z are sorted into bins according to the associated 
%   (X,Y) value, with bin edges specified by XBIN and YBIN, and the mean
%   of all finite values of Z in each bin is returned as MZ.
%  
%   If XBIN and YBIN are length N and M, respectively, then MZ is of 
%   size M-1 x N-1.  Bins with no data are assigned a value of NAN.
%
%   XBIN and YBIN must be monotonically increasing. 
%   __________________________________________________________________
%
%   Additional options
%
%   [MZ,XMID,YMID]=TWODMEAN(...) optionally returns the midpoints XMID
%   and YMID of the bins.
%
%   [MZ,XMID,YMID,NUMZ]=TWODMEAN(...) also returns the number of good
%   data points in each of the (X,Y) bins.  STDZ is the same size as MZ.
%
%   [MZ,XMID,YMID,NUMZ,STDZ]=TWODMEAN(...) also returns the standard 
%   deviation of Z in the (X,Y) bins.  STDZ is the same size as MZ.
%
%   You can use TWODMEAN for fast binning of data over the plane.  For
%   the case in which Z is so sparsely distributed over X and Y, such 
%   that no bins will have more than one entry, the mean in each bin
%   is just the value of the data point in the bin.  
%   __________________________________________________________________
%   
%   See also TWODHIST, TWODMED.
%
%   'twodmean --t' runs a test.
%
%   Usage: mz=twodmean(x,y,z,xbin,ybin);
%          [mz,xmid,ymid]=twodmean(x,y,z,xbin,ybin);
%          [mz,xmid,ymid,numz]=twodmean(x,y,z,xbin,ybin);
%          [mz,xmid,ymid,numz,stdz]=twodmean(x,y,z,xbin,ybin);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details    


if strcmp(xdata,'--t')
   twodmean_test;return
end

if nargin==5
  flag=1;
end

vcolon(xbin,ybin);
if any(diff(xbin)<0)
  error('XBIN must be monotonically increasing')
end
if any(diff(ybin)<0)
  error('YBIN must be monotonically increasing')
end
if ~aresame(size(xdata),size(zdata))
     error('X, Y, and Z should all have the same size.')
end
    
if nargout>4
    stdflag=1;
else
    stdflag=0;
end

% if ~aresame(size(zdata),size(xdata))
%     if aresame(size(zdata(:,:,1)),size(xdata))
%         xdata=vrep(xdata,size(zdata,3),3)
if anyany(~isnan(xdata.*ydata.*zdata))
    if flag
      [mat,num,std]=twodmean_fast(xdata,ydata,zdata,xbin,ybin,stdflag);
    else
      [mat,num,std]=twodmean_slow(xdata,ydata,zdata,xbin,ybin,stdflag);
    end
else
    warning('Data contains only NaNs.')
    mat=0*osum(ybin(1:end-1),xbin(1:end-1)); 
    num=mat;
    std=mat;
end
if nargout>1
  xmid=(xbin+vshift(xbin,1,1))./2;
  xmid=xmid(1:end-1);
end
if nargout>2
  ymid=(ybin+vshift(ybin,1,1))./2;
  ymid=ymid(1:end-1);
end

index=find(num==0);
if ~isempty(index)
    mat(index)=nan;
    if stdflag
        std(index)=nan;
    end
end

function[mat,num,std]=twodmean_fast(xdata,ydata,zdata,xbin,ybin,stdflag)

[mat,index,matz]=twodtools_common(xdata,ydata,xbin,ybin,zdata);
num=zeros(size(mat));

if stdflag 
    std=zeros(size(mat));
else
    std=[];
end
  
if ~isempty(index)
    [L,ia,ib,numblock]=blocklen(index);
    L=L(ia);
    
    colbreaks(numblock,matz);
    col2mat(numblock,matz);
    mat(index(ia))=vmean(matz,1);
    num(index(ia))=vsum(isfinite(matz),1);
    
    if stdflag
        std(index(ia))=vstd(matz,1);
    end
        
end

mat=mat(1:end-1,:);
mat=mat(:,1:end-1);
num=num(1:end-1,:);
num=num(:,1:end-1);
    
if stdflag
    std=std(1:end-1,:);
    std=std(:,1:end-1);
end


function[mat,num,std]=twodmean_slow(xdata,ydata,zdata,xbin,ybin,stdflag)
vcolon(xdata,ydata,zdata,xbin,ybin);
index=find(isfinite(xdata)&isfinite(ydata)&isfinite(zdata));
vindex(xdata,ydata,zdata,index,1);

mat=0*osum(ybin,xbin); 
num=0*osum(ybin,xbin); 
    
if stdflag 
    std=0*osum(ybin,xbin); 
else
    std=[];
end

[xbinb,ybinb]=vshift(xbin,ybin,1,1);
for i=1:length(xbin)
   for j=1:length(ybin)
         index=find(xdata>xbin(i)&xdata<=xbinb(i)&ydata>ybin(j)&ydata<=ybinb(j));
         if ~isempty(index)
             mat(j,i)=vmean(zdata(index),1);
             num(j,i)=length(index);
             if stdflag
                 std(j,i)=vstd(zdata(index),1);
             end
         end
   end
end
mat=mat(1:end-1,:);
mat=mat(:,1:end-1); 
num=num(1:end-1,:);
num=num(:,1:end-1);
    
if stdflag
    std=std(1:end-1,:);
    std=std(:,1:end-1);
end

function[]=twodmean_test
L=100;
xdata=2*abs(rand(L,1));
ydata=2*abs(rand(L,1));
zdata=randn(L,1);
xbin=[0:.01:2];
ybin=[0:.02:2];
tic;
[mat1,xmid,ymid,num1,std1]=twodmean(xdata,ydata,zdata,xbin,ybin,1);
dt1=toc;
tic
[mat2,xmid,ymid,num2,std2]=twodmean(xdata,ydata,zdata,xbin,ybin,0);
dt2=toc;
bool1=aresame(mat1,mat2,1e-10);
bool2=aresame(std1,std2,1e-10);
bool3=aresame(num1,num2,1e-10);
reporttest('TWODMEAN fast vs. slow algorithm, mean',bool1)
reporttest('TWODMEAN fast vs. slow algorithm, std',bool2)
reporttest('TWODMEAN fast vs. slow algorithm, num',bool3)
disp(['TWODMEAN fast algorithm was ' num2str(dt2./dt1) ' times faster than direct algorithm.'])

xdata=-2*abs(rand(L,1));
ydata=-2*abs(rand(L,1));
xbin=[-2:.01:0];
ybin=[-2:.02:0];
[mat1,xmid,ymid,num1,std1]=twodmean(xdata,ydata,zdata,xbin,ybin,1);
[mat2,xmid,ymid,num2,std2]=twodmean(xdata,ydata,zdata,xbin,ybin,0);
bool1=aresame(mat1,mat2,1e-10);
bool2=aresame(std1,std2,1e-10);
reporttest('TWODMEAN fast vs. slow algorithm, negative bins, std',bool2)
reporttest('TWODMEAN fast vs. slow algorithm, negative bins, mean',bool1)
reporttest('TWODMEAN fast vs. slow algorithm, negative bins, std',bool2)
reporttest('TWODMEAN fast vs. slow algorithm, negative bins, num',bool3)


