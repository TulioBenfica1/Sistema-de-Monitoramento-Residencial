#ifndef VIBRATION_SENSOR_H
#define VIBRATION_SENSOR_H

#include <mega16.h>
#include <alcd.h>
#include <delay.h>

void VibrationSensorInit(void);
bool VibrationSensorUpdate(void);

#endif  