#ifndef SECURITY_SYSTEM_PASSWORD_H
#define SECURITY_SYSTEM_PASSWORD_H

typedef enum
{
    PASSWORD_PENDING,
    PASSWORD_CORRECT,
    PASSWORD_INCORRECT
} PasswordResult;

void PasswordStart(void);
void PasswordInput(unsigned char input);
PasswordResult PasswordConfirm(void);

#endif
