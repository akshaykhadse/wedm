//###########################################################################
// FILE:   wedmDSP.c
// TITLE:  Controller implementation for WEDM
//
//! Peripheral Config:
//! CPU Timer0 -> SOC0 -> ... -> SOC4 -> ADCINT1 -> Read voltages
//! ePWM4: Active High Complementary PWM with DeadBand
//! ePWM5: Independent PWM
//! epWM6: Independent PWM
//! GPIO22: Togglabe for status check
//
//! Watch Variables:
//! - Voltage1 => ADCINA5
//! - Voltage2 => ADCINB5
//! - Voltage3 => ADCINA3
//! - Voltage4 => ADCINB3
//! - Voltage5 => ADCINA4
//! - log      => Logged Values
//
//! Pin Connections:
//! - ADCINA4 => Pin69
//! - ADCINB3 => Pin68
//! - ADCINA3 => Pin67
//! - ADCINB5 => Pin66
//! - ADCINA5 => Pin65
//!
//! - EPWM4A  => Pin80
//! - EPWM4B  => Pin79
//! - EPWM5A  => Pin78
//! - EPWM5B  => Pin77
//! - EPWM6A  => Pin76
//! - EPWM6B  => Pin75
//!
//! - GPIO22 => Pin8
//!
//! - GND     => Pin22, 62, 20, 60
//! - 5V      => Pin21, 61
//! - 3.3V    => Pin1, 41
//###########################################################################

#define CPU_FREQ   90       // CPU Frequency (MHz)
#define CPU_T0_PER 3.47     // CPU Timer0 period (uSecs) 146.5kHz

#define EPWM4_PER 0x1       // EPWM4 Period
#define EPWM4_DUTY 0x7FFF   // EPWM4 Duty
#define EPWM4_DB   0x0000   // EPWM4 Dead Band

#define EPWM5_PER 65535     // EPWM5 Period
#define EPWM5A_DUTY 6553    // EPWM5A Duty
#define EPWM5B_DUTY 58000   // EPWM5B Duty

#define EPWM6_PER 65535     // EPWM6 Period
#define EPWM6A_DUTY 6553    // EPWM6A Duty
#define EPWM6B_DUTY 58000   // EPWM6B Duty

#define LOG_LEN 5000        // Number of values to log

// Included Files
#include "DSP28x_Project.h" // Device Headerfile and Examples Include File

// Function Prototypes
__interrupt void cpu_timer0_isr(void);
__interrupt void adc_isr(void);
void InitStatusGpio(void);
void AdcConfig(void);
void InitEPwm4Example(void);
void InitEPwm5Example(void);
void InitEPwm6Example(void);

// Globals
Uint16 SampleCount;
Uint16 Voltage1;
Uint16 Voltage2;
Uint16 Voltage3;
Uint16 Voltage4;
Uint16 Voltage5;
Uint16 log[LOG_LEN];

// Main
void main(void)
{
    // Step 1. Initialize System Control:
    // PLL, WatchDog, enable Peripheral Clocks
    InitSysCtrl();

    // Step 2. Initialize GPIO:
    InitStatusGpio();   // Initialize GPIO22
    InitEPwm4Gpio();    // Initialize GPIO pin for ePWM4
    InitEPwm5Gpio();    // Initialize GPIO pin for ePWM5
    InitEPwm6Gpio();    // Initialize GPIO pin for ePWM6

    // Step 3. Clear all interrupts and initialize PIE vector table:
    // Disable CPU interrupts
    DINT;

    // Initialize the PIE control registers to their default state.
    // The default state is all PIE interrupts disabled and flags
    // are cleared.
    InitPieCtrl();

    // Disable CPU interrupts and clear all CPU interrupt flags:
    IER = 0x0000;
    IFR = 0x0000;

    // Initialize the PIE vector table with pointers to the shell Interrupt
    // Service Routines (ISR).
    // This will populate the entire table, even if the interrupt
    // is not used in this example.  This is useful for debug purposes.
    // The shell ISR routines are found in F2806x_DefaultIsr.c.
    // This function is found in F2806x_PieVect.c.
    InitPieVectTable();

    // Interrupts that are used in this example are re-mapped to
    // ISR functions found within this file.
    EALLOW;  // This is needed to write to EALLOW protected register
    PieVectTable.ADCINT1 = &adc_isr;
    PieVectTable.TINT0 = &cpu_timer0_isr;
    EDIS;    // This is needed to disable write to EALLOW protected registers

    // Step 4. Initialize the required Device Peripherals:
    InitCpuTimers();                                    // Initialize Cpu Timers
    ConfigCpuTimer(&CpuTimer0, CPU_FREQ, CPU_T0_PER);   // Configure CPU-Timer 0

    // To ensure precise timing, use write-only instructions to write to the
    // entire register. Therefore, if any of the configuration bits are changed
    // in ConfigCpuTimer and InitCpuTimers (in F2806x_CpuTimers.h), the below
    // settings must also be updated.

    // Use write-only instruction to set TSS bit = 0
    CpuTimer0Regs.TCR.all = 0x4000;

    InitAdc();          // Initialize the ADC
    AdcOffsetSelfCal();
    AdcConfig();        // Configure ADC

    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;

    InitEPwm4Example();
    InitEPwm5Example();
    InitEPwm6Example();

    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;

    // Step 5. User specific code, enable interrupts:

    PieCtrlRegs.PIEIER1.bit.INTx1 = 1; // Enable ADCINT1 in PIE i.e INT 1.1 in the PIE
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1; // Enable TINT0 in the PIE: Group 1 interrupt 7
    IER |= M_INT1; 					   // Enable CPU Interrupt 1, responsible for CPUTIMER0, ADCINT1

    // Enable global Interrupts and higher priority real-time debug events:
    EINT;          					   // Enable Global interrupt INTM
    ERTM;          					   // Enable Global realtime interrupt DBGM

    SampleCount = 0;

    // Wait
    for(;;);
}

__interrupt void
adc_isr(void)
{
    Voltage1 = AdcResult.ADCRESULT0;
    Voltage2 = AdcResult.ADCRESULT1;
    Voltage3 = AdcResult.ADCRESULT2;
    Voltage4 = AdcResult.ADCRESULT3;
    Voltage5 = AdcResult.ADCRESULT4;

    // Log LOG_LEN data samples
    log[SampleCount] = Voltage2;
    SampleCount = SampleCount<LOG_LEN?SampleCount+1:0;

    GpioDataRegs.GPATOGGLE.bit.GPIO22 = 1;  // Toggle GPIO22

    AdcRegs.ADCINTFLGCLR.bit.ADCINT1 = 1;   // Clear ADCINT1 flag reinitialize for next SOC
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1; // Acknowledge interrupt to PIE
    return;
}

__interrupt void
cpu_timer0_isr(void)
{
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1; // Acknowledge this interrupt to receive more interrupts from group 1
}

void
InitStatusGpio()
{
    // Configure GPIO22 as a GPIO output pin
    EALLOW;
    GpioCtrlRegs.GPAMUX2.bit.GPIO22 = 0;
    GpioCtrlRegs.GPADIR.bit.GPIO22  = 1;
    EDIS;
}

void
AdcConfig()
{
    // Configure ADC
    EALLOW;

    AdcRegs.ADCCTL1.bit.TEMPCONV      = 0;  //Temperature sensor not used
    AdcRegs.ADCCTL2.bit.ADCNONOVERLAP = 1;  // Enable non-overlap mode

    AdcRegs.INTSEL1N2.bit.INT1E     = 1;    // Enabled ADCINT1
    AdcRegs.INTSEL1N2.bit.INT1CONT  = 0;    // Disable ADCINT1 Continuous mode
    AdcRegs.ADCCTL1.bit.INTPULSEPOS = 1;    // ADCINT1 trips AFTER AdcResults latch
    AdcRegs.INTSEL1N2.bit.INT1SEL   = 4;    // setup EOC4 to trigger ADCINT1 to fire

    AdcRegs.ADCSAMPLEMODE.bit.SIMULEN0 = 1; // Simultaneous sampling for SOC0 and 1
    AdcRegs.ADCSAMPLEMODE.bit.SIMULEN2 = 1; // Simultaneous sampling for SOC2 and 3

    // Set ADCCLK = SYSCLK
    AdcRegs.ADCCTL2.bit.CLKDIV2EN   = 0;
    AdcRegs.ADCCTL2.bit.CLKDIV4EN   = 0;

    // Channel select for SOCs
    AdcRegs.ADCSOC0CTL.bit.CHSEL    = 5;    // set SOC0 channel select to ADCINA5
    AdcRegs.ADCSOC1CTL.bit.CHSEL    = 13;   // set SOC1 channel select to ADCINB5
    AdcRegs.ADCSOC2CTL.bit.CHSEL    = 3;    // set SOC2 channel select to ADCINA3
    AdcRegs.ADCSOC3CTL.bit.CHSEL    = 11;   // set SOC3 channel select to ADCINB3
    AdcRegs.ADCSOC4CTL.bit.CHSEL    = 4;    // set SOC4 channel select to ADCINA4

    // Set SOC0 start trigger on CPU TIMER 0 Interrupt
    // due to round-robin SOC0 converts in order SOC0, SOC1, ..., SOC4
    AdcRegs.ADCSOC0CTL.bit.TRIGSEL  = 1;
    AdcRegs.ADCSOC1CTL.bit.TRIGSEL  = 1;
    AdcRegs.ADCSOC2CTL.bit.TRIGSEL  = 1;
    AdcRegs.ADCSOC3CTL.bit.TRIGSEL  = 1;
    AdcRegs.ADCSOC4CTL.bit.TRIGSEL  = 1;

    // Set SOC0 to SOC4 S/H Window to 7 ADC Clock Cycles
    AdcRegs.ADCSOC0CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC1CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC2CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC3CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC4CTL.bit.ACQPS    = 6;

    EDIS;
}

void
InitEPwm4Example()
{
    EPwm4Regs.TBPRD = EPWM4_PER;                    // Set timer period
    EPwm4Regs.TBPHS.half.TBPHS = 0x0000;            // Phase is 0
    EPwm4Regs.TBCTR = 0x0000;// Clear counter

    // Setup TBCLK
    // TBCLK = SYSCLKOUT / (HSPCLKDIV × CLKDIV)
    EPwm4Regs.TBCTL.bit.PHSEN = TB_DISABLE;         // Disable phase loading
    EPwm4Regs.TBCTL.bit.HSPCLKDIV = 0x0;        // Clock ratio to SYSCLKOUT
    // 000 => /1
    // 001 /2 (default on reset)
    // 010 /4
    // 011 /6
    // 100 /8
    // 101 /10
    // 110 /12
    // 111 /14
    EPwm4Regs.TBCTL.bit.CLKDIV = 0x0;           // Time Base Prescaler
    // 000 /1 (default on reset)
    // 001 /2
    // 010 /4
    // 011 /8
    // 100 /16
    // 101 /32
    // 110 /64
    // 111 /128
    EPwm4Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;  // Count up
    // For Up Count or Down Count i.e TB_COUNT_UP
    // TPWM = (TBPRD + 1) x TBCLK
    // For Up and Down Count i.e. TB_COUNT_UPDOWN
    // TPWM = 2 x TBPRD x TBCLK
    // FPWM = 1 / (TPWM)

    EPwm4Regs.CMPA.half.CMPA = EPWM4_DUTY;          // Duty cycle

    // Set actions
    EPwm4Regs.AQCTLA.bit.CAU = AQ_SET;              // Set PWM4A on CAU
    EPwm4Regs.AQCTLA.bit.CAD = AQ_CLEAR;            // Clear PWM4A on CAD
    EPwm4Regs.AQCTLB.bit.CAU = AQ_CLEAR;            // Clear PWM4B on CAU
    EPwm4Regs.AQCTLB.bit.CAD = AQ_SET;              // Set PWM4B on CAD

    // Active high complementary PWMs - Setup the deadband
    EPwm4Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;
    EPwm4Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;
    EPwm4Regs.DBCTL.bit.IN_MODE = DBA_ALL;

    // Dead Band
    // FED = DBFED × TTBCLK/2
    // RED = DBRED × TTBCLK/2
    EPwm4Regs.DBRED = EPWM4_DB;
    EPwm4Regs.DBFED = EPWM4_DB;
}

void
InitEPwm5Example()
{
    EPwm5Regs.TBPRD = EPWM5_PER;                    // Period = <EPWM5_PER> TBCLK counts
    EPwm5Regs.TBPHS.half.TBPHS = 0;                 // Set Phase register to zero
    EPwm5Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN;  // Symmetrical mode
    EPwm5Regs.TBCTL.bit.PHSEN = TB_DISABLE;         // Master module
    EPwm5Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    EPwm5Regs.TBCTL.bit.SYNCOSEL = TB_CTR_ZERO;     // Sync down-stream module
    EPwm5Regs.TBCTL.bit.CLKDIV = TB_DIV4;
    EPwm5Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm5Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm5Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;   // load on CTR=Zero
    EPwm5Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;   // load on CTR=Zero
    EPwm5Regs.AQCTLA.bit.CAU = AQ_SET;              // set actions for EPWM5A
    EPwm5Regs.AQCTLA.bit.CAD = AQ_CLEAR;
    EPwm5Regs.AQCTLB.bit.CBU = AQ_SET;              // set actions for EPWM5B
    EPwm5Regs.AQCTLB.bit.CBD = AQ_CLEAR;

    EPwm5Regs.CMPA.half.CMPA = EPWM5A_DUTY;         // adjust duty for output EPWM5A
    EPwm5Regs.CMPB = EPWM5B_DUTY;                   // adjust duty for output EPWM5B
}

void
InitEPwm6Example()
{
    EPwm6Regs.TBPRD = EPWM6_PER;                    // Period = <EPWM6_PER> TBCLK counts
    EPwm6Regs.TBPHS.half.TBPHS = 0;                 // Set Phase register to zero
    EPwm6Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN;  // Symmetrical mode
    EPwm6Regs.TBCTL.bit.PHSEN = TB_DISABLE;         // Master module
    EPwm6Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    EPwm6Regs.TBCTL.bit.SYNCOSEL = TB_CTR_ZERO;     // Sync down-stream module
    EPwm6Regs.TBCTL.bit.CLKDIV = TB_DIV4;
    EPwm6Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm6Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm6Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;   // load on CTR=Zero
    EPwm6Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;   // load on CTR=Zero
    EPwm6Regs.AQCTLA.bit.CAU = AQ_SET;              // set actions for EPWM6A
    EPwm6Regs.AQCTLA.bit.CAD = AQ_CLEAR;
    EPwm6Regs.AQCTLB.bit.CBU = AQ_SET;              // set actions for EPWM6B
    EPwm6Regs.AQCTLB.bit.CBD = AQ_CLEAR;

    EPwm6Regs.CMPA.half.CMPA = EPWM6A_DUTY;         // adjust duty for output EPWM6A
    EPwm6Regs.CMPB = EPWM6B_DUTY;                   // adjust duty for output EPWM6B
}

// End of File
