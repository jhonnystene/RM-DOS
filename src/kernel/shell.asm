; Super Mega Awesome SHell (SMASH)
; Wanna SMASH?

shell_start:
	mov si, prompt
	call printstring
	mov bx, 0
	
	.loop:
		call waitkey
		
		cmp al, 13
		je .newline
		
		cmp al, 08
		je .backspace
		
		call char_upper
		mov byte [buffer + bx], al
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
		
		mov byte [buffer + bx], 0
		mov di, buffer
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
		
		jmp shell_start
	
	.backspace:
		cmp bx, 0
		je .loop
		
		mov byte [buffer + bx], 0
		dec bx
		mov al, 08
		call printchar
		mov al, ' '
		call printchar
		mov al, 08
		call printchar
		jmp .loop
		
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
buffer times 64 db 0

command_about		db "ABOUT", 0
command_milestone	db "MILESTONE", 0
command_floppy_test	db "FLOPPY TEST", 0
command_mode_video	db "MODE VIDEO", 0
command_mode_text	db "MODE TEXT", 0
