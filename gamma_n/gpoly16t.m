function [g,gnum,gden] = gpoly16t(s,t)

%        function [g,gnum,gden] = gpoly16t(s,t)
%
%        Calculate gamma through an approximate function in terms of
%        salinity and potential temperature according to 'The material
%        derivative of neutral density, McDougall and Jackett, 2005'
%
%
% Input:          s          salinity
%                 t          potential temperature
%
% Output:         g          gamma       
%                 gnum       numerator  
%                 gden       denominator
%
% Calls:          
%
% Units:          salinity psu (IPSS-78)
%                 potential temperature degrees C (IPS-90)
%
%
% Andreas Klocker on 05/06
%
%

% check input arguments
if ~(nargin ==2)
  error('gpoly16t.m: requires 2 input arguments')
end 

zcheck(s,t)

t2 = t.*t; s2 = s.*s; sqrts = sqrt(s);

gnum =        1.0023063688892480e003 + ...
         t.*( 2.2280832068441331e-001 + ...
         t.*( 8.1157118782170051e-002 + ...
         t.*(-4.3159255086706703e-004))) + ...
         s.*(-1.0304537539692924e-004 + ...
         t.* -3.1710675488863952e-003) + ...
        s2.* -1.7052298331414675e-007;
     
gden =         1.0 + ...
         t.*( 4.3907692647825900e-005 + ...
         t.*( 7.8717799560577725e-005 + ...
         t.*(-1.6212552470310961e-007 + ...
         t.*(-2.3850178558212048e-009)))) + ...
         s.*(-5.1268124398160734e-004 + ...
         t.*( 6.0399864718597388e-006 + ...
        t2.* -2.2744455733317707e-009) + ...
     sqrts.*(-3.6138532339703262e-005 + ...
        t2.* -1.3409379420216683e-009));
   
g = (gnum./gden) - 1000;

return
