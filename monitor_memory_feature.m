function [ in_use, free, largest_block  ] = monitor_memory_feature( )
%MONITOR_MEMORY grabs the memory usage from the feature('memstats')
%function and returns the amount (1) in use, (2) free, and (3) the largest
%contiguous block.

clc;

diary('memory_diary.txt');
feature('memstats');
diary off

FID = fopen('memory_diary.txt');

stop_a = 0;
line_number = 1;
while (stop_a == 0)
    line = fgets(FID);
    if (line == -1)
        stop_a = 1;
        break;
    end
    
    if (line_number == 3)
%       In Use:                              xxx MB (24855000)
        in_use = sscanf(line,'%*s %*s %d %*s %*s');
    end
    if (line_number == 4)
%       Free:                                xxx MB (199d7000)
        free = sscanf(line,'%*s %d %*s %*s');
    end
    if (line_number == 15)
%       1. [at 10005000]                   xxxx MB (4ad6b000)
        largest_block = sscanf(line,'%*s %*s %*s %d* %*s %d %*s %*s');
    end
    line_number = line_number + 1;
end

fclose(FID);
delete memory_diary.txt;