#include <mega16.h>
#include <delay.h>
#include "config.h"

void main(void)
{
    SystemInit();

    while (1)
    {
        SystemUpdate();
    }
}
