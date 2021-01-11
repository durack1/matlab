function [year,month,day] = dectime2yymmdd(dectime)

% Paul J. Durack 13 June 2007 - Nicked from Catia

addpath /home/toolbox/local/csirolib % Make sure that gregorian/julian are on path

iyear = unique(fix(dectime));

% Initialise output variables
year = dectime * NaN; month = dectime * NaN; day = dectime * NaN;

% Treat input vectors (x,1)
year = year(:); month = month(:); day = day(:);

for j = 1:length(iyear)
    % Julian vector (take into account 365/366 ndays in the target year)
    jd = [];
    jd = julian([iyear(j) 01 01 0 0 0; iyear(j) 12 31 0 0 0]);
    jd = (jd(1):1:jd(end));
    
    % Gregorian vector
    gregday = [];
    gregday = gregorian(jd);
    
    % Decimal day based on the no. julian days to be used as index to go back to year & month format
    ndays = [];
    ndays = (1:length(jd))/length(jd);
    
    % find data in same year
    i = [];
    i = find(fix(dectime) == iyear(j));
    % disp([iyear(j) length(i)])

    % Get year & month vectors for data
    for k = 1:length(i)
        dummy = [];
        ddummy = [];
        imin = [];
        dummy = abs([dectime(i(k))-fix(dectime(i(k)))]-ndays);

        % index of the best match
        [ddummy,imin] = min(dummy);

        year(i(k),1) = gregday(imin,1);
        month(i(k),1) = gregday(imin,2);
        day(i(k),1) = gregday(imin,3)+1;
    end % k number of data in same year
end % different years