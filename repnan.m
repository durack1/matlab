function [y]=repnan(x,val)
% function [y]=repnan(x,val)
% Replaces NANs with val
%
ib = find(isnan(x));
y=x;
if ~isempty(ib), 
y(ib) = val*ones(size(ib));
end,
return
