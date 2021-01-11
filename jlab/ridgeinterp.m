function[struct]=ridgeinterp(varargin)
% RIDGEINTERP  Interpolate quantity values onto ridge locations.
%
%   STRUCTI=RIDGEINTERP(STRUCT,W) where W is a wavelet transform 
%   as output by WAVETRANS, and STRUCT is a ridge structure as
%   output by RIDGEWALK, returns a new structure STRUCTI with 
%   improved estimates of the transform values along ridges.
%
%   Transform values along ridges are improved with using an 
%   interpolation scheme to estimate values at exact ridge 
%   locations, which may in general fall between the discrete scale
%   levels of the transform matrix W.
%
%   STRUCTI=RIDGEINTERP(STRUCT,W,F1,F2,... FN) also interpolates
%   the quantities F1, F2, ... FN, all the same size as W. 
%
%   The interpolated quantities are contained in fields of STRUCTI 
%   with the original function value with 'R' appended, i.e. the 
%   interpolation a quanitty called 'w' is placed into 'structi.wr'.
%
%   While the transform W is specifed only at discrete frequencies,
%   RIDGEINTERP interpolates transform values between discrete 
%   frequencies to find a more precise value of the transform along 
%   the ridges than simply looking up the values of W at rows IR and 
%   columns JR.  
%
%   RIDGEINTERP uses fast quadratic interpolation via QUADINTERP.
%
%   See also RIDGEWALK, RIDGEMAP, QUADINTERP.
%
%   Usage:  struct=ridgeinterp(struct,w);
%           struct=ridgeinterp(struct,w,f1,f2,f3);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2005--2007 J.M. Lilly --- type 'help jlab_license' for details    

bscalecurve=0;
nargs=nargin;
if ~isstruct(varargin{1})
      sr=varargin{1};
      bscalecurve=1;
      varargin=varargin(2:end);
      nargs=nargs-1;
end

struct=varargin{1};
w=varargin{2};


use struct

for i=1:nargs-1
    argnames{i}=inputname(i+1+bscalecurve);
    if ~isfield(struct,[argnames{i} 'r'])
          eval(['struct.' argnames{i} 'r=nan*ir;'])
    end
end
for k=minmin(kr):maxmax(kr)
  index=find(kr==k|isnan(kr));
  if ~isempty(index)
     for i=1:length(argnames)
          var=varargin{i+1};
          args{i}=var(:,:,k);
     end
      %These are actually about the same in quality but quadratic algorithm
      %is actually faster and also easier to read.
      %outargs=ridgeinterp1_linear(ir(index),jr(index),fs,w(:,:,k),args,alg);
      outargs=ridgeinterp1_quadratic(ir(index),jr(index),fs,w(:,:,k),args,alg);
     for i=1:length(argnames)
         eval(['struct.' argnames{i} 'r(index)=outargs{i};'])
     end
  end
end


function[outargs]=ridgeinterp1_linear(ir,jr,fs,x,args,alg)

rq=ridgequantity(x,fs,alg);    

indexr=sub2ind(size(x),ir,jr);
indexrp=sub2ind(size(x),ir,jr+1);
indexrn=sub2ind(size(x),ir,jr-1);

%Ridge quantity along the ridges, and at one scale up and down
index=find(~isnan(ir));
dr=0*ir;dr(index)=rq(nonnan(indexr));
drp=0*ir;drp(index)=rq(nonnan(indexrp));
drn=0*ir;drn(index)=rq(nonnan(indexrn));

%Indices into location of point bracketing exact ridge---
%   do we look one scale up or one scale down?
indexp=find((dr>0&drp<0&drn>=0)|(dr<0&drn<0&drp>=0));
indexn=find((dr>0&drn<0&drp>=0)|(dr<0&drp<0&drn>=0));

%Note that this excludes the few points which are at extrema of the local frequency 
%    i.e.:    index=find(drp<0&drn<0); 

%Find the distance between the true ridge and the approximate ridge
rb=0*ir;
rb(indexp)=drp(indexp);
rb(indexn)=drn(indexn);
dy=abs(frac(dr,dr-rb));

%Extrema points should have dy=0 but start out with dy=1
dy=vswap(dy,1,0); 
    

for i=1:length(args)
   x=args{i}; 
   xro=0*ir;xro(index)=x(nonnan(indexr));
   xrp=0*ir;xrp(index)=x(nonnan(indexrp));
   xrn=0*ir;xrn(index)=x(nonnan(indexrn));

   %The value for the bracketing curve we call "b" 
   b=0*ir;
   b(indexp)=xrp(indexp);
   b(indexn)=xrn(indexn);
   
   %Linearly interpolate between the approximate ridge and the bracketing curve 
   outargs{i}=xro.*(1-dy)+b.*dy;
end



function[outargs]=ridgeinterp1_quadratic(ir,jr,fs,x,args,alg)

rq=ridgequantity(x,fs,alg);    

indexr=nonnan(sub2ind(size(x),ir,jr));
indexrp=nonnan(sub2ind(size(x),ir,jr+1));
indexrn=nonnan(sub2ind(size(x),ir,jr-1));

%Ridge quantity along the ridges, and at one scale up and down
index=find(~isnan(ir));
dr=0*ir;dr(index)=rq(indexr);
drp=0*ir;drp(index)=rq(indexrp);
drn=0*ir;drn(index)=rq(indexrn);
    
[xmin,jre]=quadinterp(jr-1,jr,jr+1,abs(drn).^2,abs(dr).^2,abs(drp).^2);

for i=1:length(args)
   x=args{i}; 
   xro=0*ir;xro(index)=x(indexr);
   xrp=0*ir;xrp(index)=x(indexrp);
   xrn=0*ir;xrn(index)=x(indexrn);

   %Linearly interpolate between the approximate ridge and the bracketing curve 
   outargs{i}=quadinterp(jr-1,jr,jr+1,xrn,xro,xrp,jre);
end







