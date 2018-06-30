//###########################################################################
// Peripheral Config:
// ePWM1 -> SOC0 -> ... -> SOC4 -> ADCINT7 -> CLA task7 -> Read voltages
// ePWM4: Active High Complementary PWM with DeadBand
// ePWM5: Independent PWM
// epWM6: Independent PWM
// GPIO34: Toggles every adc cycle
// GPIO31: Toggles every control loop cycle
// CPU Timer0: Control Loop
//
// Watch Variables:
// - Current1 => ADCINA5
// - Current2 => ADCINB5
// - Current3 => ADCINA3
// - Voltage1 => ADCINB3
// - Voltage2 => ADCINA4
// - mainCount
// - adcCount
// - claTask8Count
// - SampleCount
//
// Pin Connections:
// - ADCINA4 => Pin69
// - ADCINB3 => Pin68
// - ADCINA3 => Pin67
// - ADCINB5 => Pin66
// - ADCINA5 => Pin65
//
// - EPWM1A  => Pin40
// - EPWM4A  => Pin80
// - EPWM4B  => Pin79
// - EPWM5A  => Pin78
// - EPWM5B  => Pin77
// - EPWM6A  => Pin76
// - EPWM6B  => Pin75
//
// - GPIO18 => Pin7 (Not Used Anymore)
// - GPIO22 => Pin8 (Not Used Anymore)
// - GPIO31 => LD2
// - GPIO34 => LD3
//
// - GND     => Pin22, 62, 20, 60
// - 5V      => Pin21, 61
// - 3.3V    => Pin1, 41
//###########################################################################

//  Includes
#include "DSP28x_Project.h"
#include "definitions.h"            // Include wedm definitions
#include "CLAShared.h"              // Include CLA shared variables
#include "string.h"
#include "variables.h"

Uint16 pid1 = 0;

// Function Prototypes
//interrupt void cla1_isr7(void);   // CLA task 7 ISR
//interrupt void controller(void);  // CPU Timer0 ISR

// Functions that will be run from RAM need to be assigned to
// a different section.  This section will then be mapped using
// the linker cmd file.
//

#if FLASH
    #pragma CODE_SECTION(cla1_isr7, "ramfuncs");
    #pragma CODE_SECTION(controller, "ramfuncs");
#endif

interrupt void cla1_isr7(void);
interrupt void controller(void);
void init_gpio(void);               // Initialize GPIO
void init_interrupts(void);         // Initialize interrupts
void init_cla(void);                // Initialize CLA
void init_adc(void);                // Initialize ADC
void init_pwm(void);                // Initialize ePWMs
void init_epwm1(void);
void init_epwm4(void);
void init_epwm5(void);
void init_epwm6(void);
void init_epwm3(void);
void init_cputimers(void);          // Initialize CPU timer

// Main
void main(void)
{
    InitSysCtrl();      // Initialize PLL, WatchDog, enable Peripheral Clocks
    #if FLASH
        memcpy(&RamfuncsRunStart, &RamfuncsLoadStart, (Uint32)&RamfuncsLoadSize);
        InitFlash();    // Call Flash Initialization to setup flash waitstates
    #endif
    init_gpio();
    init_interrupts();
    init_cla();
    init_adc();
    init_pwm();
    init_cputimers();

    DELAY_US(10000000);
    pid1 = 1;
    for(;;)
    {
        #if DIAGNOSTICS
            mainCount++;
        #endif
    }
}

interrupt void
cla1_isr7(void)
{
    GpioDataRegs.GPASET.bit.GPIO31 = 1;  // Toggle GPIO22 for status
    current3 = current3Sum * M3 + C3;
    voltage2 = voltage2Sum * M5 + C5;
    GpioDataRegs.GPACLEAR.bit.GPIO31 = 1;  // Toggle GPIO22 for status
    AdcRegs.ADCINTFLGCLR.bit.ADCINT7 = 1;   // Clear the ADC interrupt flag
    PieCtrlRegs.PIEACK.bit.ACK11 = 1;       // Clear the CLA Interrupt IACK bits
}


interrupt void
controller(void)
{
    GpioDataRegs.GPBSET.bit.GPIO34 = 1;  // Toggle GPIO18 for status
    #if PID1
        e1[0] = REF1 - current3;
        u1[0] = u1[1] + a1 * e1[0] + b1 * e1[1] + c1 * e1[2];
        if(u1[0] > 0.9) u1[0] = 0.9;
        if(u1[0] < -0.9) u1[0] = -0.9;
        if(pid1 == 1){
            EPwm5Regs.CMPA.half.CMPA = (u1[0] / 2.0 + 0.5) * EPWM5_PER;
        }
    #endif
    #if PID2
        e2[0] = REF2 - voltage2;
        u2[0] = u2[1] + a2 * e2[0] + b2 * e2[1] + c2 * e2[2];
        if(u2[0] > 0.9) u2[0] = 0.9;
        if(u2[0] < -0.9) u2[0] = -0.9;
        EPwm4Regs.CMPA.half.CMPA = (u2[0] / 2.0 + 0.5) * EPWM4_PER;
    #endif
    #if SMC1
        e1[0] = current3 - REF1;
        u1[0] = KC * e1[0] + (e1[0] - e1[1]) / TS1;
        integral1 += u1[0];

        if(KP * u1[0] + KI * integral1 < 0.0f)
        {
            GpioDataRegs.GPASET.bit.GPIO18 = 1;
        }
        else
        {
            GpioDataRegs.GPACLEAR.bit.GPIO18 = 1;
        }
    #endif
    #if PID1 || SMC1
        u1[1] = u1[0];
        e1[2] = e1[1];
        e1[1] = e1[0];
    #endif
    #if PID2
        u2[1] = u2[0];
        e2[2] = e2[1];
        e2[1] = e2[0];
    #endif
    #if PID1 || PID2
        controllerCount++;
    #endif
    GpioDataRegs.GPBCLEAR.bit.GPIO34 = 1;
    PieCtrlRegs.PIEACK.bit.ACK1 = 1;
}

void
init_gpio(void)
{
    InitGpio();
    EALLOW;
    GpioCtrlRegs.GPBDIR.bit.GPIO34 = 1;     // GPIO34 is an output connected to LED
    GpioCtrlRegs.GPADIR.bit.GPIO31 = 1;
    GpioCtrlRegs.GPADIR.bit.GPIO18 = 1;
    EDIS;
}

void
init_interrupts(void)
{
    // Clear all interrupts and initialize PIE vector table:
    DINT;   // Disable CPU interrupts

    // Initialize the PIE control registers to their default state.
    // The default state is all PIE interrupts disabled and flags
    // are cleared.
    // This function is found in the F2806x_PieCtrl.c file.
    InitPieCtrl();

    // Disable CPU interrupts and clear all CPU interrupt flags:
    IER = 0x0000;
    IFR = 0x0000;

    // Initialize the PIE vector table with pointers to the shell Interrupt
    // Service Routines (ISR).
    InitPieVectTable();

    // Interrupts that are used in this example are re-mapped to
    // ISR functions found within this file.
    // EALLOW: is needed to write to EALLOW protected registers
    // EDIS: is needed to disable write to EALLOW protected registers
    EALLOW;
    PieVectTable.CLA1_INT7 = &cla1_isr7;
    PieVectTable.TINT0 = &controller;
    EDIS;

    PieCtrlRegs.PIEIER11.bit.INTx7 = 1;     // Enable INT 11.7 in the PIE (CLA Task7)
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;      // Enable TINT0 in the PIE: Group 1 interrupt 7
    IER |= M_INT11;                         // Enable INT 11 at the CPU level
    IER |= M_INT1;
    EINT;                                   // Enable Global interrupts with INTM
    ERTM;                                   // Enable Global realtime interrupts with DBGM
}

void
init_cla(void)
{
    // init_cla - CLA module initialization
    // 1) Enable the CLA clock
    // 2) Init the CLA interrupt vectors
    // 3) Allow the IACK instruction to flag a CLA interrupt/start a task
    //    This is used to force Task 8 in this example
    // 4) Copy CLA code from its load address to CLA program RAM
    //
    //    Note: during debug the load and run addresses could be
    //    the same as Code Composer Studio can load the CLA program
    //    RAM directly.
    //
    //    The ClafuncsLoadStart, ClafuncsLoadEnd, and ClafuncsRunStart
    //    symbols are created by the linker.
    // 4) Assign CLA program memory to the CLA
    // 5) Enable CLA interrupts (MIER)

    // This code assumes the CLA clock is already enabled in
    // the call to InitSysCtrl();

    // EALLOW: is needed to write to EALLOW protected registers
    // EDIS: is needed to disable write to EALLOW protected registers

    // Initalize the interrupt vectors for Task 7 (ADC averaging filter)
    // and for Task 8 (Set sensing variables to 0)

    // The symbols used in this calculation are defined in the CLA
    // assembly code and in the CLAShared.h header file

    EALLOW;
    Cla1Regs.MVECT7 = (Uint16)((Uint32)&Cla1Task7 -(Uint32)&Cla1Prog_Start);
    Cla1Regs.MVECT8 = (Uint16)((Uint32)&Cla1Task8 -(Uint32)&Cla1Prog_Start);

    // Task 7 has the option to be started by either EPWM7_INT or ADCINT7
    // In this case we will allow ADCINT7 to start CLA Task 7
    Cla1Regs.MPISRCSEL1.bit.PERINT7SEL = CLA_INT7_ADCINT7;

    // Copy the CLA program code from its load address to the CLA program
    // memory. Once done, assign the program memory to the CLA
    memcpy(&Cla1funcsRunStart, &Cla1funcsLoadStart, (Uint32)&Cla1funcsLoadSize);
    Cla1Regs.MMEMCFG.bit.PROGE = 1;
    // Configure CLA RAM 1 to R/W bt both processors
    Cla1Regs.MMEMCFG.bit.RAM1E = 1;
    Cla1Regs.MMEMCFG.bit.RAM1CPUE = 1;
    // Configure CLA RAM 0 to R/W via cla only
    Cla1Regs.MMEMCFG.bit.RAM0E = 1;
    Cla1Regs.MMEMCFG.bit.RAM0CPUE = 0;

    // Enable the IACK instruction to start a task
    // Enable the CLA interrupt 8 and interrupt 7
    Cla1Regs.MCTL.bit.IACKE = 1;
    Cla1Regs.MIER.all = (M_INT8 | M_INT7);

    // Force CLA task 8 using the IACK instruction
    Cla1ForceTask8();
}

void
init_adc(void)
{
    // Assumes ADC clock is already enabled in InitSysCtrl();

    // Call the InitAdc function in the F2806x_Adc.c file
    // This function calibrates and powers up the ADC to
    // into a known state.
    InitAdc();
    AdcOffsetSelfCal();

    EALLOW;
    AdcRegs.ADCREFTRIM.bit.BG_FINE_TRIM = 3;

    AdcRegs.ADCCTL2.bit.ADCNONOVERLAP = 1;  // Enable non-overlap mode
    // AdcRegs.ADCCTL1.bit.INTPULSEPOS = 0;
    AdcRegs.ADCCTL1.bit.INTPULSEPOS = 0;    // ADCINT1 trips AFTER AdcResults latch
    AdcRegs.ADCCTL1.bit.TEMPCONV      = 0;  //Temperature sensor not used
    AdcRegs.INTSEL7N8.bit.INT7E     = 1;
    AdcRegs.INTSEL7N8.bit.INT7CONT  = 0;

    #if V_SENS2
        AdcRegs.INTSEL7N8.bit.INT7SEL   = 4; // setup EOC4 to trigger ADCINT7
    #elif V_SENS1
        AdcRegs.INTSEL7N8.bit.INT7SEL   = 3; // setup EOC3 to trigger ADCINT7
    #elif I_SENS3
        AdcRegs.INTSEL7N8.bit.INT7SEL   = 2; // setup EOC2 to trigger ADCINT7
    #elif I_SENS2
        AdcRegs.INTSEL7N8.bit.INT7SEL   = 1; // setup EOC1 to trigger ADCINT7
    #elif I_SENS1
        AdcRegs.INTSEL7N8.bit.INT7SEL   = 0; // setup EOC0 to trigger ADCINT7
    #endif


    #if I_SENS1 && I_SENS2
        AdcRegs.ADCSAMPLEMODE.bit.SIMULEN0 = 1; // Simultaneous sampling for SOC0 and 1
    #endif
    #if I_SENS3 && V_SENS1
        AdcRegs.ADCSAMPLEMODE.bit.SIMULEN2 = 1; // Simultaneous sampling for SOC2 and 3
    #endif

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
    #if I_SENS1
        AdcRegs.ADCSOC0CTL.bit.TRIGSEL  = 5;
    #endif
    #if I_SENS2 && !I_SENS1
        AdcRegs.ADCSOC1CTL.bit.TRIGSEL  = 5;
    #endif
    #if I_SENS3
        AdcRegs.ADCSOC2CTL.bit.TRIGSEL  = 5;
    #endif
    #if V_SENS1 && !I_SENS3
        AdcRegs.ADCSOC3CTL.bit.TRIGSEL  = 5;
    #endif
    #if V_SENS2
        AdcRegs.ADCSOC4CTL.bit.TRIGSEL  = 5;
    #endif

    // Set SOC0 to SOC4 S/H Window to 7 ADC Clock Cycles
    AdcRegs.ADCSOC0CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC1CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC2CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC3CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC4CTL.bit.ACQPS    = 6;
    AdcRegs.ADCSOC4CTL.bit.ACQPS    = 6;
    EDIS;
}

void
init_pwm(void)
{
    // Assumes ePWM1 clock is already enabled in InitSysCtrl();
    // Before configuring the ePWMs, halt the counters
    // After configuration they can all be started again
    // in synchronization by setting this bit.
    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;

    init_epwm1();
    init_epwm3();
    #if V_SOURCE
        init_epwm4();
    #endif
    #if I_SOURCE
        init_epwm5();
    #endif
    #if LOAD
        init_epwm6();
    #endif
    // Start the ePWM counters
    // Note: this should be done after all ePWM modules are configured
    // to ensure synchronization between the ePWM modules.
    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;
}

void
init_epwm1(void)
{
    // EPWM1 will be used to generate the ADC Start of conversion

    // EALLOW: is needed to write to EALLOW protected registers
    // EDIS: is needed to disable write to EALLOW protected registers

    // Enable start of conversion (SOC) on A
    // An SOC event will occur when the ePWM counter is zero
    // The ePWM will generate an SOC on the first event

    EALLOW;
    EPwm1Regs.TBPRD             = EPWM1_PER;
    EPwm1Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;
    EPwm1Regs.ETSEL.bit.SOCAEN  = 1;
    EPwm1Regs.ETSEL.bit.SOCASEL = ET_CTR_ZERO;
    EPwm1Regs.ETPS.bit.SOCAPRD  = ET_1ST;
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = EPWM1_HSPCLKDIV;        // Clock ratio to SYSCLKOUT
    EPwm1Regs.TBCTL.bit.CLKDIV = EPWM1_CLKDIV;           // Time Base Prescaler

    //
    // For testing - monitor the EPWM1A output which toggles once every ePWM
    // period (i.e at the start of conversion)
    //
    GpioCtrlRegs.GPAMUX1.bit.GPIO0 = 1;
    EPwm1Regs.AQCTLA.bit.ZRO = AQ_TOGGLE;
    EPwm1Regs.TBCTL.bit.FREE_SOFT = 3;

    EDIS;
}

void
init_epwm4(void)
{
    InitEPwm4Gpio();                                    // Initialize GPIO pin for ePWM4
    EPwm4Regs.TBPRD = EPWM4_PER;                        // Set timer period
    EPwm4Regs.TBCTL.bit.PHSEN = TB_DISABLE;             // Disable phase loading
    EPwm4Regs.TBPHS.half.TBPHS = 0;                // Phase is 0

    EPwm4Regs.TBCTR = PHASE;                           // Clear counter

    // Setup TBCLK
    // TBCLK_freq = SYSCLKOUT / (HSPCLKDIV × CLKDIV)
    EPwm4Regs.TBCTL.bit.HSPCLKDIV = EPWM4_HSPCLKDIV;    // Clock ratio to SYSCLKOUT
    // 000 => /1
    // 001 /2 (default on reset)
    // 010 /4
    // 011 /6
    // 100 /8
    // 101 /10
    // 110 /12
    // 111 /14
    EPwm4Regs.TBCTL.bit.CLKDIV = EPWM4_CLKDIV;          // Time Base Prescaler
    // 000 /1 (default on reset)
    // 001 /2
    // 010 /4
    // 011 /8
    // 100 /16
    // 101 /32
    // 110 /64
    // 111 /128

    EPwm4Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;          // Count up
    // For Up Count or Down Count i.e TB_COUNT_UP
    // TPWM = (TBPRD + 1) x TBCLK
    // For Up and Down Count i.e. TB_COUNT_UPDOWN
    // TPWM = 2 x TBPRD x TBCLK
    // FPWM = 1 / (TPWM)

    EPwm4Regs.CMPA.half.CMPA = EPWM4_DUTY*EPWM4_PER;    // Duty cycle

    // Set actions

    // Original Dead Band Code
    /*
    EPwm4Regs.AQCTLA.bit.CAU = AQ_SET;                  // Set PWM4A on CAU
    EPwm4Regs.AQCTLA.bit.CAD = AQ_CLEAR;                // Clear PWM4A on CAD
    EPwm4Regs.AQCTLB.bit.CAU = AQ_CLEAR;                // Clear PWM4B on CAU
    EPwm4Regs.AQCTLB.bit.CAD = AQ_SET;                  // Set PWM4B on CAD
    */
    // For Count UP Mode as well as UP-DOWN Mode
    EPwm4Regs.AQCTLA.bit.ZRO = AQ_SET;                  // Set PWM4A on Zero
    EPwm4Regs.AQCTLA.bit.CAU = AQ_CLEAR;                // Clear PWM4A on event A, up count
    EPwm4Regs.AQCTLB.bit.ZRO = AQ_SET;                  // Set PWM4B on Zero
    EPwm4Regs.AQCTLB.bit.CBU = AQ_CLEAR;                // Clear PWM4B on event B, up count
    // For Count UP-DOWN Mode
    /*
    EPwm4Regs.AQCTLA.bit.CAU = AQ_SET;                  // set actions for EPWM4A
    EPwm4Regs.AQCTLA.bit.CAD = AQ_CLEAR;
    EPwm4Regs.AQCTLB.bit.CBU = AQ_SET;                  // set actions for EPWM4B
    EPwm4Regs.AQCTLB.bit.CBD = AQ_CLEAR;
    */

    // Active high complementary PWMs - Setup the deadband
    EPwm4Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;
    EPwm4Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;
    EPwm4Regs.DBCTL.bit.IN_MODE = DBA_ALL;

    // Dead Band
    // FED = DBFED × TBCLK/2
    // RED = DBRED × TBCLK/2
    EPwm4Regs.DBRED = EPWM4_DB*EPWM4_PER;
    EPwm4Regs.DBFED = EPWM4_DB*EPWM4_PER;
}

void
init_epwm5(void)
{
    InitEPwm5Gpio();                                    // Initialize GPIO pin for ePWM5

    EPwm5Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;          // Count Up
    EPwm5Regs.TBPRD = EPWM5_PER;                        // Period = <EPWM5_PER> TBCLK counts
    EPwm5Regs.TBCTL.bit.PHSEN = TB_DISABLE;             // Master module
    EPwm5Regs.TBPHS.half.TBPHS = 0;                     // Set Phase register to zero
    EPwm5Regs.TBCTR = PHASE;//270;                           // Clear counter
    EPwm5Regs.TBCTL.bit.HSPCLKDIV = EPWM5_HSPCLKDIV;    // Clock ratio to SYSCLKOUT
    EPwm5Regs.TBCTL.bit.CLKDIV = EPWM5_CLKDIV;

    EPwm5Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    //EPwm5Regs.TBCTL.bit.SYNCOSEL = TB_SYNC_IN;         // Sync down-stream module
    EPwm5Regs.TBCTL.bit.PHSDIR             = 0;

    EPwm5Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm5Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm5Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;       // load on CTR=Zero
    EPwm5Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;       // load on CTR=Zero

    // Set actions
    // For Count UP Mode as well as UP-DOWN Mode
    EPwm5Regs.AQCTLA.bit.ZRO = AQ_SET;                  // Set PWM5A on Zero
    EPwm5Regs.AQCTLA.bit.CAU = AQ_CLEAR;                // Clear PWM5A on event A, up count
    EPwm5Regs.AQCTLB.bit.ZRO = AQ_SET;                  // Set PWM5B on Zero
    EPwm5Regs.AQCTLB.bit.CBU = AQ_CLEAR;                // Clear PWM5B on event B, up count
    // For Count UP-DOWN Mode
    /*
    EPwm5Regs.AQCTLA.bit.CAU = AQ_SET;                  // set actions for EPWM5A
    EPwm5Regs.AQCTLA.bit.CAD = AQ_CLEAR;
    EPwm5Regs.AQCTLB.bit.CBU = AQ_SET;                  // set actions for EPWM5B
    EPwm5Regs.AQCTLB.bit.CBD = AQ_CLEAR;
    */

    EPwm5Regs.CMPA.half.CMPA = EPWM5A_DUTY*EPWM5_PER;   // adjust duty for output EPWM5A
    EPwm5Regs.CMPB = EPWM5B_DUTY*EPWM5_PER;             // adjust duty for output EPWM5B
}

void
init_epwm6(void)
{
    InitEPwm6Gpio();                                    // Initialize GPIO pin for ePWM6

    EPwm6Regs.TBPRD = EPWM6_PER;                        // Period = <EPWM6_PER> TBCLK counts
    EPwm6Regs.TBPHS.half.TBPHS = 0;                     // Set Phase register to zero
    EPwm6Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;          // Count Up

    EPwm6Regs.TBCTL.bit.PHSEN = TB_DISABLE;             // Master module
    EPwm6Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    EPwm6Regs.TBCTL.bit.SYNCOSEL = TB_CTR_ZERO;         // Sync down-stream module

    EPwm6Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm6Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm6Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;       // load on CTR=Zero
    EPwm6Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;       // load on CTR=Zero

    //EPwm6Regs.TBCTR = PHASE;                           // Clear counter
    EPwm6Regs.TBCTL.bit.HSPCLKDIV = EPWM6_HSPCLKDIV;    // Clock ratio to SYSCLKOUT
    EPwm6Regs.TBCTL.bit.CLKDIV = EPWM6_CLKDIV;


    // Set actions
    // For Count UP Mode as well as UP-DOWN Mode
    EPwm6Regs.AQCTLA.bit.ZRO = AQ_SET;                  // Set PWM6A on Zero
    EPwm6Regs.AQCTLA.bit.CAU = AQ_CLEAR;                // Clear PWM6A on event A, up count
    EPwm6Regs.AQCTLB.bit.ZRO = AQ_SET;                  // Set PWM6B on Zero
    EPwm6Regs.AQCTLB.bit.CBU = AQ_CLEAR;                // Clear PWM6B on event B, up count
    // For Count UP-DOWN Mode
    /*
    EPwm6Regs.AQCTLA.bit.CAU = AQ_SET;                  // set actions for EPWM6A
    EPwm6Regs.AQCTLA.bit.CAD = AQ_CLEAR;
    EPwm6Regs.AQCTLB.bit.CBU = AQ_SET;                  // set actions for EPWM6B
    EPwm6Regs.AQCTLB.bit.CBD = AQ_CLEAR;
    */

    EPwm6Regs.CMPA.half.CMPA = EPWM6A_DUTY*EPWM6_PER;   // adjust duty for output EPWM6A
    EPwm6Regs.CMPB = EPWM6B_DUTY*EPWM6_PER;             // adjust duty for output EPWM6B
}

void
init_epwm3(void)
{
    InitEPwm3Gpio();                                    // Initialize GPIO pin for ePWM5

    EPwm3Regs.TBCTL.bit.CTRMODE = TB_COUNT_UP;          // Count Up
    EPwm3Regs.TBPRD = EPWM3_PER;                        // Period = <EPWM5_PER> TBCLK counts
    EPwm3Regs.TBCTL.bit.PHSEN = TB_DISABLE;             // Master module
    EPwm3Regs.TBPHS.half.TBPHS = 0x0000;                     // Set Phase register to zero
    EPwm3Regs.TBCTR = 0x0000;//270;                           // Clear counter
    EPwm3Regs.TBCTL.bit.HSPCLKDIV = EPWM3_HSPCLKDIV;    // Clock ratio to SYSCLKOUT
    EPwm3Regs.TBCTL.bit.CLKDIV = EPWM3_CLKDIV;

    EPwm3Regs.TBCTL.bit.PRDLD = TB_SHADOW;
    EPwm3Regs.TBCTL.bit.SYNCOSEL = TB_SYNC_DISABLE;         // Sync down-stream module

    EPwm3Regs.CMPCTL.bit.SHDWAMODE = CC_SHADOW;
    EPwm3Regs.CMPCTL.bit.SHDWBMODE = CC_SHADOW;
    EPwm3Regs.CMPCTL.bit.LOADAMODE = CC_CTR_ZERO;       // load on CTR=Zero
    EPwm3Regs.CMPCTL.bit.LOADBMODE = CC_CTR_ZERO;       // load on CTR=Zero

    // Set actions
    // For Count UP Mode as well as UP-DOWN Mode
    EPwm3Regs.AQCTLA.bit.PRD = AQ_SET;                  // Set PWM5A on Zero
    EPwm3Regs.AQCTLA.bit.CAU = AQ_CLEAR;                // Clear PWM5A on event A, up count
    EPwm3Regs.AQCTLB.bit.PRD = AQ_CLEAR;                  // Set PWM5B on Zero
    EPwm3Regs.AQCTLB.bit.CBU = AQ_SET;                // Clear PWM5B on event B, up count
    // For Count UP-DOWN Mode
    /*
    EPwm5Regs.AQCTLA.bit.CAU = AQ_SET;                  // set actions for EPWM5A
    EPwm5Regs.AQCTLA.bit.CAD = AQ_CLEAR;
    EPwm5Regs.AQCTLB.bit.CBU = AQ_SET;                  // set actions for EPWM5B
    EPwm5Regs.AQCTLB.bit.CBD = AQ_CLEAR;
    */

    EPwm3Regs.CMPA.half.CMPA = EPWM3A_DUTY*EPWM3_PER;   // adjust duty for output EPWM5A
    EPwm3Regs.CMPB = EPWM3B_DUTY*EPWM3_PER;             // adjust duty for output EPWM5B
}

void
init_cputimers(void)
{
    InitCpuTimers();
    // Configure CPU-Timer 0, 1, and 2 to interrupt every second:
    // 80MHz CPU Freq, 1 second Period (in uSeconds)
    ConfigCpuTimer(&CpuTimer0, CPU_FREQ, CPU_T0_PER);
    // Use write-only instruction to set TSS bit = 0
    CpuTimer0Regs.TCR.all = 0x4000;
}
