%
% JLAB_CHANGES   Changes to JLAB in each release.
%
%   Changes new in version 0.90 
%
%   Version 0.90 is a major new release, including:
%
%       -- Improved organization of modules
%       -- Dozens of new functions and significant fixes
%       -- New functions of spherical geometry
%       -- Fast interpolation functions: QUADINTERP and CUBEINTERP
%       -- Refactoring and improvements to wavelet ridge code
%       -- Additional Morse wavelet functions
%
%   New functions --- Generalized Morse Wavelets
%                        In support of Lilly and Olhede (2008b)
%
%   morsemom      - Frequency-domain moments of generalized Morse wavelets.
%   morsederiv    - Frequency-domain derivatives of generalized Morse wavelets.
%   morsexpand    - Generalized Morse wavelets via a Taylor-series expansion.
%   morsebox      - Heisenberg time-frequency box for generalized Morse wavelets.
%   morseprops    - Properties of the demodulated generalized Morse wavelets.
%   morsefreq     - Frequency measures for generalized Morse wavelets.  
%   dawson        - The Dawson function. [By P. J. Acklam]
%   dawsonderiv   - Derivatives of the Dawson function.
%   makefigs_morsies - Makes figures for Lilly and Olhede (2008b).
%
%   New functions  -- Instantaneous frequency and bandwidth
%                        In support of Lilly and Olhede (2008a)
%
%   instfreq    - Instantaneous frequency and bandwidth.
%   bellband    - Computes Bell bandwidths quantifying signal variability.
%   bellpoly    - Complete Bell polynomials.
%   ridgedebias - De-biased wavelet ridge estimator of an oscillatory signal.
%   makefigs_analytic - Makes figures for Lilly and Olhede (2008a).
%
%   New functions --- Spherical geometry
%
%   xyz2latlon - Converts Cartesian coordinates into latitude and longitude.
%   latlon2xyz - Converts latitude and longitude into Cartesian coordinates.
%   uvw2sphere - Converts a 3D Cartesian vector to a 3D spherical vector.
%   sphere2uvw - Converts a 3D spherical vector to a 3D Cartesian vector.
%   uvw2hor    - Projects a 3D Cartesian vector into a horizontal vector on a sphere.
%   hor2uvw    - Converts a horizontal vector on a sphere into a 3D Cartesian vector.
%   spherediv  - Divergence of a vector field on the surface of a sphere.
%   spheregrad - Gradient of a field on the surface of a sphere.
%   neareastpoint - Finds the nearest point to a specified point on the sphere.
%
%   New functions --- Aquarius satellite
%
%   aquaplot   - Plot Aquarius satellite radiometer footprint.
%   aquaprint  - Compute Aquarius satellite radiometer footprints.
%   aquasal    - Aquarius salinity change with brightness temperature.
%
%   New functions
%
%   lonshift   - Shifts longitude origin for plotting purposes.
%   heat2evap  - Transform latent heat loss into units of evaporation.
%   ellridge   - Extract "elliptical" ridges for bivariate time series.
%   findfiles  - Returns all files in a directory with a specified extension.
%   quadinterp - Fast quadratic interpolation for arbitrary-sized arrays.
%   cubeinterp - Fast cubic interpolation for arbitrary-sized arrays.
%   ellband    - Elliptical bandwidth of bivariate signal or wavelet transform.
%   jmat3      - 3-D rotation matrix through specified angle.
%   vectmult3  - Matrix multiplication for arrays of three-vectors.
%   ab2kl      - Converts A and B to ellipse parameters Kappa and Lambda.
%   kl2ab      - Converts ellipse parameters Kappa and Lambda to A and B.
%   twodmed    - Median value of a function of two variables.
%   ellsig     - Creates an elliptical signal from ellipse parameters.
%   choose     - Binomial coefficient: CHOOSE(N,K) = "N choose K"
%   latratio   - Set plot aspect ratio for latitude / longitude plot.
%   mom2cum    - Convert moments to cumulants.
%   cum2mom    - Convert cumulants to moments.
%
%   New low-level wavelet ridge functions
%
%   ridgequantity - Returns the quantity to be minimized for ridge analysis.
%   isridgepoint  - Finds wavelet ridge points using one of several criterion.
%   ridgestruct   - Forms wavelet ridge structure given ridge points.
%
%   Minor changes and improvements
%
%   DISCRETECOLORBAR bugfix for Matlab 7.5.
%   JLAB_RUNTESTS now reports summary statistics
%   MORSEWAVE now uses 'bandpass' normalization by default
%   MORSEWAVE support of non-unit sample rate and zero beta
%   MORSEWAVE additional testing with analytic expressions
%   MORSEWAVE normalization flag added
%   HERMPOLY, HERMFUN, HERMEIG changed to output N+1 terms 
%   WAVETRANS now has direct computation of generalized Morse wavelets
%   DEG2RAD and RAD2DEG modified to preserve NANs and INFs
%   MORSEFREQ output argument change; new frequency measures now computed   
%   WIGDIST modified to allow for negative frequencies; new sample figure
%   RIDGEWALK now has improved ridge control parameters
%   RIDGEWALK modification --- 
%         Connection of ambiguous ridges now done by minimizing
%         log-transform curvature, rather than amplitude difference
%   RIDGEWALK modification --- RIDGEINTERP now called internally by default
%   RIDGEINTERP now uses superior fast quadratic interpolation via QUADINTERP
%   RIDESTRUCT and RIDGEWALK use improved defintion of ridge "length"
%   RIDESTRUCT and RIDGEWALK use improved chaining algorithm 
%   RIDGEWALK and RIDGEINTERP complete retooling into low-level components
%   RIDGEWALK output argument change ---
%         Transform frequency no longer output; use INSTFREQ. 
%   RIDGEWALK recommenting, added test
%   RIDGEINTERP reclassified as "low-level" function
%   RIDGEPRUNE depricated --- use RIDGESTRUCT for same functionality
%   RIDGEWALK bugfix for chaining very sparse ridges (due to VINDEX bug)
%   RIDGEWALK ridge structure format changed for smaller size
%   RIDGEMAP now supports elliptical ridge structure from ELLRIDGE
%   VINDEX bugfix for empty indicies
%   ELLIPSEPLOT now draws ellipses in default colors
%   ELLIPSEPLOT now decimates when input a row index array
%   PACKCOLS bugfix
%   PDFMULT bugfix
%   ELLCONV factor of 2 bugfix for two-parameter rotary form
%   ELLCONV test improvements
%   ELLIPSEPLOT added 'npoints' option to set number of points in ellipse
%   ELLIPSEPLOT improved handling of string input arguments
%   ELLIPSEPLOT supress plotting of missing or zero-radius ellipses
%   BLOCKLEN added block number NUM output and tests 
%   VECTMULT input argument convention change and improved flexibility
%   VFILT added options for mirror and periodic boundary conditions
%   DEG180 and DEG360 modified to accept any input degree range
%
%   Depricated functions
%
%   SLEPENVWAVE
%   TRACK2GRID
%   RIDGERECON
%
%   Changes new in version 0.85 (Previous release)
%
%   New functions
%
%   fastcontour - Lightning-fast "fake" contouring for large matrices.
%   whichdir    - Returns directory name containing file in search path.
%   range       - RANGE(x)=[MIN(x(:)) - MAX(X(:))];
%   inregion    - Tests whether lat/lon points lie within a specified box.
%   turningpoint  - True for turning points, i.e. local extrema, along rows.
%   crossings     - Find values of an array crossing a specified threshold.
%   orbitbreaks   - Separate orbit into passes based on turning points.
%   to_grab_from_caller - Returns a string to grab variable values from caller.
%   deg360     - Converts degrees from the range [-180,180] to [0,360].
%   deg180     - Converts degrees from the range [0,360] to [-180,180].
%   rad2deg    - Converts radians to degrees.
%   deg2rad    - Converts degrees to radians.
%   latlon2xyz - Convert latitude and longitude into Cartesian coordinates.
%   xyz2latlon - Convert Cartesian coordinates into latitude and longitude.
%   latlon2zeaz - Compute zenith and azimuth angles for satellite beam.
%   zeaz2latlon - Compute latitude and longitude viewed by satellite beam.
%   ascii2num  - Convert ASCII values for numbers into numeric values.
%   jlab_settings - Specifies settings for customizable JLAB properties.
%
%   Major bugs from version 0.84
%
%   LATLON2UV 0.84 was incorrect; corrected & tested in version 0.85.
%   TRACKFILL 0.84 was incorrect; temporarily depricated.
%
%   Minor changes and improvements
%
%   Global refactoring based on MLINT suggestions
%   'jlab_runtests figures' now makes all possible sample figures
%   VINTERP renamed to JINTERP to avoid filename clash
%   VINDEX changed to suppress indexing along singleton dimensions
%   STRS2SRAY rewritten to correctly format text containing commas
%   Packing turned off in STRS2SRAY, STRS2MAT, STRS2LIST
%   MAKE modified to accept cell array input
%   LAT/LON function improvements:
%      XY2LATLON and LATLON2XY now use full spherical geometry
%      LATLON2UV rewritten to account for full sphereical geometry
%   COMMENTLINES changed to infer m-files
%   XY2ELAZ and ELAZ2XY replaced with LATLON2ZEAZ and ZEAZ2LATLON
%   EL2DIST and EL2INC renamed ZE2DIST and ZE2INC
%   FILLBAD bugfix for one bad data block; added tests
%   VFILT changed to support N-D matrices
%   VFILT input argument change -- 
%        Use VFILT(X,F,'NONANS') instead of VFILT(X,F,1) 
%   VINT2STR renamed VNUM2STR
%   VSWAP now treats +INF and -INF separately
%   JLAB_RUNTESTS refactored
%   AG2BC test added  
%   LINESTYLE now supports handle input with '-h' flag
%   LINESTYLESETS and COLORSETS now incorporated into JSETTINGS
%   JCONTOUR, JCONTOURF, LINEHANDLES, PATCHHANDLES, all modified
%       to account for changes new in Matlab 7
%   MAKEFIGS_LABCONV bugfixes
%   
%   Depricated functions
%
%   JARROW (available as "ARROW" by R.S. Oldaker, online) 
%   ISSCAL depricated; provided by built-in ISSCALAR
%   SPHEREPROJ depricated; functionality wrapped into LATLON2XY
%   MAKEFIGS_OLSEF depricated pending future improvements
%   TRACKFILL depricated pending future improvements
%
%   Changes new in version 0.84 
%   -----------------------------------------------------------------------
%   MAKEFIGS_RIDGES released; creates figures for Lilly and Gascard 2006
%   New functions for wave triad interactions in JOCEANS:
%       OM, KMIN, GC_PARAMS, TRIADRES, VTRIADRES, ISRES, RESCOEFF,
%       TRIADEVOLVE, KUN, HFUN, DFUN, I2SS, SS2I, DMSPEC, DMSTD, 
%       DMSKEW, DMASYM
%   WAVETRANS added output size test
%   WAVETRANS output change -- K and M dimensions swapped
%   MSVD added output size tests
%   MSVD input and output change -- K and M dimensions swapped
%   MSVD refactoring
%   MSVD added 'quiet' option
%   ANATRANS now different for real and complex input, as in LG06
%   TESTSERIES added replicated-modulated chirp signal
%   BANDNORM bugfix for high-frequency spillover
%
%   Changes new in version 0.83
%   -----------------------------------------------------------------------
%   New function: RIDGEMAP
%   New function: ISLARGEST
%   New functions: IMLOG, RELOG, UNWRANGLE
%   New function: RIDGEPRUNE
%   MAKELLIPSE depricated
%   ECCONV bugfix for zero eccentricity signals
%   RIDGEINTERP output argument changes
%   CIRC2ELL absorbed into ELLIPSEPLOT
%   PF_PARAMS changed to output |LON|<180
%   VDIFF timestep functionality added
%   RIDGEWALK, RIDGEINTERP, RIDGEMAP modified to work with ridge structures 
%   ISMAT bugfix
%   TWODHIST bugfix for negative data
%   HILTRANS changed to support matrix input
%   VSUM bugfix for no NaNs 
%   STRCAPTURE depricated
%   PACKROWS rewrite
%   RIDGEWALK modified to return "ascending" ridges only
% 
%   Changes new in version 0.82 
%   -----------------------------------------------------------------------
%   JLAB_LICENSE slightly altered
%   Minor change to test report convention
%   Missing tests added
%   New functions: PF_PARAMS and PF_EXTRACT
%   New functions: TRACKFILL and TRACK2GRID
%   New function: SLIDETRANS
%   New function: QUADFORM
%   New functions: ZE2DIST and ZE2INC
%   New functions: SPHEREDIST and SPHEREPROJ 
%   New function: RADEARTH
%   New functions: ZEAZ2XY and XY2ZEAZ
%   ELLCONV modified to match new notation, added tests
%   MORSEWAVE changed to specify frequency exactly
%   MORLWAVE changed to exact zero-mean formulation
%   MORSEWAVE and MORLWAVE output argument change 
%   RIDGEWALK output argument change 
%   RIDGEINTERP input and output argument change
%   VINDEXINTO bugfix and testing, led to VSHIFT bugfix 
%   ISSCALAR renamed to ISSCAL to avoid naming conflict
%   COL2MAT bugfix for length of key output matrix
%   VFILT setting filter to unit energy feature depricated
% 
%   Changes new in version 0.81
%   -----------------------------------------------------------------------
%   RIDGEINTERP bugfix to have NANs same in frequency
%   LATLON2XY and LATLON2UV have complex NANs for one output argument
%   CATSTRUCT modified to use complex NANs for missing complex data
%   MSPEC functionality split between MSPEC and new function MTRANS
%   STICKVECT bugfix
%   Missing functions included: TIDEFREQ and SPECDIAG
% 
%   Changes new in version 0.8 
%   -----------------------------------------------------------------------
%   New functions: XY2LATLON, SPECDIAG, RIDGEINTERP, TIDEFREQ
%   New functions: ECCONV, ELLCONV, ELLDIFF, ELLVEL, ELLRAD, MAKELLIPSE
%   WAVETRANS bugfix for multiple wavelets 
%   VDIFF modified for multiple input arguments
%   MAKE additional input format added 
%   VSHIFT added selection functionality 
%   ELLIPSEPLOT bugfix
%   CIRC2ELL input argument change 
%   WAVESPECPLOT chaged to allow complex-valued trasnform matrices
%   WCONVERT renamed TRANSCONV and syntax changed 
%   COMMENTLINES bugfix for directory arguments
%   RIDGEWALK and RIDGEINTERP modified to detect negative rotary transform
%   LATLON2XY bugfix for larger than 180 degree jumps; test code
%   RUNTESTS_JLAB modified to test modules separately
%   NUMSLABS moved to JARRAY
%   ROT changed to handle special cases of n*pi/2 exactly; test added
%   FILLBAD rewrite, also changed to handle complex-valued data
%   VDIFF changed to differentiate a specified dimension
%   MORSEWAVE changed to have phase definition of frequency
%   VZEROS changed to support NAN output
%   XOFFSET and YOFFSET changed to offset groups of lines
%   UVPLOT streamlined, hold off by default
%   RIDGEWALK argument convention change
%   RIDGEWALK nasty bugfix to form_ridge_chains
%   VFILT bugfix for filter of zeros and ones
%   MAKEFIGS all modified to print to current directory
%   PACKROWS and PACKCOLS changing labels feature depricated
%   ELLIPSEPLOT major axis drawing added
%   LATLON2UV bug fixed for vector day input
%   POLPARAM modified for more general input formats
%   MATMULT acceleration and test
%   POLPARAM bugfix for noise causing imaginary determinant 
%   VSUM and VSWAP modified to support possible NAN+i*NAN
%   SLEPWAVE bugfix for 'complex' flag
%   MSPEC rewrite, bugfix for odd length clockwise, test suite
% 
%   Changes new in version 0.72
%   -----------------------------------------------------------------------
%   New functions: VEMTPY, VCELLCAT, EDGEPOINTS
%   New function:  MODMAXPEAKS
%   New function:  NONNAN
%   BLOCKLEN fixed incorrect output length  
%   ELLIPSEPLOT bug fixed
%   FLUSHLEFT and FLUSHRIGHT re-written
%   LATLON2CART and LATLON2CV renamed LATLON2XY and  LATLON2UV
%        Argument handling improvements to both
%   LATLON2XY swapped order of output arguments
%   MODMAX modified to prevent long traverses 
%   MORSECFUN and MORSEAREA modified for mixed matrix / scalar arguments
%   MORSEWAVE modified to ensure centering of wavelet
%   NORMFORM bug for infinite theta fixed
%   PDFPROPS modified to output skewness and kurtosis
%   RIDGEWALK modified to handle possible absence of ridges
%   RIDGEWALK output argument improvements
%   RIDGEWALK input argument NS depricated
%   RIDGEWALK modified to output matrices
%   RIDGERECON modified to handle multivariate datasets
%   RIDGERECON modified to handle ridges of a complex-valued time series
%   SLEPTAP fixed non-unit energy for interpolated tapers
%   TWODHIST fixed counting bug and general improvements
%   WAVETRANS modified for better centering
%
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information 
%   (C) 2002--2008 J.M. Lilly --- type 'help jlab_license' for details

help jlab_changes