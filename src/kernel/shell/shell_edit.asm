; shell_edit.asm
shell_edit:
	call shell_edit_draw
	
	jmp shell_start

shell_edit_draw:
	ret

	.line_buffer times 64 db 0
	
shell_edit_row db 0

command_edit db "EDIT", 0
