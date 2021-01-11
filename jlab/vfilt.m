function[varargout]=vfilt(varargin)
%VFILT  Filtering along rows without change in length.
%
%   Y=VFILT(X,FILTER) convolves FILTER with X along their rows and
%   crops the result Y to be the same length as X. If FILTER is a
%   number, a Hanning filter of that length is used.  
%                                                                         
%   [Y1,Y2,...YN]=VFILT(X1,X2,...XN,FILTER) also works.
%
%   The input arrays XI may have any dimensionality.
%
%   VFILT(X1,X2,...XN,FILTER); with no output arguments overwrites the
%   original input variables.
%   ___________________________________________________________________
%
%   Boundary conditions
%
%   Y=VFILT(..., STR), where STR is a string, optionally specifies
%   the boundary condition to be imposed at the edges of the time
%   series.  Valid options for STR are 
%
%         STR = 'zeros' or 'nonans' for zero-padding beyond endpoints 
%         STR = 'nan' for zero-padding beyond the endpoints, setting 
%                contaminated points near the edges to NaNs
%         STR = 'periodic' for periodic boundary conditions 
%         STR = 'mirror' for reflecting the time series at both ends
%
%   By default, STR='nan', implying that the roughly length(FILTER)/2 
%   data points on each end of Y which are contaminated by edge effects
%   are replaced with NANs.
%
%   All boundary conditions take into account potential blocks of 
%   missing data, marked by NaNs, at beginning and end of each column.  
%   ___________________________________________________________________
%
%  'vfilt --t' runs a test.
%
%   Usage: y=vfilt(x,filter);
%          y=vfilt(x,filter,'zeros');
%          [y1,y2,y3]=vfilt(x1,x2,x3,filter);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2007 J.M. Lilly --- type 'help jlab_license' for details    
 
%if strcmp(varargin{1}, '--t')
%  vfilt_test,return
%end

if strcmp(varargin{1},'--t')
    vfilt_test;return
end

narg=nargin;
bnan=1;
str='nan';
if ischar(varargin{end})
   str=lower(varargin{end});
   varargin=varargin(1:end-1);
   narg=narg-1;
end

str=str(1:3);

% ndim=1;
% if length(varargin{end})==1
%    ndim=varargin{end};
%    varargin=varargin(1:end-1);
%    narg=narg-1;
% end

n=varargin{end};

for i=1:narg-1
    varargout{i}=vfilt1_prepare(varargin{i},n,str);
end
 
eval(to_overwrite(narg-1))

function[smooth]=vfilt1_prepare(data,filter,str)
N=size(data,1);
n=length(filter);

if N<=n
  warning(['Not enough rows to filter the data with a ' int2str(n) ' point filter.'])
end

if length(filter)==1
	filter=hanning(filter);
    filter=filter./sum(filter);
end

sizedata=size(data);
data=reshape(data,[N prod(sizedata(2:end))]);

data_extended=zeros(N+2*n,size(data,2));
data_extended(n+1:n+N,:)=data;

ia=[1:n]';
ib=[n+N+1:N+2*n]';

switch str
    case {'zer', 'non'}
        %Do nothing
    case 'nan'
        data_extended([ia ib],:)=nan;
    case 'mir'
        data_extended(ia,:)=data(n-ia+2,:);
        data_extended(ib,:)=data(N-1+(n+N+1-ib),:);
    case 'per'
        data_extended(ia,:)=data(ib-2*n,:);
        data_extended(ib,:)=data(ia,:);
    otherwise
       error(['Transform option STR = ''',str,''' is not supported.']);
end   
   
smooth=vfilt1(data_extended,filter);
smooth=smooth(n+1:n+N,:);
smooth=reshape(smooth,sizedata);

function[smooth]=vfilt1(data,filter)
%Outputs a smoothed dataset of the same size as the originaldata

N=size(data,1);
a=round(length(filter)/2);
smooth=zeros(size(data));

for i=1:size(data,2)
	temp=conv(data(:,i),filter);
	smooth(:,i)=temp(a:a+N-1);
end


function[]=vfilt_test
x =[0 0 1 1 0 0]';
y1=[0 1 2 2 1 0]';

bool=aresame(y1,vfilt(x,[1 1 1]','nonnans'));
reporttest('VFILT simple nonans', bool)

x =[0 0 1 1 0 0]';
y1=[nan 1 2 2 1 nan]';

bool=aresame(y1,vfilt(x,[1 1 1]'));
reporttest('VFILT simple nans', bool)

x =[1 1 1 1 1 2]';
y1=[4 3 3 3 4 4]';

bool=aresame(y1,vfilt(x,[1 1 1]','per'));
reporttest('VFILT simple periodic', bool)


x =[1 4 1 1 2 1]';
y1=[9 6 6 4 4 5]';

bool=aresame(y1,vfilt(x,[1 1 1]','mirror'));
reporttest('VFILT simple mirror', bool)


x(:,:,1)=[0 0 1 1 0 0]';
x(:,:,3)=[0 0 1 1 0 0]';
y1(:,:,1)=[0 1 2 2 1 0]';
y1(:,:,3)=[0 1 2 2 1 0]';

bool=aresame(y1,vfilt(x,[1 1 1]','nonnans'));
reporttest('VFILT 3-D matrix', bool)


