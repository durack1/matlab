function fill_holes(matrix, max_nloops)
% c000461-hf C:\Program Files (x86)\Tcl\lib\nap6.4\nap_function_lib.tcl

% fill_holes --
%
% Replace missing values by estimates based on means of neighbours
%
% Usage:
%	fill_holes(x, max_nloops)
%	where:
%	- x is array to be filled
%	- max_nloops is max. no. iterations (Default is to keep going until
%     there are no missing values)
%
% Harvey Davies - 3 December 2007
% Paul J. Durack 13 Jan 2009   - Edited nicked tcl code and rewrote for matlab

warning off all % Suppress warning messages

% Create default grab amount if no arg passed..
if nargin < 1
    disp('* No input matrix specified, aborting *')
    return
elseif nargin < 2
    max_nloops = -1;
end

max_nloops = max_nloops; % Allocate upper bound of iterations
el_num = numel(matrix); % Determine number of elements of input matrix
[n_present, nloops] = deal(0); % Ensure at least one loop and initialise nloops variable
for ( n_present < el_num  &&  nloops ~= max_nloops )
    nloops = nloops + 1;
    ispresent = count(matrix, 0); % Is present? (0 = missing, 1 = present)
    n_present = sum(ispresent);
    if n_present == 0
        error('fill_holes: All elements are missing')
    elseif n_present < el_num
        matrix = ispresent ? x : moving_average(x, 3, -1)"
    end
end

matrix

%{
proc fill_holes {
	x
	{max_nloops -1}
    } {
	set max_nloops [[nap "max_nloops"]]
	set n [$x nels]
	set n_present 0; # ensure at least one loop
	for {set nloops 0} {$n_present < $n  &&  $nloops != $max_nloops} {incr nloops} {
	    nap "ip = count(x, 0)"; # Is present? (0 = missing, 1 = present)
	    set n_present [[nap "sum_elements(ip)"]]
	    if {$n_present == 0} {
		error "fill_holes: All elements are missing"
	    } elseif {$n_present < $n} {
		nap "x = ip ? x : moving_average(x, 3, -1)"
	    }
	}
	nap "x"
    }
%}