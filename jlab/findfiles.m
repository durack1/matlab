function[varargout]=findfiles(varargin)
%FINDFILES  Returns all files in a directory with a specified extension.
%
%   FILES=FINDFILES(DIRNAME,EXT) where DIRNAME is a full directory path 
%   name and EXT is a file extension returns a cell arrays FILES of all 
%   files in directory DIRNAME having extension EXT. 
%
%   The leading '.' should be omitted from EXT, and the trailing '/' 
%   should be omitted from DIRNAME.
% 
%   For example, FILES=FINDFILES('/Users/lilly/Home/data','m') returns a
%   cell array FILES of all m-files in the specified directory.
%
%   FINDFILES(DIRNAME,'') returns files having no extension.  This can
%   be used to return directory names.
%
%   Usage: files=findfiles(pwd,'m');
%          files=findfiles(dirname,ext);    
%
%   'findfiles --t' runs a test.
%   __________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2006--2008 J.M. Lilly --- type 'help jlab_license' for details
 
if strcmp(varargin{1}, '--t')
    findfiles_test,return
end
 
dirname=varargin{1};
ext=varargin{2};

dirstruct=dir(dirname);
files=cell(length(dirstruct),1);
for i=1:length(dirstruct)
    files{i}=dirstruct(i).name;
end

bool=zeros(length(files),1);
N=length(ext);
if N==0
    for i=1:length(files)
        bool(i,1)=isempty(findstr(files{i},'.'));
    end
else
    for i=1:length(files)
        if length(files{i})>N
            bool(i,1)=strcmp(files{i}(end-N:end),['.' ext]);
        end
    end
end

index=find(bool);
if ~isempty(index)
    files=files(index);
else 
    files=[];
end

varargout{1}=files;

function[]=findfiles_test

dirname=whichdir('jlab_license');
files=findfiles(dirname,'m');
bool=0;
for i=1:length(files)
    if strcmp('jlab_license.m',files{i})
        bool=1;
    end
end

reporttest('FINDFILES found jlab_license', bool)
