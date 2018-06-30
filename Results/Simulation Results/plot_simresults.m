load('simresult_2mh_pi.mat');
load('simresult_2mh_cmc.mat');
load('simresult_2mh_comp.mat');
load('simresult_pi.mat');
load('simresult_cmc.mat');
load('simresult_pi_comp.mat');

co = 0.25*ones(7,3);
set(0, 'defaultlinelinewidth', 2.0);
set(0, 'defaultAxesColorOrder', co);
set(0, 'DefaultAxesFontName','Times');
set(0, 'DefaultAxesFontSize',14);
set(0, 'defaultFigurePaperType', 'A5');
set(0, 'defaultFigurePaperOrientation', 'landscape');
set(0, 'defaultFigurePaperPositionMode', 'auto');
clear co

%%
count = size(logsout_2mh_pi.getElement('LoadCurrent').Values.Time);
epoch = floor(count(1) * 35/40);

f = figure(1);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 14];

s1 = subplot(2,1,1);
plot(logsout_2mh_pi.getElement('LoadVoltage').Values.Time(epoch:end).*1000,logsout_2mh_pi.getElement('LoadVoltage').Values.Data(epoch:end)); grid on
ylim([-5,90]);
xlim([7.1,8.0]);
set(gca,'xticklabel',{[]});
ylabel('Load Voltage (V)');

hold on
s2 = subplot(2,1,2);
plot(logsout_2mh_pi.getElement('LoadCurrent').Values.Time(epoch:end).*1000,logsout_2mh_pi.getElement('LoadCurrent').Values.Data(epoch:end)); grid on
ylim([-1,11]);
xlim([7.1,8.0]);
ylabel('Load Current (A)');
xlabel('Time (ms)');

s1.Position = [0.11 , 0.4, 0.89, 0.3];
s2.Position = [0.11 , 0.1, 0.89, 0.3];
print -dpdf Documentation/figures/matlab_generated/results_2mh_pi.pdf

%%
count = size(logsout_2mh_cmc.getElement('LoadCurrent').Values.Time);
epoch = floor(count(1) * 35/40);

f = figure(2);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 14];

s1 = subplot(2,1,1);
plot(logsout_2mh_cmc.getElement('LoadVoltage').Values.Time(epoch:end).*1000,logsout_2mh_cmc.getElement('LoadVoltage').Values.Data(epoch:end)); grid on
ylim([-5,90]);
xlim([7.1,8.0]);
set(gca,'xticklabel',{[]});
ylabel('Load Voltage (V)');

hold on
s2 = subplot(2,1,2);
plot(logsout_2mh_cmc.getElement('LoadCurrent').Values.Time(epoch:end).*1000,logsout_2mh_cmc.getElement('LoadCurrent').Values.Data(epoch:end)); grid on
ylim([-1,11]);
xlim([7.1,8.0]);
ylabel('Load Current (A)');
xlabel('Time (ms)');

s1.Position = [0.11 , 0.4, 0.89, 0.3];
s2.Position = [0.11 , 0.1, 0.89, 0.3];
print -dpdf Documentation/figures/matlab_generated/results_2mh_cmc.pdf

%%
count = size(logsout_2mh_comp.getElement('LoadCurrent').Values.Time);
epoch = floor(count(1) * 35/40);

f = figure(3);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 14];

s1 = subplot(2,1,1);
plot(logsout_2mh_comp.getElement('LoadVoltage').Values.Time(epoch:end).*1000,logsout_2mh_comp.getElement('LoadVoltage').Values.Data(epoch:end)); grid on
ylim([-5,90]);
xlim([7.1,8.0]);
set(gca,'xticklabel',{[]});
ylabel('Load Voltage (V)');

hold on
s2 = subplot(2,1,2);
plot(logsout_2mh_comp.getElement('LoadCurrent').Values.Time(epoch:end).*1000,logsout_2mh_comp.getElement('LoadCurrent').Values.Data(epoch:end)); grid on
ylim([-1,11]);
xlim([7.1,8.0]);
ylabel('Load Current (A)');
xlabel('Time (ms)');

s1.Position = [0.11 , 0.4, 0.89, 0.3];
s2.Position = [0.11 , 0.1, 0.89, 0.3];
print -dpdf Documentation/figures/matlab_generated/results_2mh_comp.pdf

%%
count = size(logsout_pi.getElement('LoadCurrent').Values.Time);
epoch = floor(count(1) * 15/20);

f = figure(4);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 14];

s1 = subplot(2,1,1);
plot(logsout_pi.getElement('LoadVoltage').Values.Time(epoch:end).*1000,logsout_pi.getElement('LoadVoltage').Values.Data(epoch:end)); grid on
ylim([-5,90]);
xlim([3.1,4.0]);
set(gca,'xticklabel',{[]});
ylabel('Load Voltage (V)');

hold on
s2 = subplot(2,1,2);
plot(logsout_pi.getElement('LoadCurrent').Values.Time(epoch:end).*1000,logsout_pi.getElement('LoadCurrent').Values.Data(epoch:end)); grid on
ylim([-1,11]);
xlim([3.1,4.0]);
ylabel('Load Current (A)');
xlabel('Time (ms)');

s1.Position = [0.11 , 0.4, 0.89, 0.3];
s2.Position = [0.11 , 0.1, 0.89, 0.3];
print -dpdf Documentation/figures/matlab_generated/results_pi.pdf

%%
count = size(logsout_cmc.getElement('LoadCurrent').Values.Time);
epoch = floor(count(1) * 15/20);

f = figure(5);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 14];

s1 = subplot(2,1,1);
plot(logsout_cmc.getElement('LoadVoltage').Values.Time(epoch:end).*1000,logsout_cmc.getElement('LoadVoltage').Values.Data(epoch:end)); grid on
ylim([-5,90]);
xlim([3.1,4.0]);
set(gca,'xticklabel',{[]});
ylabel('Load Voltage (V)');

hold on
s2 = subplot(2,1,2);
plot(logsout_cmc.getElement('LoadCurrent').Values.Time(epoch:end).*1000,logsout_cmc.getElement('LoadCurrent').Values.Data(epoch:end)); grid on
ylim([-1,11]);
xlim([3.1,4.0]);
ylabel('Load Current (A)');
xlabel('Time (ms)');

s1.Position = [0.11 , 0.4, 0.89, 0.3];
s2.Position = [0.11 , 0.1, 0.89, 0.3];
print -dpdf Documentation/figures/matlab_generated/results_cmc.pdf

%%
count = size(logsout_pi_comp.getElement('LoadCurrent').Values.Time);
epoch = floor(count(1) * 15/20);

f = figure(6);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 14];

s1 = subplot(2,1,1);
plot(logsout_pi_comp.getElement('LoadVoltage').Values.Time(epoch:end).*1000,logsout_pi_comp.getElement('LoadVoltage').Values.Data(epoch:end)); grid on
ylim([-5,90]);
xlim([3.1,4.0]);
set(gca,'xticklabel',{[]});
ylabel('Load Voltage (V)');

hold on
s2 = subplot(2,1,2);
plot(logsout_pi_comp.getElement('LoadCurrent').Values.Time(epoch:end).*1000,logsout_pi_comp.getElement('LoadCurrent').Values.Data(epoch:end)); grid on
ylim([-1,11]);
xlim([3.1,4.0]);
ylabel('Load Current (A)');
xlabel('Time (ms)');

s1.Position = [0.11 , 0.4, 0.89, 0.3];
s2.Position = [0.11 , 0.1, 0.89, 0.3];
print -dpdf Documentation/figures/matlab_generated/results_pi_comp.pdf


%%
f = figure(7);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_2mh_pi.getElement('L1Current').Values.Time.*1000, logsout_2mh_pi.getElement('L1Current').Values.Data); grid on
ylim([-1,11]);
xlim([0,2]);
ylabel('Current (A)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/cs_2mh_pi.pdf

%%
f = figure(8);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_2mh_cmc.getElement('L1Current').Values.Time.*1000, logsout_2mh_cmc.getElement('L1Current').Values.Data); grid on
ylim([-1,11]);
xlim([0,2]);
ylabel('Current (A)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/cs_2mh_cmc.pdf

%%
f = figure(9);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_2mh_comp.getElement('L1Current').Values.Time.*1000, logsout_2mh_comp.getElement('L1Current').Values.Data); grid on
ylim([-1,13]);
xlim([0,2]);
ylabel('Current (A)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/cs_2mh_comp.pdf

%%
f = figure(10);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_pi.getElement('L1Current').Values.Time.*1000, logsout_pi.getElement('L1Current').Values.Data); grid on
ylim([-1,11]);
xlim([0,1]);
ylabel('Current (A)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/cs_pi.pdf

%%
f = figure(10);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_cmc.getElement('L1Current').Values.Time.*1000, logsout_cmc.getElement('L1Current').Values.Data); grid on
ylim([-1,11]);
xlim([0,1]);
ylabel('Current (A)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/cs_cmc.pdf
%%
f = figure(12);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_pi_comp.getElement('L1Current').Values.Time.*1000, logsout_pi_comp.getElement('L1Current').Values.Data); grid on
ylim([-1,11]);
xlim([0,1]);
ylabel('Current (A)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/cs_pi_comp.pdf

%%
f = figure(13);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_2mh_pi.getElement('C2Voltage').Values.Time.*1000, logsout_2mh_pi.getElement('C2Voltage').Values.Data); grid on
ylim([-5,90]);
xlim([0,2]);
ylabel('Voltage (V)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/vs_2mh_pi.pdf

%%
f = figure(14);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_2mh_cmc.getElement('C2Voltage').Values.Time.*1000, logsout_2mh_cmc.getElement('C2Voltage').Values.Data); grid on
ylim([-5,100]);
xlim([0,2]);
ylabel('Voltage (V)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/vs_2mh_cmc.pdf

%%
f = figure(15);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_2mh_comp.getElement('C2Voltage').Values.Time.*1000, logsout_2mh_comp.getElement('C2Voltage').Values.Data); grid on
ylim([-5,90]);
xlim([0,4]);
ylabel('Voltage (V)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/vs_2mh_comp.pdf

%%
f = figure(16);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_pi.getElement('C2Voltage').Values.Time.*1000, logsout_pi.getElement('C2Voltage').Values.Data); grid on
ylim([-5,90]);
xlim([0,2]);
ylabel('Voltage (V)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/vs_pi.pdf

%%
f = figure(17);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_cmc.getElement('C2Voltage').Values.Time.*1000, logsout_cmc.getElement('C2Voltage').Values.Data); grid on
ylim([-5,100]);
xlim([0,2]);
ylabel('Voltage (V)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/vs_pi.pdf

%%
f = figure(18);
f.PaperUnits = 'centimeters';
f.PaperPosition = [0 0 15 7];
plot(logsout_pi_comp.getElement('C2Voltage').Values.Time.*1000, logsout_pi_comp.getElement('C2Voltage').Values.Data); grid on
ylim([-5,90]);
xlim([0,4]);
ylabel('Voltage (V)');
xlabel('Time (ms)');
print -dpdf Documentation/figures/matlab_generated/vs_pi_comp.pdf

%%
set(0, 'defaultlinelinewidth', 'remove');
set(0, 'defaultFigurePaperType', 'remove');
set(0, 'defaultFigurePaperOrientation', 'remove');
set(0, 'defaultFigurePaperPositionMode', 'remove');