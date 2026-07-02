#include "flame_sensor.h"

// 1min pra inicializar
void FlameSensorInit(void) {
    DDRC.2 = 0;
}

bool FlameSensorUpdate(void) {
    return ~PINC.2; // Leitura baixa indica chama
}

