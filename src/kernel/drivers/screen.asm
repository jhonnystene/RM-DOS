screen_enter_video_mode:
	pusha
	mov ah, 00h
	mov al, 13h
	int 10h
	popa
	ret

screen_enter_text_mode:
	pusha
	mov ah, 00h
	mov al, 03h
	int 10h
	popa
	ret

screen_clear:
	pusha
	mov ah, 06h
	mov al, 0
	mov bh, 07h
	mov cx, 0
	mov dh, 24
	mov dl, 79
	int 10h
	mov dx, 0
	call screen_set_cursor
	popa
	ret
	
; Inputs: DH - Row, DL - Column
screen_set_cursor:
	pusha
	mov ah, 02h
	mov bh, 0
	int 10h
	popa
	ret

; Inputs: SI - String
screen_puts:
	pusha
	mov ah, 0Eh
	mov bh, 0
	mov bl, 0Fh
	.loop:
		lodsb
		cmp al, 0
		je .done
		
		int 10h
		jmp .loop
	
	.done:
		popa
		ret

; Inputs: AL - Character
screen_putchar:
	pusha
	mov ah, 0Eh
	mov bh, 0
	mov bl, 0Fh
	int 10h
	popa
	ret
	
screen_newline:
	pusha
	mov ah, 0Eh
	mov al, 13
	mov bh, 0
	mov bl, 0Fh
	int 10h
	mov al, 10
	int 10h
	popa
	ret
	
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
		mov ah, 0Eh
		int 10h
		popa
		ret

; Inputs: AX - 2 bytes
screen_print_4hex:
	pusha
	mov bx, ax
	mov al, bh
	call screen_print_2hex
	mov al, bl
	call screen_print_2hex
	popa
	ret
	
screen_dump_floppy_sector:
	pusha
	mov bx, 0
	mov cx, 0
	call .spaces
	
	.loop:
		mov al, [floppy_buffer + bx]
		call screen_print_2hex
		;mov al, ' '
		;call screen_putchar
		inc bx
		inc cx
		cmp bx, 512
		je .done
		cmp cx, 32
		je .newline
		jmp .loop
	
	.spaces:
		push ax
		mov al, ' '
		mov ah, 8
		call screen_repeatchar
		pop ax
		ret
	
	.newline:
		call screen_newline
		mov cx, 0
		call .spaces
		jmp .loop
		
	.done:
		call screen_newline
		popa
		ret
		
; In: AH, AL: Count, Char
screen_repeatchar:
	pusha
	.loop:
		cmp ah, 0
		je .done
		call screen_putchar
		dec ah
		jmp .loop
	
	.done:
		popa
		ret
