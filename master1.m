%% INITIALIZATION

format compact;
warning off;
close all;
clear all;
clc;

%% WORKFLOW

master_conv2
modelling
compensator_design
poles_locus
normal_buck_comparison_vs
normal_buck_comparison_cs
sim('powersupply.slx');

%% Export Figures for paper

% Voltage source comparison - bode
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

% Current source comparison - bode
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

% Load voltage and current
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

%% END
