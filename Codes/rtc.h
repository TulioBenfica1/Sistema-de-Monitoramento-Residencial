#ifndef RTC_H
#define RTC_H


void RTCInit(void);
unsigned char *GetRTC(void);
void SetDateRTC(unsigned char dia, unsigned char mes, unsigned char ano);
void SetTimeRTC(unsigned char hor, unsigned char min);

#endif 