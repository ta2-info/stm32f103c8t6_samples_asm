
## Memory info of STM32F103C8T6
#
# ** Flash **
#  64kB
#  0x08000000 - 0x0800ffff
#
# ** SRAM **
#  20kB
#  0x20000000 - 0x20004fff

# base address of flash
BASE_FLASH := 0x08000000

ASM := arm-none-eabi-as
LD := arm-none-eabi-ld
OBJCOPY := arm-none-eabi-objcopy
ST-FLASH := st-flash
OPENOCD := openocd

ASMOPT = -g -mcpu=cortex-m3 -mthumb
LDOPT = -Ttext $(BASE_FLASH)

all: blink.bin

blink.bin: blink.elf
	$(OBJCOPY) -O binary $< $@

blink.elf: blink.o
	$(LD) $(LDOPT) -o $@ blink.o

blink.o: blink.s
	$(ASM) $(ASMOPT) -o $@ $<

install:
#	$(ST-FLASH) write blink.bin $(BASE_FLASH)
	$(OPENOCD) -f interface/stlink.cfg -f target/stm32f1x.cfg  -c "program ./blink.bin $(BASE_FLASH) verify reset exit"

clean:
	$(RM) blink.bin
	$(RM) blink.elf
	$(RM) blink.o

