keyboard_waitkey:
	pusha
	mov ax, 0
	mov ah, 10h
	int 16h
	mov [keyboard_buffer], ax
	popa
	mov ax, [keyboard_buffer]
	ret
	
keyboard_buffer db 0
