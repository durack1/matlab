%
% JDATA  Functions for data management and manipulation
%
% Naming and renaming variables. 
%   use           - Copies structure fields into named variables in workspace.
%   make          - Create a structure containing named variables as fields.
%   matsave       - Create and save structure of variables as mat-file.
%   catstruct     - Concatenates the (matrix) elements of two structures.
%   dat2vars      - Put the columns of a matrix into named vectors.
%
% Datasets of non-uniform length: column / matrix conversions. 
%   blocknum      - Numbers the contiguous blocks of an array.
%   blocklen      - Counts the lengths of 'blocks' in an array.
%   colbreaks     - Insert NANs into discontinuties in a vector.
%   mat2col       - Compress NAN-padded matrix data into long columns.
%   col2mat       - Expands 'column-appended' data into a matrix.
%
% -------------------------------------------------------------------------
% VTOOLS: Tools for operating on multiple data arrays simultaneously.
%
% Adding, multiplying, filtering
%   vadd       - Vector-matrix addition without "dimensional" hassle. 
%   vmult      - Vector-matrix multiplication without "dimensional" hassle.
%   vfilt      - Filtering along rows without change in length.
%   vdiff      - Length-preserving first central difference. 
%   vpower     - Raises array to the specified power.
%   
% Dimensions, sums, moments
%   vnd        - Number of dimensions. 
%   vsize      - Returns the sizes of multiple arguments.
%   vmoment    - Central moment over finite elements along a specfied dimension.    
%   vstd       - Standard deviation over finite elements along a specfied dimension.
%   vsum       - Sum over finite elements along a specified dimension.
%   
% Indexing, shifting, swapping
%   vindex     - Indexes an N-D array along a specified dimension. 
%   vrep       - Replicates an array along a specified dimension.                   
%   vshift     - Cycles the elements of an array along a specified dimension.       
%   vsqueeze   - Squeezes multiple input arguments simultaneously. 
%   vswap      - Swap one value for another in input arrays.
%   vcolon     - Condenses its arguments, like X(:).                           
%   vcellcat   - Concatenates cell arrays of column vectors.
%
% Initializing
%   vempty     - Initializes multiple variables to empty sets.
%   vzeros     - Initializes multiple variables to arrays of zeros.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2007 J.M. Lilly --- type 'help jlab_license' for details        

help jdata