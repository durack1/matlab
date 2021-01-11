function out=managecustom(action,varargin)
% MANAGECUSTOM A helper function for CFTOOL.

% MANAGECUSTOM stores the custom fittypes.

%   $Revision: 1.7.2.4 $  $Date: 2006/11/11 22:39:31 $
%   Copyright 1999-2006 The MathWorks, Inc.

% get (or create) the library
lib=cfgetset('customLibrary');
if isempty(lib)
   lib.names={};
   lib.fits={};
   lib.opts={};
end

out = '';

switch action
   
case 'set'
   name = varargin{1};
   eq = varargin{2};
   opts = varargin{3};
   
   ind = getFitIndex(lib,name);
   if isempty(ind)
      lib.names{end+1}=name;
      lib.fits{end+1}=eq;
      lib.opts{end+1}=opts;
   else
      lib.fits{ind}=eq;
      lib.opts{ind}=opts;
   end
   cfgetset('dirty',true);   % session has changed since last save
      
case 'delete'
   name = varargin{1};
   ind = getFitIndex(lib,name);
   lib.names(ind)=[];
   lib.fits(ind)=[];
   lib.opts(ind)=[];
   cfgetset('dirty',true);   % session has changed since last save

case 'get'
   name = varargin{1};
   ind = getFitIndex(lib,name);
   if ~isempty(ind)
      out=lib.fits{ind};
   else
      out=[];
   end

case 'getopts'
   name = varargin{1};
   ind = getFitIndex(lib,name);
   if ~isempty(ind)
      out = copy( lib.opts{ind} );
   else
      out=[];
   end

case 'getdetails'
   name = varargin{1};
   ind = getFitIndex(lib,name);
   if ~isempty(ind)
      eq=lib.fits{ind};
      fo=lib.opts{ind};
      % Pull out the first (an only) item in these two, since we
      % can only handle one dependent and one independent variable.
      indname=indepnames(eq);
      depname=dependnames(eq);
      if ~isempty(findprop(fo,'StartPoint'))
         startpoint=fo.StartPoint;
      else
         startpoint=[];
      end
      if ~isempty(findprop(fo,'Lower'))
         lower=fo.Lower;
      else
         lower=[];
      end
      if ~isempty(findprop(fo,'Upper'))
         upper=fo.Upper;
      else
         upper=[];
      end      
      out={
         formula(eq)
         indname{1}
         depname{1}
         coeffnames(eq)
         startpoint
         lower
         upper
         linearterms(eq)};
   else
      out=[];
   end

   
case 'list'
   out=lib.names';
   
end

% save the library
cfgetset('customLibrary',lib);

%===============================================================================
function ind=getFitIndex(lib,name)
ind = [];
names=lib.names;
for i=1:length(names)
   if isequal(names{i},name)
      ind = i;
      break;
   end
end
