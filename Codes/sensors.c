#include <sensors.h>

void SensorsInit(void) {
    DDRB = 0x00; // Configura PORTB como entrada
}

void SensorsUpdate(void) {
    unsigned char flame = ~(PINB & (1 << PB0)); 
    unsigned char presence = (PINB & (1 << PB1)); 
    unsigned char vibration = (PINB & (1 << PB2));

    if (flame) {
        SystemSetState(ST_FLAME);
    }
    else if (presence && vibration) {
        SystemSetState(ST_INVASION);
    }
    else if (presence) {
        SystemSetState(ST_MOTION);
    }
    else if (vibration) {
        SystemSetState(ST_SHOCK);
    }
    return;
}
