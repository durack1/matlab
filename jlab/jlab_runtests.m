function[]=jlab_runtests(str)
%JLAB_RUNTESTS  Run test suite for JLAB package.
%
%   JLAB_RUNTEST runs all automated tests for the JLAB package.
%
%   'jlab_runtest figures' will make all possible sample figures.
%   _________________________________________________________________
%   This is part of JLAB --- type 'help jlab' for more information
%   (C) 2002--2006 J.M. Lilly --- type 'help jlab_license' for details      

if nargin==0
    str='tests';
end

global BOOL_JLAB_RUNTEST

list=jlab_list;
names=fieldnames(list);
successes=zeros(length(names),1);
failures=zeros(length(names),1);
for i=1:length(names)
    if strcmpi(str(1:3),'tes')
        BOOL_JLAB_RUNTEST=nan;
        if ~isempty(findstr(getfield(list,names{i}),'t'))
            try
                disp(['Testing ' names{i} '...'])
                eval([names{i} '(''--t'');']);
            catch    
            end
        end
        if ~isnan(BOOL_JLAB_RUNTEST)
            successes(i)=successes(i)+BOOL_JLAB_RUNTEST;
            failures(i)=failures(i)+~BOOL_JLAB_RUNTEST;
        end
    elseif strcmpi(str(1:3),'fig')
        if ~isempty(findstr(getfield(list,names{i}),'f'))
            try
                disp(['Generating figure for ' names{i} '...'])
                eval([names{i} '(''--f'');']);
            catch    
            end
        end
    end
    
end

if strcmpi(str(1:3),'tes')  
    nfailed=sum(failures);
    disp(['---------------------------------------------'])
    disp(['JLAB_RUNTESTS --- ' int2str(sum(successes)) ' of '  int2str(sum(successes+failures)) ' tests passed.'])
    if sum(failures)>0
          disp(['    Tests in the following routines failed:'])
          for i=1:length(names)
              if failures(i)~=0
                  disp(['          ' names{i} ' ... '  int2str(failures(i)) ' test(s) failed.' ])
              end
          end
    end    
end



if 0
%/********************************************************
dirname=whichdir('jlab_license');
%Make a list of all m-file names

x=dir(dirname);
for i=1:length(x)
    y{i}=x(i).name;
end
x=y;

%remove elements which are not .m 
index=find(ismname(x));
if ~isempty(index)
    x=x(index);
else
    x=[];
end

bool=ones(length(x),1);
%Set exclusions
for i=1:length(x)
    if strcmp(x{i}(1:end-2),'jlab_runtests')  %Avoid recursion
        bool(i)=0;
    end
    if strfind(x{i},'makefigs')
        bool(i)=0;
    end
end


for i=1:length(x)
   if bool(i)
       try 
         eval([x{i}(1:end-2) '(''--t'');']);
       catch
         %disp(x{i}(1:end-2))
         %err=lasterror;
         %disp(err.message)
       end
   end
end
end

%\********************************************************

% Tests not current working for randspecmat, wavegrid