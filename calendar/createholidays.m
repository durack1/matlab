function createholidays(varargin)
%CREATEHOLIDAYS Interface for creating trading calendars from FinancialCalendar.com.
%   CREATEHOLIDAYS invokes the interface used to convert
%   FinancialCalendar.com financial center holiday data into market
%   specific HOLIDAYS.M files.
%
%   CREATEHOLIDAYS(FILENAME,CODEFILE,INFOFILE,TARGETDIR,INCLUDEWKDS,WPROMPT,NOGUI)
%   programmatically generates the market specific HOLIDAYS.M files without
%   displaying the interface.  
%
%   See also HOLIDAYS.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.9 $   $Date: 2011/05/09 00:47:40 $

%If nogui flag is set, create files without displaying GUI
numin = length(varargin);
if numin > 6 && varargin{7}
  generateholidays(varargin{1},varargin{2},varargin{3},varargin{4},...
    varargin{5},varargin{6});
  return
end

%Focus dialog if already open and return
f = getappdata(0,'HOLGUI');
if ~isempty(f)
  figure(f)
  return
end

%GUI spacing
[dfp,mfp,bspc,bhgt,bwid] = spaceparams([],[],[]);

%Build main window
f = figure('Name','Trading Calendars','Numbertitle','off',...
           'Integerhandle','off','Menubar','none','Tag','HOLGUI');
set(f,'Resizefcn',{@cleanupdialog,f},'Closerequestfcn',{@exitgui});         
setappdata(0,'HOLGUI',f)

%Set figure position
pos = get(f,'Position');
pos(4) = 15*bspc+13*bhgt;
set(f,'Position',[pos(1) pos(2) pos(3)/2 pos(4)]);
pos(3) = pos(3)/2;

%Create uicontrols
ui.title = uicontrol('Style','text',...
  'String','Create holiday lists from FinancialCalendar.com data',...
  'Position',[bspc pos(4)-(bspc+bhgt) bwid bhgt]);
ui.dataframe = uicontrol('Style','frame',...
  'Position',[bspc pos(4)-(13*bspc+12*bhgt) pos(3)-2*bspc 12*bspc+11*bhgt]);
ui.datafile = uicontrol('String','1. Choose data file ...',...
   'Callback',{@choosefile,f,'Choose FinancialCalendar.com data file ...'},...
   'Position',[2*bspc pos(4)-(2*bspc+2*bhgt) pos(3)-4*bspc bhgt]);
ui.datafilename = uicontrol('Style','edit',...
   'Position',[2*bspc pos(4)-(3*bspc+3*bhgt) pos(3)-4*bspc bhgt]);
ui.codefile = uicontrol('String','2. Choose codes file ...',...
   'Callback',{@choosefile,f,'Choose FinancialCalendar.com codes file ...'},...
   'Position',[2*bspc pos(4)-(4*bspc+4*bhgt) pos(3)-4*bspc bhgt]);
ui.codefilename = uicontrol('Style','edit',...
   'Position',[2*bspc pos(4)-(5*bspc+5*bhgt) pos(3)-4*bspc bhgt]);
ui.infofile = uicontrol('String','3. Choose info file ...',...
   'Callback',{@choosefile,f,'Choose FinancialCalendar.com info file ...'},...
   'Position',[2*bspc pos(4)-(6*bspc+6*bhgt) pos(3)-4*bspc bhgt]);
ui.infofilename = uicontrol('Style','edit',...
   'Position',[2*bspc pos(4)-(7*bspc+7*bhgt) pos(3)-4*bspc bhgt]);
ui.targetdir = uicontrol('String','4. Choose directory for writing holiday files ...',...
   'Callback',{@choosedir,f},...
   'Position',[2*bspc pos(4)-(8*bspc+8*bhgt) pos(3)-4*bspc bhgt]);
ui.targetdirname = uicontrol('Style','edit',...
   'Position',[2*bspc pos(4)-(9*bspc+9*bhgt) pos(3)-4*bspc bhgt]);
ui.weekends = uicontrol('Style','checkbox','String','Include weekends',...
   'Value',1,...
   'Position',[2*bspc pos(4)-(10*bspc+10*bhgt) pos(3)-4*bspc bhgt]);
ui.writeprompt = uicontrol('Style','checkbox','String','Prompt for target directory',...
   'Value',1,...
   'Position',[2*bspc pos(4)-(11*bspc+11*bhgt) pos(3)-4*bspc bhgt]);
ui.generatefiles = uicontrol('String','5. Create holiday files ...',...
   'Callback',{@createfiles,f},...
   'Position',[2*bspc pos(4)-(12*bspc+12*bhgt) pos(3)-4*bspc bhgt]);
ui.closebutton = uicontrol('String','Close','Callback',{@exitgui},...
  'Position',[pos(3)-(2*bspc+2*bwid) pos(4)-(14*bspc+13*bhgt) bwid bhgt]);
ui.helpbutton = uicontrol('String','Help','Callback',{@helpuihol},...
  'Position',[pos(3)-(bspc+bwid) pos(4)-(14*bspc+13*bhgt) bwid bhgt]);
 
%Set Userdata for file and directory storage
set(ui.datafile,'Userdata',ui.datafilename)
set(ui.codefile,'Userdata',ui.codefilename)
set(ui.infofile,'Userdata',ui.infofilename)
set(ui.targetdir,'Userdata',ui.targetdirname)

%If inputs given, update GUI appropriately
numin = length(varargin);
if numin > 0, set(ui.datafilename,'String',varargin{1},'Tooltip',varargin{1}); end
if numin > 1, set(ui.codefilename,'String',varargin{2},'Tooltip',varargin{2}); end
if numin > 2, set(ui.infofilename,'String',varargin{3},'Tooltip',varargin{3}); end
if numin > 3, set(ui.targetdirname,'String',varargin{4},'Tooltip',varargin{4}); end
if numin > 4, set(ui.weekends,'Value',varargin{5}); end
if numin > 5, set(ui.writeprompt,'Value',varargin{6}); end
  
setappdata(f,'uidata',ui)
cleanupdialog([],[],f)
 
 
function choosefile(obj,evd,frame,d)   %#ok
%CHOOSEFILE File chooser for data files.

%Prompt for file if none given
[fn,pt] = uigetfile({'*.csv','FinancialCalendar.com file'},d);
if isa(fn,'double')
  filename = '';
else
  filename = char([pt fn]);
end
set(get(gcbo,'Userdata'),'String',filename,'Tooltip',filename)


function choosedir(obj,evd,frame)  %#ok
%CHOOSEDIR File chooser for directory target.

%Prompt for file if none given
d = char(uigetdir(pwd,'Choose directory for writing calendar files.'));
if isa(d,'double')
  d = '';
end
set(get(gcbo,'Userdata'),'String',d,'Tooltip',d)


function cleanupdialog(obj,evd,frame)    %#ok
%CLEANUPDIALOG Visual enhancement of dialog.

%Set colors and alignment
e = findobj(frame,'Style','edit');
l = findobj(frame,'Style','listbox');
p = findobj(frame,'Style','popupmenu');
set([e;l;p],'Backgroundcolor','white','Horizontalalignment','left')
dbc = get(0,'Defaultuicontrolbackgroundcolor');
set(frame,'Color',dbc)

%Make text boxes proper width
textuis = findobj(frame,'Style','text');
for i = 1:length(textuis)
  pos = get(textuis(i),'Position');
  ext = get(textuis(i),'Extent');
  set(textuis(i),'Position',[pos(1) pos(2) ext(3) pos(4)])
end
set(textuis,'Backgroundcolor',dbc)

%Normalize units
set(findobj(frame,'Type','uicontrol'),'Units','normal')
set(findobj(frame,'Type','uipanel'),'Units','normal')


function createfiles(obj,evd,frame)   %#ok
%CREATEFILES Create holiday file for given financial centers.

%Get inputs for API function, createholidays
ui = getappdata(frame,'uidata');
datafile = get(ui.datafilename,'String');
codefile = get(ui.codefilename,'String');
infofile = get(ui.infofilename,'String');
targetdir = get(ui.targetdirname,'String');
includewkds = get(ui.weekends,'Value');
wprompt = get(ui.writeprompt,'Value');

%Call createholidays
p = get(frame,'Pointer');
set(frame,'Pointer','watch')
drawnow
try
  createholidays(datafile,codefile,infofile,targetdir,includewkds,wprompt,1)
catch exception
  errordlg(exception.message)
end
set(frame,'Pointer',p)


function exitgui(obj,evd,frame)    %#ok
%EXITGUI Close GUI.    

closereq 
setappdata(0,'HOLGUI',[])   


function helpuihol(ovj,evd,frame)  %#ok
%HELPUIHOL

helpview([docroot '\toolbox\finance\finance.map'],'holidaysgui')


function [dfp,mfp,bspc,bhgt,bwid,bwid2] = spaceparams(obj,evd,frame)    %#ok
%SPACEPARAMS GUI spacing parameters

dfp = get(0,'DefaultFigurePosition');
mfp = [560 420];    %Reference width and height
bspc = mean([5/mfp(2)*dfp(4) 5/mfp(1)*dfp(3)]);
bhgt = 20/mfp(2) * dfp(4);
bwid = 80/mfp(1) * dfp(3);
bwid2 = 90/mfp(1) * dfp(3);


function h = generateholidays(filename,codefile,infofile,targetdir,includewkds,wprompt)
%GENERATEHOLIDAYS Create trading calendars from FinancialCalendar.com
%  H = GENERATEHOLIDAYS(FILENAME,CODEFILE,INFOFILE,TARGETDIR,INCLUDEWKDS,WPROMPT)

%Initialize filenames to [] if not given
if nargin < 1
  filename = [];
end
if nargin < 2
  codefile = [];
end
if nargin < 3
  infofile = [];
end
if nargin < 4
  targetdir = [];
end

%Choose/open FinancialCalendar.com files
fid1 = getcalfile('Choose FinancialCalendar.com data file ...',filename);
fid2 = getcalfile('Choose FinancialCalendar.com codes file ...',codefile);
fid3 = getcalfile('Choose FinancialCalendar.com info file ...',infofile);

%Set default inputs if not given
if nargin < 6
  wprompt = 1;
end
if nargin < 5
  includewkds = 1;
end

%Get holiday data from file
holData = textscan(fid1,'%f%s%s','delimiter',',');

%Close file
fclose(fid1);

%Keep/Remove weekends based on input flag
if ~includewkds
  j = strcmp(holData{3},'w');
  holData{1}(j) = []; 
  holData{2}(j) = [];
  holData{3}(j) = [];
end

%Replace codes with descriptions
fgetl(fid2);
codData = textscan(fid2,'%s%s','delimiter',',');
fclose(fid2);

holCodes = unique(holData{3});
for i = 1:length(holCodes)
  if ~strcmp(holCodes{i},'w')
    holDesc = str2double(codData{1}{find(strcmp(holCodes{i},codData{1}))});
    j = (strcmp(holCodes{i},holData{3}));
    holData{3}(j) = codData{2}(holDesc);
  end
end

%Get unique center codes, 2nd column from holiday file
centerCodes = unique(holData{2});

%Match codes to dates and create center lists
numCenters = length(centerCodes);
centerLists = cell(numCenters,2);
for i = 1:numCenters
  j = find(strcmp(holData{2},centerCodes(i)));
  centerLists{i,1} = yyyymmdd2num(holData{1}(j));
  centerLists{i,2} = [holData{2}(j) holData{3}(j)];
  x.(centerCodes{i}){1} = centerLists{i,1};
  x.(centerCodes{i}){2} = centerLists{i,2}(:,2);
end

%Add financial center description to data
fgetl(fid3);
infoData = textscan(fid3,'%s%s%s%s%s%s%s%s','delimiter',',');
fclose(fid3);

%Find center ID in data
numFields = length(infoData);
tmp = cell(1,numFields-1);
for i = 1:numCenters
  j = find(strcmp(infoData{1},centerCodes(i)));
  tmp(:) = {''};
  for k = 2:numFields
    tmp{k-1} = infoData{k}{j};
  end
  x.(centerCodes{i}){3} = tmp;
end

%Write files to disk if no output argument given
if nargout == 0
  
  %Choose directory 
  if wprompt
    d = uigetdir(pwd,'Choose directory for writing calendar files.');
  elseif ~isempty(targetdir)
    d = targetdir;
  else
    d = pwd;
  end
  if isa(d,'double')
    return
  end
  d = [char(d) '/'];
  
  %Build output files names
  outfiles = cell(numCenters,1);
  for i = 1:numCenters
    outfiles{i} = [d 'holidays' centerCodes{i} '.m'];
    %Prompt for file names if flag is set
    if wprompt
      [f,p] = uiputfile(outfiles{i},'Create holiday file ...');
      if isa(f,'double')
        return
      end
      outfiles{i} = [p f];
    end
  end
  
  %Write data to file
  for i = 1:numCenters
    
    %Open file and add header
    [fid,s] = fopen(outfiles{i},'w');
    if fid < 0
      error(message('finance:createholidays:unableToOpenFile', s));
    end
    fprintf(fid,'function h = holidays%s(d1,d2)\n',centerCodes{i});
    fprintf(fid,'%%HOLIDAYS Holidays and non-trading days for %s\n',x.(centerCodes{i}){3}{1});
    fprintf(fid,'%%   H = HOLIDAYS(D1, D2) returns a vector of serial date numbers corresponding\n');
    fprintf(fid,'%%   to the holidays and non-trading days between the dates D1 and D2, inclusive.\n');
    fprintf(fid,'%%\n');
    fprintf(fid,'%%   H = HOLIDAYS returns known non-trading day data.\n');
    fprintf(fid,'%%\n');
    fprintf(fid,'%%   This function contains all holiday and special non-trading day data for the\n');
    fprintf(fid,'%%   %s.\n',x.(centerCodes{i}){3}{1});

    fprintf(fid,'\n\n\nh = [...\n');
    
    for j = 1:length(x.(centerCodes{i}){1})
      
      fprintf(fid,'%d ;... %% %s\n',x.(centerCodes{i}){1}(j),x.(centerCodes{i}){2}{j});
      
    end
    
    fprintf(fid,'];\n\n');
    
    fprintf(fid,'h = sort(h, 1);   %% Make sure that the dates are in chronological order\n\n');

    fprintf(fid,'if nargin == 1\n');
    fprintf(fid,'error(message(''finance:holidays:notEnoughInputs''))\n\n');

    fprintf(fid,'elseif nargin == 2\n');
    fprintf(fid,'    if ischar(d1) | ischar(d2)\n');
    fprintf(fid,'        start = datenum(d1);\n');
    fprintf(fid,'        fin = datenum(d2);\n');
    fprintf(fid,'    else\n');
    fprintf(fid,'        start = d1;\n');
    fprintf(fid,'        fin = d2;\n');
    fprintf(fid,'    end\n');
    fprintf(fid,'    hindex = find(h < start | h > fin);\n');
    fprintf(fid,'    h(hindex) = [];\n');
    fprintf(fid,'end\n');
    
    fclose(fid);
    
  end
    
else
  
  %Assign output
  h = x;
  
end
    
 
function x = yyyymmdd2num(d)
%YYYYMMDD2NUM Date number to MATLAB date number.
%   X = YYYYMMDD2NUM(D) converts dates of the form 20061121 to MATLAB date
%   numbers.

yr = round(d/10000);
mt = round(d/100) - yr*100;
dy = round(mod(d/100,1) * 100);
x = datenum(yr,mt,dy);


function f = getcalfile(d,filename)
%GETCALFILE(D) Prompt for filename.
%  F = GETCALFILE(D) Prompt user for filename and return file handle if valid.
%  D is the string to use for the dialog name.

%Prompt for file if none given
if isempty(filename)
  [fn,pt] = uigetfile({'*.csv','FinancialCalendar.com file'},d);
  filename = [pt fn];
end

%Open file and return handle
[f,s] = fopen(filename);
if f < 0
  error(message('finance:createholidays:unableToOpenFile', s));
end
  



