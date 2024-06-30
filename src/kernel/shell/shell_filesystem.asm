fs_test:
	mov si, .test_filename
	call fs_read_file
	jc .print
	mov si, .fail_msg
	call screen_puts
	jmp shell_start
.print:
	mov si, file_buffer
	call screen_puts
	jmp shell_start
.fail_msg db "FAIL", 0
.kernel_filename db "KERNEL.SYS", 0
.test_filename db "TEST.FILE", 0

ls:
	call fs_validate_partition
	jc .good
	mov si, fs_invalid_message
	call screen_puts
	popa
	ret
.good:
	call fs_load_file_table
	mov bx, floppy_buffer
	mov cx, bx
	add cx, 512
.search_loop:
	; Check to make sure filename isn't blank
	mov ax, [bx]
	cmp ax, 0
	je .search_next
	mov si, bx
	call screen_puts
	mov al, ' '
	call screen_putchar
.search_next:
	add bx, 16
	cmp bx, cx
	je .done
	jmp .search_loop
.done:
	call screen_newline
	jmp shell_start

fs_test_command db "FS TEST", 0
ls_command db "LS", 0
