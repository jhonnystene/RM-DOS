	mov si, command_fs_fat12_test
	call string_streq
	jc shell_fs_test
	
	mov si, command_fs_fat12_dump
	call string_streq
	jc shell_fs_dump
