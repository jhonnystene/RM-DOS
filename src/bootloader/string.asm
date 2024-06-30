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
