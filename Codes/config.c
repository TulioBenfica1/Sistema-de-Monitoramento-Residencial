#include <mega16.h>
#include "config.h"
#include "lcd.h"
#include "timer.h"
#include "keypad.h"
#include "password.h"

static SystemState current_state;
static bit lcd_update_pending = 1;
static bit keypad_entry = 0;

void SystemInit(void)
{
    // Configuração de registradores 
    LCDInit(); 
    KEYPAD_init();
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
    if(keypad_entry)
    {
        KEYPADProcess(current_state);
    }
}

void SystemSetState(SystemState state)
{
    current_state = state;
    lcd_update_pending = 1;
    if (state == ST_DISARMED || state == ST_SHOCK || 
        state == ST_MOTION || state == ST_SMOKE || 
        state == ST_OVERHEAT)
    {
        keypad_entry = 1;
        PasswordStart();
    }
    else
    {
        keypad_entry = 0;
    }
}

SystemState SystemGetState(void)
{
    return current_state;
}