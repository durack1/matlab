function[]=reporttest(str,bool)
%REPORTTEST  Reports the result of an m-file function auto-test.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2003, 2004 J.M. Lilly --- type 'help jlab_license' for details        
  

global BOOL_JLAB_RUNTEST

if bool
    disp([str ' test: passed'])
    BOOL_JLAB_RUNTEST=1;
else  
    disp([str ' test: FAILED'])
    BOOL_JLAB_RUNTEST=0;
end
