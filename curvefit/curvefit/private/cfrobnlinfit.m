function [p,resnorm,res,exitflag,optoutput,lam,jacob,convmsg] = ...
                cfrobnlinfit(model,p0,xdata,wtdy,lowerbnd,upperbnd,...
                 options,probparams,separargs,wts,resin,jacob,robtype,...
                 lsiter,lsfunevals)
%CFROBNLINFIT Do robust nonlinear fitting for curve fitting toolbox.
%
%   RESIN is a vector of residuals from the non-robust fit.  JACOB is
%   the Jacobian for that fit.  LSITER and LSFUNEVALS are the number of
%   iterations and the number of function evaluations used in the initial
%   least squares fit.  See cflsqcurvefit for a description of the
%   other arguments.

%   Copyright 2001-2005 The MathWorks, Inc.
%   $Revision: 1.11.2.7 $  $Date: 2005/11/18 13:57:14 $

% Global parameter, OPT_STOP is used for canceling fits
% It is initialized and set in the Curve Fitting GUI (CreateAFit.java)
global OPT_STOP 

iteroutput = isequal(lower(options.Display),'iter');

p = p0(:);
p0 = zeros(size(p));
sqrtwts = sqrt(wts);
P = numcoeffs(model);
N = length(wtdy);

% Need the real Jacobian if things are separable
if ~isempty(separargs)
   separargs{2} = wts;
   [ignore,jacob,pfull] = ...
              feval(model,p,xdata,probparams{:},separargs{:},wts,'optimweight');
end

% Adjust residuals using leverage, as advised by DuMouchel & O'Brien
[Q,ignore]=qr(jacob,0);
h = min(.9999, sum(Q.*Q,2));
adjfactor = 1 ./ sqrt(1-h);

dfe = N-P;
ols_s = norm(resin) / sqrt(dfe);

% If we get a perfect or near perfect fit, the whole idea of finding
% outliers by comparing them to the residual standard deviation becomes
% difficult.  We'll deal with that by never allowing our estimate of the
% standard deviation of the error term to get below a value that is a small
% fraction of the standard deviation of the raw response values.
tiny_s = 1e-6 * std(wtdy) / sum(wts);
if tiny_s==0
  tiny_s = 1;
end

% Perform iteratively reweighted least squares to get coefficient estimates
D = 1e-6;
robiter = 0;

% Account for iterations and function evaluations already used
origMaxIter = options.MaxIter;
origMaxFunEvals = options.MaxFunEvals;
iterlim = options.MaxIter - lsiter;
maxfunevals = options.MaxFunEvals - lsfunevals;
totaliter = lsiter;
totalfunevals = lsfunevals;

res = resin;
while((robiter==0) || any(abs(p-p0) > D*max(abs(p),abs(p0)))) && ~isequal(OPT_STOP, 1)
   robiter = robiter + 1;
   
   if iteroutput
       disp(sprintf('\nRobust fitting iteration %i:\n---------------------------',robiter));
   end
   
   % Compute residuals from previous fit, then compute scale estimate
   radj = res .* adjfactor;
   rs = sort(abs(radj));
   sigma = median(rs(P:end)) / 0.6745;
   
   % Compute new weights from these residuals, then re-fit
   tune = 4.685;
   bw = cfrobwts(robtype,radj/(max(tiny_s,sigma)*tune));
   p0 = p;
   if ~isempty(separargs)
       separargs{2} = wts.*bw;
   end
   options.MaxIter = iterlim;
   options.MaxFunEvals = maxfunevals;
   [p,resnorm,ignore1,exitflag,optoutput,lam,ignore2,convmsg] = ...
                cflsqcurvefit(model,p0,xdata,wtdy.*sqrt(bw),...
                              lowerbnd,upperbnd,...
                              options,probparams{:},separargs{:},wts.*bw,'optimweight');

   % Reduce the iteration limit by the number of nonlinear fit iterations
   % used for this set of robust weights.  Also keep track of the total
   % number of iterations, as we would like to report that total.
   iterlim = iterlim - optoutput.iterations;
   maxfunevals = maxfunevals - optoutput.funcCount;
   totaliter = totaliter + optoutput.iterations;
   totalfunevals = totalfunevals + optoutput.funcCount;

   if ~isempty(separargs)
       [ignore1,ignore2,pfull] = ...
              feval(model,p,xdata,probparams{:},separargs{:},wts.*bw,'optimweight');
   else
      pfull = p;
   end
   res = wtdy - feval(model,pfull,xdata,probparams{:},wts,'optimweight');

   if exitflag==0
      break
   end

   % After 1st iteration for lar, don't use adjusted residuals
   if robiter==1 && isequal(robtype,'lar')
      adjfactor = 1;
   end
end
if OPT_STOP
    error('curvfit:cfrobnlintfit:fittingCancelled', ...
          'Fitting computation cancelled.');
end

optoutput.iterations = totaliter;
optoutput.funcCount = totalfunevals;

% Restore original values (this is a handle object so it may affect others)
options.MaxIter = origMaxIter;
options.MaxFunEvals = origMaxFunEvals;

% To compute the res, jacob include the weights but not robust weights.
% Resnorm is computed special below.

% Note separargs is omitted in the following two feval calls; we can't
% treat the model as separable if we are omitting the robust weights,
% because solving the linear part of the model requires them.
p = pfull;
if isequal(category(model),'library') % library and not separable
    [f,jacob] = feval(model,p,xdata,probparams{:},wts,'optimweight');
else % custom
    % Finite-difference to get Jacobian without robust weights, and recompute res with weights
    f = feval(model,p,xdata,probparams{:},wts,'optimweight'); 
    jacob = jacobianmatrix(model,p,xdata,probparams);
    jacob = repmat(sqrtwts,1,size(jacob,2)) .* jacob;
end
res = wtdy - f;

if (nargout>1)
   % Compute a robust estimate of s
   if all(bw<D | bw>1-D)
       % All weights 0 or 1, this amounts to ols using a subset of the data
       included = (bw>1-D);
       robust_s = norm(res(included)) / sqrt(sum(included) - P); 
   else
       % Compute robust mse according to DuMouchel & O'Brien (1989)
       radj = res .* adjfactor;
        robust_s = cfrobsigma(max(tiny_s,sigma),robtype,radj, P, tune, h);
   end

   % Shrink robust value toward ols value if appropriate
   sigma = max(robust_s, sqrt((ols_s^2 * P^2 + robust_s^2 * N) / (P^2 + N)));
   resnorm = dfe * sigma^2; % new resnorm based on sigma
end

%---------------------------------------------------------------
function Jacob = jacobianmatrix(fun,coeffs,x,probparams)
% JACOBIANMATRIX Compute Jacobian.

n = length(coeffs);
Jacob = zeros(length(x),n);
ypred = feval(fun,coeffs,x,probparams{:},'optim');
for i = 1:n
    bi = coeffs(i);
    if (bi == 0)
        nb = sqrt(norm(coeffs));
        change = sqrt(eps) * (nb + (nb==0));
    else
        change = sqrt(eps)*bi;
    end
    coeffs(i) = bi + change;
    predplus = feval(fun,coeffs,x,probparams{:},'optim'); % Use 'optim' flag so p can be vector
    Jacob(:,i) = (predplus - ypred)/change;
    coeffs(i) = bi;
end
