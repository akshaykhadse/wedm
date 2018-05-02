################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS

GEN_OPTS__FLAG := 
GEN_CMDS__FLAG := 

ORDERED_OBJS += \
-lrts2800_fpu32_fast_supplement.lib \
-lrts2800_fpu32.lib \
"./CLA.obj" \
"./F2806x_Adc.obj" \
"./F2806x_CodeStartBranch.obj" \
"./F2806x_CpuTimers.obj" \
"./F2806x_DefaultIsr.obj" \
"./F2806x_GlobalVariableDefs.obj" \
"./F2806x_PieCtrl.obj" \
"./F2806x_PieVect.obj" \
"./F2806x_SysCtrl.obj" \
"./F2806x_usDelay.obj" \
"./main.obj" \
"../28069_RAM_CLA_lnk.cmd" \
"C:/ti/c2000/C2000Ware_1_00_04_00/device_support/f2806x/headers/cmd/F2806x_Headers_nonBIOS.cmd" \
$(GEN_CMDS__FLAG) \
-lIQmath_fpu32.lib \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(INO_DEPS)),)
-include $(INO_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(SV7A_DEPS)),)
-include $(SV7A_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(PDE_DEPS)),)
-include $(PDE_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXE_OUTPUTS += \
wedmDSP.out \

EXE_OUTPUTS__QUOTED += \
"wedmDSP.out" \

BIN_OUTPUTS += \
wedmDSP.hex \

BIN_OUTPUTS__QUOTED += \
"wedmDSP.hex" \


# All Target
all: wedmDSP.out

# Tool invocations
wedmDSP.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: "$@"'
	@echo 'Invoking: C2000 Linker'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/cl2000" -v28 -ml -mt --cla_support=cla0 --float_support=fpu32 --vcu_support=vcu0 -g --define="_DEBUG" --define="LARGE_MODEL" --quiet --verbose_diagnostics --diag_warning=225 --diag_suppress=10063 --issue_remarks -z -m"wedmDSP.map" --stack_size=0x200 --warn_sections -i"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/lib" -i"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/include" -i"C:/ti/c2000/C2000Ware_1_00_04_00/device_support/f2806x/common/lib" -i"C:/ti/c2000/C2000Ware_1_00_04_00/libraries/math/IQmath/c28/lib" -i"C:/ti/c2000/C2000Ware_1_00_04_00/libraries/math/FPUfastRTS/c28/lib" --reread_libs --priority --verbose_diagnostics --issue_remarks --xml_link_info="Example_2806xLEDBlink_linkInfo.xml" --entry_point=code_start --rom_model -o "wedmDSP.out" $(ORDERED_OBJS)
	@echo 'Finished building target: "$@"'
	@echo ' '

wedmDSP.hex: $(EXE_OUTPUTS)
	@echo 'Building files: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo 'Invoking: C2000 Hex Utility'
	"C:/ti/ccsv8/tools/compiler/ti-cgt-c2000_18.1.1.LTS/bin/hex2000"  -o "wedmDSP.hex" $(EXE_OUTPUTS__QUOTED)
	@echo 'Finished building: $(strip $(EXE_OUTPUTS__QUOTED))'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(BIN_OUTPUTS__QUOTED)$(EXE_OUTPUTS__QUOTED)
	-$(RM) "CLA.obj" "F2806x_Adc.obj" "F2806x_CodeStartBranch.obj" "F2806x_CpuTimers.obj" "F2806x_DefaultIsr.obj" "F2806x_GlobalVariableDefs.obj" "F2806x_PieCtrl.obj" "F2806x_PieVect.obj" "F2806x_SysCtrl.obj" "F2806x_usDelay.obj" "main.obj" 
	-$(RM) "F2806x_Adc.d" "F2806x_CpuTimers.d" "F2806x_DefaultIsr.d" "F2806x_GlobalVariableDefs.d" "F2806x_PieCtrl.d" "F2806x_PieVect.d" "F2806x_SysCtrl.d" "main.d" 
	-$(RM) "CLA.d" "F2806x_CodeStartBranch.d" "F2806x_usDelay.d" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets

