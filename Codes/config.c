#include "config.h"
#include "lcd.h"

static SystemState current_state;

void SystemInit(void)
{
    // Configuração de registradores 
    LCDInit(); 

}

void SystemUpdate(void)
{
    LCDUpdate(current_state);
}

void SystemSetState(SystemState state)
{
    current_state = state;
}

SystemState SystemGetState(void)
{
    return current_state;
}