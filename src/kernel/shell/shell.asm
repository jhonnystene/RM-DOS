; Super Mega Awesome SHell (SMASH)
; Wanna SMASH?

; TODO: Load into somewhere the user wants.
shell_get_string:
	mov bx, 0 ; This line was missing and caused me 3 hours of debugging.
	.loop:
		call keyboard_waitkey
		
		cmp al, 13
		je .newline
		
		cmp al, 08
		je .backspace
		
		call string_char_upper
		mov byte [string_buffer + bx], al
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
		mov byte [string_buffer + bx], 0
		ret
		
	.backspace:
		cmp bx, 0
		je .loop
		
		mov byte [string_buffer + bx], 0
		dec bx
		mov al, 08
		call screen_putchar
		mov al, ' '
		call screen_putchar
		mov al, 08
		call screen_putchar
		jmp .loop

prompt db "> ", 0
string_buffer times 64 db 0

; INCLUDE MODULES
%include "src/kernel/shell/shell_floppy.asm"
%include "src/kernel/shell/shell_screen.asm"
%include "src/kernel/shell/shell_kernel.asm"
%include "src/kernel/shell/shell_edit.asm"
%include "src/kernel/shell/shell_filesystem.asm"
%include "src/kernel/shell/shell_ui.asm"

shell_start:
	mov si, prompt
	call screen_puts
	mov bx, 0
	
	call shell_get_string
	
	mov byte [string_buffer + bx], 0
	mov di, string_buffer
	
	; INCLUDE MODULES
	%include "src/kernel/shell/shell_floppy_commands.asm"
	%include "src/kernel/shell/shell_screen_commands.asm"
	%include "src/kernel/shell/shell_kernel_commands.asm"
	%include "src/kernel/shell/shell_edit_commands.asm"
	%include "src/kernel/shell/shell_filesystem_commands.asm"
	%include "src/kernel/shell/shell_ui_commands.asm"
		
	jmp shell_start
