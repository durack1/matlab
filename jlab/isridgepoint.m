function[bool]=isridgepoint(w,fs,a,str);
%ISRIDGEPOINT  Finds wavelet ridge points using one of several criterion.
%
%   BOOL=ISRIDGEPOINT(W,FS,A,STR) where W is a wavelet transform matrix at 
%   *cyclic* frequecies FS, finds all ridge points of W with amplitudes
%   |W| exceeding the amplitude cutoff A.  Several different different 
%   ridge defintions may be used and are specified by STR.
%
%   BOOL is a matrix of the same size as W, which is equal to one for 
%   those elements of W which are ridge points, and zero otherwise.
%
%   STR may be either of the following:
%
%        'phase'       Rate of transform change of phase definition
%        'amplitude'   Maxima of transfom amplitude definition
%
%   See Lilly and Olhede (2007) for details.
%
%   For all definitions, ISRIDGEPOINT rejects spurious ridge points.
%   These tend to occur on the flanks of interesting signals, and 
%   reflect the wavelet structure rather than the signal structure.
%
%   A ridge point is considered spurious if either it is located at an
%   amplitude minima, or if the frequency anomaly (transform frequency
%   minus scale frequency) is a maximum.
%
%   See also RIDGEQUANTITY, RIDGEWALK.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2007 J.M. Lilly --- type 'help jlab_license' for details
 
%        'groove'      Joint amplitude / phase definition

if strcmp(w, '--t')
    isridgepoint_test,return
end

if nargin==3
    error('Ridge type must be specified.')
end

%bool=zeros(size(w));
bool=isridgepoint1(w,fs,a,str);
disp(['ISRIDGEPOINT checking transform.'])

%for k=1:size(w,3);
%disp(['ISRIDGEPOINT checking transform # ' int2str(k) ' of ' int2str(size(w,3)) '.'])
%    bool(:,:,k)=isridgepoint1(w(:,:,k),fs,a,str);
%end

disp(['ISRIDGEPOINT finished.'])

function[bool]=isridgepoint1(x,fs,a,str);

fs=fs(:);
xd=instfreq(x); 
fsmat=vrep(vrep(fs',size(xd,1),1),size(xd,3),3);
rq=ridgequantity(x,fsmat,str);    
clear fsmat
rqm=vshift(rq,-1,2);
rqp=vshift(rq,+1,2);

%This is d/ds < 0 since scale decreases in columns
bool=(rqm<0&rqp>=0)|(rqm<=0&rqp>0);
   
err=abs(rq);

bool((bool&vshift(bool,1,2))&err>vshift(err,1,2))=0; 
bool((bool&vshift(bool,-1,2))&err>vshift(err,-1,2))=0; 

bool1= ~isnan(x);   %Remove NANs
bool2=~(abs(x)<a);  %Remove those less than cutoff amplitude
bool=bool.*bool1.*bool2;
bool(:,[1 end],:)=0;


disp(['ISRIDGEPOINT found ' int2str(length(find(bool))) ' ridge points.'])

function[]=isridgepoint_test
 
%reporttest('ISRIDGEPOINT',aresame())
