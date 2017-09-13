clc
close all
%% MASTER DEFINE TIME PERIODS
T_mach = 180e-6;  % Machining time period
f_mach = 1 / T_mach;
duty = 10;        % duty cycle in percentage
t2 = duty * T_mach / 100;  % time delay
t1 = t2 * 20/100; % IGNITION delay assumed to be 10% of the total spark duration
duty_inv = 100 - duty;   % Duty for control signal of ignition or dead time switch
duty_load = (t2-t1)/T_mach*100;  % Duty for turning ON load
delay_load = t1;

%% COMMON PARAMETERS
Vd_val = 110;
f_sw = 500e3;


%% CURRENT SOURCE PARAMETERS
r_val = 1;
rl1_val = 0.0002;
l1_val = 480e-9;

%% VOLTAGE SOURCE PARAMETERS
rc2_val = 0.0001;
c2_val = 1e-6; %0.1e-6; %Original Value
rl2_val = 0.0001;
l2_val = 0.01e-6;

%% SET POINTS
C_ref = 10;
V_ref = 80;

%% END