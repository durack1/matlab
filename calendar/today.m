function t = today() 
%TODAY Current date. 
%   T = TODAY returns the current date.
%
%   See also CLOCK, DATENUM, DATESTR, NOW. 
 
%    Copyright 1995-2006 The MathWorks, Inc.  
%    $Revision: 1.6.2.1 $   $Date: 2006/11/08 17:47:29 $ 
 
c = clock; 
t = datenum(c(1),c(2),c(3)); 

