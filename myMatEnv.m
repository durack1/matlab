function [home_dir,work_dir,data_dir,obs_dir,username,a_host_longname,a_maxThreads,a_opengl,a_matver] = myMatEnv(maxThreads)
%MYMATENV  Setup variables, processing environment and directory paths
%
% function [home_dir,work_dir,data_dir,obs_dir,username,a_host_longname,maxThreads,a_opengl,a_matver] = myMatEnv(maxThreads)
%
% Returns the appropriate directories for target machines, so that code is
% independent of platform. Also prevent opengl rendering from occurring on
% linux boxes and set the maximum threadcount to argument supplied
%
% inputs: maxThreads - Maximum number of threads which the process will be
%                      shared across as a integer value - 2 is default
%                      This software will allow up to 75% of available
%                      system processors to be requested
%
% Paul J. Durack - 21 May 2011

% PJD 12 Aug 2009   - Include dynamic machine-dependent thread allocation
% PJD 13 Aug 2009   - For dual core machines (a_maxThreads = 1), also
%                     return a_opengl status on *nix
% PJD 20 Aug 2009   - Added a_opengl status for windows
% PJD 21 Sep 2009	- "pause" statement at username comparison tripped over shell scripts, so
%                      turned off
% PJD 22 Sep 2009   - Fixed d14qq1s-hf to validate with computer=PCWIN64
% PJD 23 Sep 2009   - Updated unix working dir to include /working/ (like windows specified work_dirs)
% PJD 27 Oct 2009   - Added a_matver as dob variable
% PJD 16 Apr 2010   - USERDNSDOMAIN was returning nil, therefore needed to update TRUSTY -> TRUSTY.
% PJD 11 May 2010   - Updated work_dir allocation for 674, CMIP3 data resides on 574, so need to
%                     access this through ~/_links/c000574-hf/
% PJD 21 Jul 2010   - Fixed bug with 675 work_dir allocation, was pointing to 574 instead
% PJD 24 Jul 2010   - Added if hostname not known, assume /work/ is work_dir
% PJD 29 Sep 2010   - Updated a_host_longname for TRUSTY and tidied up for matlab2010a+
% PJD 30 Oct 2010   - Added data_dir
% PJD  7 Nov 2010   - Added 'duro' as recognised user
% PJD 12 Apr 2011   - Added path_split variable - for use generalising paths on multiplatforms
% PJD 21 Apr 2011   - Converted path_split variable to function os_path
% PJD 27 Apr 2011   - Updated 674 work_dir to local /work/dur041/working rather than network path through _links
% PJD 21 May 2011   - Updated windows work_dir to working_574
% PJD 19 Feb 2012   - Fairly heavy editing required to add mac platform to code checks
% PJD  1 Mar 2012   - Corrected mac core_count variable with str2double
% PJD 24 Mar 2012   - Updated for crunchy
% PJD 11 May 2012   - Updated data_dir for crunchy
% PJD 14 May 2012   - Added obs_dir output
% PJD 26 Mar 2013   - Updated for oceanonly
% PJD 16 Dec 2019   - Updated for detect
% PJD 27 Feb 2021   - Updated for ml-9585568, gates

% myMatEnv.m

warning off all % Suppress warning messages

% Default maxThreads if no arg passed..
if nargin < 1
    disp('* maxThreads unspecified, defaulting to 2 *')
    a_maxThreads = 2;
else
    a_maxThreads = maxThreads;
end

% Test for maximum number of cores
if regexp(computer,'GLNX')
    [~,core_count] = unix('cat /proc/cpuinfo | grep processor | wc -l');
    core_count = str2double(core_count);
elseif regexp(computer,'MACI')
    [~,core_count] = unix('system_profiler SPHardwareDataType | grep "Total Number of Cores"');
    core_count = str2double(core_count(30)); % Hard code
elseif regexp(computer,'PCWIN')
    [~,core_count] = dos('set | find "NUMBER_OF_PROCESSORS"');
    core_count = regexprep(core_count,'NUMBER_OF_PROCESSORS=','');
    core_count = str2double(core_count);
end

% Set maxThreads
setMaxCores = floor(core_count*0.75);
if exist('a_maxThreads','var')
    if setMaxCores > a_maxThreads
        maxNumCompThreads(a_maxThreads);
    elseif core_count <= 2
        a_maxThreads = 1;
        maxNumCompThreads(a_maxThreads);
    else
        a_maxThreads = 2;
        maxNumCompThreads(a_maxThreads);
    end
    clear ans
else
    a_maxThreads = 2;
    maxNumCompThreads(a_maxThreads);
    clear ans
end

% If unix turn off opengl rendering
if isunix
    opengl neverselect
    a_opengl = 'off';
else
    a_opengl = 'on';
end

% Set matlab version
a_matver = version;

% Test user
if isunix
    [~,username] = unix('env | grep USER=');
    username = strtrim(regexprep(username,'USER=',''));
    %path_split = {'/','\'};
elseif ispc
    [~,username] = dos('set | find "USERNAME="');
    username = strtrim(regexprep(username,'USERNAME=',''));
    %path_split = {'\','/'};
end
if ~strcmp(username,'dur041') && ~strcmpi(username,'Duro') && ~strcmp(username,'durack1')
    disp('MYMATENV.M: NON-dur041/Duro/durack1 user determined, continuing..')
    %pause
end

% Set home and work directories
if regexp(computer,'GLNX')
    a_host_longname = getenv('HOSTNAME');
    if strcmp(a_host_longname,'c000574-hf.hba.marine.csiro.au')
        home_dir = ['/home/',username,'/Shared/'];
        work_dir = ['/work/',username,'/working/'];
        data_dir = '/home/datalib/';
        obs_dir  = ['/home/',username,'/Shared/Obs_Data/'];
    elseif strcmp(a_host_longname,'c000674-hf.hba.marine.csiro.au')
        home_dir = ['/home/',username,'/Shared/'];
        work_dir = ['/work/',username,'/working/'];
        data_dir = '/home/datalib/';
        obs_dir  = ['/home/',username,'/Shared/Obs_Data/'];
    elseif strcmp(a_host_longname,'.hba.marine.csiro.au')
        home_dir = ['/home/',username,'/Shared/'];
        work_dir = '/work/';
        data_dir = '/home/datalib/';
        obs_dir  = ['/home/',username,'/Shared/Obs_Data/'];
        disp('MYMATENV.M: work_dir assumed for local /work/..')
    elseif sum(strcmp(a_host_longname,{'crunchy.llnl.gov','detect.llnl.gov', ...
                                       'oceanonly.llnl.gov','gates.llnl.gov'}))
        home_dir = ['/work/',username,'/Shared/'];
        work_dir = '/work/';
        data_dir = ['/work/',username,'/csiro/'];
        obs_dir  = ['/work/',username,'/Shared/obs_data/'];
    end
elseif regexp(computer,'MACI')
    a_host_longname = java.net.InetAddress.getLocalHost.getHostName;
    home_dir = '/Volumes/durack1ml/sync/Shared/';
    work_dir = '/Volumes/durack1ml/sync/Work/';
    data_dir = '/Volumes/durack1ml/sync/cmar_csiro/';
    obs_dir  = '/Volumes/durack1ml/sync/Shared/obs_data/';
elseif strcmp(computer,'PCWIN64')
    a_host_longname = [getenv('COMPUTERNAME'),'.',getenv('USERDNSDOMAIN')];
    if strcmp(a_host_longname,'TRUSTY.')
        a_host_longname = 'TRUSTY';
        home_dir = 'E:\Research\d14qq1s-hf\Shared\';
        work_dir = 'E:\Research\d14qq1s-hf\working_574\';
        data_dir = 'E:\Research\d14qq1s-hf\cmar_csiro\';
        obs_dir  = 'E:\Research\d14qq1s-hf\Shared\obs_data\';
    end
    if strcmp(a_host_longname,'D14QQ1S-HF.NEXUS.CSIRO.AU')
        home_dir = 'C:\Sync\Shared\';
        work_dir = 'C:\Sync\working_574\';
        data_dir = 'C:\Sync\cmar_csiro\';
        obs_dir  = 'C:\Sync\Shared\obs_data\';
    end
end