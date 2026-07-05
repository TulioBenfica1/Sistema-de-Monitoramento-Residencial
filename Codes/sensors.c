#include <sensors.h>

void SensorsInit(void) {
    DDRB = 0x00; // Configura PORTB como entrada
}

SystemState SensorsUpdate(void) {
    unsigned char flame = ~(PINB & (1 << PB0)); 
    unsigned char presence = (PINB & (1 << PB1)); 
    unsigned char vibration = (PINB & (1 << PB2));

    if (flame) {
        return SystemSetState(ST_FLAME);
    }
    else if (presence && vibration) {
        return SystemSetState(ST_INVASION);
    }
    else if (presence) {
        return SystemSetState(ST_MOTION);
    }
    else if (vibration) {
        return SystemSetState(ST_SHOCK);
    }
    return;
}
