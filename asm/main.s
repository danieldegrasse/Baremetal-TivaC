
@ Main code: sets up GPIO on PF.1, and blinks the LED located there
.thumb @use thumb mode (Cortex only supports thumb mode)
.section .text
.global _asm_entry @export the entry point
_asm_entry:
    @ First, enable clock gating on RCGCGPIO
    LDR r4, SYSCTL_RCCGPIO @load value of SYSCTL_RCGCGPIO symbol into r4
    LDR r5, [r4] @load value of RCGCGPIO
    MOV r6, #32
    ORR r6, r6, r5 @ logical OR with BIT5
    STR r6, [r4]
    LDR r4, SYSCTL_PRGPIO
_GATE_LOOP:
    LDR r5, [r4]
    MOV r6, #32
    AND r6, r6, r5
    CBNZ r6, _GATE_EXIT @ if (32 & SYSCTLPRGPIO) was not zero, branch out
    B _GATE_LOOP
_GATE_EXIT:
    MOV r7, #1 @set r7 so CBZ does not jump
    LDR r4, GPIOFDIR
_SET_BIT1:
    @ This snippet sets BIT1 of the memory r4's value points to
    LDR r5, [r4] @load value based off r4
    MOV r6, #2 @BIT1 (for PF.1 GPIO PIN)
    ORR r6, r6, r5
    STR r6, [r4]
    CBZ r7, _BLINK @ if r7 is zero, jump to blink routine
    @ Enable GPIO PIN
    LDR r4, GPIOFDEN
    MOV r7, #0 @now CBZ will jump
    B _SET_BIT1 @ jump back to set bit snippet
_BLINK:
    LDR r4, GPIOFDATA
_BLINK_L:
    @ Get delay length from data section
    LDR r6, DELAY_PTR
    MOV r5, #2
    STR r5, [r4]
    LDR r0, [r6] @ load delay len as arg for function call
    BL _DELAY  @ make function call
    @ Now zero out GPIOFDATA to turn off LED
    MOV r5, #0
    STR r5, [r4]
    LDR r0, [r6] @ load delay len as arg for function call
    BL _DELAY 
    b _BLINK_L @ jump back to start of blink sequence


@ This subroutine delays for "r0"*3 clock cycles
_DELAY:
    @ First, save the registers (like a function would)
    PUSH {r4-r7}
    MOV r4, r0 @copy r0 to r4
_DELAY_LOOP:
    SUB r4, r4, #1 @decrement by 1
    CBZ r4, _DELAY_RET @ break if r4 is zero
    B _DELAY_LOOP @ otherwise keep looping
_DELAY_RET:
    POP {r4-r7}
    BX lr @ return back to caller

.align 2
SYSCTL_RCCGPIO: .word 1074783752
SYSCTL_PRGPIO: .word 1074784776
GPIOFDATA: .word 1073893384
GPIOFDIR: .word 1073894400
GPIOFDEN: .word 1073894684
DELAY_PTR: .word DELAY_LEN


.align 2
.section .data
@ Although unnessary, placing the delay in the 
@ data section checks to make sure our init routine copies it correctly
DELAY_LEN: .word 700000
