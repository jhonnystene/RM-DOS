program_type:
	mov si, [shell_argument]
	call fs_read_file
	jc .print
	mov si, .fail_msg
	call screen_puts
	call screen_newline
	jmp shell_start
.print:
	mov si, file_buffer
	call screen_puts
	jmp shell_start
.fail_msg db "Read failure", 0

command_type db "TYPE", 0
