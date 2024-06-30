program_disk:
	mov si, [shell_argument]
	
	mov di, .explore
	call string_streq
	jc program_disk_explore
	
	mov si, .usage
	call screen_puts
	
	jmp shell_start
.explore db "EXPLORE", 0
.usage db "Usage: DISK [EXPLORE]", 13, 10, 0

; Let user explore around the floppy
program_disk_explore:
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
		call program_disk_explore_dump_sector
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

program_disk_explore_dump_sector:
	pusha
	mov bx, 0
	mov cx, 0
	call .spaces
	
	.loop:
		mov al, [floppy_buffer + bx]
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
	
	.spaces:
		push ax
		mov al, ' '
		mov ah, 8
		call screen_repeatchar
		pop ax
		ret
	
	.newline:
		call screen_newline
		mov cx, 0
		call .spaces
		jmp .loop
		
	.done:
		call screen_newline
		popa
		ret

command_disk db "DISK", 0
