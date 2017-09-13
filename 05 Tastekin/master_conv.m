format compact;
warning off;
close all;
clear all;
clc;

%% TASTEKIN PAPER
Vd_val = 200;
I_ref = 1.5;
V_ref = 180;
l1_val = 180e-3;
l2_val = 1.7e-3;
c2_val = 960e-6;
f_sw = 1000e3;
T_mach = 10e-6;
t1 = 3.5e-6;
t2 = t1 + 2e-6;
duty_inv = (T_mach-t2) / T_mach * 100
duty_load = (t2 - t1) / T_mach * 100

%%
rc2_val = 0;
rl1_val = 0;
rl2_val = 0;

%% FIXED PARAMETERS
r_val = 22/1.6;
Eg = 0;



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
subplot(2, 1, 1)
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
subplot(2, 1, 1)
margin(G_CS)
%% END