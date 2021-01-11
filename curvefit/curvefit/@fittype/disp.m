function disp(obj)
%DISP   DISP for FITTYPE.

%   Copyright 1999-2005 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2005/03/07 17:26:00 $

isLoose = strcmp(get(0,'FormatSpacing'),'loose');

objectname = inputname(1);
if isempty(objectname)
   objectname = 'ans';
end
[ignore,line2] = makedisplay(obj,objectname);

if (isLoose)
   fprintf('\n');
end
fprintf('     %s\n', line2);
if (isLoose)
   fprintf('\n');
end
