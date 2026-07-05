#ifndef SENSORS_H
#define SENSORS_H

#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <sensors_state.h>

void SensorsInit(void);
SensorsState SensorsUpdate(void);

#endif  