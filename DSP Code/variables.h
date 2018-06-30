#include "definitions.h"

// Global Variables

// The DATA_SECTION pragma statements are used to place the variables in
// specific assembly sections. These sections are linked to the message RAMs
// for the CLA in the linker command (.cmd) file.
#if I_SENS1
    #pragma DATA_SECTION(current1Val, "Cla1DataRam0");
    Uint16 current1Val[FILTER_LEN];
    #pragma DATA_SECTION(current1Sum, "Cla1ToCpuMsgRAM");
    Uint32 current1Sum;
    float current1;
#endif
#if I_SENS2
    #pragma DATA_SECTION(current2Val, "Cla1DataRam0");
    Uint16 current2Val[FILTER_LEN];
    #pragma DATA_SECTION(current2Sum, "Cla1ToCpuMsgRAM");
    Uint32 current2Sum;
    float current2;
#endif
#if I_SENS3
    #pragma DATA_SECTION(current3Val, "Cla1DataRam0");
    Uint16 current3Val[FILTER_LEN2];
    #pragma DATA_SECTION(current3Sum, "Cla1ToCpuMsgRAM");
    Uint32 current3Sum;
    float current3;
#endif
#if V_SENS1
    #pragma DATA_SECTION(voltage1Val, "Cla1DataRam0");
    Uint16 voltage1Val[FILTER_LEN];
    #pragma DATA_SECTION(voltage1Sum, "Cla1ToCpuMsgRAM");
    Uint32 voltage1Sum;
    float voltage1;
#endif
    #if V_SENS2
    #pragma DATA_SECTION(voltage2Val, "Cla1DataRam0");
    Uint16 voltage2Val[FILTER_LEN];
    #pragma DATA_SECTION(voltage2Sum, "Cla1ToCpuMsgRAM");
    Uint32 voltage2Sum;
    float voltage2;
#endif
#if I_SENS1 || I_SENS2 || I_SENS3 || V_SENS1 || V_SENS2
    #pragma DATA_SECTION(SampleCount, "Cla1ToCpuMsgRAM");
    Uint16 SampleCount = 0;
    #pragma DATA_SECTION(SampleCount2, "Cla1ToCpuMsgRAM");
    Uint16 SampleCount2 = 0;
#endif

#if PID1 || PID2
    Uint16 controllerCount = 0;
#endif
#if PID1
    float a1 = KP1 + KI1 * TS1 / 2.0 + 2.0 * KD1 / TS1;
    float b1 = -KP1 + KI1 * TS1 / 2.0 - 2.0 * KD1 / TS1;
    float c1 = KD1 / TS1;
    float u1[2] = {0.0f, 0.0f};
    float e1[3] = {0.0f, 0.0f, 0.0f};
#endif
#if PID2
    float a2 = KP2 + KI2 * TS2 / 2.0 + 2.0 * KD2 / TS2;
    float b2 = -KP2 + KI2 * TS2 / 2.0 - 2.0 * KD2 / TS2;
    float c2 = KD2 / TS2;
    float u2[2] = {0.0f, 0.0f};
    float e2[3] = {0.0f, 0.0f, 0.0f};
#endif
#if SMC1
    float u1[2] = {0.0f, 0.0f};
    float e1[3] = {0.0f, 0.0f, 0.0f};
    float integral1 = 0.0f;
#endif

#if DIAGNOSTICS
    #pragma DATA_SECTION(adcCount, "Cla1ToCpuMsgRAM");
    Uint16 adcCount;
    #pragma DATA_SECTION(claTask8Count, "Cla1DataRam1");
    Uint16 claTask8Count = 0;
    Uint16 mainCount = 0;
#endif

// These are defined by the linker file and used to copy the CLA code
// from its load address to its run address in CLA program memory in the
// CLA initalization function
extern Uint16 Cla1funcsLoadStart;
extern Uint16 Cla1funcsLoadEnd;
extern Uint16 Cla1funcsRunStart;
extern Uint16 Cla1funcsLoadSize;
