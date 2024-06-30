program_dir:
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

command_dir db "DIR", 0
