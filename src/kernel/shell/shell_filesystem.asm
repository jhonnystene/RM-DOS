shell_fs_test:
	mov ax, 1
	mov bx, .filename_buffer

	.loop:
		cmp ax, fat12_max_root_directory_entries
		je .done
	
		push ax
		push bx
		mov ax, .filename_buffer
		mov bx, 12
		call kernel_memory_erase
		pop bx
		pop ax
		
		call fat12_get_filename
		inc ax
		jnc .display
		
		jmp .loop
		
	.display:
		mov si, .filename_buffer
		call screen_puts
		call screen_newline
		jmp .loop
		
	.done:
		jmp shell_start
	
	.filename_buffer times 12 db 0

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
