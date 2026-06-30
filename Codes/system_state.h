#ifndef SYSTEM_STATE_H
#define SYSTEM_STATE_H

// Define uma maquina de estados para monitoramento do sistema
typedef enum {
    ST_BOOT,
    ST_ARMED,
    ST_ARMING_DELAY,
    ST_DISARMED,
    ST_SHOCK,
    ST_MOTION,
    ST_SMOKE,
    ST_OVERHEAT,
    ST_ERROR,
} SystemState;

#endif