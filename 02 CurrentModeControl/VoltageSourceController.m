%% Controller Design for Wire EDM Power Supply
% Author: Akshay Khadse
% Date: 05/06/2017
% Dependencies: syms2tf.m, VoltageSourceSimulation.slx

%% Initialization
format compact;
warning off;
close all;
%clear all;
clc;

r_val = 1;
%rc2_val = ;
c2_val = 200e-6;
%rl2_val = ;
l2_val = 50e-4;
Vd_val = 8;
fs2 = 2e3;

%% End