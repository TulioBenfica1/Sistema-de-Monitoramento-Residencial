#ifndef SENSORS_STATE_H
#define SENSORS_STATE_H

// Define uma maquina de estados para classificação dos sensores
typedef enum {
    SS_FLAME,
    SS_MOTION,
    SS_SHOCK,
    SS_INVASION,
    SS_NONE   
} SensorsState;

#endif