# FreeRTOS Multi-Task LED Controller with Real-Time Diagnostics

A real-time firmware project built on STM32F407 (Cortex-M4) with FreeRTOS, demonstrating preemptive scheduling, priority inversion analysis, runtime diagnostics, and an interactive UART shell. Designed to showcase core RTOS concepts relevant to embedded systems engineering.

## Hardware

- **Board:** STM32F407 Discovery (Cortex-M4F, 168 MHz)
- **LEDs:** PG14 (Emergency), PG10 (Task1), PG11 (Task2), PG12 (Task3)
- **UART:** USART2 via ST-Link VCP at 115200 baud

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    FreeRTOS Scheduler                     │
├──────────┬──────────┬──────────┬──────────┬──────────────┤
│Emergency │  Task1   │  Task2   │  Task3   │  Shell Task  │
│ Prio: 4  │ Prio: 3  │ Prio: 2  │ Prio: 1  │  Prio: 3    │
│ 250 ms   │ 500 ms   │ 1000 ms  │ 1500 ms  │  Event-driven│
├──────────┴──────────┴──────────┴──────────┴──────────────┤
│              UART RX (Interrupt-driven)                   │
│         ISR → Queue (1 byte) → Shell Task                 │
├──────────────────────────────────────────────────────────┤
│     GPIO HAL    │    UART HAL    │    TIM2 (Runtime Stats)│
└──────────────────────────────────────────────────────────┘
```

### Task Overview

| Task | LED | Default Period | Priority | Role |
|------|-----|---------------|----------|------|
| Emergency | PG14 | 250 ms | 4 (highest) | High-priority periodic task |
| Task1 | PG10 | 500 ms | 3 | Medium-priority periodic task |
| Task2 | PG11 | 1000 ms | 2 | Medium-priority periodic task |
| Task3 | PG12 | 1500 ms | 1 | Low-priority periodic task |
| Shell | — | Event-driven | 3 | UART command processing |

All periodic tasks use `vTaskDelayUntil()` for accurate, drift-free timing.

## Features

### Mode Control

Only one task's LED is active at a time, selected via UART command. Tasks continue their periodic scheduling even when inactive (no suspend/resume complexity), but skip the GPIO toggle unless their mode is selected.

### Interactive UART Shell

A line-buffered command shell over UART with interrupt-driven RX. Characters accumulate in a FreeRTOS queue; a dedicated shell task processes complete lines.

```
=== RTOS LED Controller v1.0 ===
> help
  help                   - Show this message
  stats                  - Show runtime statistics
  tasks                  - Show task list and states
  set_mode <mode>        - Set active mode (emerg/task1/task2/task3)
  set_period <task> <ms> - Change task period at runtime
  inject inversion       - Trigger priority inversion demo
  lock_mode <sem|mutex>  - Switch between semaphore and mutex
> set_mode task1
> set_period task1 200
> tasks
> stats
```

### Runtime Diagnostics

Per-task CPU utilization and scheduling statistics via `vTaskGetRunTimeStats()`, backed by a free-running TIM2 hardware timer at 100 kHz. The `stats` command displays cumulative CPU time and percentage for every task, providing visibility into scheduler behavior — analogous to running `top` on a Linux system.

### Priority Inversion Demonstration

The centerpiece of this project. A deliberately constructed scenario that demonstrates priority inversion and its resolution through priority inheritance.

**The setup:**
- Task3 (low priority) acquires a shared lock and performs extended work
- Task1 (medium priority) continuously busy-loops, preempting Task3
- Emergency (high priority) attempts to acquire the same lock and is blocked

**Measured results on STM32F407:**

| Lock Type | Emergency Wait Time | Behavior |
|-----------|-------------------|----------|
| Binary Semaphore | **1,381,770 µs (1.38 s)** | Task1 continuously preempts Task3; Emergency starved |
| Mutex (priority inheritance) | **61,550 µs (62 ms)** | Task3 promoted to Emergency's priority; Task1 cannot preempt |

**Improvement: 22x reduction in worst-case latency.**

With the binary semaphore, the highest-priority task in the system was blocked for over a second by medium-priority tasks that weren't even contending for the shared resource. Switching to a FreeRTOS mutex enabled priority inheritance, which temporarily promoted the lock holder to the blocked task's priority, preventing the medium-priority tasks from preempting it.

This is the same class of bug that caused the Mars Pathfinder rover reset in 1997, resolved by enabling priority inheritance in the VxWorks mutex.

## Linux Kernel Parallels

This project intentionally mirrors concepts from the Linux kernel to demonstrate understanding at both the RTOS and OS levels:

| RTOS Concept | Linux Kernel Equivalent |
|-------------|------------------------|
| FreeRTOS mutex with priority inheritance | `rt_mutex` with `PI_FLAG` in the RT scheduler |
| `vTaskGetRunTimeStats` / per-task CPU% | `/proc/<pid>/stat`, `top`, CFS accounting |
| UART RX ISR → task notification → shell task | Top-half (hardirq) → bottom-half (tasklet/workqueue) |
| `vTaskDelayUntil` for periodic execution | `hrtimer` or `SCHED_DEADLINE` periodic tasks |
| FreeRTOS task states (Running/Blocked/Ready) | Linux process states (R/S/D/Z) in `/proc/<pid>/status` |

## Build and Flash

### Prerequisites

- STM32CubeIDE (or arm-none-eabi-gcc toolchain)
- STM32F407 Discovery board
- USB cable (ST-Link)
- Serial terminal (PuTTY, minicom, or screen) at 115200 8-N-1

### Steps

```bash
# Clone the repository
git clone https://github.com/<your-username>/freertos-led-controller.git

# Open in STM32CubeIDE
# File → Import → Existing Projects into Workspace

# Build
# Project → Build All (or Ctrl+B)

# Flash
# Run → Debug (or click the debug icon)
# The ST-Link will program the board automatically

# Connect serial terminal
# Linux: screen /dev/ttyACM0 115200
# macOS: screen /dev/cu.usbmodem* 115200
# Windows: PuTTY → Serial → COMx → 115200
```

### FreeRTOSConfig.h Key Settings

```c
#define configUSE_PREEMPTION                   1
#define configUSE_MUTEXES                      1
#define configUSE_TRACE_FACILITY               1
#define configUSE_STATS_FORMATTING_FUNCTIONS   1
#define configGENERATE_RUN_TIME_STATS          1
#define configCHECK_FOR_STACK_OVERFLOW         2
```

## Demo Script

To demonstrate all features in a live session:

```
# 1. Boot — observe default LED blinking
# 2. Switch modes
> set_mode task1
> set_mode emerg

# 3. Change timing
> set_period emerg 100
> set_period emerg 250

# 4. Inspect system state
> tasks
> stats

# 5. Priority inversion — the main event
> lock_mode sem
> inject inversion
    → Observe: Emergency wait time ~1,380,000 µs

> lock_mode mutex
> inject inversion
    → Observe: Emergency wait time ~62,000 µs

# 6. Explain the 22x improvement
```

## Project Structure

```
├── Core/
│   ├── Inc/
│   │   ├── main.h              # Pin definitions, global declarations
│   │   └── FreeRTOSConfig.h    # RTOS configuration
│   └── Src/
│       ├── main.c              # Hardware init, task creation, scheduler start
│       └── task_handler.c      # All task implementations and shell logic
├── Drivers/                    # STM32 HAL drivers (generated)
├── common/
│   └── ThirdParty/
│       └── FreeRTOS/           # FreeRTOS kernel source
└── README.md
```

## Key Design Decisions

**Why `vTaskDelayUntil` instead of `vTaskDelay`:** `vTaskDelay` introduces cumulative drift because it measures from when the delay is called, not from the last wake time. `vTaskDelayUntil` guarantees fixed-frequency execution regardless of how long the task body takes.

**Why binary semaphore vs mutex for the inversion demo:** A binary semaphore has no concept of ownership — any task can give it. A mutex tracks which task holds it, enabling priority inheritance. Demonstrating both in the same system with a runtime switch makes the difference concrete and measurable.

**Why interrupt-driven UART RX with queue:** Polling would waste CPU cycles. DMA would be optimal but adds complexity. Single-byte interrupt → queue → shell task is the right balance for a command shell: responsive, simple, and demonstrates the ISR-to-task handoff pattern.

## Author

Anirudh — Embedded systems engineer with experience in Linux kernel internals, Yocto, and RTOS firmware development.
