function [sns,tns,pns,dsns,dtns,dpns] = nsfcs(s,t,p,g,glevels)

%%% NEUTRAL_SURFACES:	Fit neutral surfaces to hydrographic data
%%%
%%%	USAGE:		[sns,tns,pns,dsns,dtns,dpns] = nsfcs(s,t,p,g,glevels)
%%%
%%%	DESCRIPTION:	For a section of hydrographic data which has been 
%%%			labelled with the neutral density variable gamma_n,
%%%			find the salinities, temperatures and pressures
%%%			on specified neutral density surfaces.
%%%
%%%	PRECISION:	Double
%%%
%%%	INPUT:		s       matrix of salinity (each column being a cast)
%%%			t       matrix of in-situ temperatures 
%%%			p	matrix of pressures
%%%			g	matrix of labelled gamma_n values
%%%			glevels	vector of gamma_n values defining the neutral
%%%				surfaces
%%%
%%%			NOTE:	missing values must be denoted by NaN's
%%%
%%%	OUTPUT:		sns	matrix of salinities on neutral surfaces
%%%			tns 	matrix of surface in situ temperatures
%%%			pns	matrix of surface pressures
%%%			dsns	matrix of surface salinity errors
%%%			dtns	matrix of surface temperature errors
%%%			dpns	matrix of surface pressure errors
%%%
%%%				sns, tns and pns values of -99.0
%%%				denotes under or outcropping
%%%
%%%				non-zero dsns, dtns and dpns values
%%%				indicate multiply defined surfaces,
%%%				and file 'ns_multiples.dat' contains
%%%				information on the multiple solutions
%%%
%%%	UNITS:		salinity	psu (IPSS-78)
%%%			temperature	degrees C (IPTS-68)
%%%			pressure	db
%%%			gamma_n		kg m-3
%%%
%%%
%%%	AUTHOR:		David Jackett
%%%
%%%	CREATED:	October, 1994
%%%
%%%	REVISION:	2.1		26/4/95
%%%



%%%
%%%		check # arguments and initialize
%%%

if nargin ~= 5
  error('ERROR in neutral_surfaces.m: invalid input arguments')
end

[nz,nx] = size(s);

ng = length(glevels);

sns = nan*zeros(ng,nx);
tns = nan*zeros(ng,nx);
pns = nan*zeros(ng,nx);
dsns = nan*zeros(ng,nx);
dtns = nan*zeros(ng,nx);
dpns = nan*zeros(ng,nx);
index = nan*zeros(nz,nx);

if nz == 1
  error('ERROR in neutral_surfaces.m: only one bottle on each cast')
else
  np = sum(~isnan(s+t+p));
end

for ix = 1:nx
  index(1:np(ix),ix) = find(~isnan(s(:,ix)+t(:,ix)+p(:,ix)));
end


%%%
%%%		save appropriate arrays
%%%


savearray = [];
for ix = 1:nx
  n = np(ix);
  savearray = [savearray; ...
               n 0 0 0; ...
               s(index(1:n,ix),ix) t(index(1:n,ix),ix) ...
	       p(index(1:n,ix),ix) g(index(1:n,ix),ix)];
end

savelevels = [ng;glevels(:)];


%% 		find path to Matlab code

zgamma = evalc('which gamma_n');

gamma_path = zgamma(1:length(zgamma)-11);

zpwd = pwd;

command = ['cd ', gamma_path]; eval(command);


save ns-m-lvls.in savelevels -ascii -double
save ns-m-stpg.in savearray -ascii -double


%%%
%%%		run external code
%%%

command = ['!./nsfces_matlab'];

eval(command);

load nsfces_matlab1.out
load nsfces_matlab2.out

delete ns-m-lvls.in ns-m-stpg.in nsfces_matlab1.out nsfces_matlab2.out


command = ['cd ',zpwd]; eval(command);


%%%
%%%		assemble surface information
%%%

sns = reshape(nsfces_matlab1(:,1),ng,nx);
tns = reshape(nsfces_matlab1(:,2),ng,nx);
pns = reshape(nsfces_matlab1(:,3),ng,nx);

dsns = reshape(nsfces_matlab2(:,1),ng,nx);
dtns = reshape(nsfces_matlab2(:,2),ng,nx);
dpns = reshape(nsfces_matlab2(:,3),ng,nx);


