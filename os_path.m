function out_path = os_path(in_path)
%OSPATH  Convert path using correct '\' alignment
%
% function out_path = os_path(path)
%
% Takes a path argument as input and corrects path for the current platform
% input :  in_path - local or network system path
% output:  out_path - corrected path for current platform
%
% Paul J. Durack - 21 April 2011

% PJD 21 Apr 2011   - Added input argument check, if > 1 ignore additional variables

% ospath.m

warning off all % Suppress warning messages

% Abort if no input arg passed..
if nargin < 1
    disp('* OS_PATH.m: no valid path specified aborting.. *')
    out_path = [];
    return
elseif ~sum(strfind(in_path,'/')) && ~sum(strfind(in_path,'\'))
    disp('* OS_PATH.m: no valid path specified aborting.. *')
    out_path = [];
    return
elseif nargin >= 2
    disp('* OS_PATH.m: too many input variables specified, using 1st only.. *')
end

if isunix % Assumes all *nix variants and macs
    path_split = ['/','\'];
    out_path = regexprep(in_path,path_split(2),path_split(1));
elseif ispc % Assume all Windows variants
    path_split = ['\','/'];
    out_path = regexprep(in_path,path_split(2),path_split(1));
end