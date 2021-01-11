% Given two sets of correlation fields, plot the regions of non-trivial +ve 
% and -ve correlations, and fade colour through gaps between regions.
%
% To produce a legend (since colorbar is not useful), use
%  [x,y]=meshgrid(-1:.05:1,-1:.05:1);
%  reg_map(x,y,[-1 1 -1 1]);
%
% OUTPUT: Plots to current figure.
% 
% Jeff Dunn 2-Nov-2000 
%
% USAGE: reg_map(corrn,corrm,region)

function reg_map(corrn,corrm,region)

maxstep = 3;
tr1 = .2;

idx=repmat(0,size(corrn));

ii=find(corrm>tr1 & corrn>tr1);
idx(ii) = repmat(4,size(ii)); 

ii=find(corrm<-tr1 & corrn>tr1);
idx(ii) = repmat(3,size(ii)); 

ii=find(corrm>tr1 & corrn<-tr1);
idx(ii) = repmat(2,size(ii)); 

ii=find(corrm<-tr1 & corrn<-tr1);
idx(ii) = repmat(1,size(ii)); 

gg = find(idx);
step = zeros(size(idx));
step(gg) = repmat(maxstep,size(gg));
   
[m,n] = size(idx);
[x,y] = meshgrid(1:n,1:m);

for stp = maxstep:-1:2
   gg = find(step==stp);
   tmp_idx = idx;
   % Step through all the filled points which may have vacant neighbours
   for ig = gg(:)'
      % Find and step through vacant neighbours for this point
      ii = find(abs(x-x(ig))<=1 & abs(y-y(ig))<=1 & ~idx);
      for jg = ii(:)'
	 % Find other-case next neighbours, but not idx=0 {vacant} and not step=0
	 jj = find(abs(x-x(jg))<=1 & abs(y-y(jg))<=1 & idx & idx~=idx(ig) & step);
	 if isempty(jj)
	    step(jg) = stp-1;
	 end	 
	 tmp_idx(jg) = idx(ig);
      end
   end
   idx = tmp_idx;
end


jdx = zeros(size(idx));
gg = find(step);
jdx(gg) = ((idx(gg)-1)*(maxstep+1))+(step(gg)+1);
mxtot = max(jdx(:));

gg = find(isnan(corrn));
jdx(gg) = repmat(mxtot+1,size(gg));

% fillpage

imagesc(region([1 2]),region([4 3]),flipud(jdx),[1 mxtot+1])
axis xy

cc = .9*ones(mxtot+1,3);

cct(1,:) = [1 .9 0];
cct(2,:) = [0 .9 0];
cct(3,:) = [0 0 .9];
cct(4,:) = [.9 0 0];

ntick = (1:4)*(maxstep+1);

for ii = 1:4
   dd = ([1 1 1]-cct(ii,:))/maxstep;
   for jj = 1:maxstep
      cc((maxstep+1)*(ii-1)+(jj+1),:) = [1 1 1]-dd*jj;
   end
end
cc(mxtot+1,:) = [0 0 0];

colormap(cc);


%hh=colorbar;
%set(hh,'YTick',ntick)
%set(hh,'YTickLabel',['1';'2';'3';'4'])

%mapmask
