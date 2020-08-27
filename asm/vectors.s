@ ARM Interrupt vectors for this program
.cpu cortex-m3
.thumb @ use thumb instructions

.section .vectors,"a" @interrupt vector section, placed at 0x0 by linker
    .word STACK_START @stack top (placed directly after SRAM in memory)
    .word _init @reset vector
    .word hang @nmi interrupt handler
    .word hang @hard fault isr

.section .text @ place the init code in the text section
.thumb_func @force bx entry to this point
hang:
    B . @hang at this address

.thumb_func
_init:
    @ Here we need to set up the BSS and data sections.
    @ Start with data section
    @ we need to copy memory from data_rom_addr to data_ram_dest_start
    LDR r4, data_ram_dest_start
    LDR r5, data_ram_dest_end
    LDR r6, data_rom_addr
    @ Now, do the copy
_data_cpy_loop:
    SUB r7, r5, r4
    CBZ r7, _data_cpy_exit @ exit if we have copied all data
    @ Copy a byte and move r6 and r4 forwards
    LDR r7, [r6]
    STR r7, [r4]
    ADD r4, r4, #1
    ADD r6, r6, #1
    B _data_cpy_loop
_data_cpy_exit:
    @ Now handle the BSS section. We just have to zero this.
    LDR r4, bss_start
    LDR r5, bss_end
    MOV r6, #0
_bss_cpy_loop:
    SUB r7, r5, r4
    CBZ r7, _bss_cpy_exit
    LDR r7, [r4]
    STR r7, [r5]
    @ Move r4
    ADD r4, r4, #1
    B _bss_cpy_loop
_bss_cpy_exit:
    @ All setup is done. Break.
    BL _asm_entry
    B hang

.align 2
@ Constants we need from the linker
data_rom_addr: .word DATA_ROM_ADDR
data_ram_dest_start: .word DATA_RAM_DEST_START
data_ram_dest_end: .word DATA_RAM_DEST_END
bss_start: .word BSS_START
bss_end: .word BSS_END
    