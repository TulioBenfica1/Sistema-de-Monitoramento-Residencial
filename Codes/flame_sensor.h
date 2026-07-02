#ifndef FLAME_SENSOR_H
#define FLAME_SENSOR_H

#include <mega16.h>
#include <alcd.h>
#include <delay.h>

void FlameSensorInit(void);
bool FlameSensorUpdate(void);

#endif  