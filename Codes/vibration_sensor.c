#include "vibration_sensor.h"

// 1min pra inicializar
void VibrationSensorInit(void) {
    DDRC.1 = 0;
}

bool VibrationSensorUpdate(void) {
    return PINC.1; // Leitura alta indica vibração
}
