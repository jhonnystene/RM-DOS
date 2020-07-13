floppy_reset:
	pusha
	mov ah, 00h
	mov dl, 7
	int 13h
	popa


	
