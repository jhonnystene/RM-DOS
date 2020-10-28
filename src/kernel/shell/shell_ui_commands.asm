	mov si, command_bottombar
	call string_streq
	jc shell_bottombar
