function [cftoolFit, results, isgood, hint]=cftoolcreatefit(cftoolFit,panel,method,normalize,arg1,dataset,outlier,fitname)

% $Revision: 1.1.6.5 $  $Date: 2006/11/11 22:39:30 $
% Copyright 2001-2006 The MathWorks, Inc.

% convert the java UDDObject to something that m-code likes
% and set new properties.
cftoolFit=handle(cftoolFit);
cftoolFit.name=fitname;
cftoolFit.dataset=dataset;
cftoolFit.outlier=outlier;

% define a couple of useful variables
thefitdb=getfitdb;
dataset=find(getdsdb,'name',cftoolFit.dataset);

% clear everything out
cftoolFit.plot=0;
convmsg = [];

% pull the new fitoptions to use from where they have been stored on the fitdb
fitOptions=thefitdb.newOptions;

% set normalize
fitOptions.Normalize = normalize;

% convert the custom method string into the corresponding fittype object
if length(method) > 7 && isequal(method(1:8),'custom: ')
   equationName=method(9:end);
   method = managecustom('get',equationName);
end

% set (or clear) the smoothing parameter
if isequal(method,'smoothing')
   sp=str2double(arg1);
   if ~isnan(sp)
      fitOptions.smoothingparam=sp;
   else
      fitOptions.smoothingparam=[];
   end
end

% Set up other fitoptions
fitOptions.weights=dataset.weight;

% if this method has a display, turn it off
if ~isempty(findprop(fitOptions,'Display'))
   fitOptions.Display='off';
end

% Exclude points if requested
if ~isequal(cftoolFit.outlier,'(none)')
   outset = find(getoutlierdb,'name',cftoolFit.outlier);
   fitOptions.Exclude = cfcreateexcludevector(dataset,outset);
else
   fitOptions.Exclude = cfcreateexcludevector(dataset,[]);
end

%---------------------------------
% DO THE FIT 
%---------------------------------
try
   [f,g,out,warnstr,errstr,convmsg]=fit(dataset.X,dataset.Y,method,fitOptions);
catch
   f = [];
   errstr= lasterr;
   warnstr = '';
   out = [];
   g = [];
end

% CreateAFit uses hint to set up the state of the parameter panel when opening 
% an existing fit.
if ischar(method) && isequal(method(1:3),'rat')
   hint=method(4:5);
elseif isequal(method,'smoothing') && isnan(sp) && isstruct(out)
   % The fit command used the default smoothing parameter.  Stick
   % this back into the cftool.fit object's hint for later use.
   hint=sprintf('%g',out.p);
else
   hint=num2str(arg1);
end

% Store all the information about this fit back into the cftool.fit object.
cftoolFit.fit=f;
if isempty( f ),
    % The fit failed in some way so we use the given fit options. We
    % make an explicit copy of them so that we don't end up with a
    % reference that some other object is also using.
    cftoolFit.fitOptions = copy( fitOptions );
else
    % We want to ensure that we get the fit options that were actually
    % used in the fit. Therefore we get them from the cfit object.
    % Another benefit of getting this way is that we get a proper copy
    % of the fit options and don't end up with multiple objects pointing
    % to the same fit options.
    cftoolFit.fitOptions = fitoptions( f );
end
cftoolFit.goodness=g;
cftoolFit.output=out;
cftoolFit.dataset=dataset.name;
cftoolFit.dshandle=dataset;
cftoolFit.type=panel;
%cftoolFit.name=fname;
cftoolFit.hint=hint;

% reset goodness of fit measures
cftoolFit.sse=NaN;
cftoolFit.rsquare=NaN;
cftoolFit.dfe=NaN;
cftoolFit.adjsquare=NaN;
cftoolFit.rmse=NaN;
cftoolFit.ncoeff=NaN;

% Check to see if a fit was created
if ~isempty(f)
   % A fit was created, this is good, :)
   cftoolFit.isGood=true;
   cftoolFit.sse=g.sse;
   cftoolFit.rsquare=g.rsquare;
   if isfield(g,'dfe')
      cftoolFit.dfe=g.dfe; 
   else 
      cftoolFit.dfe=0; 
   end
   cftoolFit.adjsquare=g.adjrsquare;
   cftoolFit.rmse=g.rmse;
   if ~isempty(out.numparam)
      cftoolFit.ncoeff=out.numparam;
   end
   if isfield(out,'R')
      cftoolFit.R = out.R;
   elseif isfield(out,'Jacob')
      [ignore,R] = qr(Jacob);
      cftoolFit.R = R;
   end
   % Plot the line
   set(cftoolFit.line,'String',cftoolFit.name);
   cftoolFit.plot=1;

   clev = cfgetset('conflev');
   results=genresults(f,g,out,warnstr,errstr,convmsg,clev);
else
   % A fit was not created, this is not good, :(
   cftoolFit.isGood=false;
   % Clear the type out so that CreateAFit will treat it as a "new" fit when
   % it opens it in the editor.
   cftoolFit.type='';
   % Clear the dataset so it doesn't show up in the table of fits.
   cftoolFit.dataset='';
   results = {errstr};
end
results=sprintf('%s\n',results{:});

cftoolFit.results=results;

% Wrap the cftool.fit object up so the java code can handle it as a UDDObject.
isgood = cftoolFit.isGood;
cftoolFit=java(cftoolFit);
