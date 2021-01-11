function mem_grab(percent_to_grab)
%
% mem_grab(percent_to_grab)
%
% Grabs a percentage of the available memory of the system and releases
% this upon allocation for system usage
%
% inputs:   percent_to_grab - Percent of the available system RAM to grab
%                             as a integer value - so 80% = 80 - This
%                             software will allow up to 80% of available
%                             system memory only to be requested
%
% Requests the appropriate sized memory block by creating a NaN-based array
% within matlab - the percent_to_grab variable specifies the amount of
% system memory that you're requesting
%
% Paul J. Durack - 9 January 2008
% PJD 26 Feb 2008   - Edited row/column assignment, warning off also set
% PJD 28 May 2008   - Enclosed the memory grab code in a try-catch loop so errors are caught and
%                     big chunks of memory are released and not held
% PJD 22 Oct 2008   - Added a default value for percent_to_grab
% PJD 13 Nov 2008   - Echo call when parsing .cshrc on thrasher causing exits.. Commented out in .cshrc

warning off all % Suppress warning messages

% Create default grab amount if no arg passed..
if nargin < 1
    disp('* No memory % specified, defaulting to 10% *')
    percent_to_grab = 10;
end

if percent_to_grab > 80
    disp('* Maximum memory requested <=80% of system total, request reset to 80% *')
    percent_to_grab = 80;
end

try
    disp(['* Currently grabbing ',num2str(percent_to_grab),'% of available system memory *'])
    % Determine array size to grab, with each NaN(1,1) variable totalling 8 bytes in memory allocated
    [status,string] = unix('grep MemTotal: /proc/meminfo');
    string = regexprep(string,'MemTotal:','');
    mem_total = str2double(regexprep(string,'kB','','ignorecase'));
    percent = percent_to_grab/100;
    mem_to_grab = mem_total*percent;
    x = mem_to_grab/.008; % mem_to_grab in KB, need bytes for memory request
    mem_grab = NaN(x,1); % Was mem_grab = NaN(1,x); PJD 26 Feb 2008 - Columns are faster
    var_info = whos('mem_grab','-bytes');
    ram_grabbed = (var_info.bytes/1024/1024/1024);
    disp(['* ',sprintf('%03.1f',ram_grabbed),'GB of system RAM allocated *'])
    clear
    disp('* Memory requested has been released back for system usage *')
catch
    clear
    disp('* Error encountered - requested memory freed back to the system *')
end