% DRIVE_MIXLD:  Version of drive_mixld_boa.m, for which you need to provide
%        the data rather than just specify the dataset codes.

function drive_mixld(lat,lon,bdep,stn,t,s,dep,time,dset)

if nargin<6
   disp('On 24/4/08 drive_mixld was renamed to drive_mixld_boa.')
   disp('The new drive_mixld requires 6 arguments.   ABORTING')
   return
end
if nargin<9 || isempty(dset)
   dset = 99;
   disp('Dataset not specified (for output name) - so setting to 99')
end

[ncast,ndep] = size(t);   
if length(lat)~=ncast
   error('Wrong argument dims')
end
   
lms = [.2 .03 .06 .003 20 .4 .06];

note = {'MLD is min of mlds 1-2. This is designed for excluding ML waters',
	'from T/S mapping - a better est for bio work maybe min([2 4])',
	['mlds(1) is interp depth of abs(t-t(10m))=' num2str(lms(1))],
	['mlds(2) is interp depth of abs(s-s(10m))=' num2str(lms(2))],
	['mlds(3) is first depth of abs(D-D(10m))=' num2str(lms(3))],
	[' OR dDdz > ' num2str(lms(4)) ', where D=sw_dens0'],
	['mlds(4) is interp depth of abs(t-t(10m))=' num2str(lms(6))],
	['mlds(5) is first depth of abs(D-D(10m))=' num2str(lms(7))],
	'--- Flags:', 
	'  -3 = cast too small or no ref value',
	'  -1 = falls in too big a gap',
	'   0 = not enough data',
	'   2 = good',
	'   9 = deeper than profile which nearly full water depth'};
	

mlds = repmat(single(nan),ncast,5);
flgs = zeros(ncast,5,'int8');
MLD = repmat(single(nan),ncast,1);
pdep = repmat(single(nan),ncast,1);

for ii = 1:ncast
   [tmpm,tmpf,pd] = mixld(t(ii,:),s(ii,:),dep(ii,:),...
			  lat(ii),lon(ii),bdep(ii),lms,0);
   mlds(ii,:) = tmpm';
   flgs(ii,:) = tmpf';
   MLD(ii) = min(tmpm(1:2));
   pdep(ii) = pd;
end

fnm = ['mlds_' num2str(dset) '_new']; 
save(fnm,'note','lat','lon','time','stn','mlds','MLD','flgs','pdep');

%-----------------------------------------------------------------------------

