shell_fs_test:
	mov si, .testing_message
	call screen_puts
	mov si, .kernel_filename
	call fat12_search_for_file
	jc .found
	mov si, .not_found_message
	call screen_puts
	jmp shell_start
	
	.found:
		mov si, .found_message
		call screen_puts
		jmp shell_start
	
	.kernel_filename	db "KERNEL  BIN", 0
	.found_message		db "Test PASS!", 13, 10, 0
	.not_found_message	db "Test FAIL - KERNEL.BIN not found.", 13, 10, 0
	.testing_message	db "Testing...", 13, 10, 0

shell_fs_dump:
	mov ax, 0
	mov bx, 0
	mov cx, 0
	call fat12_read_root_directory_entry
	
	.loop_entry:
		mov al, [fat12_root_directory_buffer + bx]
		call screen_print_2hex
		inc bx
		cmp bx, 32
		je .done_entry
		jmp .loop_entry
		
	.done_entry:
		call screen_newline
		inc cx
		cmp cx, 208
		je shell_start
		
		mov bx, 0
		push ax
		mov ax, cx
		call fat12_read_root_directory_entry
		pop ax
		jmp .loop_entry

command_fs_fat12_test db "FAT TEST", 0
command_fs_fat12_dump db "FAT DUMP", 0
