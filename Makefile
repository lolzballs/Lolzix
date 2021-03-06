# The toolchain to use (avaliable at https://github.com/raspberrypi/tools)
ARMGNU ?= arm-linux-gnueabihf

# The intermediate directory for compiled object files.

BUILD = build/

# The directory in which source files are stored.

SOURCE = src/

# Final output directory.

OUT = out/

# The name of the output file to generate.

TARGET = $(OUT)kernel.img

# The name of the assembler listing file to generate.

LIST = $(OUT)kernel.list

# The name of the map file to generate.

MAP = $(OUT)kernel.map

# The name of the linker script to use.

LINKER = kernel.ld

# The names of all object files that must be generated. Deduced from the 
# assembly code files in source.

OBJECTS := $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s))


# Rule to make everything.

all: $(TARGET) $(LIST)



# Rule to remake everything. Does not include clean.

rebuild: all



# Rule to make the listing file.

$(LIST) : $(BUILD)output.elf

	$(ARMGNU)-objdump -d $(BUILD)output.elf > $(LIST)



# Rule to make the image file.

$(TARGET) : $(BUILD)output.elf

	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary $(TARGET) 



# Rule to make the elf file.

$(BUILD)output.elf : $(OBJECTS) $(LINKER)

	$(ARMGNU)-ld --no-undefined $(OBJECTS) -Map $(MAP) -o $(BUILD)output.elf -T $(LINKER)



# Rule to make the object files.

$(BUILD)%.o: $(SOURCE)%.s $(BUILD)

	$(ARMGNU)-as -I $(SOURCE) $< -o $@



$(BUILD):
	mkdir $(OUT)
	mkdir $@



# Rule to clean files.

clean : 

	-rm -rf $(BUILD)

	-rm -f $(TARGET)

	-rm -f $(LIST)

	-rm -f $(MAP)
