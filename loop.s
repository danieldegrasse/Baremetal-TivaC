
.thumb @use thumb mode (Cortex only supports thumb mode)
.text
.global _entry @export the entry point
_entry:
    @ First, enable clock gating on RCGCGPIO
    LDR r0, SYSCTL_RCCGPIO @load value of SYSCTL_RCGCGPIO symbol into r0
    LDR r1, [r0] @load value of RCGCGPIO
    MOV r2, #32
    ORR r2, r2, r1 @ logical OR with BIT5
    STR r2, [r0]
    LDR r0, SYSCTL_PRGPIO
_GATE_LOOP:
    LDR r1, [r0]
    MOV r2, #32
    AND r2, r2, r1
    CBNZ r2, _GATE_EXIT @ if (32 & SYSCTLPRGPIO) was not zero, branch out
    B _GATE_LOOP
_GATE_EXIT:
    MOV r3, #1 @set r3 so CBZ does not jump
    LDR r0, GPIOFDIR
_SET_BIT1:
    @ This snippet sets BIT1 of the memory r0's value points to
    LDR r1, [r0] @load value based off r0
    MOV r2, #2 @BIT1 (for PF.1 GPIO PIN)
    ORR r2, r2, r1
    STR r2, [r0]
    CBZ r3, _BLINK @ if r3 is zero, jump to blink routine
    @ Enable GPIO PIN
    LDR r0, GPIOFDEN
    MOV r3, #0 @now CBZ will jump
    B _SET_BIT1 @ jump back to set bit snippet
_BLINK:
    ldr r0, GPIOFDATA
    mov r1, #2
    str r1, [r0]
    b . @ Infinite loop here (branch to our instruction)

    @ A nice little NOP sled to keep the data after this word aligned.    
    NOP

SYSCTL_RCCGPIO: .word 1074783752
SYSCTL_PRGPIO: .word 1074784776
GPIOFDATA: .word 1073893384
GPIOFDIR: .word 1073894400
GPIOFDEN: .word 1073894684

