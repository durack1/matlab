% Thrown together to get MLD fields from CARS T and S fields  10/5/06

dep = csl_dep(1:45,3);

[xch,ych] = meshgrid(0:20:340,-70:20:20);

X = 0:.5:360;
Y = -70:.5:26;

mlds = repmat(nan,[length(Y) length(X) 5]);

for ii = 1:prod(size(xch))
   xs = [xch(ii) xch(ii)+20];
   ys = [ych(ii) ych(ii)+20];
   
   [S,a,b,c,d,x,y] = getchunk('s',dep,[xs ys],[],'cars2005a',-1);
   T = getchunk('t',dep,[xs ys],[],'cars2005a');
   bdep = get_bath(x,y);

   if xs(2)==360; xs(2) = 361; end
   
   y = y(:,1)';
   x = x(1,:);
   
   iX = find(X>=xs(1) & X<xs(2));
   iY = find(Y>=ys(1) & Y<ys(2));
   ix = find(x>=xs(1) & x<xs(2));
   iy = find(y>=ys(1) & y<ys(2));
   

   for i2 = 1:length(ix)
      for i1 = 1:length(iy)
	 j = iy(i1); k = ix(i2);
	 [mld,flg,pd] = mixld(sq(T(j,k,:)),sq(S(j,k,:)),dep',[],[],bdep(j,k));
	 mlds(iY(i1),iX(i2),:) = mld;
      end
   end
end
