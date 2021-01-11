% Given two sets of correlation fields, plot the regions of non-trivial +ve 
% and -ve correlations.
%
% To produce a legend (since colorbar is not useful), use
%  [x,y]=meshgrid(-1:.05:1,-1:.05:1);
%  reg_map(x,y,[-1 1 -1 1]);
% 
% INPUT: thr  Correlation threshold eg .3 gives categories <-.3 & >.3
%
% OUTPUT: Plots to current figure.
% 
% Jeff Dunn 2-Nov-2000 
%
% USAGE: reg_map(corrn,corrm,region,thr)

function reg_map(corrn,corrm,region,thr)

[m,n] = size(corrn);
ginc = (region(2)-region(1))/(n-1);
region = region + [ginc -ginc ginc -ginc]/2;

idx=repmat(2,size(corrn));

ii=find(corrm>thr & corrn>thr);
idx(ii) = repmat(6,size(ii)); 

ii=find(corrm<-thr & corrn>thr);
idx(ii) = repmat(5,size(ii)); 

ii=find(corrm>thr & corrn<-thr);
idx(ii) = repmat(4,size(ii)); 

ii=find(corrm<-thr & corrn<-thr);
idx(ii) = repmat(3,size(ii)); 

gg = find(isnan(corrn));
idx(gg) = repmat(1,size(gg));

% fillpage

imagesc(region([1 2]),region([4 3]),flipud(idx),[1 6])
axis xy

cc(1,:) = [0 0 0];
cc(2,:) = [.85 .85 .85];
cc(3,:) = [1 .9 0];
cc(4,:) = [0 .9 0];
cc(5,:) = [0 0 .9];
cc(6,:) = [.9 0 0];

colormap(cc);


%hh=colorbar;
%set(hh,'YTick',ntick)
%set(hh,'YTickLabel',['1';'2';'3';'4'])

%mapmask
