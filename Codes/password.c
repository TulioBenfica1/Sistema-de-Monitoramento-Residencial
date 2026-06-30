#include "password.h"
#include "lcd.h"

#define PASSWORD_LENGTH 4

static unsigned char password[PASSWORD_LENGTH] = {'2', '2', '3', '4'};
static unsigned char password_length;
static unsigned char password_incorrect;
static unsigned char password_entry_active;

void PasswordStart(void)
{
    password_length = 0;
    password_incorrect = 0;
    password_entry_active = 1;
}

void PasswordInput(unsigned char input)
{
    
    if (password[password_length] != input)
        password_incorrect = 1;

    password_length++;
    updatePasswordDisplay(input, password_length);
}

PasswordResult PasswordConfirm(void)
{
    if (!password_entry_active || password_length < PASSWORD_LENGTH)
        return PASSWORD_PENDING;

    if (password_incorrect)
    {
        wrongPasswordDisplay();
        PasswordStart();
        return PASSWORD_INCORRECT;
    }

    correctPasswordDisplay();
    password_entry_active = 0;
    password_length = 0;
    return PASSWORD_CORRECT;
}

