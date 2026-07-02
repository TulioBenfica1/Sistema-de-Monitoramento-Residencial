#ifndef PRESENCE_SENSOR_H
#define PRESENCE_SENSOR_H

#include <mega16.h>
#include <alcd.h>
#include <delay.h>

void PresenceSensorInit(void);
bool PresenceSensorUpdate(void);

#endif  