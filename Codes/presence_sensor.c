#include "presence_sensor.h"

// 1min pra inicializar
void PresenceSensorInit(void) {
    DDRC.0 = 0;
}

bool PresenceSensorUpdate(void) {
    return PINC.0; // Leitura alta indica presença
}

