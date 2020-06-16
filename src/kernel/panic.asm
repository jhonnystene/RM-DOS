hang:
	jmp hang

; Inputs: AH - Error code
panic:
	mov si, panicmessage_header
	call printstring
	
	; Do we know what the code *is*?
	cmp ah, 0
	je .unknown
	
	cmp ah, 1
	je .user
	
	jmp .finish
	
	.unknown: ; Code 0
		mov si, panicmessage_unknown
		call printstring
		jmp .finish
	
	.user: ; Code 1
		mov si, panicmessage_user
		call printstring
		jmp .finish
	
	.finish:
		mov si, panicmessage_halted
		call printstring
		jmp hang

panicmessage_header db "Kernel PANIC!", 0
panicmessage_halted db "System halted.", 0

; Code 0
panicmessage_unknown db "Unknown error!", 0

; Code 1
panicmessage_user db "User requested panic!", 0
