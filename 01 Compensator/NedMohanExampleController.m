%% Controller Design for Wire EDM Power Supply
% Author: Akshay Khadse
% Date: 05/06/2017
% Dependencies: syms2tf.m

%% Initialization

format compact
close all
clear all
clc

% Declare Symbolic Variables
syms R rc rl l c Vd d a T s

%% State Space Model

% Switch ON Time
A1 = [-(rc+rl)/l -1/l;
      1/c -1/(c*R)];
B1 = [1/l; 0];
C1 = [rc 1];

% Switch OFF Time
A2 = A1;
B2 = [0; 0];
C2 = C1;

% Time Averaging
A = simplify(d*A1+(1-d)*A2)
B = simplify(d*B1+(1-d)*B2)
C = simplify(d*C1+(1-d)*C2)

% Steady State Transfer Function
Vo_Vd = -C*inv(A)*B
X = Vo_Vd*Vd

% Small Signal Transfer Function
vohat_dhat = simplify(C*inv(s*eye(2)-A)*(B1-B2)*Vd)
G_ss = syms2tf(subs(vohat_dhat, [R, rc, rl, l, c, Vd], [0.2, 0.01, 0.02, 5e-6, 2000e-6, 8]))

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_ss)
figure(1)
margin(G_ss)

%% Compensator Design Ned Mohan
%wcross = Wpm;
%K = tand(45+10)
%wz = wcross/K
%wp = K*wcross
%G1 = evalfr(G_ss, wcross)
%R1 = 1
%C2 = G1/(K*R1*wcross)
%C1 = C2*(K^2-1)
%R2 = K/(C1*wcross)

%Gc = tf(1/(R1*C2)*[1 wz], [1 wp])

%[Gm,Pm,Wgm,Wpm] = margin(Gc*G_ss)
%figure(2)
%margin(Gc*G_ss)

%% Compensator Design
pm_des = 60;

Gc = (1+a*T*s)/(1+T*s);
wcross = Wpm;
phi_m = pm_des-Pm
a_val = -(sind(phi_m)+1)/(sind(phi_m)-1)
T_val = 1/(wcross*sqrt(a_val));
Gc = syms2tf(subs(Gc, [a, T], [a_val, T_val]));
A = 1/(evalfr(G_ss, wcross)*evalfr(Gc, wcross));
Gc = A*Gc;

% Gain Margin, Phase Margin, Bode Plot of Compensated System
[Gm,Pm,Wgm,Wpm] = margin(Gc*G_ss)
figure(2)
margin(Gc*G_ss)

%% Ned Mohan Controller

%pm_des = 60;
%wcross = Wpm;
%K = tand(45+(pm_des-Pm)/2);
%wz = wcross/K;
%wp = K*wcross;
%G1 = evalfr(G_ss, wcross);
%R1 = 1;
%C2 = G1/(K*R1*wcross);
%C1 = C2*(K^2-1);
%R2 = K/(C1*wcross);
%Gc2 = syms2tf((s+wz)/(R1*C2*s*(s+wp)))

% Gain Margin, Phase Margin, Bode Plot of Compensated System
%[Gm,Pm,Wgm,Wpm] = margin(Gc2*G_ss)
%figure(3)
%margin(Gc2*G_ss)