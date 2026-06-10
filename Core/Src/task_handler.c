/*
 * task_handler.c
 *
 *  Created on: 11-May-2026
 *      Author: anirudh
 */

#include "main.h"
static void process_command(command_t *cmd);
static void extract_command(command_t *cmd);
static void print_list_of_commands();
static void string_tokenize(char *input, char **argv, int *argc);
static void set_led_period(char *led_task, char *led_period);
static void set_led_mode(char *led_mode);
static void cmd_tasks(void);
static void cmd_stats(void);
static SemaphoreHandle_t use_sem_or_mutex(void);
static volatile uint8_t lock_held;
void emergency_task_handler(void *parameters) {

	TickType_t xLastWakeTime;

	xLastWakeTime = xTaskGetTickCount();

	while (1) {
		if (curr_state == MODE_EMERG) {

			HAL_GPIO_TogglePin(LD3_GPIO_Port, EMERGENCY_LED);

			// Initialise the xLastWakeTime variable with the current time.
		}

		if (inversion_active) {
			if (use_mutex != -1) {
				while (!lock_held)
					vTaskDelay(pdMS_TO_TICKS(10));

				uint32_t t_start = __HAL_TIM_GET_COUNTER(&htim2);
				active_lock = use_sem_or_mutex();
				if (xSemaphoreTake(active_lock,
						(TickType_t) portMAX_DELAY) == pdTRUE) {
					uint32_t t_end = __HAL_TIM_GET_COUNTER(&htim2);
					uint32_t wait_us = (t_end - t_start) * 10;
					xSemaphoreGive(active_lock);
					printf("Emergency wait time: %lu us\r\n", wait_us);
					lock_held = 0;
				}

			}
		}
		vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(xTimeInMs.emerg_task));

	}
}

void task1_handler(void *parameters) {
	TickType_t xLastWakeTime;

	xLastWakeTime = xTaskGetTickCount();
	while (1) {
		if (curr_state == MODE_TASK1) {

			HAL_GPIO_TogglePin(LD3_GPIO_Port, TASK1_LED);

		}

		if (inversion_active) {
			for (volatile uint32_t i = 0; i < 200000; i++)
				;
			vTaskDelay(pdMS_TO_TICKS(1));  // yield briefly, then preempt again
			continue;                       // skip the vTaskDelayUntil below
		}
		vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(xTimeInMs.task1));

	}
}

void task2_handler(void *parameters) {
	TickType_t xLastWakeTime;

	xLastWakeTime = xTaskGetTickCount();
	while (1) {

		if (curr_state == MODE_TASK2) {
			HAL_GPIO_TogglePin(LD3_GPIO_Port, TASK2_LED);

			// Initialise the xLastWakeTime variable with the current time.
		}

		vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(xTimeInMs.task2));

	}
}

void task3_handler(void *parameters) {
	TickType_t xLastWakeTime;
	xLastWakeTime = xTaskGetTickCount();
	while (1) {
		if (curr_state == MODE_TASK3) {

			HAL_GPIO_TogglePin(LD3_GPIO_Port, TASK3_LED);

			// Initialise the xLastWakeTime variable with the current time.
		}

		if (inversion_active) {
			if (use_mutex != -1) {

				active_lock = use_sem_or_mutex();
				if (xSemaphoreTake(active_lock,
						(TickType_t) portMAX_DELAY) == pdTRUE) {

					lock_held = 1;
					for (volatile uint32_t i = 0; i < 500000; i++)
						;
					shared_counter++;
					inversion_active = 0;

					xSemaphoreGive(active_lock);
				}
			}
		}
		vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(xTimeInMs.task3));

	}
}

void cmd_task_handler(void *parameters) {
	BaseType_t ret;
	command_t cmd;
	while (1) {
		ret = xTaskNotifyWait(0, 0, NULL, portMAX_DELAY);
		if (ret == pdTRUE) {
			process_command(&cmd);
		}
	};
}

static void process_command(command_t *cmd) {
	static char *argv[4];
	static int argc;
	extract_command(cmd);

	string_tokenize(cmd->data, argv, &argc);     // always, once, up front

	if (argc == 0)
		return;          // empty line

	if (!strcmp(argv[0], "help"))          //→ cmd_help()
			{
		print_list_of_commands();
	} else if (!strcmp(argv[0], "set_mode")) {
		if (argc >= 2)          //→ check argc >= 2, set mode from argv[1]
				{
			set_led_mode(argv[1]);
		}
	} else if (!strcmp(argv[0], "set_period")) {
		if (argc >= 3)          //→ check argc >= 3, set period
			set_led_period(argv[1], argv[2]);
	} else if (!strcmp(argv[0], "tasks")) {
		cmd_tasks();
	} else if (!strcmp(argv[0], "stats")) {
		cmd_stats();
	} else if ((!strcmp(argv[0], "inject"))
			&& (!strcmp(argv[1], "inversion"))) {
		inversion_active = 1;
	} else if ((!strcmp(argv[0], "eject")) && (!strcmp(argv[1], "inversion"))) {
		inversion_active = 0;
	} else if ((!strcmp(argv[0], "lock_mode"))) {
		if (!strcmp(argv[1], "sem")) {

			use_mutex = 0;
		} else if (!strcmp(argv[1], "mutex")) {

			use_mutex = 1;
		}
	} else
		printf("ERR: unknown command\r\n");

	printf(">");
}

static void set_led_mode(char *led_mode) {
	if (!strcmp(led_mode, "emerg")) {
		curr_state = MODE_EMERG;
	} else if (!strcmp(led_mode, "task1")) {
		curr_state = MODE_TASK1;
	} else if (!strcmp(led_mode, "task2")) {
		curr_state = MODE_TASK2;
	} else if (!strcmp(led_mode, "task3")) {
		curr_state = MODE_TASK3;
	}
}

static void extract_command(command_t *cmd) {
	uint8_t cRxedChar;
	uint8_t indx = 0;
	cmd->length = 0;
	memset(cmd->data, 0, sizeof(cmd->data));
	printf("entering process command\n");
	while (xQueueReceive(q_data, (void*) &cRxedChar, 10) == pdPASS) {
		/* A character was received. Output the character now. */
		cmd->data[indx++] = cRxedChar;
		cmd->length++;

		/* If removing the character from the queue woke the task that was
		 posting onto the queue xTaskWokenByReceive will have been set to
		 pdTRUE. No matter how many times this loop iterates only one
		 task will be woken. */
	}
	indx--;
	cmd->length = indx;
	cmd->data[indx] = '\0';

}

static void print_list_of_commands() {
	printf("help                    → prints list of commands\r\n"
			"stats                   → prints per-task info (stub for now)\r\n"
			"tasks                   → prints task states\r\n"
			"set_mode <mode>         → what you already have\r\n"
			"set_period <task> <ms>  → change a task's period at runtime\r\n");
}

static void string_tokenize(char *input, char **argv, int *argc) {
	char *p = input;
	//char *argv_ptr = argv;
	int local_argc = 0;

	//char *argv_ptr = argv;
	while (*p != '\0') //set_period TASK1 300
	{

		while (*p == ' ')
			p++;
		if (*p == '\0')
			break;

		argv[local_argc++] = p;

		while (*p && *p != ' ')
			p++;

		if (*p == ' ') {
			*p = '\0';
			p++;
		}
	}

	*argc = local_argc;

}

static void set_led_period(char *led_task, char *led_period) {
	int period = 0;
	if (!strcmp(led_task, "task1")) {
		period = atoi(led_period);
		if (period > 0 && period <= 5000)
			xTimeInMs.task1 = period;
	} else if (!strcmp(led_task, "task2")) {
		period = atoi(led_period);
		if (period > 0 && period <= 5000)
			xTimeInMs.task2 = period;
	} else if (!strcmp(led_task, "task3")) {
		period = atoi(led_period);
		if (period > 0 && period <= 5000)
			xTimeInMs.task3 = period;
	} else if (!strcmp(led_task, "emerg")) {
		period = atoi(led_period);
		if (period > 0 && period <= 5000)
			xTimeInMs.emerg_task = period;
	}
}

static void cmd_tasks(void) {
	char buf[300] = { 0 };
	vTaskList(buf);
	printf("%s\r\n", buf);
}

static void cmd_stats(void) {
	char buf[400] = { 0 };
	vTaskGetRunTimeStats(buf);
	printf("%s\r\n", buf);
}

static SemaphoreHandle_t use_sem_or_mutex(void) {
	if (use_mutex)
		return mutex;
	else
		return binary_sem;
}

