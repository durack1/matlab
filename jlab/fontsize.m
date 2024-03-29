function[]=fontsize(i1,i2,i3,i4)
%FONTSIZE Rapidly set title, axes, label, and text fontsizes.
%
%   FONTSIZE(TITLES, LABEL, AXES, TEXT) sets the fontsizes of all 
%   titles, x/y/z labels, axes, and text objects in the current
%   figure to the specified values.  To avoid changing a fontsize,
%   use the empty set: FONTSIZE(14,[],12)
%	
%   FONTSIZE('NAME'), where NAME refers to a  predetermined set
%   of font sizes, also works.  Type FONTSIZE with no arguments
%   to see a list of available fontsize sets. 
%
%   When the input arguments are numbers (not named variables) or
%   a string referring to a fontsize set, parenthesis may be omitted.
%   For instance: 
%  
%	    FONTSIZE 14 12 12 10
%	    FONTSIZE DEFAULT   
%
%   Additional fontsize sets may be added to the M-file FONTSIZESETS.  
%
%   See also LINESTYLE, LINERING
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2000, 2004 J.M. Lilly --- type 'help jlab_license' for details  
  

fonts=fontsizesets;

if nargin==0
   %if no arguments, just display available fontsize sets
   disp(' ');
   disp('Available fontsize sets:');
   disp(' ');
   disp(fonts)
   disp(' ');
else

name=[];
if nargin==1
     if ischar(i1)
	  if isempty(str2num(i1))
	     name=i1;
	  end
     end
end

%move through all input parameters, evaluate if strings
if isempty(name)
   for i=1:nargin
       arg=eval(['i' int2str(i)]);
       if ischar(arg)  
	     eval(['i' int2str(i) '=' arg ';'])
       end
    end
    %initialize noninput data to empty set
    for j=i+1:4
       eval(['i' int2str(j) '=[];'])
    end
end

if ~isempty(name)
	if ~isfield(fonts,name)
		error('That is not a valid fontsize set name.')
	else
		sizes=getfield(fonts,name);
		fst=sizes(1);
		fsl=sizes(2);
		fsa=sizes(3);
		fsx=sizes(4);
	end
else
	fst=i1;
	fsl=i2;
	fsa=i3;
	fsx=i4;
end

h=get(gcf,'children');
for i=1:length(h)
	if ~isempty(fsa)
	   set(h(i),'fontsize',fsa)
    end
	if ~isempty(fst)
	   set(get(h(i),'title'),'fontsize',fst)
    end
	if ~isempty(fsl)
	   set(get(h(i),'xlabel'),'fontsize',fsl)
       set(get(h(i),'ylabel'),'fontsize',fsl)
    end
	hh=get(h(i),'children');
	if ~isempty(fsx)
		for j=1:length(hh)
			if strcmp(get(hh(j),'type'),'text')
				set(hh(j),'fontsize',fsx)
			end
		end
	end
end


end




