%% VOLTAGE SOURCE MODEL

%% Handling Path for Dependencies

stack = dbstack;
if stack(length(stack)).name ~= 'master_conv'
    mydir  = pwd;
    if ispc
        idcs   = strfind(mydir,'\');
    else
        idcs   = strfind(mydir,'/');
    end
    newdir = strcat(mydir(1:idcs(end)-1), '\Dependencies');
    addpath(newdir, '-end');
    fprintf('path added\n')
end
clear stack

%% Declare Symbolic Variables
syms rc2 c2 rl2 l2 Vd d2 s;

%% State Space Model

% Power Supply As described in Paper
% Switch ON Time
A1 = [-(rl2+rc2)/l2 -1/l2;
      1/c2 0];
B1 = [1/l2; 0];
C1 = [0 1];

% Switch OFF Time
A2 = A1;
B2 = [0; 0];
C2 = C1;

% Time Averaging
A = simplify(d2*A1+(1-d2)*A2);
B = simplify(d2*B1+(1-d2)*B2);
C = simplify(d2*C1+(1-d2)*C2);

% Steady State Transfer Function
Vo_Vd = -C*inv(A)*B;
X = Vo_Vd*Vd;

% Small Signal Transfer Function
fprintf('Small Signal Transfer Function of Uncomepensated System\n')
vohat_dhat = simplify(C*inv(s*eye(2)-A)*(B1-B2)*Vd);
G_VS = syms2tf(subs(vohat_dhat, [rc2, c2, rl2, l2, Vd],...
        [rc2_val, c2_val, rl2_val, l2_val, Vd_val]))

% Discrete Time Transfer Function
discreteG_VS = c2d(G_VS, 1/fSampling, 'tustin')

% Gain Margin, Phase Margin, Bode Plot
[Gm,Pm,Wgm,Wpm] = margin(G_VS);
fprintf('Gain Margin = %e\n', Gm)
fprintf('Phase Margin = %e\n', Pm)
fprintf('Phase Crossover Frequency = %e\n', Wgm)
fprintf('Gain Crossover Frequency = %e\n\n', Wpm)

figure(1)
margin(G_VS)

%% END