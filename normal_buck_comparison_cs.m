%% This script calculates model and designs controller.
%  Run master_conv2.m and modelling.m before executing this script
%master_conv2;
%modelling;
%compensator_design;

%% MODELLING OF NORMAL BUCK CONVERTER AS CURRENT SOURCE
syms r rl1 l1 rc2 c2 Vd d1 s; % Declare Symbolic Variables
% rc2_val=0.01;
c2_val=10e-6;
% During ON time of Q1
A1 = [-(r*rc2 + r*rl1 + rc2*rl1)/(l1*(r+rc2)), -r/(l1*(r+rc2));
    r/(c2*(r+rc2)), -1/(c2*(r+rc2))];
B1 = [1/l1; 0];
C1 = [rc2/(r+rc2), 1/(r+rc2)];

% During OFF time of Q1
A2 = A1;
B2 = [0; 0];
C2 = C1;

% Time Averaging
A = simplify(d1*A1+(1-d1)*A2)
B = simplify(d1*B1+(1-d1)*B2)
C = simplify(d1*C1+(1-d1)*C2)

X = [I_ref; V_ref]; % Final value of state vector

% Small Signal Transfer Function
vohat_dhat = simplify(C*inv(s*eye(2)-A)*((A1 - A2)*X+(B1-B2)*Vd)+(C1-C2)*X);
% fprintf('Small Signal Transfer Function of Uncomepensated System\n')
G_CS_norm = syms2tf(subs(vohat_dhat, [r, rl1, l1, rc2, c2, Vd],...
        [r_val, rl1_val, l1_val,rc2_val, c2_val, Vd_val]))

G_CS2_norm = feedback(G_CS_norm, 1);
[num1_compr,den1_compr] = tfdata(G_CS2_norm,'v');
[z1,p1,k1] = tf2zp(num1_compr,den1_compr)

% Discrete Time Transfer Function
discreteG_CS = c2d(G_CS_norm, 1/fSampling, 'tustin');

% Gain Margin, Phase Margin, Bode Plot
% [Gm,Pm,Wgm,Wpm] = margin(G_CS_0);
% fprintf('Gain Margin = %e\n', Gm)
% fprintf('Phase Margin = %e\n', Pm)
% fprintf('Phase Crossover Frequency = %e\n', Wgm)
% fprintf('Gain Crossover Frequency = %e\n\n', Wpm)
figure(4);hold on
margin(G_CS_norm)
figure(8)
margin(G_CS_norm)
figure(6);hold on
pzmap(G_CS2_norm)
set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
%% COMPENSATOR
syms a1 T1 a2 T2; % Declare Symbolic Variables
a2_val = 1e-10;

% Lead Compensator Design
wcross = wcross2;
Gc1 = (1+a1*T1*s)/(1+T1*s);
[Mag, Ph] = bode(G_CS_norm, wcross2);
phi_m = pm_des_vs-(180+Ph);
a1_val = (1+sind(phi_m))/(1-sind(phi_m));
T1_val = 1/(wcross*sqrt(a1_val));
Gc1 = syms2tf(subs(Gc1, [a1, T1], [a1_val, T1_val]));

% Balancing Loop Gain
Ac = 1/(evalfr(G_CS_norm, wcross)*evalfr(Gc1, wcross));
fprintf('Compensator Transfer Function\n')
Gc = Ac*Gc1

% Gain Margin, Phase Margin, Bode Plot of Compensated System
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_CS_norm);
fprintf('New Gain Margin = %e\n', Gm)
fprintf('New Phase Margin = %e\n', Pm)
fprintf('New Phase Crossover Frequency = %e\n', Wgm)
fprintf('New Gain Crossover Frequency = %e\n\n', Wpm)
figure(8);hold on
margin(Gc*G_CS_norm)
[num_c1_compr, den_c1_compr] = tfdata(Gc);

%% Restoring c2_val from master_conv
c2_val = 0.1e-3;

%% END