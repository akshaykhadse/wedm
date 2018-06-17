#ifndef CLA_SHARED_H
#define CLA_SHARED_H

#ifdef __cplusplus
extern "C" {
#endif

#include "IQmathLib.h"
#include "DSP28x_Project.h"
#include "definitions.h"

#if I_SENS1
    extern Uint32  current1Sum;
    extern Uint16  current1Val[];
    extern float current1;
#endif

#if I_SENS2
    extern Uint32  current2Sum;
    extern Uint16  current2Val[];
    extern float current2;
#endif

#if I_SENS3
    extern Uint32  current3Sum;
    extern Uint16  current3Val[];
    extern float current3;
#endif

#if V_SENS1
  extern Uint32  voltage1Sum;
  extern Uint16  voltage1Val[];
  extern float voltage1;
#endif

#if V_SENS2
    extern Uint32  voltage2Sum;
    extern Uint16  voltage2Val[];
    extern float voltage2;
#endif

#if I_SENS1 || I_SENS2 || I_SENS3 || V_SENS1 || V_SENS2
    extern Uint16 SampleCount;
#endif

#if DIAGNOSTICS
    extern Uint16 adcCount;
    extern Uint16 claTask8Count;
#endif

// The following are symbols defined in the CLA assembly code
// Including them in the shared header file makes them 
// .global and the main CPU can make use of them. 
extern Uint32 Cla1Prog_Start;//*
__interrupt void Cla1Task7();
__interrupt void Cla1Task8();

#ifdef __cplusplus
}
#endif /* extern "C" */

#endif  // end of CLA_SHARED definition
