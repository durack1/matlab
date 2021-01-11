clear all, close all, clc

s = 35; th = 20; ct = 20;


%%  theta equation

load rfunc16_th.dat

g = rfunc16(s,th,rfunc16_th)


%%  ct equation

load rfunc16_ct.dat

g = rfunc16(s,ct,rfunc16_ct)