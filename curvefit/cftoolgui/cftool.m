function varargout=cftool(varargin)
%CFTOOL Curve Fitting Tool.
%   CFTOOL displays a window for fitting curves to data.  You can create a
%   data set using data in your workspace and you can create graphs of fitted
%   curves superimposed on a scatter plot of the data.
%   
%   CFTOOL(X,Y) starts the Curve Fitting tool with an initial data
%   set containing the X and Y data you supply.  X and Y must be
%   numeric vectors having the same length.
%   
%   CFTOOL(X,Y,W) also includes the weight vector W in the initial
%   data set.  W must have the same length as X and Y.

%   Copyright 2000-2006 The MathWorks, Inc.
%   $Revision: 1.62.4.26 $  $Date: 2006/12/15 19:26:04 $

% Check that the Curve Fitting Toolbox is installed                                                
%if ~license('test', 'Curve_Fitting_Toolbox')                               
%    error('curvefit:cftool:noLicense',... 
%    'The use of the function CFTOOL requires the Curve Fitting Toolbox.');                                                               
%end

% Check that the Curve Fitting Toolbox has enough concurrent licenses
%if (license('checkout', 'Curve_Fitting_Toolbox') == 0)
%    return;
%end

import com.mathworks.toolbox.curvefit.*;

% Handle call-back
if (nargin > 0 && ischar(varargin{1}))
   cffig = cfgetset('cffig');

   switch(varargin{1})
    case 'duplicate'
     cfduplicatefigure(cffig);
     return
    case 'clear session'
     delete(findall(cffig,'Tag','cfstarthint'));
     if asksavesession
        cfsession('clear');
     end
     return
    case 'save session'
     cfsession('save');
     return
    case 'load session'
     delete(findall(cffig,'Tag','cfstarthint'));
     if asksavesession
        cfsession('load');
     end
     return
    case 'clear plot'
     delete(findall(cffig,'Tag','cfstarthint'));
     cbkclear;
     return
    case 'import data'
     delete(findall(cffig,'Tag','cfstarthint'));
     awtinvoke('com.mathworks.toolbox.curvefit.DataManager', 'showDataManager(I)', 0);
     return
    case 'delete dataset'
     try
       awtinvoke('com.mathworks.toolbox.curvefit.DataManager', 'showDataManager(I)', 0);
     catch
     end
     return
    case 'customeqn'
     customeqn;
     return
    case 'setconflev'
     setconflev(cffig,varargin{2});
     return
    case 'togglebounds'
     togglebounds(cffig);
     return
    case 'togglelegend'
     togglelegend(cffig,varargin{2:end});
     return
    case 'togglegrid'
     togglegrid(cffig);
     return
    case 'toggleaxlimctrl'
     delete(findall(cffig,'Tag','cfstarthint'));
     toggleaxlimctrl(cffig);
     return
    case 'defaultaxes'
     cfupdatexlim;
     cfupdateylim;
     return
    case 'toggleresidplot'
     toggleresidplot(cffig,varargin{2});
     return
    case 'adjustlayout'
     cfadjustlayout(cffig);
     cfgetset('oldposition',get(cffig,'Position'));
     cfgetset('oldunits',get(cffig,'Units'));

     % If we get resize callbacks, get rid of the position listener
     if ~ispc
        list = cfgetset('figposlistener');
        if ~isempty(list) && ishandle(list(1))
           delete(list(1));
           cfgetset('figposlistener',[]);
        end
     end
     return
    case 'adjustlayout2'
     % adjust via listener, done on some platforms where the resize
     % function is not reliable
     cffig = cfgetset('cffig');
     oldpos = cfgetset('oldposition');
     oldunits = get(cffig,'Units');
     figunits = cfgetset('oldunits');
     set(cffig,'Units',figunits);
     newpos = get(cffig,'Position');
     if length(oldpos)~=4 || ~isequal(oldpos(3:4),newpos(3:4))
        cfgetset('oldposition',newpos);
        cfadjustlayout(cffig);
     end
     set(cffig,'Units',oldunits);
     return
    case 'makefigure'
     if isempty(cffig) || ~ishandle(cffig)
        % Create the plot window
        cffig = createplot;
     end
     varargout = {cffig};
     return
   end
end

% Can't proceed unless we have desktop java support
if ~usejava('swing')
   error('curvefit:cftool:missingJavaSwing',...
         'The Curve Fitting Tool (cftool) requires Java Swing to run.');
end

% Get handle of the figure with the curve fitting tag
cffig = cfgetset('cffig');

cfgetset('dirty',true);   % session has changed since last save
 
% If the handle is empty, create the object and save the handle
if (isempty(cffig) || ~ishandle(cffig))
   % create the plot window
   cffig = createplot;
else % already exists, bring it forward
    figure(cffig);
end

% Get the java window handle
cft = cfgetset('cft');
startup = isempty(cft);
if startup
   dsdb = getdsdb;
   % create the Curve Fitting Tool window

   CurveFitting.showCurveFitting;
   cft = CurveFitting.getCurveFitting;
   cfgetset('cft',cft);

   % There could be problems if the user types "clear classes".
   % To avoid having the curve fitting classes clear, create and store
   % empty instances that are disconnected from the databases.
   clear temp;
   temp(3) = cftool.dataset('disconnected');
   temp(2) = cftool.fit('disconnected');
   cfgetset('fitcount',1);

	%init (behind the scenes) analysis and plot
	awtinvoke('com.mathworks.toolbox.curvefit.Analysis', 'initAnalysis');
	awtinvoke('com.mathworks.toolbox.curvefit.Plotting', 'initPlotting');
   
   % For the boundedline class, disconnect it and delete its
   % BoundLines entry.  This way neither the main line nor the bounds
   % will remain as children of the curve fit figure's axes.  The
   % BoundLines entry will still be a vector of two doubles, but they
   % will longer be valid hg handles.
   temp(1) = cftool.boundedline('parent',get(cffig,'CurrentAxes'));
   disconnect(temp(1));
   delete(get(temp(1),'BoundLines'));
   cfgetset('classinstances',temp);
end

% Create initial dataset using input data, if any
emsg = '';
x = [];
if nargin>=2 && nargin<=3 && isa(varargin{1}, 'double') ...
                          && isa(varargin{2}, 'double')
   x = varargin{1};
   xname = inputname(1);
   y = varargin{2};
   yname = inputname(2);
   if length(x)~=numel(x) || length(y)~=numel(y) || length(x)~=length(y)
      emsg = xlate('X and Y must be vectors with the same length.');
   elseif length(x)==1
      emsg = xlate('X and Y must have at least two values.');
   end
   if isempty(emsg) && nargin==3
      w = varargin{3};
      if isempty(w)
         wname = '(none)';
      else
         if length(w)~=length(x) || length(w)~=numel(w) || ~isa(w, 'double')
          emsg = xlate('Weight argument must be a vector with the same length as X.');
         else
            wname = inputname(3);
         end
      end
   elseif isempty(emsg)
      w = [];
      wname = '(none)';
   end
elseif nargin>0
   emsg = xlate('CFTOOL requires two or three double vectors as arguments.');
end
if isempty(emsg) && ~isempty(x)
   delete(findall(cffig,'Tag','cfstarthint'));
   cftool.dataset(xname,yname,wname,'',x(:),y(:),w(:));
elseif startup && isempty(down(dsdb))
   text(.5,.5,xlate('Select "Data" to begin curve fitting'),...
        'Parent',get(cffig,'CurrentAxes'),'Tag','cfstarthint',...
        'HorizontalAlignment','center');
end
if ~isempty(emsg)
   uiwait(warndlg(emsg,'Curve Fitting','modal'));
end

if nargout==1
   varargout={cft};
end


% ---------------- helper to set up plot window
function cffig = createplot
%CREATEPLOT Create plot window for CFTOOL

% Get some screen and figure position measurements
tempFigure=figure('visible','off','units','pixels');
dfp=get(tempFigure,'position');
dfop=get(tempFigure,'outerposition');
diffp = dfop - dfp;
xmargin = diffp(3);
ymargin = diffp(4);
close(tempFigure)
oldu = get(0,'units');
set(0,'units','pixels');
screenSize=get(0,'screensize');
screenWidth=screenSize(3); 
screenHeight=screenSize(4);
set(0,'units',oldu');

% Get the desired width and height
width=dfp(3)*1.2 + xmargin;
height=dfp(4)*1.2 + ymargin;
if width > screenWidth
  width = screenWidth-10-xmargin;
end
if height > screenHeight;
  height = screenHeight-10-ymargin;
end

% Calculate the position on the screen
leftEdge=min((screenWidth/3)+10+xmargin/2, screenWidth-width-10-2*xmargin);
bottomEdge=(screenHeight-height)/2;

% Make an invisible figure to start
cffig=figure('Visible','off','IntegerHandle','off',...
             'HandleVisibility','callback',...
             'color',get(0,'defaultuicontrolbackgroundcolor'),...
             'name','Curve Fitting Tool',...
             'numbertitle','off',...
             'units','pixels',...
             'position',[leftEdge bottomEdge width height], ...
             'CloseRequestFcn',@closefig, ...
             'PaperPositionMode','auto',...
             'doublebuffer','on',...
             'Dock','off');
cfgetset('cffig',cffig);

% Set default print options
pt = printtemplate;
pt.PrintUI = 0;
set(cffig,'PrintTemplate',pt)

% Add buttons along the top
cfaddbuttons(cffig);

% We want a subset of the usual toolbar
% Instead of calling adjusttoolbar, there is a handlegraphics bug
% that turned the toolbar off when the buttons were created, so
% we have to toggle it back on.
toggletoolbar(cffig,'on');

% We want a subset of the usual menus and some more toolbar icons
adjustmenu(cffig);

% Create containers for the axes
u1 = uicontainer('Parent',cffig,'Units','normalized','Position',[0 0 1 1], ...
                 'Tag','axescontainer');
uicontainer('Parent',cffig,'Units','normalized','Position',[0 0 1 .5], ...
            'Tag','residcontainer','Visible','off');

% Set up axes the way we want them
ax=axes('Parent',u1, 'box','on','Tag','main');

% Adjust layout of buttons and graph
if ~ispc    % some unix platforms seem to require this
   set(cffig,'Visible','on');
   drawnow;
end
cfadjustlayout(cffig);

% Define the colors to be used here
a = [3 0 2 1 3 3 3 2 2 0 2 3 0 1 2 1 0 1 0 1 1
     0 0 1 1 0 3 2 2 1 2 0 1 3 2 3 0 1 3 0 2 0
     0 3 0 1 3 0 1 2 3 1 1 2 0 3 1 2 2 2 0 0 2]'/3;
set(ax,'ColorOrder',a);

% Remember current position
cfgetset('oldposition',get(cffig,'Position'));
cfgetset('oldunits',get(cffig,'Units'));

% Now make the figure visible
if ispc
   set(cffig,'visible','on');
end
set(cffig, 'ResizeFcn','cftool(''adjustlayout'')');
drawnow;

% Add any fits with a plotting flag on
a = cfgetallfits;
for j=1:length(a)
   b = a{j};
   if b.plot == 1
      updateplot(b);
   end
end

% Add any datasets with a plotting flag on
a = cfgetalldatasets;
for j=1:length(a)
   b = a{j};
   if b.plot == 1
      cfmplot(b);
   end
end

% Create context menus for data and fit lines
cfdocontext('create', cffig);

% Listen for figure position changes if resize function is questionable
if ~ispc
   list = handle.listener(cffig, findprop(handle(cffig),'position'), ...
             'PropertyPostSet', 'cftool(''adjustlayout2'')');
   cfgetset('figposlistener',list);
end

% ---------------------- helper to invoke custom equation dlg
function customeqn
%CUSTOMEQN Invoke custom equation dialog
com.mathworks.toolbox.curvefit.CustomEquation.getInstance.defaults;

% ---------------------- helper to toggle toolbar state
function toggletoolbar(varargin)
%TOGGLETOOLBAR Toggle curve fit plot toolbar on or off

if (nargin>0 && ishandle(varargin{1}) && ...
               isequal(get(varargin{1},'Type'),'figure'))
   cffig = varargin{1};
else
   cffig = gcbf;
end

tbstate = get(cffig,'toolbar');
h = findall(cffig,'Type','uitoolbar');
if isequal(tbstate,'none') || isempty(h)
   % Create toolbar for the first time
   set(cffig,'toolbar','figure');
   adjusttoolbar(cffig);
elseif nargin>1 && isequal(varargin{2},'on')
   % Hide toolbar
   set(h,'Visible','on');
else
   % Show toolbar
   set(h,'Visible','off');
end

% ---------------------- helper to toggle confidence bound on/off
function togglebounds(cffig)
%TOGGLEBOUNDS Toggle curve fit plot confidence bounds on or off

% Get new state
wason = isequal(get(gcbo,'Checked'),'on');
if wason
   onoff = 'off';
else
   onoff = 'on';
end

% Change curves
ax = findall(cffig,'Type','axes','Tag','main');
h = findobj(ax,'tag','curvefit');
for j=1:length(h)
   hj = handle(h(j));
   if isequal(class(hj),'cftool.boundedline')
      hj.ShowBounds = onoff;
   end
end

% Change menu state
set(gcbo,'Checked',onoff);
cfgetset('showbounds',onoff);

% Adjust y limits if necessary
cfupdateylim;

cfgetset('dirty',true);   % session has changed since last save

% ---------------------- helper to set confidence level
function setconflev(cffig,clev)
%SETCONFLEV Set confidence level for curve fitting

% Get new value
oldlev = cfgetset('conflev');
if isempty(clev)
   ctxt = inputdlg({'Confidence level (in percent):'},...
                   'Set Confidence Level',1,{num2str(100*oldlev)});
   if isempty(ctxt)
      clev = oldlev;
   else
      ctxt = ctxt{1};
      clev = str2double(ctxt);
      if ~isfinite(clev) || ~isreal(clev) || clev<=0 || clev>=100
         errordlg(sprintf(...
             ['Bad confidence level "%s".\n' ...
              'Must be a percentage larger than 0 and smaller than 100.\n' ...
              'Keeping old value %g.'],...
             ctxt,100*oldlev),...
             'Error','modal');
         clev = oldlev;
      else
         clev = clev/100;
      end
   end
end
if oldlev~=clev
   cfgetset('conflev',clev);
   
   % Update any existing fits
   ax = findall(cffig,'Type','axes','Tag','main');
   h = findobj(ax,'tag','curvefit');
   for j=1:length(h)
      hj = handle(h(j));
      if isequal(class(hj),'cftool.boundedline')
         hj.ConfLev = clev;
      end
   end
   
   % Check the appropriate menu item
   h = findall(cffig,'Type','uimenu','Tag','conflev');
   set(h,'Checked','off');
   verysmall = sqrt(eps);
   if abs(clev-.95)<verysmall
      txt = '9&5%';
   elseif abs(clev-.9)<verysmall
      txt = '9&0%';
   elseif abs(clev-.99)<verysmall
      txt = '9&9%';
   else
      txt = '&Other...';
   end
   h1 = findall(h,'flat','Label',txt);
   if ~isempty(h1)
      set(h1,'Checked','on');
   end
   cfgetset('dirty',true);   % session has changed since last save
end

% ---------------------- helper to toggle legend on/off
function togglelegend(cffig,onoff,leginfo,rleginfo)
%TOGGLELEGEND Toggle curve fit plot legend on or off

% Get new state if not passed in -- note uimenu state reflects
% old state, and uitoggletool state reflects new state
if nargin<2 || isempty(onoff)
   h = gcbo;
   if isequal(get(h,'Type'),'uimenu')
      onoff = on2off(get(h,'Checked'));
   else
      onoff = get(h,'State');
   end
end
cfgetset('showlegend',onoff);
if nargin<3
    leginfo = {};
end
if nargin<4
    rleginfo = {};
end

% Change menu state
h = findall(cffig,'Type','uimenu','Tag','showlegend');
if ~isempty(h), set(h,'Checked',onoff); end

% Change button state
h = findall(cffig,'Type','uitoggletool','Tag','showlegend');
if ~isempty(h), set(h,'State',onoff); end

% Change legend state
cfupdatelegend(cffig,false,leginfo,rleginfo);

% ---------------------- helper to toggle grid on/off
function togglegrid(cffig)
%TOGGLEGGRID Toggle x and y axes grid on or off

% Get new state -- note uimenu state reflects old state, and
% uitoggletool state reflects new state
h = gcbo;
if isequal(get(h,'Type'),'uimenu')
   onoff = on2off(get(h,'Checked'));
else
   onoff = get(h,'State');
end
cfgetset('showgrid',onoff);

% Change grid
ax = findall(cffig,'Type','axes');
for j=1:length(ax)
   if ~isequal(get(ax(j),'Tag'),'legend')
      set(ax(j),'xgrid',onoff,'ygrid',onoff)
   end
end

% Change menu state
h = findall(cffig,'Type','uimenu','Tag','showgrid');
if ~isempty(h), set(h,'Checked',onoff); end

% Change button state
h = findall(cffig,'Type','uitoggletool','Tag','showgrid');
if ~isempty(h), set(h,'State',onoff); end

% ---------------------- helper to toggle axis limit controls on/off
function toggleaxlimctrl(cffig)
%TOGGLEAXLIMCTRL Toggle x and y axis limit controls on or off

% Get new state
h = gcbo;
onoff = on2off(get(h,'Checked'));
cfgetset('showaxlimctrl',onoff);

% Add or remove controls
cfaxlimctrl(cffig,onoff)

% Remove effects of controls on layout
if isequal(onoff,'off')
   cfadjustlayout(cffig);
end

% Change menu state
set(h,'Checked',onoff);


% ---------------------- helper to toggle residual plot on/off
function toggleresidplot(cffig,ptype)
%TOGGLERESIDPLOT Toggle residual plot on or off

% Turn off all siblings, then turn on this menu item
h = gcbo;
if ~isequal(get(h,'Tag'),'residmenu')
   % Not called from the menu, so search for the menu
   hParent = findall(cffig,'Type','uimenu','Tag','residmenu');
   h = findall(hParent,'Tag',ptype);
end
h1 = get(get(h,'Parent'),'Child');
set(h1,'Checked','off');
set(h,'Checked','on');
cfgetset('residptype',ptype);

% Add or remove the axes from the figure and adjust layout
needaxes = ~isequal(ptype,'none');
axh = findall(cffig,'Type','axes','Tag','resid');
ax1 = findall(cffig,'Type','axes','Tag','main');
hcontr = findall(cffig,'Type','uicontainer','Tag','residcontainer');

if needaxes && isempty(axh)
   set(hcontr,'Visible','on');
   ax1 = findall(cffig,'Type','axes','Tag','main');

   gridonoff = cfgetset('showgrid');
   axh = axes('OuterPosition',[0 0 1 1],'Units','normalized','Tag','resid',...
              'Box','on','XLim',get(ax1,'XLim'),'Parent',hcontr,...
              'XGrid',gridonoff,'YGrid',gridonoff);

   % Link the main and residual plot so that when the user zooms on one,
   % they zoom on the other as well. These two axes have different
   % y-scales so we only link the x-zoom.
   linkaxes( [axh, ax1], 'x' );

   htitle = get(axh,'Title');
   set(htitle,'String',xlate('Residuals'));
   htitle = get(ax1,'Title');
   set(htitle,'String',xlate('Data and Fits'));
elseif ~needaxes && ~isempty(axh)
   delete(axh);
   htitle = get(ax1,'Title');
   set(htitle,'String','');
   set(hcontr,'Visible','off');
end
cfadjustlayout(cffig);

% Now plot the residuals if toggling on
if needaxes
   a = cfgetallfits;
   for j=1:length(a)
      b = a{j};
      if b.plot == 1
         updateplot(b)
      end
   end
end

% Update legend
cfupdatelegend(cffig);
cfgetset('dirty',true);   % session has changed since last save

% ---------------------- helper to fix toolbar contents
function adjusttoolbar(cffig)
%ADJUSTTOOLBAR Adjust contents of curve fit plot toolbar

h0 = findall(cffig,'Type','uitoolbar');
h1 = findall(h0,'Parent',h0);
czoom = [];
for j=length(h1):-1:1
   mlabel = get(h1(j),xlate('TooltipString'));
   if ~isempty(findstr(mlabel,'Zoom')) || isequal(mlabel,'Pan')
      czoom(end+1) = h1(j);
   elseif isempty(findstr(mlabel,'Print'))
      delete(h1(j));
      h1(j) = [];
   else
     c1 = h1(j);
   end
end

% Add more icons especially for curve fitting
if exist('cficons.mat','file')==2
   icons = load('cficons.mat','icons');
   state = cfgetset('showlegend');
   if isempty(state), state = 'on'; end
   try
      % Try to get the default MATLAB legend icon
      legicon = load([matlabroot '/toolbox/matlab/icons/legend.mat']);
      cdata = legicon.cdata;
   catch
      cdata = icons.icons.legend; % in case of trouble, use older icon
   end
   c2 = uitoggletool(h0, 'CData',cdata,...
                    'State',state,...
                    'TooltipString', 'Legend On/Off',...
                    'Separator','on',...
                    'ClickedCallback','cftool(''togglelegend'')',...
                    'Tag','showlegend');
   state = cfgetset('showgrid');
   if isempty(state), state = 'off'; end
   c3 = uitoggletool(h0, 'CData',icons.icons.grid,...
                    'State',state,...
                    'TooltipString', ('Grid On/Off'),...
                    'Separator','off',...
                    'ClickedCallback','cftool(''togglegrid'')',...
                    'Tag','showgrid');
   cnew = [c1 czoom c2 c3]';
   
   set(h0,'Children',cnew(end:-1:1));
end

% ---------------------- helper to fix menu contents
function adjustmenu(cffig)
%ADJUSTMENU Adjust contents of curve fit plot menus

% Remove some menus entirely
h = findall(cffig, 'Type','uimenu', 'Parent',cffig);
removelist = {'&Edit' '&Insert' '&Desktop'};
for j=1:length(removelist)
   h0 = findall(h,'flat', 'Label',removelist{j});
   if (~isempty(h0))
      h(h==h0) = [];
      delete(h0);
   end
end

% Add or remove some items from other menus
% Fix FILE menu
h0 = findall(h,'flat', 'Label','&File');
h1 = findall(h0, 'Type','uimenu', 'Parent',h0);
for j=length(h1):-1:1
   mlabel = get(h1(j),'Label');
   if ~isempty(findstr(mlabel,'Close'))
      m7 = h1(j);
      set(m7,'Label','&Close Curve Fitting')
   elseif ~isempty(findstr(mlabel,'Print...'))
      m5 = h1(j);
   else
      delete(h1(j));
      h1(j) = [];
   end
end
uimenu(h0, 'Label','&Import Data...', 'Position',1,...
      'Callback','cftool(''import data'')');
uimenu(h0, 'Label','Clea&r Session','Position',2,...
       'Callback','cftool(''clear session'')','Separator','on');
uimenu(h0, 'Label','&Load Session...', 'Position',3,...
      'Callback','cftool(''load session'')');
uimenu(h0, 'Label','&Save Session...', 'Position',4,...
           'Callback','cftool(''save session'')');
uimenu(h0, 'Label','Generate &M-file...', 'Position',5,...
           'Callback','cfswitchyard(''cffig2m'')');
set(m5,'Position',6,'Separator','on');
uimenu(h0, 'Label','Print to &Figure', 'Position',7,...
           'Callback','cftool(''duplicate'')');
set(m7,'Position',8,'Separator','on');

% Fix VIEW menu
h0 = findall(h,'flat', 'Label','&View');
h1 = findall(h0, 'Type','uimenu', 'Parent',h0);
delete(h1);
uimenu(h0, 'Label','&Prediction Bounds', 'Position',1,...
           'Callback','cftool(''togglebounds'')', 'Checked','off');
cfgetset('showbounds','off');
h1 = uimenu(h0, 'Label','Confidence &Level','Position',2);
uimenu(h1, 'Label','9&0%', 'Position',1, ...
           'Callback','cftool(''setconflev'',.90)','Tag','conflev');
uimenu(h1, 'Label','9&5%', 'Position',2, 'Checked','on',...
           'Callback','cftool(''setconflev'',.95)','Tag','conflev');
uimenu(h1, 'Label','9&9%', 'Position',3, ...
           'Callback','cftool(''setconflev'',.99)','Tag','conflev');
uimenu(h1, 'Label','&Other...', 'Position',4, ...
           'Callback','cftool(''setconflev'',[])','Tag','conflev');
cfgetset('conflev',0.95);
h1 = uimenu(h0, 'Label','&Residuals', 'Position',3,'Separator','on',...
                'Tag','residmenu');
uimenu(h1, 'Label','&None', 'Position',1, 'Tag','none',...
           'Callback','cftool(''toggleresidplot'',''none'')', 'Checked','on');
uimenu(h1, 'Label','&Scatter Plot', 'Position',2, 'Tag','scat',...
           'Callback','cftool(''toggleresidplot'',''scat'')', 'Checked','off');
uimenu(h1, 'Label','&Line Plot', 'Position',3, 'Tag','line',...
           'Callback','cftool(''toggleresidplot'',''line'')', 'Checked','off');
%uimenu(h1, 'Label','&Bar Plot', 'Position',4, 'Tag','bar',...
%           'Callback','cftool(''toggleresidplot'',''bar'')', 'Checked','off');
cfgetset('residptype','none');
uimenu(h0, 'Label','&Clear Plot', 'Position',4,...
           'Callback','cftool(''clear plot'')');

% Fix TOOLS menu
h0 = findall(h,'flat', 'Label','&Tools');
h1 = findall(h0, 'Type','uimenu', 'Parent',h0);
for j=length(h1):-1:1
   mlabel = get(h1(j),'Label');
   % remove '&' before comparisons as mnemonics might change.
   index = strfind(mlabel, '&');
   mlabel(index) = [];
   if (isempty(findstr(mlabel,'Zoom'))) && ~isequal(mlabel,'Pan')
     delete(h1(j));
     h1(j) = [];
   end
end
uimenu(h0, 'Label','&Custom Equation', 'Position',1,...
           'Callback','cftool(''customeqn'')');
uimenu(h0, 'Label','&Legend', 'Position',2,'Separator','on',...
           'Callback','cftool(''togglelegend'')', 'Checked','on',...
           'Tag','showlegend');
cfgetset('showlegend','on');
uimenu(h0, 'Label','&Grid', 'Position',3,...
           'Callback','cftool(''togglegrid'')', 'Checked','off', ...
           'Tag','showgrid');
cfgetset('showgrid','off');
uimenu(h0, 'Label','&Axis Limit Control', 'Position',7, 'Separator','on', ...
           'Callback','cftool(''toggleaxlimctrl'')', 'Checked','off', ...
           'Tag','showaxlimctrl');
cfgetset('showaxlimctrl','off');
uimenu(h0, 'Label','&Default Axis Limits', 'Position',8, ...
           'Callback','cftool(''defaultaxes'')');

% Fix HELP menu
h0 = findall(h,'flat', 'Label','&Help');
h1 = findall(h0, 'Type','uimenu', 'Parent',h0);
delete(h1);
uimenu(h0, 'Label', '&Curve Fitting Tool Help', 'Position',1,'Callback',...
       'cfswitchyard(''cfcshelpviewer'', ''cftool'', ''cftool'')'); 
uimenu(h0, 'Label','Curve Fitting &Toolbox Help', 'Position',2,'Callback',...
       'doc curvefit/'); 
uimenu(h0, 'Label','&Demos', 'Position',3,'Separator','on','Callback',...
       'demo toolbox curve'); 
uimenu(h0, 'Label', '&About Curve Fitting', 'Position',4,'Separator','on',...
       'Callback', @helpabout);


% ---------------------- helper to display "about curve fitting" help
function helpabout(varargin)

a = ver('curvefit');
str = sprintf(['Curve Fitting Toolbox ' a.Version '\n',...
               'Copyright 2001-' a.Date(end-3:end) ' The MathWorks, Inc.']);
msgbox(str,'About the Curve Fitting Toolbox','modal');



% ---------------------- helper to verify closing of figure
function closefig(varargin)
%CLOSEFIG Verify intention to close curve fitting figure

if asksavesession
   set(gcbf,'CloseRequestFcn','');

   % Clear current session
   cfsession('clear');

   % Delete any cftool-related figures
   h = cfgetset('analysisfigure');
   if ~isempty(h) && ishandle(h), delete(h); end
   h = gcbf;
   if ~isempty(h) && ishandle(h), delete(h); end
   cfnewexcludeds;  % close graphical exclude figure if it is open.
end

% --------------------- change on to off and vice versa
function a = on2off(b)

if isequal(b,'on')
   a = 'off';
else
   a = 'on';
end

% ---------------------- callback for Clear button
function cbkclear
%CBKCLEAR Callback for Clear button

import com.mathworks.toolbox.curvefit.*;

% Clear all saved fits from the plot and notify fits manager
a = cfgetallfits;
for j=1:length(a)
   b = a{j};
   b.plot = 0;
   FitsManager.getFitsManager.fitChanged(java(b));
end

% Clear all datasets from the plot and notify data sets manager
a = cfgetalldatasets;
for j=1:length(a)
   b = a{j};
   b.plot = 0;
   DataSetsManager.getDataSetsManager.dataSetListenerTrigger(...
             java(b), DataSetsManager.DATA_SET_CHANGED, '', '');
end


% ---------------------- Clear session
function ok = asksavesession

allds = cfgetalldatasets;
allfits = cfgetallfits;

% Offer to save session unless there's nothing to save
if ~cfgetset('dirty') || isempty(allds) && isempty(allfits)
   resp = 'No';
else
   resp = questdlg('Save this Curve Fitting session?', ...
                   'Curve Fitting', 'Yes', 'No', 'Cancel', 'Yes');
end

if isempty(resp)
	resp = 'Cancel';
end

if isequal(resp,'Yes')
   ok = cfsession('save');
   if ~ok
      resp = 'Cancel';
   end
end

ok = ~isequal(resp,'Cancel');
