function float = gourfloat(float)
% Extracts Gouretski and Koltermann profiles at float data points 
% 
% HEP April 2004, Modification of carsfloat.m
% SEW August 2001 CMR
% Paul Durack, CSIRO January 29 2007
% -070129 Add code to remove duplicate values which was causing interp1 to fall over

addpath /home/eez_data/software/matlab
addpath /home/argo/climatology/gouretski


float(1).tgour = NaN*float(1).t;
float(1).sgour = NaN*float(1).t;

len_fl = length(float);
lat = nan*ones(1,len_fl);
lon = lat;
for j = 1:length(float) 
    if float(j).npoints > 1,
        lat(j) = float(j).lat(1);
        lon(j) = float(j).lon(1);
    end
end
% Extract Gouretski temp (tg), salt (sg), ? (gg) and pres (p)
[tg,sg,gg,p] = gouretski_profiles(lon,lat); % Assume source dir for gouretski_profiles.m is in path
%disp('from gourfloat.m')
%tg = tg(1,1:5)
%sg = sg(1,1:5)
%gg = gg(1,1:5)
%p = p(1)
%pause
% project to float depths
for j = 1:length(float) 
    if float(j).npoints > 1,
        pf = float(j).p;         
        if exist('float(j).p_calibrate')
           pf = float(j).p_calibrate;
        end
        
        tgp = interp1q(p,tg(:,j),pf(:));
        sgp = interp1q(p,sg(:,j),pf(:));
% project salinity to float pt:
% 
        ss = float(j).s;
        if isempty(ss)
           ss = float(j).s;
        end
        float(j).pt = sw_ptmp(ss,float(j).t,float(j).p,0.);
        ptgp = sw_ptmp(sgp,tgp,pf,0.);
        ig = ~isnan(sgp); % Check for NaN values (is good), and index these
        % Remove duplicate values - to solve: '??? Error using ==> % interp1 The values of X should be distinct.'
        [t_ptgp, m, n] = unique(ptgp(ig)); % Return truncated unique values to t_pgtp, with m the index of ptgp
        %sizept = size(t_ptgp)
        t_sgp = sgp(ig);
        t_sgp = t_sgp(m); % Return sgp indexed to t_ptgp
        %sizes = size(t_sgp)
        ig = ~isnan(t_sgp); % Resize ig (is good) values on new unique array
        %t_floatpt = float(j).pt;
        %t_floatpt = t_floatpt(m); % Return float(j).pt indexed to t_ptgp
        %sizefl = size(t_floatpt)
        %test = sum(ig)
        %pause
        if sum(ig) > 3,
            %%Aptgp = ptgp(ig)
            %cptgp = class(ptgp(ig))
            %sizep = size(ptgp(ig))
            %%Asgp = sgp(ig)
            %csgp = class(sgp(ig))
            %sizes = size(sgp(ig))
            %%Afloat = float(j).pt
            %cfloatj = class(float(j).pt)
            %sizef = size(float(j).pt)
            %scp = interp1(ptgp(ig),sgp(ig),float(j).pt); % Old code doesn't remove duplicates
            scp = interp1(t_ptgp,t_sgp,float(j).pt);
            %scp = interp1(t_ptgp,t_sgp,t_floatpt)
            %disp('good as gold')
            %pause(1)
        % form difference
           sdiffp = [ss(:) - scp(:)];

           % Debug by plotting the output from each station iteration
           %clf
           %plot(ptc(ig),sc(ig),float(j).pt,scp,float(j).pt,float(j).s,'k',float(j).pt,sdiffp)
           %title(int2str(j))
           %pause
        else
            sdiffp = NaN*ss;
        end % store stuff:
        
        float(j).tgour = tgp(:);
        float(j).sgour = sgp(:);
        float(j).sdiff = sdiffp(:);
    else
    % fill with Nans
        float(j).tgour = NaN*float(j).t;
        float(j).sgour = NaN*float(j).t; 
        float(j).sdiff = NaN*float(j).t;     
    end
end

return
