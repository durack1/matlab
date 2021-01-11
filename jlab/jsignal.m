%
% JSIGNAL  Signal processing, wavelet and spectral analysis
%
% Multitaper analysis
%   mspec      - Multitaper power spectrum.
%   mtrans     - Multitaper "eigentransform" computation.
%   sleptap    - Slepian tapers.
%   hermfun    - Orthonormal Hermite functions. [with F. Rekibi]
%   hermeig    - Eigenvalues of orthonormal Hermite functions. [with F. Rekibi]
%
% Wavelet analysis
%   wavetrans  - Wavelet transform.
%   morsewave  - Generalized Morse wavelets. [See also below]
%   slepwave   - Slepian multi-wavelets.
%   bandnorm   - Applies a bandpass normalization to a wavelet matrix.
%
% Multi-transform polarization analysis
%   msvd       - Singular value decomposition for polarization analysis.
%
% Wavelet ridge analysis
%   ridgewalk  - Extract wavelet transform ridges.
%   ridgedebias- De-biased wavelet ridge estimator of an oscillatory signal.
%   ridgemap   - Map wavelet ridge properties onto original time series.
%
% Isolated maxima
%   isomax     - Locates isolated maximum of wavelet spectrum.
%   modmax     - Locates the modulus maxima of a wavelet transform.
%   modmaxpeaks- Locates peaks of wavelet transform modulus maxima lines.
%   edgepoints - Exclude edge effect regions from ridge or modmax points.
%
% Bandwidth and stability
%   instfreq   - Instantaneous frequency and bandwidth.
%   bellband   - Computes Bell bandwidths quantifying signal variability.
%
% Assorted other transforms   
%   wigdist    - Wigner distribution (alias-free algorithm).
%   slidetrans - Sliding-window ('moving-window') Fourier transform. 
%   hiltrans   - Hilbert transform.
%   anatrans   - Analytic part of signal.
%
% Generalized Morse wavelets [co-authored with F. Rekibi]
%   morsewave  - Generalized Morse wavelets of Olhede and Walden (2002). 
%   morsefreq  - Minimum and maximum frequencies of Morse wavelets.
%   morseprops - Properties of the demodulated generalized Morse wavelets.
%   morsebox   - Heisenberg time-frequency box for generalized Morse wavelets.
%   morsearea  - Time-frequency concentration area of Morse wavelets.
%
% Generalized Morse wavelet details
%   morsemom   - Frequency-domain moments of generalized Morse wavelets.
%   morsederiv - Frequency-domain derivatives of generalized Morse wavelets.
%   morsexpand - Generalized Morse wavelets via a time-domain Taylor series.
%   morsecfun  - Morse wavelet "C"-function.
%
%Plotting tools
%   wavespecplot- Plot of wavelet spectra together with time series.
%   edgeplot   - Draws limits of edge-effect region on wavelet transform.
%   plbl       - Label frequency axis in terms of period.
%   timelabel  - Put month, day, or hour labels on a time axes.
%
% Low-level wavelet ridge components
%   ridgequantity - Returns the quantity to be minimized for ridge analysis.
%   isridgepoint  - Finds wavelet ridge points using one of several criterion.
%   ridgestruct   - Forms wavelet ridge structure given ridge points.
%   ridgeinterp   - Interpolate transform values onto ridge locations.
%
% Sample time series
%   testseries  - Various time series for testing signal processing code.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details      

%Very low-level functions
%   morsea            - Returns the generalized Morse wavelet amplitude "a".
%   waverot     - Rotates complex-valued wavelets.

help jsignal
%   ellridge   - Extract "elliptical" ridges for bivariate time series.