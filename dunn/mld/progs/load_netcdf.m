% Load MLD maps into a netcdf file.  JRD 19/2/98
%
% INPUT
%   fnm - name of mat file to load from
%
% Mod 18/2/03 -  reduce from multiple MLD estimates to just one set of field

function load_netcdf(fnmi)


scfact = 0.01;
iFillValue_ = -32766;

load(fnmi)

ncquiet

fnm = 'mld_mapped_new.nc';
nc = netcdf(fnm,'clobber');

tmp = 'MLD mean and temporal harmonics';
disp(['Title: ' tmp])
nc.title = tmp;

if exist('details','var')
   tmp = ['Mixed Layer Depth seasonal fields by loess mapping: ' details];
elseif exist('Note','var')
   tmp = Note{1};
   for ii = 2:length(Note)
      tmp = [tmp ' ' Note{ii}];
   end
else
   tmp = '?';
end
disp(['Description: ' tmp])
ss = input('Input alternate Description if required: ','s');
if isempty(ss)
   nc.description = tmp;
else
   nc.description = ss;
end
nc.history = ['Created on ' date ' by Jeff Dunn, CSIRO Marine & Atmospheric Research, CAWCR'];

[status, w] = unix('whoami');
nc.author = w(1:end-1);
nc.date = datestr(now, 0);

% Define dimensions
if min(size(x))>1
   x = x(1,:);
   y = y(:,1)';
end
nc('lon') = length(x);
nc{'lon'} = ncfloat('lon');
nc{'lon'}.long_name = 'Longitude';
nc{'lon'}.cartesian_axis = 'X';
nc{'lon'}.units = 'degrees_east';
nc{'lon'}.ipositive = ncint(1);
nc{'lon'}(:) = x;

nc('lat') = length(y);
nc{'lat'} = ncfloat('lat');
nc{'lat'}.long_name = 'Latitude';
nc{'lat'}.cartesian_axis = 'Y';
nc{'lat'}.units = 'degrees_north';
nc{'lat'}.ipositive = ncint(1);
nc{'lat'}(:) = y;

% Define variables
% Note: doing a fudge here to get around a bug in the netcdf system. We are
% making up an attribute called SF, which will be renamed to scale_factor
% at the bottom of this code, because if we call it scale_factor now it will
% be forced to the same datatype as the corresponding variable (and .01 as
% a short is not very useful!).

nc{'mean'} = ncshort('lat','lon');
nc{'mean'}.long_name = 'mean mixed layer depth';
nc{'mean'}.units = 'meters';
nc{'mean'}.ipositive = ncshort(-1);
nc{'mean'}.positive = 'down';
nc{'mean'}.FillValue_ = ncshort(iFillValue_);
nc{'mean'}.add_offset = ncdouble(0);
nc{'mean'}.SF = ncdouble(scfact);

nc{'an_cos'} = ncshort('lat','lon');
nc{'an_cos'}.long_name = 'Cosine of annual signal';
nc{'an_cos'}.units = 'meters';
nc{'an_cos'}.ipositive = ncshort(-1);
nc{'an_cos'}.positive = 'down';
nc{'an_cos'}.FillValue_ = ncshort(iFillValue_);
nc{'an_cos'}.add_offset = ncdouble(0);
nc{'an_cos'}.SF = ncdouble(scfact);
    
nc{'an_sin'} = ncshort('lat','lon');
nc{'an_sin'}.long_name = 'Sine of annual signal';
nc{'an_sin'}.units = 'meters';
nc{'an_sin'}.ipositive = ncshort(-1);
nc{'an_sin'}.positive = 'down';
nc{'an_sin'}.FillValue_ = ncshort(iFillValue_);
nc{'an_sin'}.add_offset = ncdouble(0);
nc{'an_sin'}.SF = ncdouble(scfact);

if exist('sa','var')
   nc{'sa_cos'} = ncshort('lat','lon');
   nc{'sa_cos'}.long_name = 'Cosine of semi-annual signal';
   nc{'sa_cos'}.units = 'meters';
   nc{'sa_cos'}.ipositive = ncshort(-1);
   nc{'sa_cos'}.positive = 'down';
   nc{'sa_cos'}.FillValue_ = ncshort(iFillValue_);
   nc{'sa_cos'}.add_offset = ncdouble(0);
   nc{'sa_cos'}.SF = ncdouble(scfact);
    
   nc{'sa_sin'} = ncshort('lat','lon');
   nc{'sa_sin'}.long_name = 'Sine of semi-annual';
   nc{'sa_sin'}.units = 'meters';
   nc{'sa_sin'}.ipositive = ncshort(-1);
   nc{'sa_sin'}.positive = 'down';
   nc{'sa_sin'}.FillValue_ = ncshort(iFillValue_);
   nc{'sa_sin'}.add_offset = ncdouble(0);
   nc{'sa_sin'}.SF = ncdouble(scfact);
end

nc{'q_radius'} = ncshort('lat','lon');
nc{'q_radius'}.long_name = 'Data source radius (min axis of ellipse)';
nc{'q_radius'}.units = 'km';
nc{'q_radius'}.FillValue_ = iFillValue_;
nc{'q_radius'}.add_offset = 0;
nc{'q_radius'}.scale_factor = 1;
kk = find(isnan(rq));
rq(kk) = iFillValue_;
nc{'q_radius'}(:) = round(rq);
    
nc{'q_ndata'} = ncshort('lat','lon');
nc{'q_ndata'}.long_name = 'Number of data used in mapping';
nc{'q_ndata'}.units = 'counts';
nc{'q_ndata'}.FillValue_ = iFillValue_;
nc{'q_ndata'}.add_offset = 0;
nc{'q_ndata'}.scale_factor = 1;
kk = find(isnan(nq));
nq(kk) = iFillValue_;
kk = find(nq>32766);
nq(kk) = 32766;
nc{'q_ndata'}(:) = round(nq);

ff = find(isnan(mn));
mn = round(mn./scfact);
if ~isempty(ff)
   mn(ff) = iFillValue_;
end
nc{'mean'}(:) = mn;

tmp = round(real(an)./scfact);
ff = find(isnan(tmp));
if ~isempty(ff)
   tmp(ff) = iFillValue_;
end
nc{'an_cos'}(:) = tmp;

tmp = round(imag(an)./scfact);
ff = find(isnan(tmp));
if ~isempty(ff)
   tmp(ff) = iFillValue_;
end
nc{'an_sin'}(:) = tmp;

if exist('sa','var')
   tmp = round(real(sa)./scfact);
   ff = find(isnan(tmp));
   if ~isempty(ff)
      tmp(ff) = iFillValue_;
   end
   nc{'sa_cos'}(:) = tmp;

   tmp = round(imag(sa)./scfact);
   ff = find(isnan(tmp));
   if ~isempty(ff)
      tmp(ff) = iFillValue_;
   end
   nc{'sa_sin'}(:) = tmp;
end

nc = close(nc);

% Now repair the scale_factor attribute names, which were given a dummy name
% previously to stop the tricky 'netcdf' overloading system from mucking
% them up.

cdfid = ncmex('ncopen',fnm,'write');
rcode = ncmex('REDEF',cdfid);

vid = ncmex('ncvarid',cdfid,'mean');
rcode = ncmex('attrename',cdfid,vid,'SF','scale_factor');
vid = ncmex('ncvarid',cdfid,'an_cos');
rcode = ncmex('attrename',cdfid,vid,'SF','scale_factor');
vid = ncmex('ncvarid',cdfid,'an_sin');
rcode = ncmex('attrename',cdfid,vid,'SF','scale_factor');
if exist('sa','var')
   vid = ncmex('ncvarid',cdfid,'sa_cos');
   rcode = ncmex('attrename',cdfid,vid,'SF','scale_factor');
   vid = ncmex('ncvarid',cdfid,'sa_sin');
   rcode = ncmex('attrename',cdfid,vid,'SF','scale_factor');
end

rcode = ncclose(cdfid);

% --------------- End load_netcdf.m -----------------
