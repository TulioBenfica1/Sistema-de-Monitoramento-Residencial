#include "pwm.h"
#include "buzzer.h"
#include "timer.h"

void PoliceSiren(void)
{
    static unsigned int f; 
    static bit drive = 1;  // Variavel para controlar a direcao da frequencia: 1 - subindo, 0 - descendo

    UpdateTIMER1CompareValue(20);

    if(GetTIMER1Flag()) 
    {
        SetTIMER1Flag(0); 

        if (drive == 1) 
        {
            f += 10;
            if (f >= 1400) {
                drive = 0;
            } 
        } 
        else 
        {
            f -= 10;
            if (f <= 600) {
                drive = 1;
            }
        }

        SetPWMFrequency(f);
    }
}

void FireAlarm(void)
{
    static unsigned int f[2] = {650, 550};    
    static bit drive = 0;  

    UpdateTIMER1CompareValue(20);

    if(GetTIMER1Flag()) 
    {
        SetTIMER1Flag(0); 

        if (drive == 0) 
        {
            f[drive] += 1;
            if (f[drive] >= 750) {
                drive = 1;
                f[0] = 650; 
            } 
        } 
        else                    
        {
            f[drive] -= 1;
            if (f[drive] <= 450) {
                drive = 0;
                f[1] = 550;
            }
        }

        SetPWMFrequency(f[drive]);
    }           
}

void StopSound(void)
{
    SetPWMFrequency(0);
    UpdateTIMER1CompareValue(0);
}

void BeepSound(void)
{
    UpdateTIMER1CompareValue(20);
    if(GetTIMER1Flag()) {
        SetTIMER1Flag(0);
        SetPWMFrequency(450);
    }
    else {
        SetPWMFrequency(0);
    }
}

void BuzzerUpdate(SystemState state)
{
    switch (state)
    {
        case ST_MOTION:
        case ST_SHOCK:
            PoliceSiren();
            break;
            
        case ST_OVERHEAT:
        case ST_FLAME:
            FireAlarm();
            break;
            
        default:
            StopSound();
            break;
    }
}
