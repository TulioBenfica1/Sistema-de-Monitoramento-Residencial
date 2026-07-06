#ifndef KEYPAD_H
#define KEYPAD_H

#include "system_state.h"

void KEYPADInit(void);
void KEYPADProcess(SystemState state);
unsigned InKey(void);
unsigned char KeyToIndex (unsigned key);
#endif