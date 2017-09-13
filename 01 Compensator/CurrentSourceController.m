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

% Declare Symbolic Variables
syms r rl1 l1 Vd d2 a1 T1 a2 T2 s;
r_val = 1;
rl1_val = 0.0002;
l1_val = 480e-8;
Vd_val = 100;

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

%sim('CurrentSourceSimulation.slx')

%% End