format compact;
warning off;
close all;
clear all;
clc;

%% Handling Path for Dependencies

mydir  = pwd;
if ispc
    idcs   = strfind(mydir,'\');
else
    idcs   = strfind(mydir,'/');
end
newdir = strcat(mydir(1:idcs(end)-1), '\Dependencies');
addpath(newdir, '-end');

%% MACHINING TIMES

T_mach = 200e-6;  % Machining time period
f_mach = 1 / T_mach;
duty = 10;        % duty cycle in percentage
t2 = duty * T_mach / 100;  % time delay
t1 = t2 * 30/100; % IGNITION delay assumed to be 10% of the total spark duration
duty_inv = 100 - duty;   % Duty for control signal of ignition or dead time switch
duty_load = (t2-t1)/T_mach*100;  % Duty for turning ON load
delay_load = t1;
delayVC = 2e-4; % Delay between start of vsrc and csrc

%% DESIRED PARAMETERS

I_ref = 10;
V_ref = 80;
I1_ripple = 0.1*I_ref;
V2_ripple = 0.1*V_ref; 
I2_ripple = 0.1*I_ref; % Output current of 2 quadrant chopper is close to zero - assume this to be 10% of actual load current

%% FIXED PARAMETERS

Vd_val = 110;
r_val = 1;
Eg = 30;
f_sw = 50e3;
fSampling = f_sw;

%% INDUCTOR FOR SINGLE QUADRANT CHOPPER

Vo1 = I_ref*r_val + Eg;
l1_val = Vo1*(Vd_val-Vo1)/(I1_ripple*f_sw*Vd_val)
rl1_val = 0.0002;

%% CAPACITOR FOR TWO QUADRANT CHOPPER

c2_val = I2_ripple/(8*f_sw*V2_ripple)
rc2_val = 0.0001;

%% INDUCTOR FOR TWO QUADRANT CHOPPER

l2_val = V_ref*(Vd_val-V_ref)/(I2_ripple*f_sw*Vd_val)
rl2_val = 0.0001;

%% Calling Other Functions

VoltageSourceModel;
CurrentSourceModel;
VoltageSourceCompensator;
CurrentSourceCompensator;

QdSnubber;

%% END