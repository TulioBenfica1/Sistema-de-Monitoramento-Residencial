#include "presence_sensor.h"

unsigned char presence_detected = 0;

void PresenceSensorInit(void) {
    DDRC.0 = 0;
}

void PresenceSensorUpdate(void) {
    presence_detected = PINC.0; // Leitura alta indica presença
}

































































