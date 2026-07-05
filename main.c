#include <mega16.h>
#include "config.h"

void main(void)
{
    SystemInit();
        
    while (1)
    {
        SystemUpdate();
    }
}
