%% VOLTAGE SOURCE CONTROLLER

VoltageSourceModel; 

%% Declare Symbolic Variables
syms a1 T1 a2 T2;

%% Compensator Design

%pm_des = 15;
pm_des = 30;
wgc = 2*pi*f_sw/10;


% ACE Method
%{
% Parameters
% Desired Phase Margin
%wcross = Wpm;
wcross = f_sw*2*pi/10;
%a2_val = 1e-2; %working
a2_val = 1e-8;

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
%}

% K Factor Method
%{
[Tpv,phi_pv]=bode(G_VS,wgc);
boost_v = pm_des - phi_pv - 90;
if (boost_v < 0)
    boost_v = boost_v+360;
end
boost_radv = boost_v*pi/180;

% Type II Compensator

K_vc = tan((boost_radv/2)+pi/4);

wz_vc = wgc/K_vc;
wp_vc = wgc*K_vc;
A_vc = K_vc*wgc/Tpv;

tc_v1 = tf ([1 wz_vc],[1 wp_vc]);
tc_v2 = tf ([0 A_vc],[1 0]);
Gc = tc_v2*tc_v1;
[num_c2, den_c2] = tfdata(Gc);
%}

% Type III Compensator
%{
K_vc2 = tan((boost_radv/4)+pi/4)^2;

wz_vc2 = wgc/sqrt(K_vc2);
wp_vc2 = wgc*sqrt(K_vc2);
A_vc2 = K_vc2*wgc/Tpv;

tc_v12 = tf ([1 wz_vc2],[1 wp_vc2]);
tc_v22 = tf ([0 A_vc2],[1 0]);
Gc = tc_v22*tc_v12*tc_v12;
[num_c2, den_c2] = tfdata(Gc);
%}
margin(Gc*G_VS)
%% END