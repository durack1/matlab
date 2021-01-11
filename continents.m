function continents(color,edge,nmin)

% CONTINENTS(COLOR,EDGE,NMIN)
% Draw continents as patches with color COLOR
% edge color EDGE and NMIN points in coastline

% PJD  1 Nov 2009   - Updated path/hostname info for PCWIN64 boxes
% PJD 28 Mar 2012   - Updated for crunchy paths
% PJD 27 Mar 2013   - Updated for oceanonly
% PJD  9 Jan 2021   - Updated for detect

if nargin < 1, color = [.6 .6 .6]; end
if nargin < 2, edge = 'k'; end
if nargin < 3, nmin = 3; end

if isunix
    if sum(strcmp(getenv('HOSTNAME'),{'crunchy.llnl.gov','oceanonly.llnl.gov','detect.llnl.gov'}))
        load('/work/durack1/csiro/toolbox-local/csirolib/xy_map_patch')
    else
        load('/home/argo/matlab/plot/xy_map_patch')
    end
elseif strcmp(computer,'PCWIN64')
    [~,hostname] = dos('hostname'); clear status
    if strcmpi(strtrim(hostname),'D14QQ1S-HF')
        load('C:\Sync\cmar_csiro\toolbox-local\csirolib\xy_map_patch')
    elseif strcmpi(strtrim(hostname),'trusty')
        load('E:\Research\d14qq1s-hf\cmar_csiro\toolbox-local\csirolib\xy_map_patch')
    end
end

bad = find(isnan(x_map));

lastlen = 0;
x = [];
y = [];
for i = 1:length(bad)-1
    i1 = bad(i)+1;
    i2 = bad(i+1)-1;
    len = i2-i1+1;
    if len >= nmin
        if (len ~= lastlen && i > 1) || i == length(bad)-1
            patch(x,y,color,'edgecolor',edge);
            x = x_map(i1:i2)';
            y = y_map(i1:i2)';
        else
            x = [x x_map(i1:i2)'];
            y = [y y_map(i1:i2)'];
        end
        lastlen = len;
    end
end
