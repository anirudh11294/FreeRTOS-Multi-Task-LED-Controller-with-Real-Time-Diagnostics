################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (14.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Rec/segger_uart.c 

OBJS += \
./common/ThirdParty/SEGGAR/Rec/segger_uart.o 

C_DEPS += \
./common/ThirdParty/SEGGAR/Rec/segger_uart.d 


# Each subdirectory must supply rules for building sources it contributes
common/ThirdParty/SEGGAR/Rec/segger_uart.o: /home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Rec/segger_uart.c common/ThirdParty/SEGGAR/Rec/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F407xx -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/include -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS/portable/GCC/ARM_CM4F -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/FreeRTOS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/Config -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/OS -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER/Syscalls -I/home/anirudh/RTOS_workspace/Task/common/ThirdParty/SEGGAR/SEGGER -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-common-2f-ThirdParty-2f-SEGGAR-2f-Rec

clean-common-2f-ThirdParty-2f-SEGGAR-2f-Rec:
	-$(RM) ./common/ThirdParty/SEGGAR/Rec/segger_uart.cyclo ./common/ThirdParty/SEGGAR/Rec/segger_uart.d ./common/ThirdParty/SEGGAR/Rec/segger_uart.o ./common/ThirdParty/SEGGAR/Rec/segger_uart.su

.PHONY: clean-common-2f-ThirdParty-2f-SEGGAR-2f-Rec

