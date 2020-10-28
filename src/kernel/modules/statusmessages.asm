; Inputs: SI, AL - String, Status
kernel_print_status:
	pusha
	
	push ax
	mov al, 13
	call screen_putchar
	pop ax
	
	push si
	mov si, .status_msg_openbracket
	call screen_puts
	
	cmp al, kernel_status_ok
	je .ok
	
	cmp al, kernel_status_fail
	je .fail
	
	mov si, kernel_msg_waiting
	mov bl, 0Eh
	call screen_color_puts
	
	.finish_printing:
		mov si, .status_msg_closebracket
		call screen_puts
		pop si
		call screen_puts
		popa
		ret
	
	.actually_finished:
		mov si, .status_msg_closebracket
		call screen_puts
		pop si
		call screen_puts
		call screen_newline
		popa
		ret
	
	.ok:
		mov si, kernel_msg_ok
		mov bl, 02h
		call screen_color_puts
		jmp .actually_finished
		
	.fail:
		mov si, kernel_msg_fail
		mov bl, 04h
		call screen_color_puts
		jmp .actually_finished
	
	.status_msg_openbracket 	db "[ ", 0
	.status_msg_closebracket 	db " ] ", 0

kernel_status_ok		db 0
kernel_status_fail		db 1
kernel_status_waiting	db 2
