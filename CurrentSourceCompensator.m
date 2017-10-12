%% CURRENT SOURCE CONTROLLER
% CurrentSourceModel;

%% Declare Symbolic Variables
syms a1 T1 a2 T2;

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
Ac = 1/(evalfr(G_CS, wcross)*evalfr(Gc1, wcross)*evalfr(Gc2, wcross));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1*Gc2

% Gain Margin, Phase Margin, Bode Plot of Compensated System
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_CS);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)

figure(4)
margin(Gc*G_CS)
[num_c1, den_c1] = tfdata(Gc);

%% END