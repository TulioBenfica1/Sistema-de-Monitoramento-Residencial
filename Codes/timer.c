#include <mega16.h>
#include "timer.h"

static volatile unsigned char flag_tim1 = 0;

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    TCNT1 = 0;
    flag_tim1 = 1;
}

void TIMER1Init(void)
{ 
    // Registradores para configurar o Timer1
    TCCR1B = 0x05; // Prescaler de 64
    TIMSK = 0x10; // Habilita interrupção do Timer1 via comparacao registrador A
    OCR1A = 0x00;
}

void UpdateTIMER1CompareValue(unsigned int time)
{
    // Recebe um periodo em ms e atualiza o valor do registrador de comparacao A do Timer1
    OCR1A = (14400UL * time) / 1000UL - 1;
}

unsigned char GetTIMER1Flag(void)
{
    return flag_tim1;
}

void SetTIMER1Flag(unsigned char value)
{
    flag_tim1 = value; 
}
