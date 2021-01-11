function ts_background(salt,temp)
% function ts_background(salt,temp)
%
% Takes salinity and temperature as arguments to contour density (sigma)
% as a background for T/S plots.
%
% If salt and temp are not provided as function arguments, the code assumes
% T values as 0:30 C and S values as 34:37 psu.
%
% Plot ranges are set +/- 0.5 psu either side of the S argument provided
%
% Paul J. Durack -  4 August 2008
% PJD  4 Aug 2008   - Original code provided by dom032
% PJD  4 Aug 2008   - Adapted to take salt as a function argument and
%                     preallocated memory for matrices (sptq, temq, salq)
% PJD  4 Aug 2008   - Function requires swstate function in path
% PJD  4 Aug 2008   - Now takes temp as function argument

% Create arguments if they are not provide
if nargin < 1, salt = 34:37; end
salt_range = range(salt);
salt_lo = salt_range(1)-0.5; salt_hi = salt_range(2)+0.5;
if nargin < 2, temp = (0:30)'; end

sq = linspace(salt_lo,salt_hi,length(temp))';
pq = zeros(length(temp),1);
[sgtq,temq,salq] = deal(NaN (length(temp),length(temp)) );

for i = 1:length(temp)
    ttq = ones(length(temp),1)*temp(i);
    % swstate function required in path
    [anomq,sgq] = swstate(sq,ttq,pq);
    sgtq(:,i) = sgq;
    temq(:,i) = ttq;
    salq(:,i) = sq;
end

[c1,c2] = contour(salq,temq,sgtq,'k');
for i = 1:length(c2)
    set(c2(i),'color',[.5 .5 .5],'linewidth',.1)
end
cl = clabel(c1,c2,'fontsize',8,'color',[.5 .5 .5],'labelspacing',6000);