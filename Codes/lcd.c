#include <mega16.h>
#include <alcd.h>

#include "lcd.h"

void LCDInit(void)
{
    // Configura os registradores para utilizar o LCD - Barramento A
    DDRA |= 0x04;     // Configura o pino PA2 como saída para habilitar o LCD
    lcd_init(16);     // Inicializa o LCD com 16 caracteres
    PORTA |= 0x08;    // Habilita o backlight do LCD
    lcd_gotoxy(0, 0); // Posicão padrão do cursor no LCD
}

void LCDUpdate(SystemState state)
{
    // Atualiza o display do LCD com base no estado atual do sistema
    lcd_clear();

    switch (state)
    {
        case ST_BOOT:
            lcd_puts("Booting...");
            break;
        case ST_ARMED:
            lcd_puts("Sistema Armado");
            break;
        case ST_DISARMED:
            lcd_puts("Sistema Desarmado");
            break;
        case ST_ERROR:
            lcd_puts("Erro no Sistema");
            break;
        default:
            lcd_puts("Estado Desconhecido");
            break;
    }
}