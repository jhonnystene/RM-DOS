program_about:
	mov si, kernel_msg_version
	call screen_puts
	mov si, kernel_msg_copyright
	call screen_puts
	
	jmp shell_start

command_about db "ABOUT", 0
