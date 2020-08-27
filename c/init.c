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
extern unsigned char STACK_START;

// Function prototypes
void init(void);
void DefaultISRHandler(void);
extern void main(void); // Assume that the user will provide a main function
/*
 * Exception Vector Table. See page 103 of Datasheet for list.
 * Reset vector is required for code to run.
 */
const uint32_t exception_vectors[] __attribute__((section(".vectors"))) = {
    (uint32_t)&STACK_START,      /* address for top of stack */
    (uint32_t)init,              /* Reset handler */
    (uint32_t)DefaultISRHandler, /* NMI */
    (uint32_t)DefaultISRHandler, /* Hard fault */
    (uint32_t)DefaultISRHandler, /* Bus fault */
    (uint32_t)DefaultISRHandler, /* Memory management fault */
    (uint32_t)DefaultISRHandler, /* Usage fault */
    (uint32_t)0,                 /* Reserved */
    (uint32_t)DefaultISRHandler, /* SVCall */
    (uint32_t)DefaultISRHandler, /* Debug Monitor */
    (uint32_t)0,                 /* Reserved */
    (uint32_t)DefaultISRHandler, /* PendSV */
    (uint32_t)DefaultISRHandler  /* SysTick */
};

/**
 * Default Handler for an ISR.
 */
void DefaultISRHandler(void) {
    // Spin.
    while (1) {
    }
}

/**
 * Core init function for MCU. Sets up global variables.
 *
 * Reference: http://eleceng.dit.ie/frank/arm/BareMetalTILM4F/index.html
 */
void init(void) {
    unsigned char *src;
    unsigned char *dst;
    unsigned int len;
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
    main();
}
