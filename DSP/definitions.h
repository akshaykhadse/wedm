#ifndef DEFINITIONS_H
#define DEFINITIONS_H

// FEATURE SELECTION
#define V_SOURCE        1
#define I_SOURCE        1
#define LOAD            1
#define I_SENS1         1
#define I_SENS2         1
#define I_SENS3         1
#define V_SENS1         1
#define V_SENS2         1
#define FILTER_LEN      5
#define PID1            1
#define PID2            1
#define DIAGNOSTICS     1

// PID1
#define KP1             1.0
#define KD1             0.0
#define KI1             0.0
#define REF1            0.0

// PID2
#define KP2             1.0
#define KD2             0.0
#define KI2             0.0
#define REF2            0.0

#define TS              1

// CPU TIMER0
#define CPU_FREQ        90      // in MHz
#define CPU_T0_PER      1000000     // in us

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
#define EPWM1_PER           1   // EPWM1 Period
#define EPWM1_HSPCLKDIV     3       // EPWM1 HSPCLKDIV
#define EPWM1_CLKDIV        4       // EPWM1 CLKDIV

// V_SOURCE PWM
#define EPWM4_PER           65535   // EPWM4 Period
#define EPWM4_DUTY          1     // EPWM4 Duty
#define EPWM4_DB            0.1     // EPWM4 Dead Band
#define EPWM4_HSPCLKDIV     3       // EPWM4 HSPCLKDIV
#define EPWM4_CLKDIV        4       // EPWM4 CLKDIV

// I_SOURCE PWM
#define EPWM5_PER           65535   // EPWM5 Period
#define EPWM5A_DUTY         1     // EPWM5A Duty
#define EPWM5B_DUTY         1     // EPWM5B Duty
#define EPWM5_HSPCLKDIV     3       // EPWM5 HSPCLKDIV
#define EPWM5_CLKDIV        4       // EPWM5 CLKDIV

// LOAD PWM
#define EPWM6_PER           65535   // EPWM6 Period
#define EPWM6A_DUTY         1     // EPWM6A Duty
#define EPWM6B_DUTY         1     // EPWM6B Duty
#define EPWM6_HSPCLKDIV     3       // EPWM6 HSPCLKDIV
#define EPWM6_CLKDIV        4       // EPWM6 CLKDIV

// SENSOR CALIBRATION
#define M1 0.010782271
#define C1 -17.68244799
#define M2 0.010898775
#define C2 -17.7613643
#define M3 0.0105754
#define C3 -17.79172917
#define M4 0.073176936
#define C4 -1.077599129
#define M5 0.074527422
#define C5 0.72267536

#endif // DEFINITIONS_H
