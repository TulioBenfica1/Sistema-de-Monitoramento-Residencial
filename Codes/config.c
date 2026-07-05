#include <mega16.h>
#include "config.h"
#include "lcd.h"
#include "timer.h"

static SystemState current_state;
static bit lcd_update_pending = 1;

void SystemInit(void)
{
    // Configuração de registradores 
    LCDInit(); 
    TIMER1Init();
    #asm("sei");

}

void SystemUpdate(void)
{
    if (lcd_update_pending)
    {
        LCDUpdate(current_state);
        lcd_update_pending = 0;
    }
}

void SystemSetState(SystemState state)
{
    current_state = state;
    lcd_update_pending = 1;
}

SystemState SystemGetState(void)
{
    return current_state;
}