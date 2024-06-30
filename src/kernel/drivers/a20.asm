a20_enable:
	pusha

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
		popa
		stc
		ret
	.fail:
		popa
		clc
		ret
	

a20_enable_keyboardcontroller:
	pusha
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
	
