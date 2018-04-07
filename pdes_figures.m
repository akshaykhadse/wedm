%% Export Figures for PDES paper

%% Voltage source comparison - bode
fig12 = figure(12);
set(fig12, 'Units', 'Inches', 'Position', [0.5, 1, 5.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 3.5])
p = bodeplot(G_VS, 'k', G_VS_norm, 'k:');
title('');
fig12.Children(2).set('Position', [0.1,0.1,0.85,0.4])
fig12.Children(3).set('Position', [0.1,0.55,0.85,0.4])
set(findobj(gcf,'type','line'),'linewidth',2);
fig12.CurrentAxes = fig12.Children(3);
legend('G\_VS', 'G\_VS\_norm');
print -deps Documentation/figures/matlab_generated/vs_comparison.eps

%% Current source comparison - bode
fig13 = figure(13);
set(fig13, 'Units', 'Inches', 'Position', [0.5, 1, 5.5, 3.5], 'PaperUnits', 'Inches', 'PaperSize', [5.5, 3.5])
p = bodeplot(G_CS, 'k', G_CS_norm, 'k:');
title('');
fig13.Children(2).set('Position', [0.1,0.1,0.85,0.4])
fig13.Children(3).set('Position', [0.1,0.55,0.85,0.4])
set(findobj(gcf,'type','line'),'linewidth',2);
fig13.CurrentAxes = fig13.Children(3);
legend('G\_CS', 'G\_CS\_norm', 'Location', 'southwest');
print -deps Documentation/figures/matlab_generated/cs_comparison.eps

%% Load voltage and current
fig14 = figure(14);
len = length(logsout.getElement('LoadVoltage').Values.Time);
time = logsout.getElement('LoadVoltage').Values.Time(3.9*len/5:len);
load_voltage = logsout.getElement('LoadVoltage').Values.Data(3.9*len/5:len);
load_current = logsout.getElement('LoadCurrent').Values.Data(3.9*len/5:len);
subplot(2,1,1);
p1 = plot(time, load_voltage, 'LineWidth', 2, 'Color', 'k');
xlim([3.15e-3 time(length(time))]);
ylabel('Voltage (V)')
subplot(2,1,2);
p2 = plot(time, load_current, 'LineWidth', 2, 'Color', 'k');
xlim([3.15e-3 time(length(time))]);
ylabel('Current (A)')
xlabel('Time (s)')
print -deps Documentation/figures/matlab_generated/load_pulsed.eps

%% Imag part of poles of Voltage source vs capacitance
figure(15);
plot(c2_range, imag(pd_vs_c2), 'LineWidth', 2, 'Color', 'k');
xlabel('C');
ylabel('j\omega');
% title('Varation of imiganiary part of poles wrt Capacitance');
print -deps Documentation/figures/matlab_generated/pd_imag_vs_c2.eps

%% Real part of poles of Voltage source vs capacitance
figure(16);
plot(c2_range, real(pd_vs_c2), 'LineWidth', 2, 'Color', 'k');
xlabel('C');
ylabel('\sigma');
% title('Varation of real part of poles wrt Capacitance');
print -deps Documentation/figures/matlab_generated/pd_real_vs_c2.eps

%% Imag part of poles of Voltage source vs inductance
figure(17);
plot(l2_range, imag(pd_vs_l2), 'LineWidth', 2.0, 'Color', 'k');
xlabel('L');
ylabel('j\omega');
% title('Varation of imaginary part of poles wrt Inductance');
print -deps Documentation/figures/matlab_generated/pd_imag_vs_l2.eps

%% Real part of poles of Voltage source vs inductance
figure(18);
plot(l2_range, real(pd_vs_l2), 'LineWidth', 2.0, 'Color', 'k');
axis([-0.05e-3, 1e-3, -100, 5]);
xlabel('L');
ylabel('\sigma');
% title('Varation of real part of poles wrt Inductance');
print -deps Documentation/figures/matlab_generated/pd_real_vs_l2.eps

%% Poles of Current source vs inductance
figure(19)
plot(l1_range, real(pd_cs_l1), 'LineWidth', 2.0, 'Color', 'k')
axis([-0.2e-3, 2.2e-3, -11e5, 1e5])
xlabel('L')
ylabel('\sigma')
% title('Varation of poles wrt Inductance of Current Source')
print -deps Documentation/figures/matlab_generated/pd_cs_l1.eps

%% END