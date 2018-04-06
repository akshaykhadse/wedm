% Run this file after running master_conv2 and modelling

vs_poles = poles(vohat_dhat);
c2_range = 0.001e-3:0.01e-3:1e-3;
pole_data = [];
for c2_val = c2_range
    pole_data = [pole_data subs(vs_poles, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val])];
end

figure(9)
plot3(c2_range, real(pole_data), imag(pole_data))
xlabel('C')
ylabel('\sigma')
zlabel('j\omega')
title('Varation of poles wrt Capacitance')
c2_val = 0.1e-3;

l2_range = logspace(-6,-3, 100);
pole_data = [];
for l2_val = l2_range
    pole_data = [pole_data subs(vs_poles, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val])];
end

figure(10)
plot3(l2_range, real(pole_data), imag(pole_data))
xlabel('L')
ylabel('\sigma')
zlabel('j\omega')
title('Varation of poles wrt Inductance')
l2_val = 2e-3;

cs_poles = poles(iohat_dhat);
l1_range = 0.001e-3:0.01e-3:2e-3;
pole_data = [];
for l1_val = l1_range
    pole_data = [pole_data subs(cs_poles, [r, rl1, l1, Vd],...
        [r_val, rl1_val, l1_val, Vd_val])];
end

figure(11)
plot(l1_range, real(pole_data))
axis([-0.2e-3, 2.2e-3, -11e5, 1e5])
xlabel('L')
ylabel('\sigma')
title('Varation of poles wrt Inductance of Current Source')
l1_val=1.8e-3;
