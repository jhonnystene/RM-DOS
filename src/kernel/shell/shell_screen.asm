mode_text:
	call screen_enter_text_mode
	jmp shell_start

mode_video:
	call screen_enter_video_mode
	jmp shell_start
		
about:
	mov si, kernel_msg_copyright
	call screen_puts
	
	jmp shell_start

cls:
	call screen_clear
	jmp shell_start

command_about		db "ABOUT", 0
command_mode_video	db "MODE VIDEO", 0
command_mode_text	db "MODE TEXT", 0
command_cls			db "CLS", 0
