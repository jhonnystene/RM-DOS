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
		
		; TODO: Run command
		mov di, buffer
		
		mov si, command_about
		call stringsequal
		jc about
		
		mov si, command_milestone
		call stringsequal
		jc milestone
		
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
		
about:
	mov si, about_text_1
	call printstring
	mov si, about_text_2
	call printstring
	mov si, about_text_3
	call printstring
	jmp shell_start
	
milestone:
	mov si, milestone_text_1
	call printstring
	mov si, milestone_text_2
	call printstring
	mov si, milestone_text_3
	call printstring
	mov si, milestone_text_4
	call printstring
	jmp shell_start

prompt db "> ", 0
buffer times 64 db 0

command_about		db "ABOUT", 0
about_text_1		db "The Real Mode Disk Operating System (RM-DOS) By Johnny Stene", 10, 13, 0
about_text_2		db "Kernel: Bismuth v0.1a Alpha", 10, 13, 0
about_text_3		db "Shell: Super Mega Awesome SHell (SMASH) v1", 10, 13, 0

command_milestone	db "MILESTONE", 0
milestone_text_1	db "Last completed milestone: 1", 10, 13, 0
milestone_text_2	db "Milestone 1: Interactable shell", 10, 13, 0
milestone_text_3	db "Milestone 2: Floppy Driver w/ file API", 10, 13, 0
milestone_text_4	db "Milestone 3: Graphics APIs", 10, 13, 0
