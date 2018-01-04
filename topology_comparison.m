clear all;
master_conv2;
sim('powersupply_1jan_old_top.slx');
logsout_old = logsout;
sim('powersupply_1jan.slx');
%%
DCurrent = get(logsout, 1);
DCurrent_old = get(logsout_old, 1);
VoltageSourceOutput = get(logsout, 9);
VoltageSourceOutput_old = get(logsout_old, 9);
IgnitionControl = get(logsout, 10);
len = size(IgnitionControl.Values.Time, 1)/2;
%%
hold all
subplot(3,1,1)
plot(IgnitionControl.Values.Time, IgnitionControl.Values.Data);grid on
subplot(3,1,2)
plot(DCurrent.Values.Time, DCurrent.Values.Data, 'LineWidth', 2);grid on
axis([0 2.5e-3 -1 10])
hold on
plot(DCurrent_old.Values.Time, DCurrent_old.Values.Data); grid on
subplot(3,1,3)
plot(VoltageSourceOutput.Values.Time, VoltageSourceOutput.Values.Data, 'LineWidth', 2);grid on
hold on
plot(VoltageSourceOutput_old.Values.Time, VoltageSourceOutput_old.Values.Data)
