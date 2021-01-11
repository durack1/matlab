function schema
% Schema for basefitoptions object

% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.6.2.3 $  $Date: 2004/08/20 19:48:03 $

pk = findpackage('curvefit');
c = schema.class(pk, 'smoothoptions', pk.findclass('basefitoptions'));

% Add properties
m01Type = 'MATLAB array [0,1]';
oldType = findtype(m01Type);
if isempty(oldType)
   schema.UserType(m01Type, 'MATLAB array', @checkScalarZeroToOne);
end
schema.prop(c, 'SmoothingParam', m01Type);

% No longer use this property, but keep for backwards compatibility
p = schema.prop(c, 'SubClassPropertyListeners', 'handle.listener vector');
p.AccessFlags.Serialize = 'off';
p.AccessFlags.PublicGet = 'off';
p.AccessFlags.PublicSet = 'off';
p.AccessFlags.Reset     = 'off';

% No longer use this property, but keep for backwards compatibility
p = schema.prop(c, 'PSmoothingParam', 'MATLAB array');
p.AccessFlags.PublicGet = 'off';

%--------------------------------------------------------------------------
%---
function checkScalarZeroToOne(value)

if isempty(value)
    return;
end
if ~isa(value,'double') || issparse(value) || ...
        numel(value)~= 1 || ...
        isnan(value) || (value < 0) || (value > 1)
  error('curvefit:smoothoptions:schema:invalidParam', ...
        ['Smoothing parameter must be [] (default) or ', ...
         'a scalar in the interval [0,1].']);
end
