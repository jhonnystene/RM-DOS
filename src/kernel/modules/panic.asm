kernel_hang:
	jmp kernel_hang
	
kernel_panic:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_unknown_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish

kernel_panic_divzero:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_divzero_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish


kernel_panic_boundrange:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_divzero_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish

kernel_panic_opcode:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_opcode_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish

kernel_panic_devicegone:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_devicegone_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish

kernel_panic_TSS:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_TSS_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish

kernel_panic_seggone:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_seggone_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish

kernel_panic_stackseg:
	call screen_enter_text_mode
	pusha
	mov bl, 0x4F
	mov si, kernel_msg_panic
	call screen_color_puts
	mov si, kernel_msg_stackseg_error
	call screen_color_puts
	popa
	jmp kernel_panic_finish
	
kernel_panic_finish:
	call kernel_dump_regs
	jmp kernel_hang
