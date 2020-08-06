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
	
command_about		db "ABOUT", 0
command_milestone	db "MILESTONE", 0
command_mode_video	db "MODE VIDEO", 0
command_mode_text	db "MODE TEXT", 0
