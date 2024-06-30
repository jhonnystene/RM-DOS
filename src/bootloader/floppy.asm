reset_floppy:
	; First, reset floppy controller
	pusha
	mov ax, 0
	mov dl, [boot_device]
	stc
	int 13h
	
	; Check for error
	mov ah, 01h
	mov dl, [boot_device]
	int 13h
	jc .error
	popa
	ret
.error:
	mov si, .errormsg
	call screen_puts
	popa
	jmp reset_floppy
.errormsg db "RSTERR", 13, 10, 0

; In: AX - Logical Sector Number, CL - Sector Count
read_sectors:
	pusha

	call reset_floppy
	mov [.count], cl
	; Convert logical sector number to C,H,S
	push bx
	push ax
	mov bx, ax
	mov dx, 0
	div word [sectors_per_track]
	add dl, 01h
	mov cl, dl
	mov ax, bx
	mov dx, 0
	div word [sectors_per_track]
	mov dx, 0
	div word [sides]
	mov dh, dl
	mov ch, al
	pop ax
	pop bx

	; Finally, read the sectors
	mov ah, 02h
	mov al, [.count]
	mov dl, [boot_device]
	int 13h
	jc .error
	
	popa
	ret
.error:
	mov si, .errmessage
	call screen_puts
	popa
	jmp read_sectors
.errmessage db "LODERR", 13, 10, 0
.count db 0
