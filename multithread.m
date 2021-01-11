% This is a quick test for multi-threading capabilities in matlab7.4+

% Paul J. Durack 19 Sep 2007

numThreads=2;              % Number of threads to test
dataSize=5000;              % Data size to test
A=rand(dataSize,dataSize); % Random square matrix
B=rand(dataSize,dataSize); % Random square matrix
setNumberOfComputationalThreads(1);
tic;
C = A*B;
time1=toc;
disp('Time for 1 thread  = 0.058 sec - BLAS_VERSION unset; datasize=500');
disp('Time for 1 thread  = 0.081 sec - BLAS_VERSION unset; datasize=500');
disp('Time for 1 thread  = 76.920 sec - BLAS_VERSION unset; datasize=5000');
disp('Time for 1 thread  = 77.734 sec - BLAS_VERSION unset; datasize=5000');
disp('Time for 1 thread  = 78.342 sec - BLAS_VERSION unset; datasize=5000');
fprintf('Time for 1 thread  = %3.3f sec - BLAS_VERSION unset; datasize=5000\n', time1);

setNumberOfComputationalThreads(numThreads);
tic;
C = A*B;
timeN=toc;
disp('Time for 2 threads = 0.059 sec - BLAS_VERSION set; datasize=500');
disp('Time for 2 threads = 0.043 sec - BLAS_VERSION set; datasize=500');
disp('Time for 2 threads = 39.382 sec - BLAS_VERSION set; datasize=5000');
disp('Time for 2 threads = 39.286 sec - BLAS_VERSION set; datasize=5000');
disp('Time for 2 threads = 39.371 sec - BLAS_VERSION set; datasize=5000');
fprintf('Time for %d threads = %3.3f sec - BLAS_VERSION set; datasize=5000\n', numThreads, timeN);

numThreads=4;              % Number of threads to test
dataSize=5000;              % Data size to test
A=rand(dataSize,dataSize); % Random square matrix
B=rand(dataSize,dataSize); % Random square matrix
setNumberOfComputationalThreads(numThreads);
tic;
C = A*B;
timeN=toc;
disp('Time for 4 threads = 19.925 sec - BLAS_VERSION set; datasize=5000');
disp('Time for 4 threads = 19.876 sec - BLAS_VERSION set; datasize=5000');
fprintf('Time for %d threads = %3.3f sec - BLAS_VERSION set; datasize=5000\n', numThreads, timeN);

numThreads=8;              % Number of threads to test
dataSize=5000;              % Data size to test
A=rand(dataSize,dataSize); % Random square matrix
B=rand(dataSize,dataSize); % Random square matrix
setNumberOfComputationalThreads(numThreads);
tic;
C = A*B;
timeN=toc;
disp('Time for 8 threads = 12.966 sec - BLAS_VERSION set; datasize=5000');
fprintf('Time for %d threads = %3.3f sec - BLAS_VERSION set; datasize=5000\n', numThreads, timeN);