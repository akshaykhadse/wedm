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
% fprintf('Small Signal Transfer Function of Uncomepensated System\n')
vohat_dhat = simplify(C*inv(s*eye(2)-A)*((A1 - A2)*X+(B1-B2)*Vd)+(C1-C2)*X);
G_VS = syms2tf(subs(vohat_dhat, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val]))

G_VS2 = feedback(G_VS, 1);
[num1,den1] = tfdata(G_VS2,'v');
[z1,p1,k1] = tf2zp(num1,den1)

% Discrete Time Transfer Function
discreteG_VS = c2d(G_VS, 1/fSampling, 'tustin');

% Gain Margin, Phase Margin, Bode Plot
% [Gm,Pm,Wgm,Wpm] = margin(G_VS);
% fprintf('Gain Margin = %e\n', Gm);
% fprintf('Phase Margin = %e\n', Pm);
% fprintf('Phase Crossover Frequency = %e\n', Wgm);
% fprintf('Gain Crossover Frequency = %e\n\n', Wpm);
figure(1)
margin(G_VS)
figure(2)
margin(G_VS)
figure(3)
pzmap(G_VS2)


%% CURRENT SOURCE MODEL
syms r rl1 l1 Vd d2 s; % Declare Symbolic Variables

% During ON time of Q1
A1 = -(rl1+r)/l1;
B1 = 1/l1;
C1 = 1;

% During OFF time of Q1
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
% fprintf('Small Signal Transfer Function of Uncomepensated System\n');
G_CS = syms2tf(subs(vohat_dhat, [r, rl1, l1, Vd],...
        [r_val, rl1_val, l1_val, Vd_val]))

G_CS2 = feedback(G_CS, 1);
[num1,den1] = tfdata(G_CS2,'v');
[z1,p1,k1] = tf2zp(num1,den1)

% Discrete Time Transfer Function
discreteG_CS = c2d(G_CS, 1/fSampling, 'tustin');

% Gain Margin, Phase Margin, Bode Plot
% [Gm,Pm,Wgm,Wpm] = margin(G_CS);
% fprintf('Gain Margin = %e\n', Gm);
% fprintf('Phase Margin = %e\n', Pm);
% fprintf('Phase Crossover Frequency = %e\n', Wgm);
% fprintf('Gain Crossover Frequency = %e\n\n', Wpm);
figure(4)
margin(G_CS);
figure(5)
margin(G_CS);
figure(6)
pzmap(G_CS2)

%% END