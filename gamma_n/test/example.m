example_data; 

[g,dgl,dgh] = gamma_n(s,t,p,long,lat);

glevels = [26.8 27.9 28.0 28.1 28.197];

[sns,tns,pns,dsns,dtns,dpns] = nsfcs(s,t,p,g,glevels);


for icast = 1:length(long)
  fprintf(1,'\ncast # %d    location %9.4f %9.4f\n', ...
				[icast,long(icast),lat(icast)])
  fprintf(1,'\nlabels\n')
  fprintf(1,'%8.1f %12.6f %12.6f %12.6f\n',[p(:,icast),g(:,icast), ...
				       dgl(:,icast),dgh(:,icast)]')
  fprintf(1,'\nsurfaces\n')
  for isfce = 1:length(glevels)
    fprintf(1,'%9.2f %12.6f %12.6f %14.6f %6.1f\n', ...
			[glevels(isfce),sns(isfce,icast),tns(isfce,icast), ...
				pns(isfce,icast),dpns(isfce,icast)]')
  end
  fprintf(1,'\n')
end
