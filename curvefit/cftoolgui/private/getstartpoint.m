function sp=getstartpoint(model,dataSetName,excludeSetName,doNormalize)
% GETSTARTPOINT returns the default starting point.

% $Revision: 1.5.2.4 $  $Date: 2005/12/12 23:15:31 $
% Copyright 2001-2005 The MathWorks, Inc.

if nargin<4
    doNormalize = false;
end

if length(model) > 7 && isequal(model(1:8),'custom: ')
   equationName=model(9:end);
   sp=get(managecustom('getopts',equationName),'startpoint');
else
   dataSet=find(getdsdb,'name',char(dataSetName));
   ft=fittype(model);
   h=constants(ft);
   spfun=startpt(ft);
   if ~isempty(spfun)
      % Exclude points if requested
      if ~isequal(excludeSetName,'(none)')
         outset=find(getoutlierdb,'name',excludeSetName);
         include=~cfcreateexcludevector(dataSet,outset);
      else
         include=~cfcreateexcludevector(dataSet,[]);
      end
      x=dataSet.x(include);
      y=dataSet.y(include);
      if doNormalize
          mu = mean(x);
          sig = std(x);
          if sig==0
              sig = 1;
          end
          x = (x-mu) / sig;
      end
      
      % Turn warnings off to avoid messages like this:
      % Warning: Power functions require x to be positive. ...
      warnstate=warning('off', 'all');
      try
          sp=feval(spfun,x,y,h{:});
      catch
          warning(warnstate);
          rethrow(lasterror);
      end
      warning(warnstate);
   else
      % Use random start points if necessary
      sp = rand(1,numcoeffs(ft));
   end
end
