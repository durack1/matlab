function[v1,v2,v3]=vectmult3(mat,u1,u2,u3)
%VECTMULT3  Matrix multiplication for arrays of three-vectors. 
%
%   [Y1,Y2,Y3]=VECTMULT3(M,X1,X2,X3) where MAT is a 3 x 3 matrix and 
%   X1--X3 are three arrays of the same size, returns Y1--Y3 which 
%   result from the matrix multiplication of [X1; X2; X3] with M, i.e.
%
%    [Y1(k); Y2(k); Y3(k)] = M * [X1(k); X2(k); X3(k)]
%
%   where "k" is an index into the elements of the arrays.
%  
%   There is no constraint on the size of X1--X3.  The matrix M
%   may be 3 x 3 matrix or an array of size 3 x 3 x SIZE(X1).
%  
%   Y=VECTMULT3(M,X) where X is an array of size N1 x ... NN x 3 also 
%   works.  Then the matrix M may be a 3 x 3 matrix or an array of 
%   size 3 x 3 x N1 x ... NN.
%
%   See also VECTMULT, JMAT3.
%
%   Usage:[y1,y2,y3]=vectmult3(m,x1,x2,x3);
%         y=vectmult3(m,x);  
%
%   'vectmult3 --t' runs a test.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details        

  
%x=jmat1(theta);    

if strcmp(mat,'--t')
  vectmult3_test;return
end

breshape=0;
if nargin==2
  breshape=1;
  i2=u1;
  u1=vindex(i2,1,ndims(i2));
  u2=vindex(i2,2,ndims(i2));
  u3=vindex(i2,3,ndims(i2));
end
sizeu=size(u1);

[v1,v2,v3]=vectmult3_sub(mat,u1,u2,u3);

%\********************************************************


if ~breshape
    v1=reshape(v1,sizeu);
    v2=reshape(v2,sizeu);
    v3=reshape(v3,sizeu);
else
    if sizeu(end)==1&&length(sizeu)>1
        sizeu=sizeu(1:end-1);
    end
    v1=reshape([v1;v2;v3],[sizeu 3]);
end


function[v1,v2,v3]=vectmult3_sub(mat,u1,u2,u3)
vcolon(u1,u2,u3);

m11=mat(1,1,:);
m12=mat(1,2,:);
m13=mat(1,3,:);

m21=mat(2,1,:);
m22=mat(2,2,:);
m23=mat(2,3,:);

m31=mat(3,1,:);
m32=mat(3,2,:);
m33=mat(3,3,:);


vcolon(m11,m12,m13,m21,m22,m23,m31,m32,m33);
v1=m11.*u1+m12.*u2+m13.*u3;
v2=m21.*u1+m22.*u2+m23.*u3;
v3=m31.*u1+m32.*u2+m33.*u3;

function[]=vectmult3_test
tol=1e-10;
M=100;
th=rand(M,1)*2*pi;

xo=randn(M,3);
xo1=squeeze(xo(:,1));
xo2=squeeze(xo(:,2));
xo3=squeeze(xo(:,3));

rotdim=ceil(rand(M,1)*3);
xf=vectmult3(jmat3(th,rotdim),xo);
[xf1,xf2,xf3]=vectmult3(jmat3(th,rotdim),xo1,xo2,xo3);

xfo=0*xo;
for i=1:M
  xfo(i,:)=jmat3(th(i),rotdim(i))*conj(xo(i,:)');
end

b(1)=aresame(xfo,xf,tol);
b(2)=aresame(squeeze(xfo(:,1)),xf1,tol) && aresame(squeeze(xfo(:,2)),xf2,tol)&& aresame(squeeze(xfo(:,3)),xf3,tol);

reporttest('VECTMULT3 linear 3-d vector format, random rotation',b(1))
reporttest('VECTMULT3 linear vector component format, random rotation',b(2))


