# Nombre del proyecto
TARGET = firmware

# Rutas de la Toolchain (ajustar si es necesario)
PREFIX = riscv32-wch-elf-
CC = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
SIZE = $(PREFIX)size

# Arquitectura para CH32V307 (Núcleo V4F)
# march: r=riscv, 32=bits, i=base, m=multiplicación, a=atómicos, f=flotante, c=comprimido
ARCH_FLAGS = -march=rv32imafc -mabi=ilp32f

# Directorios
INC_FLAGS = -Iinclude -Ivendor/Core -Ivendor/Peripheral/inc
LD_SCRIPT = CH32V30x_flash.ld

# Flags de compilación
CFLAGS = $(ARCH_FLAGS) $(INC_FLAGS) -O2 -g -Wall
LDFLAGS = $(ARCH_FLAGS) -T $(LD_SCRIPT) -nostartfiles -Wl,--gc-sections

# Archivos fuente (Busca todos los .c en src y vendor)
SRCS = $(wildcard src/*.c) $(wildcard vendor/Peripheral/src/*.c) $(wildcard vendor/Core/*.c)
SRCS += vendor/Startup/startup_ch32v30x.s

OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.s=.o)

# --- Reglas ---

all: $(TARGET).elf

$(TARGET).elf: $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@
	$(OBJCOPY) -O binary $@ $(TARGET).bin
	$(SIZE) $@

# Programación con OpenOCD
download: all
	openocd -f /opt/wch/openocd/bin/wch-riscv.cfg -c "program $(TARGET).elf verify reset exit"

clean:
	rm -f *.elf *.bin *.o src/*.o vendor/**/*.o