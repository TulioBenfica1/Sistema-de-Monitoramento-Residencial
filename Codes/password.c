#include <alcd.h>
#include "password.h"
#include "lcd.h"

#define PASSWORD_LENGTH 4
#define DATA_LENGTH 15

static unsigned char password[PASSWORD_LENGTH] = {'2', '2', '3', '4'};
static unsigned char password_length;
static unsigned char data_length;
static unsigned char password_input[PASSWORD_LENGTH];
static unsigned char data_input[DATA_LENGTH];
static unsigned char password_entry_active;
static unsigned char data_entry_active;

void PasswordStart(void)
{
    password_length = 0;
    password_entry_active = 1;
}

void DataStart(void)
{
    data_length = 0;
    data_entry_active = 1;
}

void PasswordInput(unsigned char input)
{
    if (password_length >= PASSWORD_LENGTH)
        return;

    password_input[password_length] = input;
    password_length++;

    UpdatePasswordDisplay(input, password_length);
}

void DataInput(unsigned char input)
{
    if (data_length >= DATA_LENGTH)
        return;

    data_input[data_length] = input;    
    data_length++;

    UpdateDataDisplay(input, data_length);
    
    if (data_length % 3 == 2 && data_length < DATA_LENGTH)
    {
        data_length++;
    }
}


void CleanLastPasswordDigit(void)
{
    if (password_length > 0)
    {
        password_length--;
        lcd_gotoxy(7 + 2 * password_length, 1);
        lcd_putchar('_');
    }
}

void CleanLastDataDigit(void)
{
    if (data_length > 0)
    {
        data_length--;
        if (data_length % 3 == 2)
        {
            return;
        }
        lcd_gotoxy(data_length, 1);
        lcd_putchar('_');
    }
}

PasswordResult PasswordConfirm(void)
{
    unsigned char i;

    if (!password_entry_active || password_length < PASSWORD_LENGTH)
        return PASSWORD_PENDING;

    for (i = 0; i < PASSWORD_LENGTH; i++)
    {
        if (password_input[i] != password[i])
        {
            WrongPasswordDisplay();
            PasswordStart();
            return PASSWORD_INCORRECT;
        }
    }

    CorrectPasswordDisplay();
    password_entry_active = 0;
    password_length = 0;
    return PASSWORD_CORRECT;
}

Data DataSet(void)
{
    if (!data_entry_active || data_length < DATA_LENGTH)
        return DATA_PENDING;

    SetDataDisplay();
    data_entry_active = 0;
    data_length = 0;
    return DATA_SET;       
}