#include "sensors.h"

void SensorsInit(void) {
    DDRB = 0x00; // Configura PORTB como entrada
}

SensorsState SensorsUpdate(void) {
    unsigned char chama_ativa = ~(PINB & (1 << PB0)); 
    unsigned char presenca_ativa = (PINB & (1 << PB1)); 
    unsigned char choque_ativo = (PINB & (1 << PB2));

    if (chama_ativa) {
        return SS_FLAME;
    }
    else if (presenca_ativa && choque_ativo) {
        return SS_INVASION; 
    }
    else if (presenca_ativa) {
        return SS_MOTION;
    }
    else if (choque_ativo) {
        return SS_SHOCK;
    }
    else {
        return SS_NONE;
    }
    return -1; 
}
