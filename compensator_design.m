%% This script calculates model and designs controller.
%  Run master_conv2.m and modelling.m before executing this script

%% VOLTAGE SOURCE COMPENSATOR
syms a1 T1 a2 T2; % Declare Symbolic Variables
wcross2 = 2*pi*f_sw / 10; % Gain crossover frequency an order lower than switching freq
pm_des_vs = 60; % Desired phase margin
a2_vs = 1e-5; % ??????
wm2 = 1; % ??????

% Lead Compensator Design
Gc1 = (1+a1*T1*s)/(1+T1*s);
[~, Ph] = bode(G_VS, wcross2);
phi_m = pm_des_vs-(180+Ph);
a1_val = (1+sind(phi_m))/(1-sind(phi_m));
T1_val = 1/(wcross2*sqrt(a1_val));
Gc1 = syms2tf(subs(Gc1, [a1, T1], [a1_val, T1_val]));

% Lag Compensator Design
Gc2 = (1+a2*T2*s)/(a2*(1+T2*s));
T2_val = 1/(wm2*sqrt(a2_vs));
Gc2 = syms2tf(subs(Gc2, [a2, T2], [a2_vs, T2_val]));

% Balancing Loop Gain
Ac = 1/(evalfr(G_VS, wcross2)*evalfr(Gc1, wcross2)*evalfr(Gc2, wcross2));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1*Gc2

% Gain Margin, Phase Margin, Bode Plot of Compensated System
% [Gm,Pm,Wgm,Wpm] = margin(Gc*G_VS);
% fprintf('New Gain Margin = %e\n', Gm)
% fprintf('New Phase Margin = %e\n', Pm)
% fprintf('New Phase Crossover Frequency = %e\n', Wgm)
% fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)
figure(2); hold on
margin(Gc*G_VS)
[num_c2, den_c2] = tfdata(Gc);

discreteGc_VS = c2d(Gc, 1/fSampling, 'tustin')
[dis_num_c2, dis_den_c2] = tfdata(discreteGc_VS);

%% CURRENT SOURCE COMPENSATOR
syms a1 T1 a2 T2; % Declare Symbolic Variables
a2_val = 1e-10;

% Lead Compensator Design
wcross = wcross2;
Gc1 = (1+a1*T1*s)/(1+T1*s);
[Mag, Ph] = bode(G_CS, wcross2);
phi_m = pm_des_vs-(180+Ph);
a1_val = (1+sind(phi_m))/(1-sind(phi_m));
T1_val = 1/(wcross*sqrt(a1_val));
Gc1 = syms2tf(subs(Gc1, [a1, T1], [a1_val, T1_val]));

% Balancing Loop Gain
Ac = 1/(evalfr(G_CS, wcross)*evalfr(Gc1, wcross));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1

% Gain Margin, Phase Margin, Bode Plot of Compensated System
% [Gm,Pm,Wgm,Wpm] = margin(Gc*G_CS);
% fprintf('New Gain Margin = %e\n', Gm)
% fprintf('New Phase Margin = %e\n', Pm)
% fprintf('New Phase Crossover Frequency = %e\n', Wgm)
% fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)
figure(5); hold on
margin(Gc*G_CS)
[num_c1, den_c1] = tfdata(Gc);

discreteGc_CS = c2d(Gc, 1/fSampling, 'tustin')
[dis_num_c1, dis_den_c1] = tfdata(discreteGc_CS);

%% END