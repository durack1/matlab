function [g,gnum,gden] = gpoly16ct(s,ct)

%        function [g,gnum,gden] = gpoly16ct(s,ct)
%
%        Calculate gamma through an approximate function in terms of
%        salinity and conservative temperature according to 'The material
%        derivative of neutral density, McDougall and Jackett, 2005'
%
%
% Input:          s           salinity
%                 ct          conservative temperature
%
% Output:         g           gamma       
%                 gnum        numerator  
%                 gden        denominator
%
% Calls:          
%
% Units:          salinity    psu (IPSS-78)
%                 temperature degrees C (IPS-90)
%
%
% Andreas Klocker on 05/06
%
%

% check input arguments
if ~(nargin ==2)
  error('gpoly16ct.m: requires 2 input arguments')
end 

zcheck(s,ct)

ct2 = ct.*ct; s2 = s.*s; sqrts = sqrt(s);

gnum =        1.0022048243661291e003 + ...
        ct.*( 2.0634684367767725e-001 + ...
        ct.*( 8.0483030880783291e-002 + ...
        ct.*(-3.6670094757260206e-004))) + ...
         s.*(-1.4602011474139313e-003 + ...
        ct.* -2.5860953752447594e-003) + ...
        s2.* -3.0498135030851449e-007;
     
gden =         1.0 + ...
        ct.*( 4.4946117492521496e-005 + ...
        ct.*( 7.9275128750339643e-005 + ...
        ct.*(-1.2358702241599250e-007 + ...
        ct.*(-4.1775515358142458e-009)))) + ...
         s.*(-4.3024523119324234e-004 + ...
        ct.*( 6.3377762448794933e-006 + ...
       ct2.* -7.2640466666916413e-010) + ...
     sqrts.*(-5.1075068249838284e-005 + ...
       ct2.* -5.8104725917890170e-009));
   
g = (gnum./gden) - 1000;

return