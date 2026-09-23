MCU  = atmega328p
SRC  = src/embercore.S
ELF  = build/embercore.elf
HEX  = build/embercore.hex

all: $(HEX)

$(ELF): $(SRC)
	mkdir -p build
	avr-gcc -mmcu=$(MCU) -nostdlib -Os -o $(ELF) $(SRC)

$(HEX): $(ELF)
	avr-objcopy -O ihex $(ELF) $(HEX)

flash: $(HEX)
	avrdude -c arduino -p m328p -P /dev/ttyUSB0 -b 115200 -U flash:w:$(HEX):i

clean:
	rm -rf build
.PHONY: all flash clean
