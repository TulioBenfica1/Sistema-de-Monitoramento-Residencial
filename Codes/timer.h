#ifndef TIMER_H
#define TIMER_H

void TIMER1Init(void);
void UpdateTIMER1CompareValue(unsigned int time);
unsigned char GetTIMER1Flag(void);
void SetTIMER1Flag(unsigned char value);

#endif