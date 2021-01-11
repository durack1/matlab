function[str]=to_grab_from_caller(index)
%TO_GRAB_FROM_CALLER  Returns a string to grab variable values from caller.
%
%   TO_GRAB_FROM_CALLER is used from within an m-file function which is
%   called with a set of variable names, and having input VARARGIN.  
%
%   STR=TO_GRAB_FROM_CALLER then returns a string STR such that EVAL(STR) 
%   within the m-file will 'grab' all input variables from the calling 
%   workspace.  That is, if an m-file is called as follows
%
%         MFILE V1 V2 V3
%    
%   then after EVAL(TO_GRAB_FROM_CALLER) within the m-file, the m-file
%   workspace will contain variables named V1, V2, and V3 whose values are
%   the same as in the calling workspace.
%
%   TO_GRAB_FROM_CALLER(INDEX) where INDEX is e.g. [1 2 3] grabs only the
%   values of the Nth the specified input variables, in this example the
%   first throught the third.
%
%   See also TO_OVERWRITE.
%
%   Usage: eval(to_grab_from_caller)
%          eval(to_grab_from_caller(index))
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006 J.M. Lilly --- type 'help jlab_license' for details
 
if nargin ==1
   if strcmp(index, '--t')
        to_grab_from_caller_test,return
   end
end

if nargin==0
  indexstr=['1:nargin'];
else
  indexstr=int2str(index);
end



clear str

str{1}=      'global ZZtemp,';
str{end+1}=  'evalin(''caller'',''global ZZtemp''),';
str{end+1}=  ['for i=[' indexstr '],'];
str{end+1}=  '   evalin(''caller'',[''ZZtemp=[];try ZZtemp= '' varargin{i} '';    , end;'']),';
str{end+1}=  '   eval([varargin{i} ''=ZZtemp;'']),';
str{end+1}=  'end,';
str{end+1}=  'evalin(''caller'',''clear ZZtemp''),';
str=strscat(str);

function[]=to_grab_from_caller_test


