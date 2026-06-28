#ifndef SYSTEM_STATE_H
#define SYSTEM_STATE_H

// Define uma maquina de estados para monitoramento do sistema
typedef enum {
    ST_BOOT,
    ST_ARMED,
    ST_DISARMED,
    ST_ERROR,
} SystemState;

#endif