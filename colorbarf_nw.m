function handle=colorbarf(loc, cont, axes_ticks)
%COLORBARF Display color bar (color scale) in conjunction with contourf.
%function handle=colorbarf(loc, cont, axes_ticks)
%   COLORBARF('vert') appends a vertical color scale to the current
%   axis. COLORBARF('horiz') appends a horizontal color scale.
%
%   CONT is optional and is used to 'discretize' the colorbar.  If cont
%   contains the contour levels used in a call to contourf then the
%   colorbar will properly represent the fill colors used.  Alternatively,
%   cont may the contour matrix as returned by contourf or contoursc.
%
%   AXES_TICKS is optional and specifies the tick marks on the colorbar.
%   If axes_ticks is the same as cont then the contour levels will be
%   marked on the colorbar
%
%   COLORBARF(H) places the colorbar in the axes H. The colorbar will
%   be horizontal if the axes H width > height (in pixels).
%
%   COLORBARF without arguments either adds a new vertical color scale
%   or updates an existing colorbar.
%
%   H = COLORBARF(...) returns a handle to the colorbar axis.
%
%   USAGE: Two common plots would be the following:
%
%   cs = contourf(peaks);
%   colorbarf('vert', cs);
%
%   cont = -8:2:10;
%   axes_ticks = cont;
%   contourf(peaks, cont);
%   colorbarf('vert', cont, axes_ticks);

%   Clay M. Thompson 10-9-92
%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 1998/09/01 05:12:55 $
%   Hacked by Jim Mansbridge 30/5/97 to allow for cont and axes_ticks to
%   be passed.  Apart from the comments all changes involve using if
%   statements that depend on nargin.

%   If called with COLORBARF(H) or for an existing colorbar, don't change
%   the NextPlot property.
changeNextPlot = 1;

if nargin<1, loc = 'vert'; end
ax = [];
if nargin>=1,  % Changed by JVM to allow handles to be passed.
    if ishandle(loc)
        ax = loc;
        if ~strcmp(get(ax,'type'),'axes'),
            error('Requires axes handle.');
        end
        units = get(ax,'units'); set(ax,'units','pixels');
        rect = get(ax,'position'); set(ax,'units',units)
        if rect(3) > rect(4), loc = 'horiz'; else loc = 'vert'; end
        changeNextPlot = 0;
    end
end

% Determine color limits by context.  If any axes child is an image
% use scale based on size of colormap, otherwise use current CAXIS.

ch = get(gca,'children');
hasimage = 0; t = [];
cdatamapping = 'direct';

for i=1:length(ch),
    typ = get(ch(i),'type');
    if strcmp(typ,'image'),
        hasimage = 1;
        cdatamapping = get(ch(i), 'CDataMapping');
    elseif strcmp(typ,'surface') & ...
            strcmp(get(ch(i),'FaceColor'),'texturemap') % Texturemapped surf
        hasimage = 2;
        cdatamapping = get(ch(i), 'CDataMapping');
%*NW    elseif strcmp(typ,'patch') | strcmp(typ,'surface')
    elseif strcmp(typ,'patch') | strcmp(typ,'surface') | strcmp(typ,'hggroup')    %*NW
        cdatamapping = get(ch(i), 'CDataMapping');
    end
end

if ( strcmp(cdatamapping, 'scaled') )
    if hasimage,
        if isempty(t); 
            t = caxis; 
        end
    else
        t = caxis;
	if nargin == 1 % Changed by JVM to get the right 'discretised colors 
	  d = (t(2) - t(1))/size(colormap,1);
	  t = [t(1)+d/2  t(2)-d/2];
	end
    end
else
    if hasimage,
        t = [1, size(colormap,1)]; 
    else
        t = [1.5  size(colormap,1)+.5];
    end
end

h = gca;

if nargin>=0,  % Changed by JVM to avoid strange refreshing behaviour
    % Search for existing colorbar
    ch = get(gcf,'children'); ax = [];
    for i=1:length(ch),
        d = get(ch(i),'userdata');
        if prod(size(d))==1 & isequal(d,h), 
            ax = ch(i); 
            pos = get(ch(i),'Position');
            if pos(3)<pos(4), loc = 'vert'; else loc = 'horiz'; end
            changeNextPlot = 0;
            break; 
        end
    end
end

origNextPlot = get(gcf,'NextPlot');
if strcmp(origNextPlot,'replacechildren') | strcmp(origNextPlot,'replace'),
    set(gcf,'NextPlot','add')
end

if loc(1)=='v', % Append vertical scale to right of current plot
    
    if isempty(ax),
        units = get(h,'units'); set(h,'units','normalized')
        pos = get(h,'Position'); 
        [az,el] = view;
        stripe = 0.075; edge = 0.02; 
        if all([az,el]==[0 90]), space = 0.05; else space = .1; end
        set(h,'Position',[pos(1) pos(2) pos(3)*(1-stripe-edge-space) pos(4)])
        rect = [pos(1)+(1-stripe-edge)*pos(3) pos(2) stripe*pos(3) pos(4)];
        
        % Create axes for stripe
        ax = axes('Position', rect);
        set(h,'units',units)
    else
        axes(ax);
    end
    
    % Create color stripe
    if nargin > 1     % use cont to determine the color stripes
      [mcont, ncont] = size(cont);
      if (mcont == 2) & (ncont > 1) % A contour matrix has been passed
	cs = cont;
	cont = find_contours(cs);
	n = length(cont);
	cont = [ (2*cont(1)-cont(2)); cont; (2*cont(n)-cont(n-1)) ];
      end
      n = length(cont);
      cont = cont(:);
      pcolor([1;2], [cont; cont(n)], [ [cont; cont(n)] [cont; cont(n)] ])
      set(ax,'Ydir','normal')
      caxis(t)
    else              % use the colormap to determine the color stripes
      n = size(colormap,1);
      image([0 1],t,(1:n)','Tag','TMW_COLORBAR'); set(ax,'Ydir','normal')
    end
    if nargin > 2
      set(ax,'ytick',axes_ticks)
    end
    set(ax,'YAxisLocation','right')
    set(ax,'xtick',[])
    
else, % Append horizontal scale to top of current plot
    
    if isempty(ax),
        units = get(h,'units'); set(h,'units','normalized')
        pos = get(h,'Position');
        stripe = 0.075; space = 0.1;
        set(h,'Position',...
            [pos(1) pos(2)+(stripe+space)*pos(4) pos(3) (1-stripe-space)*pos(4)])
        rect = [pos(1) pos(2) pos(3) stripe*pos(4)];
        
        % Create axes for stripe
        ax = axes('Position', rect);
        set(h,'units',units)
    else
        axes(ax);
    end
    
    % Create color stripe
    if nargin > 1     % use cont to determine the color stripes
      [mcont, ncont] = size(cont);
      if (mcont == 2) & (ncont > 1) % A contour matrix has been passed
	cs = cont;
	cont = find_contours(cs);
	n = length(cont);
	cont = [ (2*cont(1)-cont(2)); cont; (2*cont(n)-cont(n-1)) ];
      end
      n = length(cont);
      cont = cont(:);
      pcolor([cont; cont(n)], [1;2], [ [cont; cont(n)] [cont; cont(n)] ]')
      set(ax,'Ydir','normal')
      caxis(t)
    else              % use the colormap to determine the color stripes
      n = size(colormap,1);
      image(t,[0 1],(1:n),'Tag','TMW_COLORBAR'); set(ax,'Ydir','normal')
    end
    if nargin > 2
      set(ax,'xtick',axes_ticks)
    end
    set(ax,'ytick',[])
    
end
set(ax,'userdata',h)
set(gcf,'CurrentAxes',h)
if changeNextPlot
    set(gcf,'Nextplot','ReplaceChildren')
end

if nargout>0, handle = ax; end

function cont = find_contours(cs)
% find_contours.m returns a vector of monotonic increasing contours levels
% given cs, the contour matrix as returned by contourf or contoursc.

% $Id: colorbarf.m,v 1.6 1998/09/01 05:12:55 mansbrid Exp $
% Copyright J. V. Mansbridge, CSIRO, Thu Jun 19 16:07:09 EST 1997

ncols = size(cs, 2);
cont = zeros(ncols, 1);

% Store the contour levels in cont.

ii = 1;
count = 0;
while ii < ncols
  count = count + 1;
  cont(count) = cs(1, ii);
  ii = ii + cs(2, ii) + 1;
end
cont = cont(1:count);

% Sort cont and eliminate repeated contour levels.

cont = sort(cont);
dd = find(diff(cont)~=0);
dd = dd(:);
dd = [1; dd+1];
cont = cont(dd);
