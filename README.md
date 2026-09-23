# EmberCore-AVR

**Surprise stack:** ATmega328P (Arduino Uno silicon) in *pure assembly*.
Hardware PWM breathe on `PD6` / OC0A and a 115200 bit-banged banner on `PD1`.

## Build
```bash
make            # needs avr-gcc + avr-objcopy
make flash      # avrdude, adjust port
```

No Arduino core, no libc. Watch `PD6` on a scope or LED.
