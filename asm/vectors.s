@ ARM Interrupt vectors for this program
.cpu cortex-m3
.thumb @ use thumb instructions

.section .vectors,"a" @interrupt vector section, placed at 0x0 by linker
    .word 0x20008000 @stack top (placed directly after SRAM in memory)
    .word _init @reset vector
    .word hang @nmi interrupt handler
    .word hang @hard fault isr

.section .text @ place the init code in the text section
.thumb_func @force bx entry to this point
hang:
    B . @hang at this address

.thumb_func
_init:
    BL _asm_entry
    B hang
    