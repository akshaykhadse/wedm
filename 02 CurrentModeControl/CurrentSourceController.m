%% Controller Design for Wire EDM Power Supply
% Author: Akshay Khadse
% Date: 13/06/2017
% Dependencies: syms2tf.m, CurrentSourceSimulation.slx

%% Initialization
format compact;
warning off;
close all;
%clear all;
clc;

r_val = 1;
rl1_val = 0.0002;
l1_val = 500e-4;
Vd_val = 100;
fs1 = 2e3;

%% End