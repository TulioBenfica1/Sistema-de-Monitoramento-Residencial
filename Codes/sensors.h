#ifndef SENSORS_H
#define SENSORS_H

#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <system_state.h>
#include <config.h>

void SensorsInit(void);
void SensorsUpdate(void);

#endif  