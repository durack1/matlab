function[h]=ellipseplot(varargin)
%ELLIPSEPLOT Plot ellipses.
%
%   ELLIPSEPLOT(A,B,TH,X,AR) plots an ellipse of major axis A, minor
%   axis B, and orientation TH at complex-valued location X, rescaled
%   by aspect ratio AR for plotting purposes.
%
%   AR is optional and defaults to 1. 
%
%   Also, X is optional and defaults to 0+sqrt(-1)*0.  
%
%   Multliple ellipses are plotted if A, B, TH, and X, are matrices of 
%   the same size. 
%
%   ELLIPSEPLOT draws each column of the input arrays with a different 
%   color, cycling through the default line colors.
%   _______________________________________________________________
% 
%   Additional options
%
%   ELLIPSEPLOT(A,B,TH, ... ,'phase',PHI) optionally draws a small line, 
%   like a clock hand, to indicate the ellipse phase PHI.
%
%   ELLIPSEPLOT(A,B,TH, ... ,'axis') alternatively draws the major axis.
%
%   ELLIPSEPLOT(A,B,TH, ... ,'npoints',N) plots ellipses with N points
%   along the circumference.  The default value is 16.  Use N=32 or 64 
%   for smoother, more well-defined ellipses.
%   
%   ELLIPSPLOT(INDEX,A,...) only plots ellipses for those rows of the 
%   input matrices indicated by INDEX.
%
%   H=ELLIPSEPLOT(...) outputs an array of line handles.
%
%   ELLIPSEPLOT(A,B,TH,DX,AR) where DX is a scalar uses DX as a complex-
%   valued offset in between ellipses, beginning at 0.   
%   _______________________________________________________________ 
%
%   Usage: ellipseplot(a,b,th)
%          ellipseplot(a,b,th,x)
%          ellipseplot(a,b,th,x,ar)
%          ellipseplot(a,b,th,x,'axis')
%          ellipseplot(a,b,th,x,ar,'phase',phi)
%          ellipseplot(a,b,th,x,ar,'npoints',64)
%          ellipseplot(index,a,b,th,x)
%
%   'ellipseplot --f' generates a sample figure.
%   ______________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        

if strcmp(varargin{1},'--f')
  ellipseplot_fig;return
end

%/********************************************************
%Sort out input arguments
na=length(varargin);
bindex1=~aresame(size(varargin{1}),size(varargin{2}));
bindex2=aresame(vcolon(varargin{1}),[1:length(varargin{2})]');
if bindex1||bindex2
    index=varargin{1};
    na=na-1;
    varargin=varargin(2:end);
else
    index=[1:length(varargin{2})]';
end
a=varargin{1};
b=varargin{2};
th=varargin{3};
ar=1;
x=zeros(size(a));
phi=zeros(size(a));
baxis=0;
npoints=32;

for i=1:3
    if ischar(varargin{end})
       if strcmp(varargin{end},'axis')
          na=na-1;
          baxis=1;
          varargin=varargin(1:end-1);
      end
    end

    if ischar(varargin{end-1})
      if strcmp(varargin{end-1},'phase')
          phi=varargin{end};
          na=na-2;
          varargin=varargin(1:end-2);
      end
    end

    if ischar(varargin{end-1})
      if strcmp(varargin{end-1},'npoints')
          npoints=varargin{end};
          na=na-2;
          varargin=varargin(1:end-2);
      end
    end
end

if na>3
  x=varargin{4};
end

if na>4
  ar=varargin{5};
  if length(ar)>1
    error('The aspect ratio AR must have unit length')
  end
end
%\********************************************************

N=size(a,1);
if length(x)==1  &&  N>1
    x=exp(sqrt(-1)*angle(x)).*conj([0:abs(x):(N-1)*abs(x)]');
    x=oprod(x,ones(size(a(1,:)))');
end
vindex(a,b,th,phi,x,index,1);

bhold=ishold;
sty{1}='b';sty{2}='g';sty{3}='r';sty{4}='c';sty{5}='m';sty{6}='y';sty{7}='k';
    
hold on

nsty=rem([1:size(a,2)],length(sty));
vswap(nsty,0,length(sty));

for i=1:size(a,2)
    h(:,i)=ellipseplot1(a(:,i),b(:,i),th(:,i),phi(:,i),x(:,i),ar,baxis,npoints);
    index=find(~isnan(h(:,i)));
    if ~isempty(index)
       linestyle(h(index,i),sty{nsty(i)})
    end
end

if ~bhold
    hold off
end
set(gca,'box','on')

if nargout==0
  clear h
end

function[h]=ellipseplot1(a,b,th,phi,x,ar,baxis,npoints)
%z1=[0:.1:2*pi+.1]';

L=size(a,1);

vswap(a,0,nan);
index=find(~isnan(a));
% length(index)
% vsize(a,b,th,phi,x)
if ~isempty(index)
    vindex(a,b,th,phi,x,index,1);
end
z1=linspace(0,2*pi+0.01,npoints)';
z1=exp(sqrt(-1)*z1);
 
if ~allall(phi==0)
  z1=[0+sqrt(-1)*0;z1];
end

if baxis
  z1=[-1+sqrt(-1)*0;0+sqrt(-1)*0;z1];
end

x=osum(0*z1,x);
z=osum(z1,0*th);

z=circ2ell(z,a,b,th,phi,ar)+x;
h=nan+zeros(L,1);
ho=plot(z,'k');
if ~isempty(index)
    h(index)=ho;
end
function[z]=circ2ell(z,a,b,th,phi,ar)
%CIRC2ELL  Converts a complex-valued circle into an ellipse.
%
%   ZP=CIRC2ELL(Z,A,B,TH,PHI) where Z is a complex-valued time series,
%   performs a combined phase-lag, stretching, and rotation of Z.  
%  
%   If Z is a circle expressed as a complex-valued time series,
%   e.g. as output by PHASECIRCLE, TH and PHI are angles in radians,
%   and A and B are real-valued weighting factors, CIRC2ELL transforms
%   Z into an ellipse specified by ZP.
%  
%   This ellipse has major axis A and minor axis B, with the major
%   axis oriented at angle TH measured counterclockwise with respect
%   to the positive real axis.  If the phase at temporal midpoint of Z
%   is zero, than the ellipse has phase PHI at the midpoint.
%
%   The input arguments TH, A, B, and PHI may each be scalars or arrays
%   of the same size as Z.
%
%   ZP=CIRC2ELL(... AR) optionally rescales the ellipse by aspect ratio
%   AR for plotting purposes.
%
%   See Lilly (2005) for algorithm details.
%
%   See also ELLIPSEPLOT, PHASECIRCLE
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004 J.M. Lilly --- type 'help jlab_license' for details        


  
%   Use with PHASECIRCLE to plot polarization ellipses.
%
%   As an example,
%
%       w=slepwave(2.5,3,1,1,8/1024,8/1024);
%       w=w(:,1)/max(abs(w(:,1)));
%       z=circ2ell(phasecircle(0),pi/6,3,2,pi/4) ;
%       w=circ2ell(w,pi/6,3,2,pi/4); 
%       plot(z),hold on,plot(w),linestyle two,axis equal
%
%   creates a simplified version of Figure 5 of Lilly (2004).

  
  
if nargin==5
  ar=1;
end

rz=real(z);
iz=imag(z);

if isscalar(a)
  a=a+0*z(1,:);
end

if isscalar(b)
  b=b+0*z(1,:);
end

if isscalar(th)
  th=th+0*z(1,:);
end

if isscalar(phi)
  phi=phi+0*z(1,:);
end


for i=1:size(z,2)
  [rz(:,i),iz(:,i)]=vectmult(jmat(phi(i)),rz(:,i),iz(:,i));
  rz(:,i)=rz(:,i).*a(i);
  iz(:,i)=iz(:,i).*b(i);
  [rz(:,i),iz(:,i)]=vectmult(jmat(th(i)),rz(:,i),iz(:,i));
end

z=rz+sqrt(-1).*iz;

if ar~=1
  z=real(z)+ar.*sqrt(-1)*imag(z);
end



function[]=ellipseplot_fig

a=ones(10,1);
b=[1:10]'./10;
th=linspace(0,pi,10)';
x=linspace(0,1,10)'*20;
ellipseplot(a,b,th,x,'npoints',16)
title('Counterclockwise rotating ellipse becoming circle')
set(gca,'dataaspectratio',[1 1 1])
