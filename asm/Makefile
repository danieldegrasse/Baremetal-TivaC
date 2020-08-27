GCC_INSTALL_DIR=/usr
GCC_BIN_DIR=$(GCC_INSTALL_DIR)/bin
CC=$(GCC_BIN_DIR)/arm-none-eabi-gcc
LD=$(GCC_BIN_DIR)/arm-none-eabi-ld
AS=$(GCC_BIN_DIR)/arm-none-eabi-as
OBJS= main.o vectors.o
PROG=blink-asm

$(PROG).bin: $(PROG).out
	$(GCC_BIN_DIR)/arm-none-eabi-objdump -D $^ > $(PROG).list
	$(GCC_BIN_DIR)/arm-none-eabi-objcopy -O binary $^ $@

$(PROG).out: $(OBJS)
	$(LD) $^ $(LFLAGS) -T linker_script.ld -Map $(PROG).map -o $@

%.o: %.s
	$(AS) -o $@ $^

clean:
	rm $(OBJS) $(PROG).out $(PROG).bin $(PROG).list $(PROG).map

.PHONY: clean
