function[p,skew,kurt]=gb2ps(ga,be)
%Should call this morseprops

%GB2PS  Convert Morse wavelet beta and gamma to and skewness.
%
%   [P,SKEW]=GB2PS(GAMMA,BETA) converts Morse wavelet parameters
%   GAMMA and BETA to window width P and skewness SKEW.
%
%   'gb2ps --t' runs a test.
%
%   Usage: []=gb2ps();
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2007 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    gb2ps_test,return
end

fm = morsefreq(ga,be);

[d1,d2,d3,d4]=morsederiv(ga,be,2*pi*fm);
p=fm.*sqrt(-d2);
skew=frac(ga-3,sqrt(be.*ga));
kurt=3 - skew.^2 - frac(2,be.*ga); 

function[]=gb2ps_test
 
%reporttest('GB2PS',aresame())
