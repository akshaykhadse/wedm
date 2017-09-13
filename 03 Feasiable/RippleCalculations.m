%% SCRIPT FOR CALCULATION OF INDUCTORS AND CAPACITORS BASED ON RIPPLE

%% DESIRED PARAMETERS
I_ref = 10;
V_ref = 80;
I1_ripple = 0.1*I_ref;
V2_ripple = 0.1*V_ref; 
I2_ripple = 0.1*I_ref; % Output current of 2 quadrant chopper is close to zero - assume this to be 10% of actual load current

%% 

Vdc = 110;
R = 1;
Eg = 30;
f_sw = 150e3;

%% INDUCTOR FOR SINGLE QUADRANT CHOPPER
Vo1 = I_ref*R + Eg;
L1 = Vo1*(Vdc-Vo1)/(I1_ripple*f_sw*Vdc)

%% CAPACITOR FOR TWO QUADRANT CHOPPER
C2 = I2_ripple/(8*f_sw*V2_ripple)

%% INDUCTOR FOR TWO QUADRANT CHOPPER
L2 = V_ref*(Vdc-V_ref)/(I2_ripple*f_sw*Vdc)
