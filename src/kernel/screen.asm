enter_video_mode:
	pusha
	mov ah, 00h
	mov al, 13h
	int 10h
	popa
	ret

enter_text_mode:
	pusha
	mov ah, 00h
	mov al, 03h
	int 10h
	popa
	ret

clearscreen:
	pusha
	mov ah, 06h
	mov al, 0
	mov bh, 0Fh
	mov cx, 0
	mov dh, 24
	mov dl, 79
	int 10h
	mov dx, 0
	call setcursor
	popa
	ret
	
; Inputs: DH - Row, DL - Column
setcursor:
	pusha
	mov ah, 02h
	mov bh, 0
	int 10h
	popa
	ret

; Inputs: SI - String
printstring:
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
printchar:
	pusha
	mov ah, 0Eh
	mov bh, 0
	mov bl, 0Fh
	int 10h
	popa
	ret
