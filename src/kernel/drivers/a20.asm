a20_enable:
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

a20_enable_fast:
	pusha
	mov si, .enabling_msg
	mov al, kernel_status_waiting
	call kernel_print_status
	
	in al, 0x92
	or al, 2
	out 0x92, al
	
	mov si, .enabling_msg
	mov al, kernel_status_ok
	call kernel_print_status
	popa
	ret
	
	.enabling_msg	db "Enabling A20 line (fast method)... ", 0
