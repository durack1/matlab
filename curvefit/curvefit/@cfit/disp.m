function disp(obj)
%DISP   DISP for CFIT object.

%   Copyright 1999-2005 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $  $Date: 2005/03/07 17:25:12 $

isLoose = strcmp(get(0,'FormatSpacing'),'loose');

objectname = inputname(1);
if isempty(objectname)
   objectname = 'ans';
end

[ignore,line2,line3,line4] = makedisplay(obj,objectname);

if (isLoose)
   fprintf('\n');
end
fprintf('     %s\n', line2);
fprintf('     %s\n', line3);
if ~isempty(line4), fprintf('     %s\n', line4); end
if (isLoose)
   fprintf('\n');
end

