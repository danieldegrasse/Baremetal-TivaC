#include "TM4C123GH6PM.h"

#define HWREG(x) (*((volatile unsigned int *)(x)))

/**
 * This program sets GPIO pin PF1 (connected to red LED) to output.
 */
void main(void) {
   int i;
    // Enable clock gating on RCGCGPIO
    HWREG(SYSCTL_BASE + RCGCGPIO) |= BIT5;
    // Wait for clock gating control to work.
    while (1) {
        if (HWREG(SYSCTL_BASE + PRGPIO) & (BIT5))
            break;
    }
    HWREG(GPIOF_BASE + GPIODIR) |= BIT1;
    HWREG(GPIOF_BASE + GPIOAFSEL) &= ~BIT1;
    HWREG(GPIOF_BASE + GPIOODR) &= ~BIT1;
    HWREG(GPIOF_BASE + GPIODEN) |= BIT1;
    /*
     * In order to manipulate GPIO bins, we need to use the ability to
     * access individual bits of the GPIO port (see page 654 of the user guide)
     */
    while (1) {
        HWREG(GPIOF_BASE + GPIODATA + (BIT1 << 2)) = BIT1;
        i = 100000;
        while(i--);
        HWREG(GPIOF_BASE + GPIODATA + (BIT1 << 2)) &= ~BIT1;
        i = 100000;
        while(i--);
    }
}