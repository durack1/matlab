function [command, mat_version, mat_patch_version] = matlab_mode
%function [command, mat_version, mat_patch_version] = matlab_mode
%
% function [command, mat_version, mat_patch_version] = matlab_mode
%
% Returns the currently running process command (command) and matlab version
% number (mat_version) and patch_version (mat_patch_version) to the caller
% Can be adapted to extract additional information from the system call
%
% Paul J. Durack - 20 August 2007
% PJD 19 September 2007 - Updated to include optional matlab version number
% PJD  7 Nov 2010       - Updated to deal with Windows hosts

if isunix
    [~,result] = unix('ps -o ppid,comm | awk "/matlab_helper/ {print "\$1"}"');
    [~,result] = unix(sprintf('ps -o args= -p %s', result));
    command = result;
elseif ispc
    command = 'OS: Windows host';
end
mat_version = version;
mat_patch_version = str2double(mat_version(1:3));

% Deprecated code
% [status,result] = unix('ps -Af | grep /home/matlab7. | grep dur041'); % Return only matlab sessions running by me