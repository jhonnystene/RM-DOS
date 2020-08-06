; Super Mega Awesome SHell (SMASH)
; Wanna SMASH?

; TODO: Load into somewhere the user wants.
shell_get_string:
	mov bx, 0 ; This line was missing and caused me 3 hours of debugging.
	.loop:
		call keyboard_waitkey
		
		cmp al, 13
		je .newline
		
		cmp al, 08
		je .backspace
		
		call string_char_upper
		mov byte [string_buffer + bx], al
		inc bx
		
		; Are we about to write past the buffer?
		cmp bx, 63
		je .newline
		
		call screen_putchar
		jmp .loop
		
	.newline:
		mov al, 13
		call screen_putchar
		mov al, 10
		call screen_putchar
		mov byte [string_buffer + bx], 0
		ret
		
	.backspace:
		cmp bx, 0
		je .loop
		
		mov byte [string_buffer + bx], 0
		dec bx
		mov al, 08
		call screen_putchar
		mov al, ' '
		call screen_putchar
		mov al, 08
		call screen_putchar
		jmp .loop

shell_start:
	mov si, prompt
	call screen_puts
	mov bx, 0
	
	call shell_get_string
	
	mov byte [string_buffer + bx], 0
	mov di, string_buffer
	
	mov si, command_about
	call string_streq
	jc about
	
	mov si, command_milestone
	call string_streq
	jc milestone
	
	mov si, command_floppy_test
	call string_streq
	jc floppy_test
	
	mov si, command_mode_text
	call string_streq
	jc mode_text
	
	mov si, command_mode_video
	call string_streq
	jc mode_video
	
	mov si, command_panic
	call string_streq
	jc kpanic
	
	mov si, command_floppy_dump
	call string_streq
	jc floppy_dump
	
	mov si, command_floppy_read
	call string_streq
	jc floppy_read
	
	jmp shell_start

kpanic:
	jmp kernel_panic

mode_text:
	call screen_enter_text_mode
	jmp shell_start

mode_video:
	call screen_enter_video_mode
	jmp shell_start
		
about:
	mov si, kernel_msg_osname
	call screen_puts
	
	mov si, kernel_msg_copyright
	call screen_puts
	
	mov si, .text_1
	call screen_puts
	
	mov si, .text_2
	call screen_puts
	
	jmp shell_start
	
	.text_1		db "Kernel: Bismuth v0.1a Alpha", 10, 13, 0
	.text_2		db "Shell: Super Mega Awesome SHell (SMASH) v1", 10, 13, 0
	
milestone:
	mov si, .text_1
	call screen_puts
	
	mov si, .text_2
	call screen_puts
	
	mov si, .text_3
	call screen_puts
	
	mov si, .text_4
	call screen_puts
	
	jmp shell_start

	.text_1	db "Last completed milestone: 1", 10, 13, 0
	.text_2	db "Milestone 1: Interactable shell", 10, 13, 0
	.text_3	db "Milestone 2: Floppy Driver w/ file API", 10, 13, 0
	.text_4	db "Milestone 3: Graphics APIs", 10, 13, 0

prompt db "> ", 0
string_buffer times 64 db 0

command_about		db "ABOUT", 0
command_milestone	db "MILESTONE", 0
command_mode_video	db "MODE VIDEO", 0
command_mode_text	db "MODE TEXT", 0
command_panic		db "PANIC", 0

; INCLUDE FLOPPY PROGRAMS
%include "src/kernel/shell/shell_floppy.asm"
