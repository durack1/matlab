function[h1,h2]=linehandles(axh)
%LINEHANDES  Finds all line handles from a given set of axes.
%
%   H=LINEHANDLES returns handles to all lines associated with the
%   current axes.
%	 
%   H=LINEHANDLES(AX) returns handles to all lines associated with
%   the set of axes whose handle is AX.
%
%   See also PATCHHANDLES, AXESHANDLES
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2000--2007 J.M. Lilly --- type 'help jlab_license' for details        
  
if nargin==0
   axh=gca;
end
h=get(axh,'children');
if strcmp(get(h,'type'),'hggroup')
    h=get(h,'children');
end

if iscell(h)
    for i=1:size(h)
        h2(i)=h{i};
    end
    h=h2;
end

bool=zeros(size(h));
for j=1:length(h)
    if strcmp(get(h(j),'type'),'line')
       bool(j)=1;
    end
end
index1=find(bool);
index2=find(~bool);

h1=h(index1);     
h2=h(index2);     