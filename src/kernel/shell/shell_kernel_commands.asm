	mov si, command_panic
	call string_streq
	jc kernel_panic
