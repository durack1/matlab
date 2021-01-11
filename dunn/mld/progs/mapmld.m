% NOTE: Before next use, 

% Map MLD from BOA MLD files

% MODS: 25/9/08  Add WOD05, convert to chunking in x and y. 

%dsets = [7  9  11 13  19  21  22  23  24  31  35];
%dsets = [7  9  11 13  19  21  22  23  31  35];
dsets = [7  9  11 13  19  31  35  41  42  43];

[x,y] = meshgrid(0:.5:360,-75:.5:90);

% Process by 10degree chunks
[xch,ych] = meshgrid(5:10:365,-75:10:85);

mn = repmat(nan,size(x));
rq = repmat(nan,size(x));
nq = repmat(nan,size(x));

%dw = [];
fns = [1 0];
%bar = 1;
%scrn = 0;

if fns(1)==1
   an = repmat(i*nan,size(x));
end
if fns(2)==1
   sa = repmat(i*nan,size(x));
end

%% NOTE: Option 14 (Q) is base number, inflated if fitting any temporal fns.
%% 300 will be inflated to 450 for fns=[1 0] 
%fopt = [  1   3   13  14   40];
%fval = {400, 1.5, 4, 350, 'MLD from Argo and unscreened WOD05'};
xw = 1.5;

ym = 12;  % Chunk margin to roughly allow for 1500km data radius

ncc = prod(size(xch));

hwb = waitbar(0,'MLD mapping');

for cc = 1:ncc
   waitbar(cc/ncc,hwb);
   
   xm = xw*ym/latcor(ych(cc));   
   if xm>50; xm=50; end    % High lat cap
   
   chnk = [xch(cc)-5 xch(cc)+5 ych(cc)-5 ych(cc)+5];
   if chnk(2)==360; chnk(2)=360.1; end
   if chnk(4)==90; chnk(4)=90.1; end
   
   ig = find(x>=chnk(1) & x<chnk(2) & y>=chnk(3) & y<chnk(4));

   [la,lo,tim,mld] = deal([]);
   
   for ids = dsets
      load(['/home/oez5/eez_data/mld/mlds_' num2str(ids)]);
      id = find(lon>chnk(1)-xm & lon<chnk(2)+xm & lat>chnk(3)-ym & lat<chnk(4)+ym);
      ii = id(find(flgs(id,1)==2 & flgs(id,2)==2));
      if ~isempty(ii)
	 la = [la; vec(lat(ii))];
	 lo = [lo; vec(lon(ii))];
	 tim = [tim; vec(time(ii))];
	 %mld = [mld; mlds(ii,5)];
	 mld = [mld; vec(MLD(ii))];
      end
   end
   
   doy = time2doy(tim);   
   
   %[mni,rqi,nqi,ani] = loess_map(x(ig),y(ig),lo,la,dd,doy,dw,fns,bar,scrn, ...
   %				 fopt,fval); 
   [mni,rqi,nqi,ani] = loess(mld,lo,la,x(ig),y(ig),doy,[1 3 4 8 11],...
			     [500 400 2 1.5 0]); 
   mn(ig) = mni;
   rq(ig) = rqi;
   nq(ig) = nqi;
   an(ig) = ani;
   %sa(ig) = sai;
end

x = x(1,:); y=y(:,1)';

Note= {'CARS MLD. Mapped from BOA profiles using var MLD, which is min',
'of mlds(1) and mlds(2), that is, abs(t-t(10m)) > 0.2 and ',
'abs(s-s(10m)) > 0.03. Mapped using mapmld from dsets 7,9,11,13,19,31,35,',
'41,42,43 - ie WOD05 (Jul08 update), Argo, WOCE, and other. Loess options',
'Q=500 rmin=400 bogus=2 xw=1.5. Mean capped at 2. Seasonal -ve NOT',
' suppressed because better to cap MLD after evaluation of seasonal component.',
[' Jeff Dunn CMAR/CACWR ' date]};

addpath /home/dunn/eez/postmap

% Suppress -ve mean or seasonal MLD (in fact, limit MLD at 3m)
mn_orig = mn;
%# [mn,an] = season_nonneg(mn-3,an);
%# mn = mn+3;
mn(mn<2) = 2;

save mldmap_out mn mn_orig rq nq an x y Note

disp('Need to infill the arctic?')
% If map only to 85N, infill by extending the grid,

do_infill = 0;

if do_infill & max(y)==85
   iprev = length(y);
   y = [y 85.5:.5:90];
   ipole = length(y);
   mn = [mn; repmat(nan,[10 721])];
   an = [an; repmat(nan,[10 721])];
   nq = [nq; repmat(nan,[10 721])];
   rq = [rq; repmat(nan,[10 721])];
   
   %mn(ipole,:) = .8*mean(mn(iprev,:));
   %an(ipole,:) = .8*mean(an(iprev,:));

   % Eyeballing all data in the area, very inconclusive but mean of majority
   % of data is around 15-20m as approach the pole, but a scatter towards
   % ~120m. Not possible to discern seasnal cycle, esp as no data from winter
   % of course. Conservatively phase to zero annual cycle at pole.
   mn(ipole,:) = 20;
   an(ipole,:) = 0;
   
   ii = iprev+1:ipole-1;
   mn(ii,:) = interp1([85 90],mn([iprev ipole],:),y(ii));
   an(ii,:) = interp1([85 90],an([iprev ipole],:),y(ii));
end
