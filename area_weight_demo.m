% Create dummy matrices
clear,clc
test_mat = repmat(35,[9 10])
area = single([0.2 0.4 0.6 0.8 1 0.8 0.6 0.4 0.2]);
area_mat = repmat(area',[1 10])

% Correct - Write working to console
weighted_test_mat = test_mat.*area_mat
sum_weighted_test_mat = sum(weighted_test_mat)
sum_area_mat = sum(area_mat)
mean_of_mat = sum(weighted_test_mat)/sum(area_mat)

% Correct - Normalising all areas to = 1
area_mat_ratio = area_mat/max(area_mat(:));
weighted_mat = test_mat.*area_mat_ratio;
mean = sum(weighted_mat)/sum(area_mat)