function schema
%
% $Revision: 1.16.2.2 $	$Date: 2005/03/07 17:24:49 $
% Copyright 2000-2004 The MathWorks, Inc.


pk = findpackage('cftool');

% Create a new class called data

c = schema.class(pk, 'dataset');

% Add properties
schema.prop(c, 'x', 'MATLAB array');
schema.prop(c, 'y', 'MATLAB array');
schema.prop(c, 'weight', 'MATLAB array');
schema.prop(c, 'name', 'string');

schema.prop(c, 'xlength', 'double');

p=schema.prop(c, 'xname', 'string');
p=schema.prop(c, 'yname', 'string');
p=schema.prop(c, 'weightname', 'string');

schema.prop(c, 'xlim', 'MATLAB array');
schema.prop(c, 'ylim', 'MATLAB array');

p=schema.prop(c, 'plot', 'int32');
p.AccessFlags.Serialize = 'off';
p=schema.prop(c, 'line', 'MATLAB array');
p.AccessFlags.Serialize = 'off';

p=schema.prop(c, 'listeners', 'MATLAB array');
p.AccessFlags.Serialize = 'off';

p=schema.prop(c, 'ColorMarkerLine', 'MATLAB array');
schema.prop(c, 'source', 'MATLAB array');
