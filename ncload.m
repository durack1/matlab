function theResult = ncload(theNetCDFFile, varargin)

% ncload -- Load NetCDF variables.
%  ncload('theNetCDFFile', 'var1', 'var2', ...) loads the
%   given variables of 'theNetCDFFile' into the Matlab
%   workspace of the "caller" of this routine.  If no names
%   are given, all variables are loaded.  The names of the
%   loaded variables are returned or assigned to "ans".
%   No attributes are loaded.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 18-Aug-1997 10:13:57.
% Modifications: 
% looks for missing_value or FillValue_ and replaces it
% with NaN's (Martin Losch, 25-Oct-1999)
% assigns values not to 'base' Workspace but to 'caller''s Workspace,
% that way ncload can be called from within functions (Martin Losch,
% 25-Oct-1999) 

% Version 21-Sept-2005
  % Modifications:
% look for scale_factor and add_offset to rescale variable.
% Bernadette Sloyan

if nargin < 1, help(mfilename), return, end

result = [];
if nargout > 0, theResult = result; end

f = netcdf(theNetCDFFile, 'nowrite');
if isempty(f), return, end

if isempty(varargin), varargin = ncnames(var(f)); end

for i = 1:length(varargin)
   if ~isstr(varargin{i}), varargin{i} = inputname(i+1); end
   oldvalues = f{varargin{i}}(:);
   spval = f{varargin{i}}.missing_value(:);

   if isempty(spval);
     spval = f{varargin{i}}.FillValue_(:);
   end
   values = oldvalues;
   if ~isempty(spval)
     replace = find(oldvalues == spval);
     nreplace = length(replace);
     if nreplace>0
       values(replace) = NaN*ones(1,nreplace);
     end %if

% Rescale the byte type data which was not done automatically by scale_factor 
% and add_offset given in nc file.

%if vartypv == nc_byte
  spval = f{varargin{i}}.scale_factor(:);
  if ~isempty(spval)
    values = values*spval;
  end
 spval = f{varargin{i}}.add_offset(:);
  if ~isempty(spval)
    values = values + spval;
  end
%end


   end %if

   assignin('caller', varargin{i}, values)
end

result = varargin;

close(f)

if nargout > 0
   theResult = result
else
   ncans(result)
end
