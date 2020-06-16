; Super Mega Awesome SHell (SMASH)

shell_start:
	mov si, prompt
	call printstring
	mov bx, 0
	
	.loop:
		call waitkey
		
		cmp al, 13
		je .newline
		
		cmp al, 08
		je .backspace
		
		mov byte [buffer + bx], al
		inc bx
		
		; Are we about to write past the buffer?
		cmp bx, 63
		je .newline
		
		call printchar
		jmp .loop
		
	.newline:
		mov al, 13
		call printchar
		mov al, 10
		call printchar
		
		; TODO: Run command
		
		jmp shell_start
	
	.backspace:
		cmp bx, 0
		je .loop
		
		mov byte [buffer + bx], 0
		dec bx
		mov al, 08
		call printchar
		mov al, ' '
		call printchar
		mov al, 08
		call printchar
		jmp .loop

prompt db "> ", 0
buffer times 64 db 0
