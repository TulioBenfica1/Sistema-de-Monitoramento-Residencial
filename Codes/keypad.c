#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include "config.h"
#include "keypad.h"
#include "password.h"
#include "buzzer.h"
#include "lcd.h"

#define KEYIN PINC // PINC0..3 para entrada do teclado nas linhas
#define KEYOUT PORTC // PORTC4..6 para saida do teclado nas colunas
#define FIRST_COLUMN 0x40 
#define LAST_COLUMN 0x10

#define ROW_LENGTH 4
#define COLUMN_LENGTH 3

typedef unsigned char byte; 
unsigned volatile keys; // armazena cada estado da chave

static const char keymap[ROW_LENGTH * COLUMN_LENGTH] = {
   '1', '4', '7', '<',
   '2', '5', '8', '0',
   '3', '6', '9', '#'
};

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
   // Interrupção do Timer0 para varredura do teclado a cada 2ms
   static byte key_pressed_counter = 10;
   static byte key_released_counter, column = FIRST_COLUMN;
   static unsigned row_data, crt_key;

   // Reinicia o timer0
   TCNT0 = 0x8D; // 2ms

   row_data <<= 4;
   row_data |= ~(KEYIN)&0xF; // le as linhas do teclado
   column >>= 1; // muda para a proxima coluna
   
   if(column == (LAST_COLUMN >> 1)) // se chegou na ultima coluna
   {
      column = FIRST_COLUMN; // volta para a primeira coluna

      // Verifica se alguma tecla foi pressionada, logica para debouncing
      if(row_data == 0)
      {
         goto new_key;
      }
      if(key_released_counter)
      {
         --key_released_counter;
      }
      else
      {
         if(--key_pressed_counter == 9)
         {
            crt_key = row_data;
         }
         else
         {
            if(row_data != crt_key)
            {
               new_key:
                  key_pressed_counter = 10;
                  key_released_counter = 10;
                  goto end_key;
            }
            if(!key_pressed_counter)
            {
               keys = row_data;
               key_released_counter = 20;
            }
         }
      }
   end_key:
      row_data = 0;
   }
   KEYOUT = ~column; // seleciona a proxima coluna do teclado
}

unsigned InKey(void)
{
   // Retorna o valor da tecla pressionada, se houver
   unsigned k;
   if (k=keys)
      keys = 0;
   return k;
}

void KEYPADInit(void)
{
   // Configuracoes dos registradores do teclado
   DDRC |= 0x70; // Bits 0..3: entrada, 4..6: saida - Ultima coluna inativa
   PORTC |= 0x7f; // saida alta em 4..6

   // Configuracoes do Timer0 para varredura do teclado a cada 2ms
   TCCR0 |= 0x04;
   TCNT0 |= 0x8D;

   TIMSK |= 0x01; // habilita interrupcao do Timer0
}

unsigned char KeyToIndex (unsigned key)
{
   // Converte o valor da tecla pressionada para um índice de 0 a 11 
   unsigned char i;

    for (i = 0; i < 12; i++)
    {
        if (key & (1U << i))
         
         return i;
    }   
}

void KEYPADclear(void)
{
    keys = 0;
}

void KEYPADProcess(SystemState state)
{
   // Processa a tecla pressionada, se houver 
   unsigned k;
   unsigned char index;    
   char key;
   static PasswordResult password_result;
   static Data data_result;
   
   if(k=InKey())
   {
      index = KeyToIndex(k);
      key = keymap[index];
      if (key == '<') // Tecla <
      {
        if (state == ST_SET_DATA)
        {
            CleanLastDataDigit();
            return;
        } 
        CleanLastPasswordDigit();
      }
      else if (key == '#') // Tecla #
      {  
         if(state == ST_SET_DATA)
         {
            data_result = DataSet();
            //delay_ms(1000);
            if(data_result == DATA_SET)
            {
                LCDUpdate(ST_ARMING_DELAY);
                SystemSetState(ST_ARMING_DELAY);        
            } 
            return;         
         } 
         password_result = PasswordConfirm();
         //delay_ms(1000);
         if (password_result == PASSWORD_INCORRECT)
         {
            SystemSetState(state);
            BeepSound();   
         }
         else if (password_result == PASSWORD_CORRECT)
         {   
            if(state == ST_DISARMED)
            {                       
                LCDUpdate(ST_ARMING_DELAY);
                SystemSetState(ST_ARMING_DELAY);
            }
            else
            {
                SystemSetState(ST_DISARMED);
         
                lcd_clear();
            
                lcd_puts("    Sistema");
                lcd_gotoxy(0,1);
                lcd_puts("  Desarmado");
                delay_ms(1000);
            }
         }
      }
      else 
      {  
        if(state == ST_SET_DATA)
        {
            DataInput(keymap[index]);
        }
        else
        {
            PasswordInput(keymap[index]);
        }
      }
   }  
}