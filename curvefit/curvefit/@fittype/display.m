function display(obj)
%DISPLAY Display a FITTYPE.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2005/03/07 17:26:01 $

isLoose = strcmp(get(0,'FormatSpacing'),'loose');

objectname = inputname(1);
if isempty(objectname)
   objectname = 'ans';
end

[line1,line2] = makedisplay(obj,objectname);

if (isLoose)
   fprintf('\n');
end
fprintf('%s\n', line1);
if (isLoose)
   fprintf('\n');
end
fprintf('     %s\n', line2);
if (isLoose)
   fprintf('\n');
end

