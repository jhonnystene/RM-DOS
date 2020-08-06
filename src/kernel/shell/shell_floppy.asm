; Floppy programs for SMASH

; Let user explore around the floppy
shell_floppy_explore:
	mov cx, 0
	
	.loop:
		; Clear the screen and print the logical sector number in the center of the screen.
		call screen_clear
		mov ah, 34
		mov al, ' '
		call screen_repeatchar
		mov si, .sector_msg
		call screen_puts
		mov ax, cx
		mov bx, 1
		call screen_print_4hex
		call screen_newline
		
		; Load in the logical sector and write it to the screen.
		call floppy_read_sectors
		call screen_dump_floppy_sector
		call screen_newline
		
		; Print out the controls in the middle of the screen.
		mov ah, 12
		mov al, ' '
		call screen_repeatchar
		mov si, .controls_msg
		call screen_puts
		
		; Get the key pressed and check to see if it's a real command.
		call keyboard_waitkey
		call string_char_upper
		cmp al, 'A'
		je .back
		cmp al, 'D'
		je .forward
		cmp al, 'S'
		je shell_start
		jmp .loop
	
	.back:
		cmp cx, 0
		je .loop
		dec cx
		jmp .loop
	
	.forward:
		inc cx
		jmp .loop
	
	.sector_msg		db "Sector: ", 0
	.controls_msg	db "A: Move back a sector, D: Move forward a sector, S: Exit", 13, 10, 0

; Read floppy data into memory
shell_floppy_read:
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
shell_floppy_dump:
	call screen_dump_floppy_sector
	jmp shell_start

command_floppy_dump 		db "FLOPPY DUMP", 0
command_floppy_read 		db "FLOPPY READ", 0
command_floppy_explore		db "FLOPPY EXPLORE", 0
