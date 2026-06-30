#ifndef LCD_H
#define LCD_H

#include "system_state.h"

void LCDInit(void);
void LCDUpdate(SystemState state);
void updatePasswordDisplay(char input, int length);
void wrongPasswordDisplay(void);
void correctPasswordDisplay(void);

#endif  