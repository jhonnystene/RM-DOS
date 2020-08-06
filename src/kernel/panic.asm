

; Inputs: AH - Error code
panic:
	mov si, panic_msg_header
	call screen_puts
	
	; Do we know what the code *is*?
	cmp ah, 0
	je .unknown
	
	cmp ah, 1
	je .user
	
	jmp .finish
	
	.unknown: ; Code 0
		mov si, panic_msg_unknown
		call screen_puts
		jmp .finish
	
	.user: ; Code 1
		mov si, panic_msg_user
		call screen_puts
		jmp .finish
	
	.finish:
		mov si, panic_msg_halted
		call screen_puts
		jmp hang

panic_msg_header db "Kernel PANIC!", 13, 10, 0
panic_msg_halted db "System halted.", 13, 10, 0

; Code 0
panic_msg_unknown db "Unknown error!", 13, 10, 0

; Code 1
panic_msg_user db "User requested panic!", 13, 10, 0
