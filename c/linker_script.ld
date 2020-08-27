MEMORY
{
    flash : org = 0x00000000, len = 256k
    ram : org = 0x20000000, len = 32k
}
  
SECTIONS
{
        
	. = ORIGIN(flash);
        .text : {
		  *(.vectors); /* The interrupt vectors */
		  *(.text);
        } >flash
	. = ORIGIN(ram);
        .data : {
	  INIT_DATA_VALUES = LOADADDR(.data); /* Where we need to copy .data from */
	  INIT_DATA_START = .; /* Where we need to copy data to */
	    *(.data);
	  INIT_DATA_END = .;
		/* AT here places the .data section in the ROM of the image. 
		   We copy it to RAM in the init() function */
        } >ram AT>flash 
	BSS_START = .;
	.bss : {
	  
	    *(.bss);
	  
	} > ram
	BSS_END = .;
	STACK_START = ORIGIN(ram) + LENGTH(ram);
}
