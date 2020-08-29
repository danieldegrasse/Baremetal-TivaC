# ARM Baremetal for Tiva C Launchpad
This project includes demonstrations of how to write a bare metal ARM program for the TI Tiva C launchpad, using pure C or assembly. It supports BSS and Data sections in both projects, along with relocation of the Data section to the ROM memory space.

# ARM Startup sequence
When the Cortex-M4F processor in the Tiva C starts up, it looks for a reset vector in the exception table. The exception table is table of function pointers holding addresses of functions (vectors) for common faults the ARM processor can encounter. The first word in the exception table denotes the starting address the stack should grow from (in the code, that address is directly after the 32k of flash memory). The second word is the address of the reset routine, called init() in the C example or _init in the ASM code. the init function copies all Data section variables from the ROM to RAM, then zeros out the BSS section. After doing this, it calls the main routine and code execution proceeds normally.