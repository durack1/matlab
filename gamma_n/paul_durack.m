clear all, close all, clc

load Durack_data_090709

disp(' '), disp('computing ...')

tic, g = gamma_n(s,t,pressure_levels*ones(1,100),x,y); toc
