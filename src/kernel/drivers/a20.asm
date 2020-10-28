a20_enable:
	pusha
	mov si, .enabling_msg
	mov al, kernel_status_waiting
	call kernel_print_status
	
	mov ax, 2403h
	int 15h
	jb .fail
	cmp ah, 0
	jnz .fail
	
	mov ax, 0x2401
	int 15h
	jb  .fail
	cmp ah, 0
	jnz .fail
	
	jmp .check
	
	.fast:
		in al, 0x92
		or al, 2
		out 0x92, al
		
		jmp .check
	
	.check:
		mov ax, 0x2402
		int 15h
		jb .fail
		cmp ah, 0
		jnz .fail
		
		cmp al, 1
		jz .success
		
		jmp .fail
	
	.success:
		mov si, .enabling_msg
		mov al, kernel_status_ok
		call kernel_print_status
		popa
		ret
	
	.fail:
		mov si, .enabling_msg
		mov al, kernel_status_fail
		call kernel_print_status
		popa
		ret
	
	.enabling_msg	db "Enabling A20 line... ", 0

a20_enable_keyboardcontroller:
	pusha
	mov si, .enabling_msg
	mov al, kernel_status_waiting
	call kernel_print_status
	cli
	
	call .wait
	mov al, 0xAD
	out 0x64, al
	
	call .wait
	mov al, 0xD0
	out 0x64, al
	
	call .wait2
	in al, 0x60
	push eax
	
	call .wait
	mov al, 0xD1
	out 0x64, al
	
	call .wait
	pop eax
	or al, 2
	out 0x60, al
	
	call .wait
	mov al, 0xAE
	out 0x64, al
	
	call .wait
	
	sti
	mov si, .enabling_msg
	mov al, kernel_status_ok
	call kernel_print_status
	popa
	ret

	.wait:
		in al, 0x64
        test al, 2
        jnz .wait
        ret
        
	.wait2:
		in al, 0x64
		test al, 1
		jnz .wait2
		ret
	
	.enabling_msg	db "Enabling A20 line... ", 0
