%% VOLTAGE SOURCE CONTROLLER

% VoltageSourceModel; 

%% Declare Symbolic Variables
syms a1 T1 a2 T2;

%% Compensator Design

% Parameters
pm_des = 60; % Desired Phase Margin
wcross = Wpm;
a2_val = 1e-2;

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
Ac = 1/(evalfr(G_VS, wcross)*evalfr(Gc1, wcross)*evalfr(Gc2, wcross));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1*Gc2;

% Gain Margin, Phase Margin, Bode Plot of Compensated System
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_VS);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)

figure(3)
margin(Gc*G_VS)
[num_c2, den_c2] = tfdata(Gc);

%% END