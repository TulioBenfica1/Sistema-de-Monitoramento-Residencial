#include <mega16.h>
#include <ds1307.h>

#include "rtc.h"
#include "i2c.h"

#define TIME_LENGTH 6

void RTCInit(void)
{
    rtc_init(0,1,0); // 1Hz, pino de saida baixo
    
    
}

unsigned char *GetRTC(void)
{
    unsigned char dia, mes, ano, hor, min, seg;
    unsigned char time[TIME_LENGTH];
    rtc_get_date(&dia, &mes, &ano);
    rtc_get_time(&hor, &min, &seg);
    //time[TIME_LENGTH] = {ano, mes, dia, hor, min, seg};    
    return time;        
}

