%% Variation of voltage source poles with c2 value

c2_val_bak = c2_val;    % Backup original c2 value 
vs_poles = poles(vohat_dhat);
c2_range = 0.001e-3:0.01e-3:1e-3;
pd_vs_c2 = zeros(size(vs_poles, 1), length(c2_range));
i = 0;
for c2_val = c2_range
    i = i + 1;
    pd_vs_c2(:, i) = subs(vs_poles, [rc2, c2, rl2, l2, Vd],...
                     [rc2_val, c2_val, rl2_val, l2_val, Vd_val]);
end

figure(9);
plot3(c2_range, real(pd_vs_c2), imag(pd_vs_c2));
xlabel('C');
ylabel('\sigma');
zlabel('j\omega');
title('Varation of poles wrt Capacitance');

c2_val = c2_val_bak;    % Restore c2 value
clear c2_val_bak        % Clear temperory variable

%% Variation of voltage source poles with l2 value

l2_val_bak = l2_val;    % Backup original l2 value
l2_range = logspace(-6,-3, 100);
pd_vs_l2 = zeros(size(vs_poles, 1), length(l2_range));
i = 0;
for l2_val = l2_range
    i = i + 1;
    pd_vs_l2(:, i) = subs(vs_poles, [rc2, c2, rl2, l2, Vd],...
                     [rc2_val, c2_val, rl2_val, l2_val, Vd_val]);
end

figure(10);
plot3(l2_range, real(pd_vs_l2), imag(pd_vs_l2));
xlabel('L');
ylabel('\sigma');
zlabel('j\omega');
title('Varation of poles wrt Inductance');

l2_val = l2_val_bak;    % Restore l2 vlaue
clear l2_val_bak        % Clear temperory variable

%% Variation of current source poles with l1 value

l1_val_bak = l1_val;    % Backup original l1 value
cs_poles = poles(iohat_dhat);
l1_range = 0.001e-3:0.01e-3:2e-3;
pd_cs_l1 = zeros(size(cs_poles, 1), length(l1_range));
i = 0;
for l1_val = l1_range
    i = i + 1;
    pd_cs_l1(:, i) = subs(cs_poles, [r, rl1, l1, Vd],...
                     [r_val, rl1_val, l1_val, Vd_val]);
end

figure(11);
plot(l1_range, real(pd_cs_l1));
axis([-0.2e-3, 2.2e-3, -11e5, 1e5]);
xlabel('L');
ylabel('\sigma');
title('Varation of poles wrt Inductance of Current Source');

l1_val = l1_val_bak;    % Rectore l1 value
clear l1_val_bak i        % Clear temperory variable

%% END