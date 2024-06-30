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
	.loop:
		lodsb
		cmp al, 0
		je .done
		
		call screen_putchar
		jmp .loop
	
	.done:
		popa
		ret

; Inputs: SI, BL - String, Color
screen_color_puts:
	pusha
	.loop:
		lodsb
		cmp al, 0
		je .done
		
		call screen_putchar_color
		
		jmp .loop
	
	.done:
		popa
		ret

; Inputs: AL - Character
screen_putchar:
	push bx
	mov bl, 0Fh
	call screen_putchar_color
	pop bx
	ret

; I/O: None
screen_scroll:
	pusha
	mov ah, 06h
	mov al, 1
	mov bh, 0Fh
	mov cx, 0
	mov dh, 25
	mov dl, 80
	int 10h
	popa
	ret

; Inputs: AL, BL - Character, color
screen_putchar_color:
	pusha
	
	; Carriage return?
	cmp al, 13
	je .carriage_return
	
	; Line feed?
	cmp al, 10
	je .line_feed
	
	; Backspace?
	cmp al, 8
	je .backspace
	
	; Print character
	mov ah, 09h
	mov bh, 0
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
		cmp dh, 25
		je .scroll
		jmp .finish
	
	; Just go to the start of the line.
	.carriage_return:
		mov ah, 03h
		mov bl, 0
		int 10h
		mov dl, 0
		jmp .finish
	
	; Go to this same spot, but on the line below.
	.line_feed:
		mov ah, 03h
		mov bl, 0
		int 10h
		inc dh
		cmp dh, 25
		je .scroll
		jmp .finish
	
	; Scroll the screen up
	.scroll:
		dec dh
		call screen_scroll
		jmp .finish
	
	; Delete this character.
	.backspace:
		mov ah, 03h
		mov bl, 0
		int 10h
		dec dl
		
		mov ah, 09h
		mov al, ' '
		mov cx, 1
		int 10h
		
		jmp .finish
	
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

screen_print_ram:
	pusha
	
	.detect_lomem:
		clc
		int 12h
		jc .lomem_error
		
		cmp ax, 0
		je .lomem_error
		
		mov si, kernel_msg_low_ram_amount
		call screen_puts
		call screen_print_4hex
		mov si, kernel_msg_kilobytes
		call screen_puts
		call screen_newline
		jmp .detect_himem
	
	.detect_himem:
		clc
		mov ah, 88h
		int 15h
		jc .himem_error
		
		cmp ax, 0
		je .no_himem
		
		mov si, kernel_msg_high_ram_amount
		call screen_puts
		call screen_print_4hex
		mov si, kernel_msg_kilobytes
		call screen_puts
		call screen_newline
		
		jmp .finish
	
	.finish:
		popa
		ret
	
	.lomem_error:
		mov si, kernel_msg_couldnt_get_ram
		call screen_puts
		jmp .detect_himem
	
	.himem_error:
		mov si, kernel_msg_couldnt_get_ram
		call screen_puts
		jmp .finish
	
	.no_himem:
		mov si, kernel_msg_no_himem
		call screen_puts
		jmp .finish
