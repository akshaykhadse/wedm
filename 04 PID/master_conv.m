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

%% MASTER DEFINE TIME PERIODS

T_mach = 180e-6;  % Machining time period
f_mach = 1 / T_mach;
duty = 10;        % duty cycle in percentage
t2 = duty * T_mach / 100;  % time delay
t1 = t2 * 30/100; % IGNITION delay assumed to be 10% of the total spark duration
duty_inv = 100 - duty;   % Duty for control signal of ignition or dead time switch
duty_load = (t2-t1)/T_mach*100;  % Duty for turning ON load
delay_load = t1;

%% CALCULATION OF INDUCTORS AND CAPACITORS BASED ON RIPPLE

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
% f_sw = 500e3;
f_sw = 50e3;

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

%% MANUAL PID TUNING
% For Current Source
Kp1 = 10;
Ki1 = 0;
Kd1 = 0;

%% VOLTAGE SOURCE MODEL
% Declare Symbolic Variables
syms rc2 c2 rl2 l2 Vd d2 a1 T1 a2 T2 s;

%% State Space Model

% Power Supply As described in Paper
% Switch ON Time
A1 = [-(rl2+rc2)/l2 -1/l2;
      1/c2 0];
B1 = [1/l2; 0];
C1 = [0 1];

% Switch OFF Time
A2 = A1;
B2 = [0; 0];
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

% Steady State Transfer Function
Vo_Vd = -C*inv(A)*B;
X = Vo_Vd*Vd;

% Small Signal Transfer Function
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
vohat_dhat = simplify(C*inv(s*eye(2)-A)*(B1-B2)*Vd);
G_VS = syms2tf(subs(vohat_dhat, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val]))

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_VS);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)

figure(2)
margin(G_VS)

%% CURRENT SOURCE MODEL
% Declare Symbolic Variables
syms r rl1 l1 Vd d2 a1 T1 a2 T2 s;

%% State Space Model

% Power Supply As described in Paper
% Switch ON Time
A1 = -(rl1+r)/l1;
B1 = 1/l1;
C1 = 1;

% Switch OFF Time
A2 = A1;
B2 = 0;
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

% Steady State Transfer Function
Vo_Vd = -C*inv(A)*B;
X = Vo_Vd*Vd;

% Small Signal Transfer Function
vohat_dhat = simplify(C*inv(s*eye(1)-A)*(B1-B2)*Vd);
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
G_CS = syms2tf(subs(vohat_dhat, [r, rl1, l1, Vd],...
        [r_val, rl1_val, l1_val, Vd_val]))

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_CS);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)

figure(1)
margin(G_CS)

%% SNUBBER DESIGN OF Qd

Rs = V_ref / I_ref;
Ton = (T_mach - t2) / 100;
L = l1_val + l2_val; % Max worst case inductance across Qd
Cs_min = L * I_ref^2 / V_ref^2;
Cs_max = Ton / (10 * Rs);
Cs = (Cs_min + Cs_max) / 2;

%% COMPENSATOR DESIGN
%{
%% CURRENT SOURCE CONTROLLER
% Declare Symbolic Variables
syms r rl1 l1 Vd d2 a1 T1 a2 T2 s;

%% State Space Model

% Power Supply As described in Paper
% Switch ON Time
A1 = -(rl1+r)/l1;
B1 = 1/l1;
C1 = 1;

% Switch OFF Time
A2 = A1;
B2 = 0;
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

% Steady State Transfer Function
Vo_Vd = -C*inv(A)*B;
X = Vo_Vd*Vd;

% Small Signal Transfer Function
vohat_dhat = simplify(C*inv(s*eye(1)-A)*(B1-B2)*Vd);
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
G_ss = syms2tf(subs(vohat_dhat, [r, rl1, l1, Vd],...
        [r_val, rl1_val, l1_val, Vd_val]))

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_ss);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)

figure(1)
subplot(2, 1, 1)
margin(G_ss)

%% Compensator Design

% Parameters
pm_des = 160; % Desired Phase Margin
a2_val = 1e-10;

% Lead Compensator Design
wcross = Wpm;
Gc1 = (1+a1*T1*s)/(1+T1*s);
phi_m = pm_des-Pm;
a1_val = -(sind(phi_m)+1)/(sind(phi_m)-1);
T1_val = 1/(wcross*sqrt(a1_val));
Gc1 = syms2tf(subs(Gc1, [a1, T1], [a1_val, T1_val]));

% Lag Compensator Design
Gc2 = (1+a2*T2*s)/((1+T2*s));
T2_val = 1/sqrt(a2_val);
Gc2 = syms2tf(subs(Gc2, [a2, T2], [a2_val, T2_val]));

% Balancing Loop Gain
Ac = 1/(evalfr(G_ss, wcross)*evalfr(Gc1, wcross)*evalfr(Gc2, wcross));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1*Gc2

% Gain Margin, Phase Margin, Bode Plot of Compensated System
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_ss);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)

subplot(2, 1, 2)
margin(Gc*G_ss)
[num_c1, den_c1] = tfdata(Gc);

%% VOLTAGE SOURCE CONTROLLER

% Declare Symbolic Variables
syms rc2 c2 rl2 l2 Vd d2 a1 T1 a2 T2 s;

%% State Space Model

% Power Supply As described in Paper
% Switch ON Time
A1 = [-(rl2+rc2)/l2 -1/l2;
      1/c2 0];
B1 = [1/l2; 0];
C1 = [0 1];

% Switch OFF Time
A2 = A1;
B2 = [0; 0];
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

% Steady State Transfer Function
Vo_Vd = -C*inv(A)*B;
X = Vo_Vd*Vd;

% Small Signal Transfer Function
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
vohat_dhat = simplify(C*inv(s*eye(2)-A)*(B1-B2)*Vd);
G_ss = syms2tf(subs(vohat_dhat, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val]))

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_ss);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)

figure(2)
subplot(2, 1, 1)
margin(G_ss)

%% Compensator Design

% Parameters
pm_des = 60; % Desired Phase Margin
wcross = Wpm;
a2_val = 1e-1;

% Lead Compensator Design
Gc1 = (1+a1*T1*s)/(1+T1*s);
phi_m = pm_des-Pm;
a1_val = -(sind(phi_m)+1)/(sind(phi_m)-1);
T1_val = 1/(wcross*sqrt(a1_val));
Gc1 = syms2tf(subs(Gc1, [a1, T1], [a1_val, T1_val]));

% Lag Compensator Design
Gc2 = (1+a2*T2*s)/(a2*(1+T2*s));

T2_val = 1/sqrt(a2_val);
Gc2 = syms2tf(subs(Gc2, [a2, T2], [a2_val, T2_val]));

% Balancing Loop Gain
Ac = 1/(evalfr(G_ss, wcross)*evalfr(Gc1, wcross)*evalfr(Gc2, wcross));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1*Gc2;

% Gain Margin, Phase Margin, Bode Plot of Compensated System
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_ss);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)

subplot(2, 1, 2)
margin(Gc*G_ss)
[num_c2, den_c2] = tfdata(Gc);
%}
%% END