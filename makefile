# Nombre del proyecto
TARGET = firmware
BUILD_DIR = build

# Rutas de la Toolchain (ajustar si es necesario)
PREFIX = riscv32-wch-elf-
CC = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
SIZE = $(PREFIX)size

# Arquitectura para CH32V307 (Núcleo V4F)
ARCH_FLAGS = -march=rv32imafc -mabi=ilp32f

# Directorios de Inclusión
INC_FLAGS = -Iinc -Ivendor/Core -Ivendor/Debug -Ivendor/Peripheral/inc
LD_SCRIPT = vendor/Ld/Link.ld

# Flags de compilación
CFLAGS = $(ARCH_FLAGS) $(INC_FLAGS) -O2 -g -Wall
LDFLAGS = $(ARCH_FLAGS) -T $(LD_SCRIPT) -nostartfiles -Wl,--gc-sections

# Archivos fuente
SRCS = $(wildcard src/*.c) \
       $(wildcard vendor/Peripheral/src/*.c) \
       $(wildcard vendor/Core/*.c) \
	   $(wildcard vendor/Debug/*.c) \
       vendor/Startup/startup_ch32v30x_D8.s

# Generación de la lista de objetos en la carpeta build
# Esto transforma "src/main.c" en "build/src/main.o"
OBJS = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(basename $(SRCS))))

OPENOCD_BIN = /opt/wch/openocd/bin/openocd


# --- Reglas ---

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin

# Regla para el archivo ELF
$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@
	$(SIZE) $@

# Regla para el archivo BIN
$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Regla genérica para compilar archivos .c
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Regla genérica para compilar archivos .s (Startup)
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Programación con OpenOCD
download: all
	$(OPENOCD_BIN) -f /opt/wch/openocd/bin/wch-riscv.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

# Limpieza total de la carpeta build
clean:
	rm -rf $(BUILD_DIR)