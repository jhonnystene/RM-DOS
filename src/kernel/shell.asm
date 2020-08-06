; Super Mega Awesome SHell (SMASH)
; Wanna SMASH?

get_string:
	mov bx, 0 ; This line was missing and caused me 3 hours of debugging.
	.loop:
		call waitkey
		
		cmp al, 13
		je .newline
		
		cmp al, 08
		je .backspace
		
		call char_upper
		mov byte [string_buffer + bx], al
		inc bx
		
		; Are we about to write past the buffer?
		cmp bx, 63
		je .newline
		
		call printchar
		jmp .loop
		
	.newline:
		mov al, 13
		call printchar
		mov al, 10
		call printchar
		mov byte [string_buffer + bx], 0
		ret
		
	.backspace:
		cmp bx, 0
		je .loop
		
		mov byte [string_buffer + bx], 0
		dec bx
		mov al, 08
		call printchar
		mov al, ' '
		call printchar
		mov al, 08
		call printchar
		jmp .loop

shell_start:
	mov si, prompt
	call printstring
	mov bx, 0
	
	call get_string
	
	mov byte [string_buffer + bx], 0
	mov di, string_buffer
	
	mov si, command_about
	call stringsequal
	jc about
	
	mov si, command_milestone
	call stringsequal
	jc milestone
	
	mov si, command_floppy_test
	call stringsequal
	jc floppy_test
	
	mov si, command_mode_text
	call stringsequal
	jc mode_text
	
	mov si, command_mode_video
	call stringsequal
	jc mode_video
	
	mov si, command_panic
	call stringsequal
	jc kpanic
	
	mov si, command_hex_test
	call stringsequal
	jc hextest
	
	mov si, command_floppy_dump
	call stringsequal
	jc floppy_dump
	
	mov si, command_floppy_read
	call stringsequal
	jc floppy_read
	
	jmp shell_start
	
floppy_read:
	; First, we need to figure out where to start reading from.
	mov si, .start_point_msg
	call printstring
	call get_string
	mov si, string_buffer
	call string_to_number
	mov cx, ax
	
	; Then, we need to know how many sectors to read.
	mov si, .count_msg
	call printstring
	call get_string
	mov si, string_buffer
	call string_to_number
	
	; Put the values in the proper spots, and read the sectors.
	mov bl, al
	mov ax, cx
	call floppy_read_sectors
	
	jmp shell_start
	
	.start_point_msg db "Sector to start: ", 0
	.count_msg db		"Count: ", 0
	
floppy_dump:
	mov bx, 0
	mov cx, 0
	.loop:
		mov al, [Buffer + bx]
		call printhex
		;mov al, ' '
		;call printchar
		inc bx
		inc cx
		cmp bx, 512
		je .done
		cmp cx, 32
		je .newline
		jmp .loop
	
	.newline:
		mov al, 10
		call printchar
		mov al, 13
		call printchar
		mov cx, 0
		jmp .loop
		
	.done:
		mov al, 10
		call printchar
		mov al, 13
		call printchar
		jmp shell_start
	
hextest:
	mov al, 0Fh
	call printhex
	jmp shell_start

kpanic:
	mov ah, 1
	jmp panic

mode_text:
	call enter_text_mode
	jmp shell_start

mode_video:
	call enter_video_mode
	jmp shell_start
		
floppy_test:
	call floppy_reset
	jc .error
	
	mov si, .text_good
	call printstring
	
	jmp shell_start
	
	.error:
		mov si, .text_error
		call printstring
		jmp shell_start
	
	.text_good	db "Floppy reset success!", 10, 13, 0
	.text_error	db "Floppy reset failure!", 10, 13, 0
		
about:
	mov si, kernelmsg_osname
	call printstring
	
	mov si, kernelmsg_copyright
	call printstring
	
	mov si, .text_1
	call printstring
	
	mov si, .text_2
	call printstring
	
	jmp shell_start
	
	.text_1		db "Kernel: Bismuth v0.1a Alpha", 10, 13, 0
	.text_2		db "Shell: Super Mega Awesome SHell (SMASH) v1", 10, 13, 0
	
milestone:
	mov si, .text_1
	call printstring
	
	mov si, .text_2
	call printstring
	
	mov si, .text_3
	call printstring
	
	mov si, .text_4
	call printstring
	
	jmp shell_start

	.text_1	db "Last completed milestone: 1", 10, 13, 0
	.text_2	db "Milestone 1: Interactable shell", 10, 13, 0
	.text_3	db "Milestone 2: Floppy Driver w/ file API", 10, 13, 0
	.text_4	db "Milestone 3: Graphics APIs", 10, 13, 0

prompt db "> ", 0
string_buffer times 64 db 0

command_about		db "ABOUT", 0
command_milestone	db "MILESTONE", 0
command_floppy_test	db "FLOPPY RESET", 0
command_floppy_dump db "FLOPPY DUMP", 0
command_floppy_read db "FLOPPY READ", 0
command_mode_video	db "MODE VIDEO", 0
command_mode_text	db "MODE TEXT", 0
command_hex_test	db "HEX TEST", 0
command_panic		db "PANIC", 0
