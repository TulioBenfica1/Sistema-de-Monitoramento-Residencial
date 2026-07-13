#include <mega16.h>
#include <ds1307.h>
#include <stdio.h>
#include <stdlib.h>

#include "rtc.h"

#define TIME_LENGTH 6

void RTCInit(void)
{
    rtc_init(0,1,0); // 1Hz, pino de saida baixo 
    DDRD |= 0b00000000; 
    PORTD |= 0b00000100;     
}

unsigned char *GetRTC(void)
{
    char *time = (char*) malloc(TIME_LENGTH * sizeof(char));
    unsigned char dia, mes, ano, hor, min, seg; 
    rtc_get_date(&dia, &mes, &ano);
    rtc_get_time(&hor, &min, &seg);
    time[0] = ano;
    time[1] = mes;
    time[2] = dia;
    time[3] = hor;
    time[4] = min;
    time[5] = seg;  
    return time;        
}

void SetDateRTC(unsigned char dia, unsigned char mes, unsigned char ano){
    rtc_set_date(dia, mes, ano);
}
void SetTimeRTC(unsigned char hor, unsigned char min){
    rtc_set_time(hor, min, 0);
}

