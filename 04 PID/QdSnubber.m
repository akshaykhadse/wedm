%% SNUBBER DESIGN OF Qd

Rs = V_ref / I_ref;
Ton = (T_mach - t2) / 100;
L = l1_val + l2_val; % Max worst case inductance across Qd
Cs_min = L * I_ref^2 / V_ref^2;
Cs_max = Ton / (10 * Rs);
Cs = (Cs_min + Cs_max) / 2;

%% END