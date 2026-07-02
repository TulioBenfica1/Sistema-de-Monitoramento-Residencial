#include "vibration_sensor.h"

unsigned char vibration_detected = 0;

// 1min pra inicializar
void VibrationSensorInit(void) {
    DDRC.1 = 0;
}

void VibrationSensorUpdate(void) {
    vibration_detected = PINC.1; // Leitura alta indica vibração
}
