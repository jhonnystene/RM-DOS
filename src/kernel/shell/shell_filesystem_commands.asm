	mov si, fs_test_command
	call string_streq
	jc fs_test

	mov si, ls_command
	call string_streq
	jc ls
