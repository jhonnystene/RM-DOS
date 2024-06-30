kernel_hang:
	jmp kernel_hang
	
kernel_panic:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_unknown_error
	call screen_puts
	popa
	jmp kernel_panic_finish

kernel_panic_divzero:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_divzero_error
	call screen_puts
	popa
	jmp kernel_panic_finish


kernel_panic_boundrange:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_divzero_error
	call screen_puts
	popa
	jmp kernel_panic_finish

kernel_panic_opcode:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_opcode_error
	call screen_puts
	popa
	jmp kernel_panic_finish

kernel_panic_devicegone:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_devicegone_error
	call screen_puts
	popa
	jmp kernel_panic_finish

kernel_panic_TSS:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_TSS_error
	call screen_puts
	popa
	jmp kernel_panic_finish

kernel_panic_seggone:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_seggone_error
	call screen_puts
	popa
	jmp kernel_panic_finish

kernel_panic_stackseg:
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_puts
	mov si, kernel_msg_stackseg_error
	call screen_puts
	popa
	jmp kernel_panic_finish
	
kernel_panic_finish:
	call screen_newline
	call kernel_dump_regs
	jmp kernel_hang

kernel_msg_panic				db "                                 Kernel PANIC!!                                 ", 13, 10, 0
kernel_msg_halted				db "                                 System halted.                                 ", 13, 10, 0
kernel_msg_unknown_error		db "                         Unknown error - System halted.                         ", 13, 10, 0
kernel_msg_divzero_error		db "                         Divide by zero - System halted                         ", 13, 10, 0
kernel_msg_boundrange_error		db "                      Bound Range Exceeded - System halted                      ", 13, 10, 0
kernel_msg_opcode_error			db "                         Invalid Opcode - System halted                         ", 13, 10, 0
kernel_msg_devicegone_error		db "                      Device Not Available - System halted                      ", 13, 10, 0
kernel_msg_TSS_error			db "                          Invalid TSS - System halted.                          ", 13, 10, 0
kernel_msg_seggone_error		db "                        Invalid Segment - System halted.                        ", 13, 10, 0
kernel_msg_stackseg_error		db "                    Stack Segmentation Fault - System halted                    ", 13, 10, 0

kernel_msg_ax					db "                          AX: ", 0
kernel_msg_bx					db "BX: ", 0
kernel_msg_cx					db "                          CX: ", 0
kernel_msg_dx					db "DX: ", 0
kernel_msg_si					db "                          SI: ", 0
kernel_msg_di					db "DI: ", 0
kernel_msg_sp					db "SP: ", 0
kernel_msg_reg_spacer			db "        ", 0
kernel_msg_hex					db "0x", 0
