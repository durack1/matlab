% find the coastlines from hypsometric data , to 
% be used in flux integrations for the oceans

% Susan Wijffels - harvested from Susan 16 Aug 2007: /home/wijffels/matlab
% PJD 16 Aug 2007   - Updated indents to reflect loop depth

if ~[exist('hd') & exist('xd')],
    load world_topo_20m.mat
    xd = real(xb); yd=real(yb); hd=real(db);
    clear xb yb db
end

% Eastern boundary of Pacific
xc = 360-140;

junk =  ones(length(yd),1)*xd';
iocean = find(hd < 50);

junk(iocean) = 999.*ones(size(iocean));

iwest = find(junk < xc);
junk(iwest) = 999.*ones(size(iwest));

for i = 1:length(yd);
    [val,in] = min( junk(i,:) - xc);
    xpacE(i) = xd(in);
end

% Western Pacific boundary:x

xc = 170.;

junk =  ones(length(yd),1)*xd';
iocean = find(hd < 0.);

junk(iocean) = -999.*ones(size(iocean));
ieast = find(junk > xc);
junk(ieast) = -999.*ones(size(ieast));

for i = 1:length(yd);
    if(yd(i) < -15 & xc == 170.), xc= 150.;,end
    [val,in] = max( junk(i,:) - xc);
    xpacW(i) = xd(in);
end


% fix up western boundary:

iaus = find(yd <= -35 & yd >= -45);
xpacW(iaus(5:6)) = 147.5*ones(2,1);

% eastern boundary of Indian
xc = 90;
junk =  ones(length(yd),1)*xd';
iocean = find(hd < 0.);

junk(iocean) = 999.*ones(size(iocean));
iwest = find(junk < xc);
junk(iwest) = 999.*ones(size(iwest));
for i = 1:length(yd);
    [val,in] = min( junk(i,:) - xc);
    xindE(i) = xd(in);
end

% deal with torres
in = find(yd > -12 & yd <= -9);
xindE(in) = 130;


% western boundary of Indian
xc = 60;
junk =  ones(length(yd),1)*xd';
junk2 = yd*ones(1,length(xd));
iocean = find(hd < 0.);

junk(iocean) = -999.*ones(size(iocean));
iwest = find(junk > xc);
junk(iwest) = -999.*ones(size(iwest));
% deal with Madagascar
iwest = find(junk > 40. & junk2 < -10);
junk(iwest) = -999.*ones(size(iwest));
for i = 1:length(yd);
    [val,in] = max( junk(i,:) - xc);
    xindW(i) = xd(in);
end

% western boundary of Atlantic

xc = 340;
junk =  ones(length(yd),1)*xd';
junk2 = yd*ones(1,length(xd));
iocean = find(hd < 0.);

junk(iocean) = -999.*ones(size(iocean));
iwest = find(junk > xc);
junk(iwest) = -999.*ones(size(iwest));
% deal with ???
iwest = find(junk > 275. & junk2 < 30 & junk2 > 10.);
junk(iwest) = -999.*ones(size(iwest));
iwest = find(junk > 250. & junk2 >60  );
junk(iwest) = -999.*ones(size(iwest));
for i = 1:length(yd);
    [val,in] = max( junk(i,:) - xc);
    xatlW(i) = xd(in);
end
% get labrador sea
in = find(yd > 59);
xatlW(in) = 250;

in = find(yd > -52.6 & yd < -50.8);
xatlW(in) = 290.5;

%set(h,'Visible','off')
%h = plot(xatlW,yd,'o')

% Eastern boundary of Atlantic
xc = 340;
[val,im] = min(abs(xd-180));
imap = [im:length(xd),1:[im-1]];
xdd = xd;
is = find(xd < length(yd));
xdd(is) = xd(is) + 360.;
junk =  ones(length(yd),1)*xdd(imap)';
iocean = find(hd(:,imap) < 0.);

junk(iocean) = 999.*ones(size(iocean));
iwest = find(junk < xc);
junk(iwest) = 999.*ones(size(iwest));
iwest = find(junk < 370. & junk2 >60  );
junk(iwest) = -999.*ones(size(iwest));

for i = 1:length(yd);
    [val,in] = min( junk(i,:) - xc);
    xatlE(i) = xd(imap(in));
end

% fix up Pacific western boundary:
in = find(yd > 0);
xpacW(in)= xindE(in);
in = find(yd <= -39);
xpacW(in)= 147*ones(size(in));
xindE(in)= 147*ones(size(in));

% fix up Pacific western boundary:
in = find(yd > -25);
xpacW(in)= xindE(in);

in = find(yd <= -39);
xpacW(in)= 147*ones(size(in));
xindE(in)= 147*ones(size(in));

% fix up Pacific eastern boundary:
in = find(yd <= -54);
xpacE(in)= 292.7*ones(size(in));
xatlW(in)= 292.7*ones(size(in));

% fix up Indian western boundary:
in = find(yd <= -34);
xindW(in)= 20*ones(size(in));
xatlE(in)= 20*ones(size(in));

in= find(yd > 30);
xindW(in) = 80;
xindE(in) = 80;

in = find(yd < -39);
xindE(in) = xpacW(in);