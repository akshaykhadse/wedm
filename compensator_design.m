%% This script calculates model and designs controller.
%  Run master_conv2.m before executing this script

%% VOLTAGE SOURCE MODEL
syms rc2 c2 rl2 l2 Vd d2 s; % Declare Symbolic Variables

% During ON time of Q1
A1 = [-(rl2+rc2)/l2 -1/l2; 1/c2 0];
B1 = [1/l2; 0];
C1 = [rc2 1];

% During OFF time of Q1
A2 = A1;
B2 = [0; 0];
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

X = [I_L2 ;V_ref]; % Final value of state vector

% Small Signal Transfer Function
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
vohat_dhat = simplify(C*inv(s*eye(2)-A)*((A1 - A2)*X+(B1-B2)*Vd)+(C1-C2)*X);
G_VS = syms2tf(subs(vohat_dhat, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val]));

% Discrete Time Transfer Function
discreteG_VS = c2d(G_VS, 1/fSampling, 'tustin');

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_VS);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)
figure(1)
margin(G_VS)

%% VOLTAGE SOURCE CONTROLLER
syms a1 T1 a2 T2; % Declare Symbolic Variables
wcross2 = 2*pi*f_sw / 10; % Gain crossover frequency an order lower than switching freq

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
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_VS);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)
figure(3)
margin(Gc*G_VS)
[num_c2, den_c2] = tfdata(Gc);

%% CURRENT SOURCE MODEL
syms r rl1 l1 Vd d2 s; % Declare Symbolic Variables

% During ON time of Q2
A1 = -(rl1+r)/l1;
B1 = 1/l1;
C1 = 1;

% During OFF time of Q2
A2 = A1;
B2 = 0;
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

X = I_ref; % Final value of state vector

% Small Signal Transfer Function
vohat_dhat = simplify(C*inv(s*eye(1)-A)*((A1 - A2)*X+(B1-B2)*Vd)+(C1-C2)*X);
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
G_CS = syms2tf(subs(vohat_dhat, [r, rl1, l1, Vd],...
        [r_val, rl1_val, l1_val, Vd_val]));

% Discrete Time Transfer Function
discreteG_CS = c2d(G_CS, 1/fSampling, 'tustin');

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_CS);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)
figure(2)
margin(G_CS)

%% CURRENT SOURCE CONTROLLER
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
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_CS);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)
figure(4)
margin(Gc*G_CS)
[num_c1, den_c1] = tfdata(Gc);

%% END