SECTIONS {
	/* 0x8000 is bootloader loading for kernel
	 *
	 */
	.init 0x8000 : {
		*(.init)
	}
	
	/* 
	 * Rest of the code
	 */
	.text : {
		*(.text)
	}

	.data : {
		*(.data)
	}

	/* Discard everything else
	 *
	 */
	/DISCARD/ : {
		*(*)
	}
}
