set(0, 'defaultlinelinewidth', 1);
set(0, 'defaultFigurePaperType', 'A5');
set(0, 'defaultFigurePaperOrientation', 'landscape');
set(0, 'defaultFigurePaperPositionMode', 'auto');

%% Phase Portrait
C=10e-6;
L=2e-3;
V=120;
Vref=80;

x1_lin = -100:10:100;
x2_lin = -100:10:100;
[x1, x2] = meshgrid(x1_lin, x2_lin);

u=1;
x1dot = x2;
x2dot = (-x1+V*u-Vref)/(L*C);

figure(1)
quiver(x1,x2,1/(L*C).*x1dot,x2dot, 'LineWidth', 0.8);
hold on;
u=0;
x1dot = x2;
x2dot = (-x1+V*u-Vref)/(L*C);
quiver(x1,x2,1/(L*C).*x1dot, x2dot, 'LineWidth', 0.8)
c = -1;
plot(x1_lin, -c.*x1_lin, 'k');
plot(V-Vref,0,'k*');
plot(-Vref,0,'k*');
xlabel('x_1','FontSize',12);
ylabel('x_2','FontSize',12);
legend('u=1', 'u=0', 'Sliding Line')
axis([-100,100,-100,100]);
print -dpdf Documentation/figures/matlab_generated/phase_map.pdf

%% Voltage Source
Ki = 0;
c = 1.5e5;
Vref=40;
figure(2)
simOut = sim('vs_nonlinear.slx', 'StopTime', '1.4e-3','SignalLogging','on','SignalLoggingName','logsout');
logsout = simOut.get('logsout');
x1_val = logsout.getElement('x1').Values.Data;
x2_val = logsout.getElement('x2').Values.Data;
plot(x1_val,x2_val, 'Linewidth', 1.5);
hold on
plot(x1_val, -c.*x1_val, 'Linewidth', 1.5);
xlabel('x_1','FontSize',12);
ylabel('x_2','FontSize',12);
legend('Trajectory', 'Sliding Line')
print -dpdf Documentation/figures/matlab_generated/vs_trajectory.pdf

figure(3)
Ki = 1e3;
c = 1.5e5;
Vref=80;
simOut = sim('vs_nonlinear.slx', 'StopTime', '0.02','SignalLogging','on','SignalLoggingName','logsout');
logsout = simOut.get('logsout');
v_val = logsout.getElement('LoadVoltage').Values.Data;
t_val = logsout.getElement('LoadVoltage').Values.Time.*1000;
plot(t_val,v_val, 'Linewidth', 1.5);
hold on
Ki = 0;
c = 1.5e5;
simOut = sim('vs_nonlinear.slx', 'StopTime', '0.02','SignalLogging','on','SignalLoggingName','logsout');
logsout = simOut.get('logsout');
v_val = logsout.getElement('LoadVoltage').Values.Data;
t_val = logsout.getElement('LoadVoltage').Values.Time.*1000;
plot(t_val,v_val, 'Linewidth', 1.5);
xlabel('Time (ms)','FontSize',12);
ylabel('Output Voltage (V)','FontSize',12);
legend('K_i \neq 0', 'K_i = 0')
print -dpdf Documentation/figures/matlab_generated/nl_response.pdf

%% Current Source

figure(4)
Ki = 1e3;
c = 6e5;
Iref=10;
simOut = sim('cs_nonlinear.slx', 'StopTime', '0.01','SignalLogging','on','SignalLoggingName','logsout');
logsout = simOut.get('logsout');
c_val = logsout.getElement('LoadCurrent').Values.Data;
t_val = logsout.getElement('LoadCurrent').Values.Time.*1000;
plot(t_val,c_val, 'Linewidth', 1.5);
hold on
Ki = 0;
simOut = sim('cs_nonlinear.slx', 'StopTime', '0.01','SignalLogging','on','SignalLoggingName','logsout');
logsout = simOut.get('logsout');
c_val = logsout.getElement('LoadCurrent').Values.Data;
t_val = logsout.getElement('LoadCurrent').Values.Time.*1000;
plot(t_val,c_val, 'Linewidth', 1.5);
xlabel('Time (ms)','FontSize',12);
ylabel('Output Current (A)','FontSize',12);
legend('K_i \neq 0', 'K_i = 0', 'Location','Best')
print -dpdf Documentation/figures/matlab_generated/nl_cs_response.pdf
