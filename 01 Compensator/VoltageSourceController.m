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

% Declare Symbolic Variables
syms rc2 c2 rl2 l2 Vd d2 a1 T1 a2 T2 s;
rc2_val = 0.0001;
c2_val = 0.1e-6;
rl2_val = 0.0001;
l2_val = 0.01e-6;
Vd_val = 100;

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

figure(1)
subplot(2, 1, 1)
margin(G_ss)

%% Compensator Design

% Parameters
pm_des = 60; % Desired Phase Margin
wcross = Wpm;

% Lead Compensator Design
Gc1 = (1+a1*T1*s)/(1+T1*s);
phi_m = pm_des-Pm;
a1_val = -(sind(phi_m)+1)/(sind(phi_m)-1);
T1_val = 1/(wcross*sqrt(a1_val));
Gc1 = syms2tf(subs(Gc1, [a1, T1], [a1_val, T1_val]));

% Lag Compensator Design
Gc2 = (1+a2*T2*s)/(a2*(1+T2*s));
a2_val = 1e-10;
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
[num_c2, den_c2] = tfdata(Gc);

%sim('VoltageSourceSimulation.slx')

%% End