program_help:
	call screen_clear
	mov si, .help1
	call screen_puts
	mov si, .help2
	call screen_puts
	mov si, .help3
	call screen_puts
	mov si, .help4
	call screen_puts
	mov si, .help5
	call screen_puts
	mov si, .help6
	call screen_puts
	mov si, .help7
	call screen_puts
	mov si, .help8
	call screen_puts
	jmp shell_start
.help1 db "RM-DOS Help", 13, 10, 0
.help2 db "=============", 13, 10, 0
.help3 db "", 13, 10, 0
.help4 db "CLS - Clears the screen", 13, 10, 0
.help5 db "DIR - Lists files on the disk", 13, 10, 0
.help6 db "DISK - Floppy disk utilities", 13, 10, 0
.help7 db "HELP - This screen", 13, 10, 0
.help8 db "TYPE <file name> - Print the contents of a file", 13, 10, 0

command_help db "HELP", 0
