function matrixOut = smooth2(matrixIn, Nr, Nc)

% smooth2.m: Smooths 2D matrix data.
%
%   matout = smooth2(matin,Nr,Nc) smooths the data in matin
%   using a running mean over 2*N+1 successive points, N points on
%   each side of the current point.  At the ends of the series
%   skewed or one-sided means are used.
%
%    Inputs:  matrixIn - original matrix
%             Nr - points used to smooth across rows (longitude/meridional)
%             Nc - points to smooth across columns (latitude/zonal)
%    Outputs: matrixOut - smoothed version of original matrix
%
%   Remark: By default, if Nc is omitted, Nc = Nr.
%
% PJD 12 Feb 2010   - Sourced from:
%                   http://www.mathworks.com/matlabcentral/fileexchange/6298-smooth2
% PJD 12 Feb 2010   - Edited original comments and help

%Initial error statements and definitions
if nargin < 2, error('Not enough input arguments!'), end

N(1) = Nr; 
if nargin < 3 
    N(2) = N(1); 
else
    N(2) = Nc;
end

if length(N(1)) ~= 1, error('Nr must be a scalar!'), end
if length(N(2)) ~= 1, error('Nc must be a scalar!'), end

for dim = 1:2 % dim = 1, smooth rows; dim = 2, smooth cols
    % Transpose matrix to smooth columns (instead of rows)
    if dim == 2
        matrixIn = matrixOut';
    end
    [row,col] = size(matrixIn);
    
    % Initialize temporary vectors
    vectorOut = zeros(1,col);
    matrixOut = zeros(row,col);
    temp = zeros(2*N(dim)+1,col-2*N(dim));
    temp(N(dim)+1,:) = matrixIn(N(dim)+1:col-N(dim));
    
    % Smooth each vector in the matrix
    for i = 1:row
        vectorIn = matrixIn(i,:);
        for j = 1:N(dim)
            vectorOut(j) = mean(vectorIn(1:j+N(dim)));
            vectorOut(col-j+1) = mean(vectorIn(col-j-N(dim):col));
            temp(j,:) = vectorIn(j:col-2*N(dim)+j-1);
            temp(N(dim)+j+1,:) = vectorIn(N(dim)+j+1:col-N(dim)+j);
        end
        vectorOut(N(dim)+1:col-N(dim)) = mean(temp);
        matrixOut(i,:) = vectorOut;
    end
end

% Transpose matrix back to original orientation
matrixOut = matrixOut';