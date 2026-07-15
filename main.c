#include <mega16.h>
#include <stdio.h>
#include "config.h"
#include "usart.h"

void main(void)
{
    SystemInit(); 

        
    while (1)
    {                  
        SystemUpdate();
        if(PIND.5 == 0)
        {                                                                   
            SystemSetState(ST_MOTION);
        }
        /*if(PIND.3 == 0)
        {
            SystemSetState(ST_FLAME);                                                                                                             
        }*/
    }
}
