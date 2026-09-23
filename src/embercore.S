; EmberCore-AVR — ATmega328P @ 16 MHz
; Fast-PWM on OC0A (PD6) + bit-banged UART 115200 on PD1
; avr-gcc -mmcu=atmega328p -nostdlib -o embercore.elf src/embercore.S

#include <avr/io.h>

.global main

main:
    ldi  r16, (1 << DDD6) | (1 << DDD1)
    out  _SFR_IO_ADDR(DDRD), r16

    ; Timer0 Fast PWM, non-inverting, clk/64
    ldi  r16, (1 << COM0A1) | (1 << WGM01) | (1 << WGM00)
    out  _SFR_IO_ADDR(TCCR0A), r16
    ldi  r16, (1 << CS01) | (1 << CS00)
    out  _SFR_IO_ADDR(TCCR0B), r16

    ldi  r17, 1          ; duty
    ldi  r18, 1          ; direction +1 / -1

loop:
    out  _SFR_IO_ADDR(OCR0A), r17
    rcall uart_banner
    rcall delay
    add  r17, r18
    cpi  r17, 240
    brne check_floor
    ldi  r18, 0xFF       ; -1
check_floor:
    cpi  r17, 2
    brne loop
    ldi  r18, 1
    rjmp loop

uart_banner:
    ldi  r19, 'E'
    rcall tx
    ldi  r19, 'm'
    rcall tx
    ldi  r19, 'b'
    rcall tx
    ldi  r19, 'e'
    rcall tx
    ldi  r19, 'r'
    rcall tx
    ldi  r19, '\r'
    rcall tx
    ldi  r19, '\n'
    rcall tx
    ret

; ~115200 bit-bang @ 16 MHz  (~139 cycles/bit)
tx:
    cbi  _SFR_IO_ADDR(PORTD), 1   ; start
    rcall bit_delay
    ldi  r20, 8
tx_bits:
    sbrc r19, 0
    sbi  _SFR_IO_ADDR(PORTD), 1
    sbrs r19, 0
    cbi  _SFR_IO_ADDR(PORTD), 1
    lsr  r19
    rcall bit_delay
    dec  r20
    brne tx_bits
    sbi  _SFR_IO_ADDR(PORTD), 1   ; stop
    rcall bit_delay
    ret

bit_delay:
    ldi  r21, 40
bd:
    dec  r21
    brne bd
    ret

delay:
    ldi  r22, 40
d1:
    ldi  r23, 0
d2:
    dec  r23
    brne d2
    dec  r22
    brne d1
    ret
