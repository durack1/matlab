function[b]=bellpoly(varargin)
%BELLPOLY  Complete Bell polynomials.
%
%   BN=BELLPOLY(K1,K2,...KN) with N arguments returns the Nth order 
%   complete Bell polynomial BN.  
%
%   For details, see the article at Wikipedia:
%  
%        http://en.wikipedia.org/wiki/Bell_polynomials.
%
%   The Bell polynomials are used by Lilly and Olhede (2008a) to
%   create terms called "Bell bandwidths" quantifying signal 
%   time variability.  See BELLBAND.
%
%   BN=BELLPOLY(KCELL) also works, where KCELL is a cell array 
%   containing N elements of identical size.  
%
%   BELLPOLY uses an iterative algorithn implemented in CUM2MOM.
%
%   See also CUM2MOM, BELLBAND.
%
%   'bellpoly --t' runs some tests.
%
%   Usage: b3=bellpoly(k1,k2,k3);
%          bn=bellpoly(kcell);
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007--2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    bellpoly_test,return
end

if ~iscell(varargin{1})
    n=nargin;
    kcell=varargin;
else
    kcell=varargin{1};
    n=length(kcell);
end


kcell2{1}=0;
kcell2(2:n+1)=kcell;
mcell=cum2mom(kcell2);
mcell=mcell(2:n+1);
b=mcell{n};

% 
% if n<5
%     b=bellpoly_algebraic(n,kcell);
% else
%     b=bellpoly_determinant(n,kcell);
% end

function[b]=bellpoly_algebraic(n,k)

switch n
    case 1 
        b=k{1};
    case 2
        b=k{1}.^2+k{2};
    case 3
        b=k{1}.^3+3*k{1}.*k{2}+k{3};
    case 4
        b=k{1}.^4+6*(k{1}.^2).*k{2}+4*k{1}.*k{3}+3*k{2}.^2+k{4};
end


function[b]=bellpoly_determinant(n,kcell)
b=zeros(size(kcell{1}));
for k=1:length(b(:));
    b(k)=bellpoly_innerloop(n,k,kcell);
end

function[b]=bellpoly_innerloop(n,k,kcell)
mat=zeros(n,n);

for i=1:n
    for j=i:n
        mat(i,j)=choose(n-i,j-i).*kcell{j-i+1}(k);
    end
    if i<n
        mat(i+1,i)=-1;
    end
end
b=det(mat);
 

function[]=bellpoly_test

N=10;
kcell=cell(4,1);
for i=1:4
   kcell{i}=randn(N,1);
end

tol=1e-6;
bool1=zeros(4,1);
bool2=zeros(4,1);
for i=1:4
    b=bellpoly_algebraic(i,kcell);
    c=bellpoly_determinant(i,kcell);
    d=bellpoly(kcell);
    bool1(i)=aresame(b,c,tol);
    bool2(i)=aresame(b,c,tol);
end

reporttest('BELLPOLY algebraic versus determinant algorithms',allall(bool1))
reporttest('BELLPOLY using CUM2MOM versus algebraic',allall(bool2))

e=bellpoly(kcell);
reporttest('BELLPOLY algebraic versus determinant algorithms, cell array form',aresame(e,c,tol))


