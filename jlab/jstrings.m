%
% JSTRINGS   Strings and groups of strings
%
% Manipulations of groups of strings
%   flushleft     - Makes a blank-padded string matrix flush on the left.
%   flushright    - Makes a blank-padded string matrix flush on the right.
%   packstrs      - Removes empty entries from a cell array of strings.
%   deblankstrs   - Deblanks all elements in a cell array of strings.
%   mat2table     - Converts a matrix of numbers into a LaTeX-style table.
%   strscat       - Concatenates a cell array of strings into one long string.
%   vnum2str      - Number to string conversion for vectors.
%
% String tests 
%   allblanks     - Equals one if string argument is all blanks or empty, else zero. 
%   isassignment  - Checks if a string is a variable assignment, e.g. 'x=cos(t);'.
%   isboolean     - Checks to see is a string is a boolean expression, e.g. 'x==10'.
%   isblank       - Tests whether elements of a string are blanks.                    
%   ismname       - Tests whether a string ends in the ".m" extension; cells ok.
%   isquoted      - Checks to see if a string is quoted in a longer expression.
%   istab         - Tests whether elements of a string are tab markers.               
%
% Conversions between string representations  
%   strs2mat      - Converts a cell array of strings into a string matrix.
%   strs2list     - Converts a cell array of strings into a comma-delimited list.
%   strs2sray     - Converts a cell array of strings into a string array /w returns.
%   mat2strs      - Converts a string matrix into a cell array of strings.
%   list2strs     - Converts a comma-delimited list into a cell array of strings.
%   sray2strs     - Converts a string array w/ returns into a cell array of strings.
%
% File and directory management
%   commentlines  - Returns the comment lines from m-files.
%   findfiles     - Returns all files in a directory with a specified extension.
%   whichdir      - Returns directory name containing file in search path.
% 
% Miscellaneous and low-level string functions
%   alphabetize   - Sorts a string matrix by its first column.
%   digit         - Returns the specified digit(s) of input numbers.
%   rmprompt      - Removes the matlab prompt ">>" from a string matrix
%   findunquoted  - Finds unquoted instances of one string inside another.
%   usefulstrings - Note on numeric representations of useful strings.
%   lengthcells   - Determines the lengths of all elements in a cell array.
%   to_overwrite  - Returns a string to overwrite original arguments.
%   to_grab_from_caller - Returns a string to grab variable values from caller.
%   reporttest    - Reports the result of an m-file function auto-test.
%   ascii2num     - Convert ASCII values for numbers into numeric values.
%  _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2004--2006 J.M. Lilly --- type 'help jlab_license' for details        

help jstrings
