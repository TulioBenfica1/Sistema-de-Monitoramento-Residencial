#ifndef BUZZER_H
#define BUZZER_H

#include "system_state.h"

void PoliceSiren(void);
void FireAlarm(void);
void StopSound(void);
void BeepSound(void);
void BuzzerUpdate(SystemState state);

#endif