function[mat,xmid,ymid]=twodhist(xdata,ydata,xbin,ybin,flag)
%TWODHIST  Two-dimensional histogram.
%
%   MAT=TWODHIST(X,Y,XBIN,YBIN) where X and Y are arrays of the same
%   length, creates a two-dimensional histogram MAT with bin edges
%   specified by XBIN and YBIN. 
%
%   TWODHIST uses a fast (exact) algorithm which is particularly 
%   efficient for large arrays.
%  
%   The (X,Y) data points are sorted according to their X-values, which 
%   determine a column within MAT, and their Y-values, which determine 
%   a row within MAT.  
%
%   If XBIN and YBIN are length N and M, respectively, then MAT is of
%   size M-1 x N-1.
%
%   XBIN and YBIN must be monotonically increasing. 
%
%   [MAT,XMID,YMID]=TWODHIST(...) optionally returns the midpoints XMID
%   and YMID of the bins.
%
%   See also TWODMED, TWODMEAN.
%
%   'twodhist --t' runs a test.
%
%   Usage: mat=twodhist(x,y,xbin,ybin);
%          [mat,xmid,ymid]=twodhist(x,y,xbin,ybin);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details    

  
if strcmp(xdata,'--t')
   twodhist_test;return
end

if nargin==4
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

if anyany(~isnan(xdata.*ydata))
    if flag
      mat=twodhist_fast(xdata,ydata,xbin,ybin);
    else
      mat=twodhist_slow(xdata,ydata,xbin,ybin);
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

function[mat]=twodhist_fast(xdata,ydata,xbin,ybin)
[mat,index]=twodtools_common(xdata,ydata,xbin,ybin);

if ~isempty(index)
    [L,ia]=blocklen(index);
    mat(index(ia))=L(ia);
end

mat=mat(1:end-1,:);
mat=mat(:,1:end-1);

function[mat]=twodhist_slow(xdata,ydata,xbin,ybin)
mat=0*osum(ybin,xbin); 
[xbinb,ybinb]=vshift(xbin,ybin,1,1);
for i=1:length(xbin)
   for j=1:length(ybin)
         mat(j,i)=length(find(xdata>xbin(i)&xdata<=xbinb(i)&...
			      ydata>ybin(j)&ydata<=ybinb(j)));
   end
end
mat=mat(1:end-1,:);
mat=mat(:,1:end-1); 

function[]=twodhist_test
L=100;
xdata=2*abs(rand(L,1));
ydata=2*abs(rand(L,1));
xbin=[0:.01:2];
ybin=[0:.02:2];
tic;
mat1=twodhist(xdata,ydata,xbin,ybin,1);
dt1=toc;
tic
mat2=twodhist(xdata,ydata,xbin,ybin,0);
dt2=toc;
bool=aresame(mat1,mat2,1e-10);
reporttest('TWODHIST fast vs. slow algorithm',bool)
disp(['TWODHIST hist algorithm was ' num2str(dt2./dt1) ' times faster than direct algorithm.'])

xdata=-2*abs(rand(L,1));
ydata=-2*abs(rand(L,1));
xbin=[-2:.01:0];
ybin=[-2:.02:0];
mat1=twodhist(xdata,ydata,xbin,ybin,1);
mat2=twodhist(xdata,ydata,xbin,ybin,0);
bool=aresame(mat1,mat2,1e-10);
reporttest('TWODHIST fast vs. slow algorithm, negative bins',bool)

