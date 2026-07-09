#include <mega16.h>
#include <i2c.h>
#include "i2c_.h"

void I2CInit(void)
{
    #asm
        .equ __i2c_port=0x18 ; PORTB
        .equ __sda_bit=0
        .equ __scl_bit=1
    #endasm
    i2c_init();
}