shell_get_string:
	mov bx, 0 ; This line was missing and caused me 3 hours of debugging.
	.loop:
		call keyboard_waitkey
		
		cmp al, 13
		je .newline
		
		cmp al, 08
		je .backspace
		
		call string_char_upper
		mov byte [shell_buffer + bx], al
		inc bx
		
		; Are we about to write past the buffer?
		cmp bx, 63
		je .newline
		
		call screen_putchar
		jmp .loop
		
	.newline:
		mov al, 13
		call screen_putchar
		mov al, 10
		call screen_putchar
		mov byte [shell_buffer + bx], 0
		ret
		
	.backspace:
		cmp bx, 0
		je .loop
		
		mov byte [shell_buffer + bx], 0
		dec bx
		mov al, 08
		call screen_putchar
		mov al, ' '
		call screen_putchar
		mov al, 08
		call screen_putchar
		jmp .loop

shell_start:
	; Print prompt
	mov si, .flp_text
	call screen_puts
	mov al, [floppy_boot_device]
	add al, '0'
	call screen_putchar
	mov si, .prompt
	call screen_puts
	mov bx, 0
	
	; Get string
	call shell_get_string
	mov byte [shell_buffer + bx], 0
	mov bx, 0
	mov [shell_argument], bx
.split_command: ; Break off the command part of the string
	mov al, [shell_buffer + bx]
	cmp al, 0
	je .skip_argument
	cmp al, ' '
	je .split_argument
	mov [shell_command + bx], al
	inc bx
	cmp bx, 16
	je .process
	jmp .split_command
.skip_argument: ; Ignore rest of command
	mov ax, 0
	mov [shell_command + bx], ax
	jmp .process
.split_argument: ; Break off the argument part of the string into pointer (if needed)
	push bx
	add bx, shell_command
	mov byte [bx], 0
	pop bx
	inc bx
	add bx, shell_buffer
	mov [shell_argument], bx
.process: ; Process command
	mov di, shell_command
	
	; Builtin commands
	; CLS
	mov si, command_cls
	call string_streq
	jc program_cls
	; DIR
	mov si, command_dir
	call string_streq
	jc program_dir
	; DISK
	mov si, command_disk
	call string_streq
	jc program_disk
	; HELP
	mov si, command_help
	call string_streq
	jc program_help
	; TYPE
	mov si, command_type
	call string_streq
	jc program_type
	
	mov si, shell_command
	call fs_file_exists
	jc .load_binary
	
	mov si, .invalid_command
	call screen_puts
	
	jmp shell_start
.load_binary:
	call fs_read_file
	jc .load_success
	mov si, .load_failure
	call screen_puts
	jmp shell_start
.load_success:
	mov si, [shell_argument]
	pusha
	call 8000h ; Jump to loaded file
	popa
	jmp shell_start
	
.prompt db "> ", 0
.flp_text db "flp", 0
.invalid_command db "Invalid command. Enter HELP for help.", 13, 10, 0
.load_failure db "Failed to load application file.", 13, 10, 0
shell_command times 16 db 0
shell_argument dw 0
shell_buffer times 64 db 0

command_panic		db "PANIC", 0

; INCLUDE MODULES
%include "src/kernel/programs/cls.asm"
%include "src/kernel/programs/dir.asm"
%include "src/kernel/programs/disk.asm"
%include "src/kernel/programs/help.asm"
%include "src/kernel/programs/type.asm"
