#include <mega16.h>
#include <stdio.h>
#include "sensors.h"

bit flag_motion = 0;
static unsigned char flame; 
static unsigned char shock;  


void SENSORSInit(void) {
    DDRB |= 0xC0; // Configura PORTB como entrada
    GICR |= 0b01000000;
    MCUCR |= 0b00001100;   
}


interrupt [EXT_INT1] void int_ext1_motion (void)
{
    flag_motion = 1;
}

void SensorsUpdate(void) {
    flame = PINB.5; 
    shock = PINB.7;  

    if (flame==0 && flag_motion && shock){
        SystemSetState(ST_FLAME);
    }
    else if (flame==0) {
        SystemSetState(ST_FLAME);
    }
    else if (flag_motion && shock){
        SystemSetState(ST_INVASION);
    }
    else if (shock) {
        SystemSetState(ST_SHOCK);
    }
    else if (flag_motion) {
        SystemSetState(ST_MOTION);
    }
    flag_motion = 0;
    return;
}

