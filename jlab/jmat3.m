function[x]=jmat3(theta,n)
%JMAT3 3x3 rotation matrix through specified angle.
%
%   J=JMAT3(TH,N) creates a rotation matrix about axis N in three 
%   dimensions, e.g. JMAT3(TH,3) returns
%
%       J=[COS(TH) -SIN(TH) 0;
%          SIN(TH) COS(TH)  0
%             0      0      1]; 
%
%   such that J*X rotates the column-vector X by TH radians
%   counterclockwise in the XY plane.
%
%   If LENGTH(TH)>1, then J will have dimension 3 x 3 x SIZE(TH).
%   N may either be a scalar or an array of the same length as TH.
%
%   See also VECTMULT3, JMAT.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(theta, '--t')
    jmat3_test,return
end

if length(n)==1
    n=n+zeros(size(theta(:)));
end

%error('N must be 1, 2, or 3')

x=zeros(3,3,length(theta(:)));
index=find(n==3);
if ~isempty(index)
    thetai=theta(index);
    x(1,1,index)=cos(thetai);
    x(1,2,index)=-sin(thetai);
    x(2,1,index)=sin(thetai);
    x(2,2,index)=cos(thetai);
    x(3,3,index)=1;
end

index=find(n==2);
if ~isempty(index)
    thetai=theta(index);
    x(1,1,index)=cos(thetai);
    x(1,3,index)=-sin(thetai);
    x(3,1,index)=sin(thetai);
    x(3,3,index)=cos(thetai);
    x(2,2,index)=1;
end

index=find(n==1);
if ~isempty(index)
    thetai=theta(index);
    x(1,1,index)=1;
    x(2,2,index)=cos(thetai);
    x(2,3,index)=-sin(thetai);
    x(3,2,index)=sin(thetai);
    x(3,3,index)=cos(thetai);
end

if size(theta,1)~=length(theta(:));
    x=reshape(x,[3,3,size(theta)]);
end

    
% switch n
%     case 3
%         x(1,1,:)=cos(theta);
%         x(1,2,:)=-sin(theta);
%         x(2,1,:)=sin(theta);
%         x(2,2,:)=cos(theta);
%         x(3,3,:)=1;
%     case 2
%         x(1,1,:)=cos(theta);
%         x(1,3,:)=-sin(theta);
%         x(3,1,:)=sin(theta);
%         x(3,3,:)=cos(theta);
%         x(2,2,:)=1;
%      case 1
%         x(1,1,:)=1;
%         x(2,2,:)=cos(theta);
%         x(2,3,:)=-sin(theta);
%         x(3,2,:)=sin(theta);
%         x(3,3,:)=cos(theta);
%     otherwise
%         error('N must be 1, 2, or 3')
% end
%         

function[]=jmat3_test
 
%reporttest('JMAT3',aresame())
