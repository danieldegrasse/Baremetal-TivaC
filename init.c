/**
 * @file init.c
 * Init code for TM4C123GH6PM. Contains interrupt vectors and base init.
 * function.
 */
#include <stdint.h>

// Variables declared in linker script
extern unsigned char INIT_DATA_VALUES;
extern unsigned char INIT_DATA_START;
extern unsigned char INIT_DATA_END;
extern unsigned char BSS_START;
extern unsigned char BSS_END;

// Function prototypes
void init(void);
void DefaultISRHandler(void);
extern void mymain(void); // Assume that the user will provide a main function

/*
 * Exception Vector Table. See page 103 of Datasheet for list.
 * Reset vector is required for code to run.
 */
const void* exception_vectors[] __attribute__((section(".vectors"))) = {
    (void *)0x20008000,        /* address for top of stack */
    init,              /* Reset handler */
    DefaultISRHandler, /* NMI */
    DefaultISRHandler, /* Hard fault */
    0, /* Bus fault */
    0, /* Memory management fault */
    0, /* Usage fault */
    0,                 /* Reserved */
    DefaultISRHandler, /* SVCall */
    0, /* Debug Monitor */
    0,                 /* Reserved */
    DefaultISRHandler, /* PendSV */
    DefaultISRHandler  /* SysTick */
};

/**
 * Default Handler for an ISR.
 */
void DefaultISRHandler(void) {
    // Spin.
    while (1);
}

/**
 * Core init function for MCU. Sets up global variables.
 *
 * Reference: http://eleceng.dit.ie/frank/arm/BareMetalTILM4F/index.html
 */
void init(void) {
    unsigned char *src;
    unsigned char *dst;
    unsigned len;
    // Copy all data values into the correct starting location.
    src = &INIT_DATA_VALUES;
    dst = &INIT_DATA_START;
    len = &INIT_DATA_END - &INIT_DATA_START;
    // Copy each byte of src to dst.
    while (len--) {
        *dst++ = *src++;
    }
    // Zero out all bss values.
    dst = &BSS_START;
    len = &BSS_END - &BSS_START;
    while (len--) {
        *dst++ = 0;
    }
    // init is done. Call the main entry point.
    mymain();
}
