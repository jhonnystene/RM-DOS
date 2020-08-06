; Floppy programs for SMASH

; Read floppy data into memory
floppy_read:
	; First, we need to figure out where to start reading from.
	mov si, .start_point_msg
	call screen_puts
	call shell_get_string
	mov si, string_buffer
	call string_to_int
	mov cx, ax
	
	; Then, we need to know how many sectors to read.
	mov si, .count_msg
	call screen_puts
	call shell_get_string
	mov si, string_buffer
	call string_to_int
	
	; Put the values in the proper spots, and read the sectors.
	mov bl, al
	mov ax, cx
	call floppy_read_sectors
	
	jmp shell_start
	
	.start_point_msg db "Sector to start: ", 0
	.count_msg db		"Count: ", 0
	

; Show a hexdump of first loaded sector
; TODO: Let user choose what sector to dump
floppy_dump:
	mov bx, 0
	mov cx, 0
	.loop:
		mov al, [Buffer + bx]
		call screen_print_2hex
		;mov al, ' '
		;call screen_putchar
		inc bx
		inc cx
		cmp bx, 512
		je .done
		cmp cx, 32
		je .newline
		jmp .loop
	
	.newline:
		mov al, 10
		call screen_putchar
		mov al, 13
		call screen_putchar
		mov cx, 0
		jmp .loop
		
	.done:
		mov al, 10
		call screen_putchar
		mov al, 13
		call screen_putchar
		jmp shell_start

; Try to reset the floppy drive
floppy_test:
	call floppy_reset
	jc .error
	
	mov si, .text_good
	call screen_puts
	
	jmp shell_start
	
	.error:
		mov si, .text_error
		call screen_puts
		jmp shell_start
	
	.text_good	db "Floppy reset success!", 10, 13, 0
	.text_error	db "Floppy reset failure!", 10, 13, 0
	
command_floppy_test	db "FLOPPY RESET", 0
command_floppy_dump db "FLOPPY DUMP", 0
command_floppy_read db "FLOPPY READ", 0
