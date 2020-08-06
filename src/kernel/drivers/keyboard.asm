keyboard_waitkey:
	pusha
	mov ax, 0
	mov ah, 10h
	int 16h
	
	mov [.buffer], ax
	popa
	mov ax, [.buffer]
	ret
	
	.buffer db 0
