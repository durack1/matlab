function g = rfunc16(s,t,x)

ss = s(:); tt = t(:); 

A(:,1) = ones(length(ss),1);
A(:,2) = tt;
A(:,3) = tt.^2;
A(:,4) = tt.^3;
A(:,5) = ss;
A(:,6) = ss.*tt;
A(:,7) = ss.*ss;

A(:,8) = tt;
A(:,9) = tt.^2;
A(:,10) =  tt.^3;
A(:,11) =  tt.^4;
A(:,12) = ss;
A(:,13) =  ss.*tt;
A(:,14) =  ss.*tt.^3;
A(:,15) = ss.*sqrt(ss);
A(:,16) = ss.*sqrt(ss).*tt.^2;

gnum = A(:,1:7)*x(1:7);

gden = 1+A(:,8:16)*x(8:16);

g = gnum./gden;

return