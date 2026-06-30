#include <mega16.h>
#include <delay.h>
#include "config.h"
#include "password.h"

void main(void)
{
    SystemInit();

    while (1)
    {
        SystemUpdate();
    }
}
