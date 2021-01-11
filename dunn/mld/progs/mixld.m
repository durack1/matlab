% MIXLD   Calculate mixed-layer depth for a cast 
%  (developed from ~/mld/mixld.m 2004-07-23, copied on 05-09-22, which was
%   cut-down from mld_mod.m)
%
% INPUT:  
%   T   temperature observations (arbitrarily spaced)
%   S   corresponding S values, if available
%   deps  corresponding depths of observations
%   la  latitude of cast
%   lo  longitude of cast
%   bdep   depth of ocean bottom at cast location (*** +ve downwards) 
%   lims   [delT  delS  delD  dDdZ  intplim] 
%   plots   [optional]  1= do plots for each successful MLD calculation
% OUTPUT:
%   mld   [5 1] The estimate of mixed-layer depth
%   flg   [5 1] For each estimate: 
%	       -3 = cast too small or no ref value,
%              -1=detected but in a >20m gap, so ignored
%               0=none   
%               2=good  
%               9=not found so used water depth.
%
% The mixed layer estimates:
% 1)  abs(t(10m)-t) > delT  (def 0.2C) 
% 2)  abs(s(10m)-s) > delS  (def .03)
% 3)  dSigma/dz (below 10m) >= dDdZ OR abs(sigma(10m)-sigma) > delD
%            (def 0.003  and .06)
% 4)  abs(t(10m)-t) > delT2  (def 0.4C)      Secondary T threshold
% 5)  abs(sigma(10m)-sigma) > delD (def .06)  Bronte's criterion
%
%  Linear interpolate to depth across gaps up to intplim m (def 20)
%  
%  Notes: 
% #  For 1 start at first value beneath 8m, but fail if that is below
%    24m.
% #  For 1 & 2 the required T or S difference is usually straddled. Fail
%    if gap is 20m or more. We quadratic interpolate the MLD, assuming a +ve
%    d2t/d2z in larger gaps.
%
% Mods from original mixld.m:
%  - add flags
%
% USAGE: [mld,flg,pd] = mixld(T,S,deps,la,lo,bdep,lims,plots);

function [mld,flg,pd] = mixld(T,S,deps,la,lo,bdep,lims,plots)

if nargin>=7 & length(lims)>=5
   delT = lims(1);
   delS = lims(2);
   delD = lims(3);
   dDdZ = lims(4);
   intplim = lims(5);   
   if length(lims)==7
      delT2 = lims(6);
      delD2 = lims(7);
   else
      delT2 = .4;
      delD2 = .06;
   end
else
   delT = .2;
   delS = .03;
   delD = .06;
   dDdZ = .003;
   intplim = 20;
   delT2 = .4;
   delD2 = .06;
end

pd = nan;
mld = [nan nan nan nan nan]';
flg = [0 0 0 0 0]';

d2m = (0:2:450)'; 
tref3 = 0;
sref2 = 0;
tpro = [];
spro = [];
dens = [];


% Used to return straight away if cast is non-monotonic in depth. Now
% attempt repairs

ll = find(~isnan(deps));
if any(diff(deps(ll))<=0)
   nd = length(ll);
   mm = find(deps(ll(2:nd))<=deps(ll(1:(nd-1))));
   deps(ll(mm+1)) = nan;
   ll = ~isnan(deps);
   if any(diff(deps(ll))<=0)
      % Could not fix it
      return
   end
end

if nargin<7
   plots = 0;
end

% idxo is index into original cast data
idxo = find(~isnan(T) & ~isnan(deps));

ngood = length(idxo);
    
if ngood > 3 & deps(idxo(ngood)) > 24
   tpro = deps_to_2m(deps(idxo),T(idxo),450,-1);
   
   % MLD 1 - using change in temperature wrt a near-surface value,  
   % which is the first >= 10m. 
   
   i2r = find(~isnan(tpro(2:end)))+1;
   l2r = length(i2r);
   if l2r > 1
      [rfdel10,refidx] = min(abs(d2m(i2r)-10));
      i2r = i2r(refidx:end);
      pd = d2m(i2r(end));
   end

   % Only proceed if have a suitable reference value above 25m, and at 
   % least 1 value below it. 
   % What is the appropriate delT depth? the one above, or below, or linearly 
   % interpolated? The bulk of cases should have t(z) curving near bottom
   % of ML so that an interpolated value would be too shallow. Counter 
   % this by a quadratic instead of linear interpolation.  

   if l2r > 1 & rfdel10 < 14    
      kk = find(abs(tpro(i2r)-tpro(i2r(1))) > delT);  
      if ~isempty(kk)
	 k1 = i2r(kk(1)-1);
	 k2 = i2r(kk(1));
	 if tpro(k1)>tpro(k2)
	    tref3=tpro(i2r(1))-delT;
	 else 
	    tref3=tpro(i2r(1))+delT;
	 end
	 depdif = d2m(k2)-d2m(k1);
	 if depdif < intplim
	    tratio = (tref3-tpro(k2))/(tpro(k1)-tpro(k2)); 
	    mld(1) = d2m(k2) - depdif*(tratio^2);
	    flg(1) = 2;
	 else
	    flg(1) = -1;
	 end
      elseif abs(bdep-d2m(i2r(end)))<=20 & bdep>10
	 mld(1)=min(450,bdep);
	 flg(1) = 9;
      end

      kk = find(abs(tpro(i2r)-tpro(i2r(1))) > delT2);  
      if ~isempty(kk)
	 k1 = i2r(kk(1)-1);
	 k2 = i2r(kk(1));
	 if tpro(k1)>tpro(k2)
	    tref3=tpro(i2r(1))-delT2;
	 else 
	    tref3=tpro(i2r(1))+delT2;
	 end
	 depdif = d2m(k2)-d2m(k1);
	 if depdif < intplim
	    tratio = (tref3-tpro(k2))/(tpro(k1)-tpro(k2)); 
	    mld(4) = d2m(k2) - depdif*(tratio^2);
	    flg(4) = 2;
	 else
	    flg(4) = -1;
	 end
      elseif abs(bdep-d2m(i2r(end)))<=20 & bdep>10
	 mld(4)=min(450,bdep);
	 flg(4) = 9;
      end
      % I don't believe in MLs deeper than 450m, so if haven't detected one
      % here, then assume it was a missed subtle one, so do not set to 450
      % but leave as NaN.      
   else
      flg(1) = -3;
      flg(4) = -3;
   end
end    

% Calculation of mld due to a change in salinity.
% Use only if there is more than three valid points, where the 
% first point is at or below 10 m and the last is at or below 30 m
% Use deps_to_2m to estimate interpolated salinity 
% If there is a gap between sucessive data points greater than 10m
% then do not use any values below the gap

idxo = find(~isnan(S) & ~isnan(deps));
ngood = length(idxo);

if ngood > 3 & ~isempty(tpro)
   if deps(idxo(ngood)) >= 30
      spro = deps_to_2m(deps(idxo),S(idxo),450,-1);
      i2m = find(~isnan(spro) & ~isnan(tpro));
      l2m = length(i2m);
      gsize = i2m(2:l2m)-i2m(1:l2m-1);
      bigg = find(gsize>5);
      if ~isempty(bigg)
	 i2m = i2m(1:bigg(1));
	 l2m = length(i2m);
      end
   end 
end

if ~isempty(spro)
   j2m = find(~isnan(spro(6:end)))+5;
   l2m = length(j2m);
   if ~isempty(j2m)
      refidx=j2m(1);
   end

   % Only proceed if we have a reference value above 25 m and at least
   % one value below it.
   % sref is determined by using quadratic interpolation.

   if l2m > 1 & d2m(refidx) < 25
      kk = find((abs(spro(j2m)-spro(refidx)))>delS);  
      if ~isempty(kk)
	 k1 = j2m(kk(1)-1);
	 k2 = j2m(kk(1));
	 if spro(k1)>spro(k2)
	    sref2=spro(refidx)-delS;
	 else 
	    sref2=spro(refidx)+delS;
	 end
	 depdif = d2m(k2)-d2m(k1);
	 if depdif < intplim
	    sratio = (sref2-spro(k2))/(spro(k1)-spro(k2));
	    mld(2) = d2m(k2) - depdif*(sratio^2);
	    flg(2) = 2;
	 else
	    flg(2) = -1;
	 end
      elseif abs(bdep-d2m(j2m(end)))<=20 & bdep>10
	 mld(2) = min(450,bdep);
	 flg(2) = 9;
      end


      % dSigma/dz
      % DID use sw_dens, which calculates density including the depth effect.
      % Decided to use sw_dens0 so that could use a lower threshold (than .01
      % as previously used) and so be more sensitive to changes in t & s.
      % This test often trips near surface, so start it (index k2m) at 16m.
      % Tried .006 but a lot of real MLs were missed (on test Fr 10/94).
      
      k2m = j2m(find(j2m>=8));
      if length(k2m) >= 2
	 dens = sw_dens0(spro(k2m),tpro(k2m));
	 dsdz = diff(dens)./(2*diff(k2m));
	 kk = find(abs(dsdz) > dDdZ | abs(dens(2:end)-dens(1)) > delD);

	 if ~isempty(kk)
	    mld(3) = d2m(k2m(kk(1)));
	    flg(3) = 2;
	 elseif abs(bdep-d2m(k2m(end)))<=20 & bdep>10
	    mld(3) = min(450,bdep);
	    flg(3) = 9;
	 end
	 kk = find(abs(dens(2:end)-dens(1)) > delD2);
	 if ~isempty(kk)
	    mld(5) = d2m(k2m(kk(1)));
	    flg(5) = 2;
	 elseif abs(bdep-d2m(k2m(end)))<=20 & bdep>10
	    mld(5) = min(450,bdep);
	    flg(5) = 9;
	 end
      else
	 flg(3) = -3;
	 flg(5) = -3;
      end
   end
else
   k2m = [];
end



% Now plot the results

if plots & all(~isnan(mld))
%if plots & any(~isnan(mld))
   clf
   subplot(1,3,1);
   plot(T,-deps,'go');
   axis([nanmin(tpro)-.3 nanmax(tpro)+.3 -450 0])
   hold on
   if ~isempty(tpro)
      plot(tpro,-d2m,'b');
   end
   plot(tref3,-mld(1),'k+');
   title('Temp. Pro. (mld(1))');
   xlabel(['[' num2str([lo la]) ']    Bottom ' num2str(bdep)]);   

   
   if ~isnan(min(mld)) & ~isempty(k2m)
      tmp = min(mld);
      subplot(1,3,2);
      if ~isempty(dens)
	 plot(dens,-d2m(k2m)); hold on
	 plot(dens(kk),-d2m(k2m(kk)),'r.'); hold on
	 plot([nanmin(dens)-.1 nanmax(dens)+.1],-[tmp tmp],'k-');
	 plot([nanmin(dens)-.1 nanmax(dens)+.1],-[mld(3) mld(3)],'m-');
	 axis([nanmin(dens)-.1 nanmax(dens)+.1 -450 0]);
	 title('Density Pro. (mld(3))');
      end
   end

   subplot(1,3,3);
   plot(S,-deps,'go'); hold on
   if ~isempty(spro) & ~isempty(j2m)
      plot(spro,-d2m,'g');
      plot(sref2,-mld(2),'r+');
      title('Salinity Pro. (mld(2))');
      axis([nanmin(spro(j2m))-.1 nanmax(spro(j2m))+0.1 -450 0]);
   end
  
   
   rr = input([num2str(mld(:)') '	P to print, any key to continue:'],'s');
   if ~isempty(rr) & (rr=='p' | rr=='P')
      print -dps tmp
      !lpr tmp.ps
   end
end

%----------------------------------------------------------------------
