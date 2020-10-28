floppy_reset:
	pusha
	mov ax, 0
	mov dl, [floppy_boot_device]
	stc
	int 13h
	call floppy_check_error
	popa
	ret
	
floppy_check_error:
	pusha
	mov ah, 01h
	mov dl, [floppy_boot_device]
	int 13h
	popa
	ret
	
; IN: AX - Logical sector
; OUT: Needed params for int 13h
floppy_get_location:
	push bx
	push ax
	mov bx, ax
	mov dx, 0
	div word [floppy_sectors_per_track]
	add dl, 01h
	mov cl, dl
	mov ax, bx
	mov dx, 0
	div word [floppy_sectors_per_track]
	mov dx, 0
	div word [floppy_sides]
	mov dh, dl
	mov ch, al
	pop ax
	pop bx
	mov dl, [floppy_boot_device]
	ret

; In: AX - Logical Sector Number, BL - Sector Count
; Out: floppy_buffer - Data
floppy_read_sectors:
	call floppy_reset
	pusha
	call floppy_get_location
	mov ah, 02h
	mov al, bl
	mov bx, floppy_buffer
	int 13h
	jc .error
	popa
	ret

	.error:
		mov si, floppy_error_msg
		call screen_puts
		mov al, ah
		call screen_print_2hex
		mov al, 13
		call screen_putchar
		mov al, 10
		call screen_putchar
		popa
		ret

floppy_error_msg	db "[floppy.asm] Floppy error ", 0

floppy_sectors_per_track		dw 18
floppy_sides					dw 2
floppy_boot_device				db 0
floppy_buffer					equ 24576
