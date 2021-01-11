function line = fcnstring(variable,arglist,numargs,expr)
%FCNSTRING Create string representation of cfit function
%   Note: copy of fittype/private/fcnstring, but not inherited
%   because the other function is private and inaccessible.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2005/03/07 17:25:44 $

line =sprintf('  %s(', variable);
for k = 1:(numargs-1)
    line = sprintf('%s%s,', line, deblank(arglist(k,:)));
end
line = sprintf('%s%s)', line, deblank(arglist(numargs,:)));
line = sprintf('%s = %s', line, expr);

% Fold line over multiple lines if it is too long and not yet broken
nl = sprintf('\n');
if length(line)>80 && ~ismember(nl(1),line)
   line = strtrim(line);
   breakpt = 72;
   breakchars = '+-,)= ';   % willing to break after these
   blanks = repmat(' ',1,20);
   while(breakpt <= length(line)-5)
      % Break as close as possible to current point, not too close to end
      j = find(ismember(line(breakpt:end-5),breakchars));
      if isempty(j)
         break;
      end
      breakpt = breakpt+j(1);
      line = sprintf('%s\n%s%s',line(1:breakpt),blanks,line(breakpt+1:end));
      breakpt = breakpt + 72;
   end
end
