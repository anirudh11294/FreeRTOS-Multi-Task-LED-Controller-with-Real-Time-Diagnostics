################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (14.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.c \
/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.c \
/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.c 

S_UPPER_SRCS += \
/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.S 

OBJS += \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.o \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.o \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.o \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.o 

S_UPPER_DEPS += \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.d 

C_DEPS += \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.d \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.d \
./common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.d 


# Each subdirectory must supply rules for building sources it contributes
common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.o: /home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.c common/ThirdParty/SEGGAR/SEGGER/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/portable/GCC/ARM_CM4F -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Config -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/OS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/Syscalls -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.o: /home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.S common/ThirdParty/SEGGAR/SEGGER/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Config -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"
common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.o: /home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.c common/ThirdParty/SEGGAR/SEGGER/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/portable/GCC/ARM_CM4F -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Config -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/OS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/Syscalls -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"
common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.o: /home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.c common/ThirdParty/SEGGAR/SEGGER/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/portable/GCC/ARM_CM4F -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Config -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/OS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/Syscalls -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-common-2f-ThirdParty-2f-SEGGAR-2f-SEGGER

clean-common-2f-ThirdParty-2f-SEGGAR-2f-SEGGER:
	-$(RM) ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.cyclo ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.d ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.o ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT.su ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.d ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_ASM_ARMv7M.o ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.cyclo ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.d ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.o ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_RTT_printf.su ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.cyclo ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.d ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.o ./common/ThirdParty/SEGGAR/SEGGER/SEGGER_SYSVIEW.su

.PHONY: clean-common-2f-ThirdParty-2f-SEGGAR-2f-SEGGER

