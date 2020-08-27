MEMORY
{
	flash : ORIGIN = 0x00000000, LENGTH = 256k /* Chip has 256KB flash mem */
	SRAM : ORIGIN = 0x20000000, LENGTH = 32k /* Chip was 32KB SRAM */
}

SECTIONS
{
	. = ORIGIN(flash);
	.text : { 
		*(.vectors);
		*(.text); 
	} > flash
	. = ORIGIN (SRAM);
	.data : {
		DATA_ROM_ADDR = LOADADDR(.data);
		DATA_RAM_DEST_START = .;
		*(.data);
		DATA_RAM_DEST_END = .;
	} > SRAM AT>flash
	BSS_START = .;
	.bss : {*(.bss);} > SRAM
	BSS_END = .;
	STACK_START = ORIGIN(SRAM) + LENGTH(SRAM);
}