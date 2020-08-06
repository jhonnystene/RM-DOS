fuckin_padding: ; For some fucking STUPID reason, the OS shits itself if you try to run the top function of this file.
	ret ; We avoid that by having the top function be unused.

; IN: SI, DI - string 1, string 2
; OUT: carry if same
string_streq:
	pusha
	.loop:
		mov al, [si]
		mov bl, [di]
		
		cmp al, bl
		jne .different
		
		cmp al, 0
		je .end
		
		inc si
		inc di
		jmp .loop
	
	.different:
		popa
		clc
		ret
	
	.end:
		popa
		stc
		ret

; IN: SI - String
; OUT: AX - Length
string_strlen:
	pusha
	mov bx, ax
	mov cx, 0
	.loop:
		cmp byte [bx], 0
		je .done
		inc bx
		inc cx
		jmp .loop
	.done:
		mov word [.tmp], cx
		popa
		mov ax, [.tmp]
		ret
	
	.tmp dw 0
	
; IN/OUT: AL - Character
string_char_upper:
	cmp al, 'a'
	jb .done
	cmp al, 'z'
	ja .done
	sub al, 20h
	ret
	.done:
		ret
		
; IN: SI: String
; OUT: AX: Number
string_to_int:
	pusha
	mov ax, si
	call string_strlen
	add si, ax
	dec si
	mov cx, ax
	mov bx, 0
	mov ax, 0
	mov word [.multi], 1
	
	.loop:
		mov ax, 0
		mov byte al, [si]
		sub al, 48
		mul word [.multi]
		add bx, ax
		push ax
		mov word ax, [.multi]
		mov dx, 10
		mul dx
		mov word [.multi], ax
		pop ax
		dec cx
		cmp cx, 0
		je .finish
		dec si
		jmp .loop
	
	.finish:
		; This section works fine.
		mov word [.tmp], bx
		popa
		mov word ax, [.tmp]
		ret
		
		.multi dw 0
		.tmp dw 0
