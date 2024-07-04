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
		call floppy_error
		jc .retry
		jmp .fail
		
	.retry:
		popa
		pusha
		jmp floppy_read_sectors
	
	.fail:
		popa
		ret

; In: AX - Logical Sector Number, BX - Location
; Out: floppy_buffer - Data
floppy_read_sector_to:
	call floppy_reset
	pusha
	call floppy_get_location
	mov ah, 02h
	mov al, 1
	int 13h
	jc .error
	popa
	ret

	.error:
		call floppy_error
		jc .retry
		jmp .fail
		
	.retry:
		popa
		pusha
		jmp floppy_read_sector_to
	
	.fail:
		popa
		ret

; In: AX - Logical Sector Number, BL - Sector Count
; Out: floppy_buffer - Data
floppy_write_sectors:
	call floppy_reset
	pusha
	call floppy_get_location
	mov ah, 03h
	mov al, bl
	mov bx, floppy_buffer
	int 13h
	jc .error
	popa
	ret

	.error:
		call floppy_error
		jc .retry
		jmp .fail
	
	.retry:
		popa
		pusha
		jmp floppy_write_sectors
	
	.fail:
		popa
		ret

; Out: Carry - set if retry, clear if fail
floppy_error:
	pusha
	mov si, floppy_error_msg
	call screen_puts
	mov al, ah
	call screen_print_2hex
	call screen_newline
	
	mov si, floppy_error_msg2
	call screen_puts
	call keyboard_waitkey
	call string_char_upper
	call screen_putchar
	call screen_newline
	
	cmp al, 'A'
	je kernel_bootstrap
	cmp al, 'F'
	je .fail
	cmp al, 'R'
	je .retry
	popa
	jmp floppy_error
.fail:
	popa
	clc
	ret
.retry:
	popa
	stc
	ret

floppy_error_msg	db "Floppy error ", 0
floppy_error_msg2	db "Abort/Retry/Fail? ", 0

floppy_sectors_per_track		dw 18
floppy_sides					dw 2
floppy_boot_device				db 0
floppy_buffer					equ 24576
file_buffer						equ 32768
