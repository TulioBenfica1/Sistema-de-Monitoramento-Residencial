#include <mega16.h>
#include "pwm.h"

void PWMInit(void)
{
    // Configuracoes do PWM no modo geracao de onda quadrada no timer 2
    // modo CTC (clear timer on compare match), prescaler = 1024, pino PD7 pro PWM2
    TCCR2 = 0b00011100;              
    DDRD = 0x80;
}

void SetPWMFrequency(unsigned int frequency)
{
    // Altera o registrador OCR2 para alterar a frequencia do PWM   
    unsigned char reg;
    
    if(frequency == 0) {
        DDRD &= ~0x80; // Desliga o pino PD7 
        return;
    }

    DDRD |= 0x80;
    
    reg = (unsigned char)((14745600UL / (128UL * frequency)) - 1);
    OCR2 = reg;
}