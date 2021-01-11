% This code has been written to time access times taken to read rows vs
% columns on the host machine

% Paul J Durack
% 26 September 2007

%for mtd_num = [1 4] % Consider looping through this to benchmark
mtd_num = 1;
a_multithread_num = mtd_num; setNumberOfComputationalThreads(a_multithread_num); % Enable multi-threading

% Iterate this code 10 times
time_store = NaN(10,3);
for iteration = 1:10
    n = 2e4;
    clear c c_zeros row_count col_count
    
    tic
    c = rand(n);
    c_zeros = zeros(n);
    for row_count = 1:c
        for col_count = 1:c
            if c(row_count,col_count) >= 0
                c_zeros(row_count,col_count) = c(row_count,col_count);
            end
        end
    end
    row_time = toc;
    disp(['Process time : row data:    ',sprintf('%7.4f',row_time),' seconds - 2e4 samples - multithreadnum: ',num2str(a_multithread_num)]);
    %{
    disp('Time taken to process row data: 19.8535 seconds - 2e4 samples')
    disp('Time taken to process row data: 19.9410 seconds - 2e4 samples')
    disp('Time taken to process row data: 19.9390 seconds - 2e4 samples')
    disp('Time taken to process row data: 18.8785 seconds - 2e4 samples')
    disp('Time taken to process row data: 19.9732 seconds - 2e4 samples')
    disp('Time taken to process row data: 0.12478 seconds - 2e3 samples')
    %}
    time_store(iteration,1) = row_time;
    
    clear c c_zeros row_count col_count
    tic
    c = rand(n);
    c_zeros = zeros(n);
    for col_count = 1:c
        for row_count = 1:c
            if c(row_count,col_count) >= 0
                c_zeros(row_count,col_count) = c(row_count,col_count);
            end
        end
    end
    col_time = toc; percent_diff = (((row_time/col_time)-1)*100);
    disp(['Process time : column data: ',sprintf('%7.4f',col_time),' seconds - 2e4 samples - multithreadnum: ',num2str(a_multithread_num),' - ',sprintf('%5.2f',percent_diff),'% faster']);
    %{
    disp('Time taken to process column data: 15.7355 seconds - 2e4 samples - 23.25% faster')
    disp('Time taken to process column data: 17.5682 seconds - 2e4 samples - 13.01% faster')
    disp('Time taken to process column data: 16.0396 seconds - 2e4 samples - 24.31% faster')
    disp('Time taken to process column data: 15.9978 seconds - 2e4 samples - 18.01% faster')
    disp('Time taken to process column data: 16.1855 seconds - 2e4 samples - 23.40% faster')
    disp('Time taken to process column data: 0.10509 seconds - 2e3 samples - 18.73% faster')
    %}
    time_store(iteration,2) = col_time; time_store(iteration,3) = percent_diff;

end % Iterations
clear c c_zeros row_count col_count row_time col_time percent_diff % return system memory
%{
rowname = (['ave_row_mtd_',num2str(mtd_num)])
ave_row_mthd_1 = mean(time_store_mthred_1(:,1));
ave_row_mthd_4 = mean(time_store_mthred_4(:,1));
ave_col_mthd_1 = mean(time_store_mthred_1(:,2));
ave_col_mthd_4 = mean(time_store_mthred_4(:,2));
ave_percent_mthd_1 = mean(time_store_mthred_1(:,3));
ave_percent_mthd_4 = mean(time_store_mthred_4(:,3));
%}
save -v7 /home/dur041/Shared/code/colvsrow.mat
