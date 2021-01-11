function [sns,tns,pns,dsns,dtns,dpns] = nsfcs(s,t,p,g,glevels)

%%%  NSFCS:  		Fit neutral surfaces to hydrographic data
%%%		
%%%  USAGE:         [sns,tns,pns,dsns,dtns,dpns] = 
%%%                                         nsfcs(s,t,p,g,glevels)
%%%
%%%  DESCRIPTION:   For a section of hydrographic data which has been 
%%%                 labelled with the neutral density variable gamma_n,
%%%                 find the salinities, temperatures and pressures
%%%                 on specified neutral density surfaces.
%%%
%%%  PRECISION:     Single
%%%
%%%  INPUT:         s   	matrix of salinity (each column being a cast)
%%%                 t   	matrix of in-situ temperatures 
%%%                 p   	matrix of pressures
%%%                 g   	matrix of labelled gamma_n values
%%%                 glevels vector of gamma_n values defining the
%%%                 		neutral surfaces
%%%
%%%                 NOTE:   missing values must be denoted by NaN's
%%%
%%%  OUTPUT:        sns 	matrix of salinities on neutral surfaces
%%%                 tns     matrix of surface in situ temperatures
%%%                 pns 	matrix of surface pressures
%%%                 dsns    matrix of surface salinity errors
%%%                 dtns    matrix of surface temperature errors
%%%                 dpns    matrix of surface pressure errors
%%%
%%%                 NOTE:	sns, tns and pns values of -99.0
%%%                 		denotes under or outcropping
%%%
%%%           				non-zero dsns, dtns and dpns values
%%%                 		indicate multiply defined surfaces,
%%%                 		and file 'ns_multi.dat' contains
%%%                 		information on the multiple solutions
%%%
%%% UNITS:          salinity    	psu (IPSS-78)
%%%                 temperature 	degrees C (IPTS-68)
%%%                 pressure    	db
%%%                 gamma_n     	kg m-3
%%%
%%%
%%% AUTHOR:         David Jackett
%%%
%%% CREATED:        October, 1994
%%%
%%% REVISION:       3.2     6/3/97
%%%



%%%
%%%     check # arguments and initialize
%%%

if nargin ~= 5
  error('ERROR in nsfcs.m: invalid input arguments')
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
  error('ERROR in nsfcs.m: only one bottle on each cast')
else
  np = sum(~isnan(s+t+p));
end

for ix = 1:nx
  index(1:np(ix),ix) = find(~isnan(s(:,ix)+t(:,ix)+p(:,ix)));
end


%%%
%%%     save appropriate arrays
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

save ns1.in savelevels -ascii
save ns2.in savearray -ascii


%%%
%%%     run external code
%%%

command = ['!if exist ns_multi.dat del ns_multi.dat'];
eval(command);

command = ['!nsfcs_m']; eval(command);

load nsfcs1.out; load nsfcs2.out

delete ns1.in ns2.in nsfcs1.out nsfcs2.out

command = ['!if exist ns_multi.dat move /y ns_multi.dat ',zpwd];
eval(command);

command = ['cd ',zpwd]; eval(command);


%%%
%%%     assemble surface information
%%%

sns = reshape(nsfcs1(:,1),ng,nx);
tns = reshape(nsfcs1(:,2),ng,nx);
pns = reshape(nsfcs1(:,3),ng,nx);

dsns = reshape(nsfcs2(:,1),ng,nx);
dtns = reshape(nsfcs2(:,2),ng,nx);
dpns = reshape(nsfcs2(:,3),ng,nx);


