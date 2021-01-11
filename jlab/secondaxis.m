function[ax2]=secondaxis(h,x1,x2,y1,y2)
%SECONDAXIS Adds a second axis on top of an existing axis.
%
%   SECONDAXIS(H,X1,X2,Y1,Y2), where H is a handle to an existing
%   axis, adds a second axis with a linear relationship to the first 
%   axis specified by the X1, X2, Y1, and Y2.  
%
%   X1 and Y1 are two-vectors containing the x- and y-values of any two 
%   points in the first axis, and X2 and Y2 are two-vectors containing 
%   the values of the same two points in the second axis.
%
%   SECONDAXIS puts the tick-marks for the new set of axes at the same
%   locations as those for the old set of axes.
% 
%   SECONDAXIS also automatically puts the new X and Y axes on the
%   opposite side of the plot from the old axes.
%	
%   To add a new X-axis only use SECONDAXIS(H,X1,X2).
%   To add a new Y-axis only use SECONDAXIS(H,[],[],Y1,Y2).
%
%   SECONDAXIS supresses the x-ticks in the former case and suppresses
%   the y-ticks in the latter case.
%
%   Example:  plot(peaks),secondaxis(gca,1/5,1,-5)
%  
%   Usage:  h=secondaxis(h,xf,yf);
%           h2=secondaxis(h,xf,yf,xs,ys);
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 1999--2006 J.M. Lilly --- type 'help jlab_license' for details      
  




	
bshrinkx=0;
bshrinky=0;
xfactor=1;
yfactor=1;
xshift=0;
yshift=0;

bsuppress=1;

%look for string arguments
na=nargin;
i=1;
while i<na
	i=i+1;
	argi=eval(['arg',int2str(i)]);
	if ischar(argi)
		argi=argi(1:3);
		if strcmp(argi,'xsh')		
			bshrinkx=1;
		elseif strcmp(argi,'ysh')		
			bshrinky=1;
		end
		na=na-1;
		for j=i:na
			eval(['arg',int2str(j),'=arg',int2str(j+1),';'])
		end
		i=i-1;
	end
end

if na>=2
	xfactor=arg2;
end
if na>=3
	yfactor=arg3;
end
if na>=4
	xshift=arg4;
end
if na>=5
	yshift=arg5;
end


axes(ax1);
ax=axis;
xl1=get(gca,'xtick');
yl1=get(gca,'ytick');

set(ax1,'color','none')
isrevy=strcmp(get(ax1,'ydir'),'reverse');
isrevx=strcmp(get(ax1,'xdir'),'reverse');
isleft=strcmp(get(ax1,'yaxislocation'),'left');
isbot=strcmp(get(ax1,'xaxislocation'),'bottom');


ax2=axes('position',get(ax1,'position'),...
	'color','none','yaxislocation','right',...
	'xaxislocation','top');

% %reverse if necessary
% if (isrevy && yfactor>0) || (~isrevy && yfactor<0)
%     set(ax2,'ydir','reverse');
% end
% if (isrevx && xfactor>0) || (~isrevx && xfactor<0)
%     set(ax2,'xdir','reverse');
% end


%make sure the new axes are where the old ones aren't
if ~isleft
    set(ax2,'yaxislocation','left');
end
if ~isbot
    set(ax2,'xaxislocation','bottom');
end


if xfactor<0
	ax(1:2)=-1*ax(2:-1:1);
end
if yfactor<0
	ax(3:4)=-1*ax(4:-1:3);
end

if xfactor>0
  ax2x=[0 (ax(2)-ax(1))*xfactor]+xshift;
else
  ax2x=[(ax(2)-ax(1))*xfactor 0]+xshift;
end

if yfactor>0
  ax2y=[0 (ax(4)-ax(3))*yfactor]+yshift;
else
  ax2y=[(ax(4)-ax(3))*yfactor 0]+yshift;
end

axis([ax2x ax2y]);
grid off

xl2=(xl1-ax(1))*xfactor+xshift;
yl2=(yl1-ax(3))*yfactor+yshift;
%xl2=(xl1-ax(1))*xfactor+xshift;
%yl2=(yl1-ax(3))*yfactor+yshift;

if xfactor<0
	xl2=fliplr(xl2);
end
if yfactor<0
	yl2=fliplr(yl2);
end

set(ax2,'xtick',xl2)
set(ax2,'ytick',yl2)

set(ax1,'xtickmode','manual')
set(ax1,'ytickmode','manual')
set(ax2,'xtickmode','manual')
set(ax2,'ytickmode','manual')
%set(ax2,'xticklabelmode','auto')
%set(ax2,'yticklabelmode','auto')


if bsuppress
	if xfactor==1
		set(ax2,'xticklabel',[])
%	        set(ax2,'xtick',[])
	end
	if yfactor==1
		set(ax2,'yticklabel',[])
%		set(ax2,'ytick',[])
	end
end

axes(ax2)
hold on

pos=get(ax2,'position');
if bshrinkx
	if isleft
		pos(1)=pos(3)+pos(1)-0.015;
	end
	pos(3)=0.015;
end
if bshrinky
	if isbot
		pos(2)=pos(4)+pos(2)-0.015;
	end
	pos(4)=0.015;
end
if bshrinkx || bshrinky
	set(ax2,'position',pos,'color','w','ytick',[],'box','on')
end

if nargout==0
  clear ax2
end
