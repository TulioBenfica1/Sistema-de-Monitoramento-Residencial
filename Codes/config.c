#include "config.h"

static SystemState current_state;

void SystemInit(void)
{
    // Configuração de registradores 
}

void SystemUpdate(void)
{

}

void SystemSetState(SystemState state)
{
    current_state = state;
}

SystemState SystemGetState(void)
{
    return current_state;
}

