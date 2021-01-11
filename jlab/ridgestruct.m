function[struct]=ridgestruct(w,fs,dt,bool,N,df_cutoff,alg)
%RIDGESTRUCT  Forms wavelet ridge structure given ridge points.
%
%   STRUCT=RIDGESTRUCT(W,FS,DT,BOOL,N,ALPHA,ALG) forms a wavelet 
%   ridge structure STRUCT.  See RIDGEWALK for details.  Here W is 
%   a wavelet transform matrix at *cyclic* frequecies FS, and DT is
%   the sample rate. 
%
%   BOOL is a matrix of the same size as W, which is equal to one for 
%   those elements of W which are ridge points, and zero otherwise.
%
%   N specifies the minimum length of a ridge, in periods.
%
%   ALPHA is a cutoff value of the dimensionless chirp rate.
%
%   ALG may be any of the following:
% 
%         'phase'       Rate of transform change of phase definition
%         'amplitude'   Maxima of transfom amplitude definition
% 
%   STRUCT is a wavelet ridge structure described in RIDGEWALK.
%
%   See also RIDGEWALK.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2007 J.M. Lilly --- type 'help jlab_license' for details
 
%         'groove'      Joint amplitude / phase definition

if strcmp(w, '--t')
    ridgestruct_test,return
end
if nargin==5
    error('Ridge type must be specified.')
end


biter=0;
if ~isempty(alg)
    alg=alg(1:3);
else
    alg='pha';
end

if 0
    boolr=islargest(nonnan(ir),nonnan(wr));
    indexridge=sub2ind(size(w),nonnan(ir),nonnan(jr),nonnan(kr));
        bool=zeros(size(w));
if ~isempty(indexridge)
    bool(indexridge)=boolr;
end
end

%/***********************************************************
%Computing transform frequency etc
eta=instfreq(dt,w,'complex'); %Complex-valued transform frequency
deta=vdiff(eta,1)./dt;        %Complex-valued frequency derivative
f=real(eta)/2/pi;             %Cyclic frequency
dfdt=vdiff(f,1); 
%\***********************************************************

disp(['RIDGESTRUCT chaining ridges.'])


%/***********************************************************
lastid=0;
for k=1:size(w,3)
    %disp(['RIDGESTRUCT chaining ridges for transform # ' int2str(k) ' of ' int2str(size(w,3)) '.'])
    if isempty(find(bool(:,:,k)))
        idk=[];irk=[];jrk=[];wrk=[];frk=[];
    else
        [idk,irk,jrk,wrk,frk]=ridgechains(fs,N,bool(:,:,k),w(:,:,k),f(:,:,k),dfdt(:,:,k),df_cutoff);  
    end
    krk=k+0*irk;
    if ~isempty(idk),
         idk=idk+lastid;	
         lastid=maxmax(idk);
    end
  
    ir{k}=irk;jr{k}=jrk;kr{k}=krk;wr{k}=wrk;fr{k}=frk;id{k}=idk;
end

disp('RIDGESTRUCT reorganizing ridges.')
vcellcat(ir,jr,kr,wr,fr,id); 

[id,ir,jr,kr,wr,fr]=colbreaks(id,ir,jr,kr,wr,fr);
[id,ir,jr,kr,wr,fr]=col2mat(id,ir,jr,kr,wr,fr);

if allall(isnan(ir));
    id=[];ir=[];jr=[];kr=[];wr=[];fr=[];
end

siz=[size(w,1) size(w,3)];
make struct siz dt fs alg wr fr ir jr kr 
struct=ridgeinterp(struct,w,f);

disp('RIDGESTRUCT finished.')
function[]=ridgestruct_test
 
%reporttest('RIDGESTRUCT',aresame())



function[id,ii,jj,xr,fr]=ridgechains(fs,N,bool,x,f,dfdt,df_cutoff)
%RIDGECHAINS  Forms ridge curves by connecting transform ridge points.
%
%   [ID,IR,JR,WR]=RIDGECHAINS(N,BOOL,W) forms chains of ridge points
%   of wavelet transform W.  
%
%   Ridge points are all points of W for which BOOL, a matrix of the 
%   same size as W, equals one.  Only ridges of at least N periods in 
%   length are returned.
%   
%   ID is a unique ID number assigned to each ridge.  IR and JR are 
%   the time- and scale-indices along the ridges.  WR is the wavelet
%   transform along the ridge. 
% 
%   All output variables are the same size.
% 
%   See also RIDGEWALK.
%
%   Usage:  [id,ii,jj,xr]=ridgechains(N,bool,x);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2007 J.M. Lilly --- type 'help jlab_license' for details
 
% if strcmp(N, '--t')
%     ridgechains_test,return
% end

indexridge=find(bool);
[ii,jj]=ind2sub(size(bool),indexridge);
[ii,sorter]=sort(ii);
vindex(jj,indexridge,sorter,1);

%Using new algorithm as of November 2007, faster and also prevents ridge breaking

xr=x(indexridge);             %Transform value along ridge
fr=f(indexridge);             %Frequency along ridge
fsr=fs(jj);                   %Scale frequency along ridge
fr_next=fr+dfdt(indexridge);  %Predicted frequency at next point
fr_prev=fr-dfdt(indexridge);  %Predicted frequency at previous point

%figure,plot(ii,jj,'r.')
cumbool=cumsum(bool,2);
J=maxmax(cumbool(:,end));

[indexmat,nextindexmat,iimat,jjmat,fsmat,frmat,fr_nextmat,fr_prevmat]=vzeros(size(x,1),J,'nan');

%Indices for this point
indexmat(sub2ind(size(indexmat),ii,cumbool(indexridge)))=[1:length(ii)];
nonnanindex=find(~isnan(indexmat));

%Don't overwrite the original variables
[ii1,jj1,fsr1,fr1,fr_next1,fr_prev1]=vindex(ii,jj,fsr,fr,fr_next,fr_prev,indexmat(nonnanindex),1);
vindexinto(iimat,jjmat,fsmat,frmat,fr_nextmat,fr_prevmat,ii1,jj1,fsr1,fr1,fr_next1,fr_prev1,nonnanindex,0);
clear ii1 jj1 fsr1 fr1 fr_next1 fr_prev1

%Time difference from points here to next points
dii=vsum(vshift(iimat,1,1)-iimat,2);  %To get rid of nans

clear iimat

%Scale frequency difference from points here to next points
fsmat3=vrep(fsmat,J,3);
frmat3=vrep(frmat,J,3);

%Predicted minus actual frequency at this point
fr_nextmat3=vrep(fr_nextmat,J,3);
df1=abs(permute(vshift(frmat3,1,1),[1 3 2])-fr_nextmat3);
df1=frac(abs(df1),frmat3);

clear fr_nextmat3

%Expected minus actual frequency at next point
fr_prevmat3=vrep(fr_prevmat,J,3);
df2=abs(permute(vshift(fr_prevmat3,1,1),[1 3 2])-frmat3);
df2=frac(abs(df2),permute(vshift(frmat3,1,1),[1 3 2]));
df=frac(df1+df2,2);
df(df>df_cutoff)=nan;
clear fr_prevmat3 fr_mat3 df1 df2 

%Keep when they are the same 
%Set df to nan except when min along one direction
[mindf,jjmin]=min(permute(df,[1 3 2]),[],3);
iimin=vrep([1:size(df,1)]',size(df,2),2);
kkmin=vrep([1:size(df,2)],size(df,1),1);
df=nan*df;
df(sub2ind(size(df),iimin,jjmin,kkmin))=mindf;
clear iimin jjmin kkmin 

[mindf,jjmin]=min(df,[],3);
index=find(~isnan(mindf));

%Find the index into the index of the next point in the chain
if ~isempty(index)
    [ii2,jj2]=ind2sub(size(indexmat),index);
    index2=sub2ind(size(indexmat),ii2+1,jjmin(index));
    nextindexmat(index)=indexmat(index2);
end

id=nan*ii;
%Assign a unique number to all ridge points
for i=1:size(nextindexmat,1)
    id(nonnan(indexmat(i,:)))=nonnan(indexmat(i,:));
end

%Reassign number for linked points
for i=1:size(nextindexmat,1)
    id(nonnan(nextindexmat(i,:)))=id(indexmat(i,~isnan(nextindexmat(i,:))));
end

[id,sorter]=sort(id);
vindex(ii,jj,indexridge,xr,fr,sorter,1);
[id,ii,jj,indexridge,xr,fr]=ridgewalk_longridge(N,id,ii,jj,indexridge,xr,fr);


%/********************************************************
function[id,ii,jj,indexridge,xr,fr]=ridgewalk_longridge(N,id,ii,jj,indexridge,xr,fr)
%LONGRIDGES  Removes ridge lines of length than a specified length

if ~isempty(ii)
          
    %Remove ridges of less than a certain length
    [num,a,b]=blocknum(id);
    angr=unwrap(angle(xr));
    lena=frac(1,2*pi)*abs(angr(b)-angr(a));
    
    len1=zeros(size(id));
    len1(a)=lena;
    len1=cumsum(len1);
   
    len2=zeros(size(id));
    len2(a)=[0;lena(1:end-1)];
    len2=cumsum(len2);
    
    len=len1-len2;
    index=find(len>=N);
    vindex(id,ii,jj,indexridge,xr,fr,index,1); 
end

