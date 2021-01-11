% This script checks the speed at which row or column data is created

% Paul J Durack
% 28 February 2008

clear all, clc
mtd_num = 1;
a_multithread_num = mtd_num; maxNumCompThreads(a_multithread_num); % Enable multi-threading
clear mtd* 

% Iterate this code 10 times
time_store_row = NaN(10,1);
time_store_col = NaN(10,1);
for iteration = 1:10
    n = 2e7;
    dim2 = 32;
    % Allocate memory first, so that swap etc issues don't effect row/col calcs
    test = NaN(n,dim2); clear test
    tic
    clear a
    a = NaN(n,dim2);
    clear a
    row_time = toc;
    disp(['Process time (',num2str(iteration),') : row data:    ',sprintf('%7.4f',row_time),' seconds - ',num2str(n),' samples - multithreadnum: ',num2str(a_multithread_num)]);
    time_store_row(iteration,1) = row_time;
    clear row_time ans
    tic
    clear a
    a = NaN(dim2,n);
    clear a
    col_time = toc;
    disp(['Process time (',num2str(iteration),') : col data:    ',sprintf('%7.4f',col_time),' seconds - ',num2str(n),' samples - multithreadnum: ',num2str(a_multithread_num)]);
    time_store_col(iteration,1) = col_time;
    clear col_time
end
clear iteration ans
disp(['Mean process time : row data:    ',sprintf('%7.4f',mean(time_store_row)),' seconds - ',num2str(n),' samples - multithreadnum: ',num2str(a_multithread_num)]);
disp(['Mean process time : col data:    ',sprintf('%7.4f',mean(time_store_col)),' seconds - ',num2str(n),' samples - multithreadnum: ',num2str(a_multithread_num)]);