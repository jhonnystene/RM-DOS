
; Inputs: SI - String
screen_puts:
	pusha
	.loop:
		lodsb
		cmp al, 0
		je .done
		
		call screen_putchar
		jmp .loop
	
	.done:
		popa
		ret

; Inputs: AL- Character
screen_putchar:
	pusha
	
	; Print character
	mov ah, 09h
	mov bh, 0
	mov bl, 0Fh
	mov cx, 1
	int 10h
	
	; Get cursor position and increment
	mov ah, 03h
	int 10h
	inc dl
	cmp dl, 80 ; End of line?
	je .newline ; Do a newline
	
	; Set the cursor position to the new position and return
	.finish:
		mov ah, 02h
		mov bh, 0
		int 10h
		popa
		ret
	
	; Line feed + carriage return.
	.newline:
		mov dl, 0
		inc dh
		jmp .finish
	
	
; Inputs: AL - Byte
screen_print_2hex:
	pusha
	push ax
	shr ax, 4
	call .printone
	pop ax
	call .printone
	popa
	ret
	
	.printone:
		pusha
		and ax, 0Fh
		cmp ax, 9
		jle .format
		add ax, 'A'-'9'-1
	
	.format:
		add ax, '0'
		call screen_putchar
		popa
		ret

progress:
	pusha
	mov al, '.'
	jmp progress_finish
	
progress2:
	pusha
	mov al, '#'
	jmp progress_finish

progress_finish:
	mov ah, 0Eh
	mov bh, 0
	mov bl, 0Fh
	mov cx, 1
	int 10h
	popa
	ret
