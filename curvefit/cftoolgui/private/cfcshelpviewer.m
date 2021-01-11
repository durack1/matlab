function cfcshelpviewer(topic, errorname)
% CFCSHELPVIEWER  is a helper file for the Curvefitting Toolbox 
% CFCSHELPVIEWER Displays help for CurveFitting TOPIC. If the map file 
% cannot be found, an error is displayed using ERRORNAME

%   Copyright 2001-2006 The MathWorks, Inc. 
%   $Revision: 1.4.2.3 $

mapfilename = [docroot '/toolbox/curvefit/cfcsh/curvefit_csh.map'];
try
    helpview(mapfilename, topic, 'CSHelpWindow');
catch
    message = sprintf('Unable to display help for %s\n', errorname);
    errordlg(message);
end
