load('result.mat');
load('superimposed.mat');
load('l1current.mat');
load('c2voltage.mat');

co = 0.25*ones(7,3);
set(0, 'defaultlinelinewidth', 2.0);
set(0, 'defaultAxesColorOrder', co);
set(0, 'DefaultAxesFontName','Times');
set(0, 'DefaultAxesFontSize',14);
set(0, 'defaultFigurePaperType', 'A4');
set(0, 'defaultFigurePaperOrientation', 'portrait');
set(0, 'defaultFigurePaperPositionMode', 'auto');
clear co

%{
f = figure(1);
f.PaperUnits = 'inches';
f.PaperPosition = [0 0 8.27 11.69];
s1 = subplot(5,1,1);
plot(out(:,1),out(:,2)); grid on
ylim([-5,20]);
xlim([-2.5,2.0]);
set(gca,'xticklabel',{[]});
ylabel('Ignition');

hold on
s2 = subplot(5,1,2);
plot(out(:,3),out(:,4)); grid on
xlim([-2.5,2.0]);
ylim([-5,20]);
set(gca,'xticklabel',{[]});
ylabel('Load SW');

s3 = subplot(5,1,3);
plot(out(:,5)-0.5,out(:,6)); grid on
xlim([-2.5,2.0]);
ylim([-5,25]);
set(gca,'xticklabel',{[]});
ylabel('V_{Load} (V)');


s4 = subplot(5,1,4);
plot(out(:,7)-0.3,out(:,8)); grid on
xlim([-2.5,2.0]);
ylim([-6,8]);
set(gca,'xticklabel',{[]});
ylabel('I_{Load} (A)');

s5 = subplot(5,1,5);
plot(out(:,9)-0.5,out(:,10)); grid on
xlim([-2.5,2.0]);
ylim([-15,3]);
ylabel('V_D (V)');
xlabel('Time (ms)')

s1.Position = [0.1 , 0.75, 0.89, 0.1];
s2.Position = [0.1 , 0.65, 0.89, 0.1];
s3.Position = [0.1 , 0.45, 0.89, 0.2];
s4.Position = [0.1 , 0.25, 0.89, 0.2];
s5.Position = [0.1 , 0.05, 0.89, 0.2];
print -dpdf Documentation/figures/matlab_generated/results.pdf
set(0,'defaultAxesColorOrder', 'remove');

f2 = figure(2);
f2.PaperUnits = 'inches';
f2.PaperPosition = [0 0 6 4];
f2.Position = [0 0 6 4];
plot(out2(:,1),out2(:,2)); hold on; grid on
plot(out2(:,3),out2(:,4)); hold on; grid on
legend('V_{Cap}', 'V_{Load}', 'Location', 'SouthEast')
print -dpdf Documentation/figures/matlab_generated/results2.pdf
%}

f2 = figure(3);
f2.PaperUnits = 'inches';
f2.PaperPosition = [0 0 6 4];
f2.Position = [0 0 6 4];
plot(l1current(:,1),l1current(:,2)); grid on
ylabel('L_1 Current (A)')
xlabel('Time (ms)')
xlim([-2,2]);
print -dpdf Documentation/figures/matlab_generated/l1current.pdf

f2 = figure(4);
f2.PaperUnits = 'inches';
f2.PaperPosition = [0 0 6 4];
f2.Position = [0 0 6 4];
plot(c2voltage(:,1),c2voltage(:,2)); grid on
ylabel('C_2 Voltage (V)')
xlabel('Time (ms)')
xlim([-5,4.5]);
ylim([0,20]);
print -dpdf Documentation/figures/matlab_generated/c2voltage.pdf

set(0, 'defaultlinelinewidth', 'remove');
set(0, 'defaultFigurePaperType', 'remove');
set(0, 'defaultFigurePaperOrientation', 'remove');
set(0, 'defaultFigurePaperPositionMode', 'remove');

