//###########################################################################
//
// FILE:   main.c
//
// TITLE:  Timer based blinking LED Example
//
//!  \addtogroup f2806x_example_list
//!  <h1>Timer based blinking LED(timed_led_blink)</h1>
//!
//!  This example configures CPU Timer0 for a 500 msec period, and toggles the 
//!  GPIO34 LED once per interrupt. For testing purposes, this example
//!  also increments a counter each time the timer asserts an interrupt.
//!
//!  \b Watch \b Variables \n
//!  - CpuTimer0.InterruptCount
//!
//! \b External \b Connections \n
//!  Monitor the GPIO34 LED blink on (for 500 msec) and off (for 500 msec) on 
//!  the 2806x control card.
//
//###########################################################################
//
// FILE:   Example_2806xClaAdc.c
//
// TITLE:  CLA ADC Example
//
//!  \addtogroup f2806x_example_list
//!  <h1>CLA ADC (cla_adc)</h1>
//!
//! In this example ePWM1 is setup to generate a periodic ADC SOC.
//! Channel ADCINA2 is converted. When the ADC begins conversion,
//! it will assert ADCINT2 which will start CLA task 2.
//!
//! Cla Task2 logs 20 ADCRESULT1 values in a circular buffer.
//! When Task2 completes an interrupt to the CPU clears the ADCINT2 flag.
//!
//! \b Watch \b Variables \n
//! - VoltageCLA       - Last 20 ADCRESULT1 values
//! - ConversionCount  - Current result number
//! - LoopCount        - Idle loop counter
//
//###########################################################################
//
// FILE:   Example_2806xEPwmDeadBand.c
//
// TITLE:  ePWM Deadband Generation Example
//
//! \addtogroup f2806x_example_list
//! <h1>ePWM Deadband Generation (epwm_deadband)</h1>
//!
//! This example configures ePWM1, ePWM2 and ePWM3 for:
//!   - Count up/down
//!   - Deadband
//! 3 Examples are included:
//!   - ePWM3: Active high complementary PWMs
//!
//! Each ePWM is configured to interrupt on the 3rd zero event
//! when this happens the deadband is modified such that
//! 0 <= DB <= DB_MAX.  That is, the deadband will move up and
//! down between 0 and the maximum value.
//!
//! \b External \b Connections \n
//!  - EPWM3A is on GPIO4
//!  - EPWM3B is on GPIO5
//
//###########################################################################

//
// Included Files
//
#include "DSP28x_Project.h"     // Device Headerfile and Examples Include File
#include "CLAShared.h"
#include "string.h"

//
// Function Prototypes statements for functions found within this file.
//
__interrupt void cpu_timer0_isr(void);
__interrupt void cla1_isr2(void);
void InitEPwm2Example(void);
__interrupt void epwm2_isr(void);

//
// Globals
//
#pragma DATA_SECTION(ConversionCount, "Cla1ToCpuMsgRAM");
#pragma DATA_SECTION(VoltageCLA,      "Cla1ToCpuMsgRAM");

Uint16 ConversionCount;
Uint16 LoopCount;
Uint16 VoltageCLA[NUM_DATA_POINTS];
Uint32  EPwm2TimerIntCount;
Uint16  EPwm2_DB_Direction;

//
// Defines that Maximum Dead Band values
//
#define EPWM2_MAX_DB   0x03FF
#define EPWM2_MIN_DB   0


//
// Defines to keep track of which way the Dead Band is moving
//
#define DB_UP   1
#define DB_DOWN 0

//
// These are defined by the linker file
//
extern Uint16 Cla1funcsLoadStart;
extern Uint16 Cla1funcsLoadEnd;
extern Uint16 Cla1funcsRunStart;
extern Uint16 Cla1funcsLoadSize;

//
// Main
//
void main(void)
{
    //
    // Step 1. Initialize System Control:
    // PLL, WatchDog, enable Peripheral Clocks
    // This example function is found in the F2806x_SysCtrl.c file.
    //
    InitSysCtrl();

    //
    // Step 2. Initalize GPIO:
    // This example function is found in the F2806x_Gpio.c file and
    // illustrates how to set the GPIO to it's default state.
    //
    // InitGpio();  // Skipped for this example

    //
    // For this case just init GPIO pins for ePWM3
    // These functions are in the F2806x_EPwm.c file
    //
    InitEPwm2Gpio();

    //
    // Step 3. Clear all interrupts and initialize PIE vector table:
    // Disable CPU interrupts
    //
    DINT;

    //
    // Initialize the PIE control registers to their default state.
    // The default state is all PIE interrupts disabled and flags
    // are cleared.
    // This function is found in the F2806x_PieCtrl.c file.
    //
    InitPieCtrl();

    //
    // Disable CPU interrupts and clear all CPU interrupt flags
    //
    IER = 0x0000;
    IFR = 0x0000;

    //
    // Initialize the PIE vector table with pointers to the shell Interrupt
    // Service Routines (ISR).
    // This will populate the entire table, even if the interrupt
    // is not used in this example.  This is useful for debug purposes.
    // The shell ISR routines are found in F2806x_DefaultIsr.c.
    // This function is found in F2806x_PieVect.c.
    //
    InitPieVectTable();

    //
    // Interrupts that are used in this example are re-mapped to
    // ISR functions found within this file.
    //
    EALLOW;    // This is needed to write to EALLOW protected registers
    PieVectTable.TINT0 = &cpu_timer0_isr;
    PieVectTable.CLA1_INT2 = &cla1_isr2;
    PieVectTable.EPWM2_INT = &epwm2_isr;
    EDIS;      // This is needed to disable write to EALLOW protected registers

    //
    // Step 4. Initialize the Device Peripheral. This function can be
    //         found in F2806x_CpuTimers.c
    //
    InitCpuTimers();   // For this example, only initialize the Cpu Timers
    InitAdc();         // For this example, init the ADC
    AdcOffsetSelfCal();
    
    //
    // Configure CPU-Timer 0 to interrupt every 500 milliseconds:
    // 80MHz CPU Freq, 50 millisecond Period (in uSeconds)
    //
    ConfigCpuTimer(&CpuTimer0, 80, 500000);

    //
    // To ensure precise timing, use write-only instructions to write to the
    // entire register. Therefore, if any of the configuration bits are changed
    // in ConfigCpuTimer and InitCpuTimers (in F2806x_CpuTimers.h), the
    // below settings must also be updated.
    //
    
    //
    // Use write-only instruction to set TSS bit = 0
    //
    CpuTimer0Regs.TCR.all = 0x4001;

    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;

    InitEPwm2Example();

    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;

    //
    // Step 5. User specific code, enable interrupts:
    //

    //
    // Configure GPIO34 as a GPIO output pin
    //
    EALLOW;
    GpioCtrlRegs.GPBMUX1.bit.GPIO34 = 0;
    GpioCtrlRegs.GPBDIR.bit.GPIO34 = 1;
    EDIS;

    //
    // Enable CPU INT1 which is connected to CPU-Timer 0
    //
    IER |= M_INT1;

    //
    // Enable ADCINT1 in PIE
    //

    //
    // Enable INT 11.2 in the PIE (CLA Task2)
    //
    PieCtrlRegs.PIEIER11.bit.INTx2 = 1;

    IER |= M_INT11;             // Enable CPU Interrupt 11

    //
    // Enable TINT0 in the PIE: Group 1 interrupt 7
    //
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;

    // Initalize counters:
    //
    EPwm2TimerIntCount = 0;

    //
    // Enable CPU INT3 which is connected to EPWM1-3 INT
    //
    IER |= M_INT3;

    //
    // Enable EPWM INTn in the PIE: Group 3 interrupt 1-3
    //
    PieCtrlRegs.PIEIER3.bit.INTx2 = 1;

    //
    // Enable global Interrupts and higher priority real-time debug events
    //
    EINT;   // Enable Global interrupt INTM
    ERTM;   // Enable Global realtime interrupt DBGM

    //
    // Copy CLA code from its load address to CLA program RAM
    //

    //
    // Note: during debug the load and run addresses can be
    // the same as Code Composer Studio can load the CLA program
    // RAM directly.
    //

    //
    // The ClafuncsLoadStart, Cla1funcsLoadSize, and ClafuncsRunStart
    // symbols are created by the linker.
    //
    memcpy(&Cla1funcsRunStart, &Cla1funcsLoadStart, (Uint32)&Cla1funcsLoadSize);

    //
    // Initialize the CLA registers
    //
    EALLOW;
    Cla1Regs.MVECT2 = (Uint16) (&Cla1Task2 - &Cla1Prog_Start)*sizeof(Uint32);
    Cla1Regs.MVECT8 = (Uint16) (&Cla1Task8 - &Cla1Prog_Start)*sizeof(Uint32);

    //
    // ADCINT2 starts Task 2
    //
    Cla1Regs.MPISRCSEL1.bit.PERINT2SEL = CLA_INT2_ADCINT2;

    Cla1Regs.MMEMCFG.bit.PROGE = 1;        // Map CLA program memory to the CLA

    //
    // Enable IACK to start tasks via software
    //
    Cla1Regs.MCTL.bit.IACKE = 1;

    Cla1Regs.MIER.all = (M_INT8 | M_INT2); // Enable Task 8 and Task 2

    //
    // Force CLA task 8.
    // This will initialize ConversionCount to zero
    //
    Cla1ForceTask8andWait();

    AdcRegs.ADCCTL2.bit.ADCNONOVERLAP = 1;  // Enable non-overlap mode

    //
    // ADCINT trips when ADC begins conversion
    //
    AdcRegs.ADCCTL1.bit.INTPULSEPOS = 0;

    AdcRegs.INTSEL1N2.bit.INT2E     = 1;    // Enable ADCINT2
    AdcRegs.INTSEL1N2.bit.INT2CONT  = 0;    // Disable ADCINT2 Continuous mode

    //
    // setup EOC1 to trigger ADCINT2 to fire
    //
    AdcRegs.INTSEL1N2.bit.INT2SEL   = 1;

    //
    // set SOC1 channel select to ADCINA2
    //
    AdcRegs.ADCSOC1CTL.bit.CHSEL    = 2;

    AdcRegs.ADCSOC1CTL.bit.TRIGSEL  = 5;    // set SOC1 start trigger on EPWM1A

    //
    // set SOC1 S/H Window to 7 ADC Clock Cycles, (6 ACQPS plus 1)
    //
    AdcRegs.ADCSOC1CTL.bit.ACQPS    = 6;
    EDIS;

    // Assumes ePWM1 clock is already enabled in InitSysCtrl();
    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;
    EPwm1Regs.ETSEL.bit.SOCAEN  = 1;        // Enable SOC on A group

    //
    // Select SOC from from CPMA on upcount
    //
    EPwm1Regs.ETSEL.bit.SOCASEL = 4;

    EPwm1Regs.ETPS.bit.SOCAPRD  = 1;        // Generate pulse on 1st event
    EPwm1Regs.CMPA.half.CMPA    = 0x0080;   // Set compare A value

    //
    // Set period for ePWM1 - this will determine the sampling frequency
    //
    EPwm1Regs.TBPRD             = 900;

    EPwm1Regs.TBCTL.bit.CTRMODE = 0;        // count up and start
    EALLOW;
    SysCtrlRegs.PCLKCR0.bit.TBCLKSYNC = 1;
    EDIS;

    //
    // Step 6. IDLE loop. Just sit and loop forever (optional)
    //
    //for(;;);

    //
    // Wait for ADC interrupt
    //
    for(;;)
    {
        LoopCount++;
        __asm("          NOP");
    }
}

//
// cpu_timer0_isr - 
//
__interrupt void
cpu_timer0_isr(void)
{
    CpuTimer0.InterruptCount++;
    
    //
    // Toggle GPIO34 once per 500 milliseconds
    //
    GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;
    
    //
    // Acknowledge this interrupt to receive more interrupts from group 1
    //
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;
}

//
// cla1_isr2 - This interrupt occurs when CLA Task 2 completes
//
__interrupt void
cla1_isr2()
{
    //
    // Clear ADCINT2 flag reinitialize for next SOC
    //
    AdcRegs.ADCINTFLGCLR.bit.ADCINT2 = 1;

    PieCtrlRegs.PIEACK.all = 0xFFFF;
}

//
// epwm3_isr -
//
__interrupt void
epwm2_isr(void)
{
    if(EPwm2_DB_Direction == DB_UP)
    {
        if(EPwm2Regs.DBFED < EPWM2_MAX_DB)
        {
            EPwm2Regs.DBFED++;
            EPwm2Regs.DBRED++;
        }
        else
        {
            EPwm2_DB_Direction = DB_DOWN;
            EPwm2Regs.DBFED--;
            EPwm2Regs.DBRED--;
        }
    }
    else
    {
        if(EPwm2Regs.DBFED == EPWM2_MIN_DB)
        {
            EPwm2_DB_Direction = DB_UP;
            EPwm2Regs.DBFED++;
            EPwm2Regs.DBRED++;
        }
        else
        {
            EPwm2Regs.DBFED--;
            EPwm2Regs.DBRED--;
        }
    }

    EPwm2TimerIntCount++;

    //
    // Clear INT flag for this timer
    //
    EPwm2Regs.ETCLR.bit.INT = 1;

    //
    // Acknowledge this interrupt to receive more interrupts from group 3
    //
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}

//
// InitEPwm3Example -
//
void
InitEPwm2Example()
{
    EPwm2Regs.TBPRD = 6000;                        // Set timer period
    EPwm2Regs.TBPHS.half.TBPHS = 0x0000;            // Phase is 0
    EPwm2Regs.TBCTR = 0x0000;                       // Clear counter

    //
    // Setup TBCLK
    //
    EPwm2Regs.TBCTL.bit.CTRMODE = TB_COUNT_UPDOWN; // Count up
    EPwm2Regs.TBCTL.bit.PHSEN = TB_DISABLE;        // Disable phase loading
    EPwm2Regs.TBCTL.bit.HSPCLKDIV = TB_DIV4;       // Clock ratio to SYSCLKOUT

    //
    // Slow so we can observe on the scope
    //
    EPwm2Regs.TBCTL.bit.CLKDIV = TB_DIV4;

    //
    // Setup compare
    //
    EPwm2Regs.CMPA.half.CMPA = 3000;

    //
    // Set actions
    //
    EPwm2Regs.AQCTLA.bit.CAU = AQ_SET;              // Set PWM3A on CAU
    EPwm2Regs.AQCTLA.bit.CAD = AQ_CLEAR;            // Clear PWM3A on CAD

    EPwm2Regs.AQCTLB.bit.CAU = AQ_CLEAR;            // Clear PWM3B on CAU
    EPwm2Regs.AQCTLB.bit.CAD = AQ_SET;              // Set PWM3B on CAD

    //
    // Active high complementary PWMs - Setup the deadband
    //
    EPwm2Regs.DBCTL.bit.OUT_MODE = DB_FULL_ENABLE;
    EPwm2Regs.DBCTL.bit.POLSEL = DB_ACTV_HIC;
    EPwm2Regs.DBCTL.bit.IN_MODE = DBA_ALL;
    EPwm2Regs.DBRED = EPWM2_MIN_DB;
    EPwm2Regs.DBFED = EPWM2_MIN_DB;
    EPwm2_DB_Direction = DB_UP;

    //
    // Interrupt where we will change the deadband
    //
    EPwm2Regs.ETSEL.bit.INTSEL = ET_CTR_ZERO;     // Select INT on Zero event
    EPwm2Regs.ETSEL.bit.INTEN = 1;                // Enable INT
    EPwm2Regs.ETPS.bit.INTPRD = ET_3RD;           // Generate INT on 3rd event
}

//
// End of File
//

