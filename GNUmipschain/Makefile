ifndef CROSS_COMPILE
	CROSS_COMPILE = mips-linux-gnu-
endif
CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECT = inst_rom.o

all: inst_rom.data

%.o: %.s
	$(CC) -mips32 $< -o $@

inst_rom.om: ram.ld $(OBJECT)
	$(LD) -T ram.ld $(OBJECT) -o $@

inst_rom.bin: inst_rom.om
	$(OBJCOPY) -S -O binary -j .text $< $@

inst_rom.data: inst_rom.bin
	./bin2mem -o $@ $<

.PHONY: clean debug
clean:
	rm -f *.o *.om *.bin *.data *.asm

debug:
	$(OBJDUMP) -D inst_rom.om > inst_rom.asm

