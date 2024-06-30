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
	.loop:
		lodsb
		cmp al, 0
		je .done
		
		call screen_putchar
		jmp .loop
	
	.done:
		popa
		ret

; I/O: None
screen_scroll:
	pusha
	mov ah, 06h
	mov al, 1
	mov bh, 07h
	mov cx, 0
	mov dh, 25
	mov dl, 80
	int 10h
	popa
	ret

screen_putchar:
	pusha
	cmp al, 8
	je .backspace
	cmp al, 9
	je .tab
	
	mov ah, 0Eh
	mov bh, 0
	mov cx, 1
	int 10h
	
	cmp al, 10
	je .line_feed
	popa
	ret

.backspace:
	mov ah, 03h
	mov bl, 0
	int 10h
	dec dl
	
	mov ah, 0Eh
	mov al, ' '
	mov cx, 1
	int 10h
	
	mov ah, 02h
	mov bh, 0
	int 10h
	popa
	ret

.line_feed:
	mov al, 13
	call screen_putchar
	popa
	ret

.tab:
	mov al, ' '
	call screen_putchar
	call screen_putchar
	call screen_putchar
	call screen_putchar
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
		call screen_putchar
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
