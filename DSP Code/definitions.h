#ifndef DEFINITIONS_H
#define DEFINITIONS_H

// FEATURE SELECTION
#define V_SOURCE        1
#define I_SOURCE        1
#define LOAD            1
#define I_SENS1         0
#define I_SENS2         0
#define I_SENS3         1
#define V_SENS1         0
#define V_SENS2         1
#define FILTER_LEN      25
#define FILTER_LEN2     1
#define PID1            1
#define PID2            1
#define SMC1            0
#define DIAGNOSTICS     1
#define FLASH           0

// CPU TIMER0 Control Loop
#define CPU_FREQ        90      // in MHz
#define CPU_T0_PER      10      // in us

// PID1
#define KP1             0.3
#define KD1             0.0
#define KI1             600
#define REF1            4.0
// SMC1
#define KC              1000000000
#define KP              1
#define KI              0
#define TS1             CPU_T0_PER * 1e-6

// PID2
#define KP2             0.2
#define KD2             0.0
#define KI2             10.0
#define REF2            15.0
#define TS2             CPU_T0_PER * 1e-6

// Frequency Selection
// +-----------+----------------------------+--------+
// | Frequency | Calculated                 | Actual |
// +-----------+----------------------------+--------+
// |           | HSPCLKDIV | CLKDIV | TBPRD | TBPRD  |
// +-----------+-----------+--------+-------+--------+
// | 100 Hz    | 3         | 4      | 9374  | 9500   |
// +-----------+-----------+--------+-------+--------+
// | 1 kHz     | 0         | 1      | 44999 | 44999  |
// +-----------+-----------+--------+-------+--------+
// | 10 kHz    | 0         | 0      | 8999  | 9100   |
// +-----------+-----------+--------+-------+--------+
// | 15 kHz    | 0         | 0      | 5999  | 6080   |
// +-----------+-----------+--------+-------+--------+
// | 20 kHz    | 0         | 0      | 4499  | 4560   |
// +-----------+-----------+--------+-------+--------+
// | 30 kHz    | 0         | 0      | 2999  | 3040   |
// +-----------+-----------+--------+-------+--------+
// | 40 kHz    | 0         | 0      | 2249  | 2280   |
// +-----------+-----------+--------+-------+--------+
// | 50 kHz    | 0         | 0      | 1799  | 1823   |
// +-----------+-----------+--------+-------+--------+

// ADC SOC PWM
#define EPWM1_PER           605       // EPWM1 Period
#define EPWM1_HSPCLKDIV     0       // EPWM1 HSPCLKDIV
#define EPWM1_CLKDIV        0       // EPWM1 CLKDIV

// V_SOURCE PWM
#define EPWM4_PER           1823    // EPWM4 Period
#define EPWM4_DUTY          0     // EPWM4 Duty
#define EPWM4_DB            0.1       // EPWM4 Dead Band
#define EPWM4_HSPCLKDIV     0       // EPWM4 HSPCLKDIV
#define EPWM4_CLKDIV        0       // EPWM4 CLKDIV

// I_SOURCE PWM
#define EPWM5_PER           1823   // EPWM5 Period
#define EPWM5A_DUTY         0     // EPWM5A Duty
#define EPWM5B_DUTY         0     // EPWM5B Duty
#define EPWM5_HSPCLKDIV     0       // EPWM5 HSPCLKDIV
#define EPWM5_CLKDIV        0       // EPWM5 CLKDIV

// IGNITION PWM
#define EPWM6_PER           44999   // EPWM6 Period
#define EPWM6A_DUTY         0     // EPWM6A Duty
#define EPWM6B_DUTY         0.5     // EPWM6B Duty
#define EPWM6_HSPCLKDIV     0       // EPWM6 HSPCLKDIV
#define EPWM6_CLKDIV        1       // EPWM6 CLKDIV

// LOAD PWM
#define EPWM3_PER           44999   // EPWM6 Period
#define EPWM3A_DUTY         0.5     // EPWM6A Duty
#define EPWM3B_DUTY         0.7     // EPWM6B Duty
#define EPWM3_HSPCLKDIV     0       // EPWM6 HSPCLKDIV
#define EPWM3_CLKDIV        1      // EPWM6 CLKDIV

#define PHASE 0

// SENSOR CALIBRATION
#define M1 0.010782271
#define C1 -17.68244799
#define M2 0.010898775
#define C2 -17.7613643
#define M3 0.010348 / FILTER_LEN2
#define C3 -16.67936
#define M4 0.073176936
#define C4 -1.077599129
#define M5 0.074486658648508 / FILTER_LEN
#define C5 0.98143834306731

#endif // DEFINITIONS_H
