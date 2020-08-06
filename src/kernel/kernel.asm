; RM-DOS (Real Mode Disk Operating System)
; Keep it real
; Bismuth Kernel

BITS 16

callvectors:
	; Core kernel functions
	jmp kernel_bootstrap			; Setup stack and segmenting, then call kernel_init.
	jmp kernel_init					; Do any needed init functions, then start the shell.
	jmp kernel_hang					; Freeze the kernel
	jmp kernel_panic				; Dump registers and hang.
	
	; Screen driver functions
	jmp screen_enter_video_mode		; Switch to video mode
	jmp screen_enter_text_mode		; Switch to text mode
	jmp screen_clear				; Empty the screen
	jmp screen_set_cursor			; Set the cursor position
	jmp screen_puts					; Print a string to the screen.
	jmp screen_putchar				; Print a single character to the screen.
	jmp screen_newline				; Print a newline + carriage return.
	jmp screen_print_2hex			; Print an 8-bit value to screen.
	jmp screen_print_4hex			; Print a 16-bit value to screen.
	
	; Keyboard driver functions
	jmp keyboard_waitkey 			; Wait for a key to be pressed, and return that key.
	
	; Floppy driver functions
	jmp floppy_reset 				; Reset the floppy controller.
	jmp floppy_check_error			; Check if an error has occurred in the floppy controller.
	jmp floppy_get_location			; Returns the needed registers for int 13h for a given logical sector.
	jmp floppy_read_sectors			; Reads any number of sectors into the disk buffer.
	jmp floppy_read_root_directory	; Loads the FAT16 root directory into the disk buffer.
	jmp floppy_read_fat				; Loads the first FAT into the disk buffer.
	
	; String functions
	jmp string_streq				; Check if two strings are equal.
	jmp string_strlen				; Check the length of a string.
	jmp string_char_upper			; Return the uppercase version of a character.
	jmp string_to_int				; Convert a string to an integer.
	
	; Shell functions
	jmp shell_get_string			; Get a string as input.
	jmp shell_start					; Initialize the shell.

; Setup stack and segmenting and boot OS
kernel_bootstrap:
	cli
	mov ax, 0
	mov ss, ax
	mov sp, 0FFFFh
	sti
	cld
	mov ax, 2000h
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	jmp kernel_init

kernel_init:
	; Print welcome message
	call screen_clear
	mov si, kernel_msg_osname
	call screen_puts
	mov si, kernel_msg_copyright
	call screen_puts
	
	call shell_start
	
	; We should never get here unless the shell crashed
	jmp kernel_panic
	
kernel_hang:
	jmp kernel_hang

kernel_panic:
	mov dx, 0
	call screen_set_cursor
	mov si, kernel_panic_msg
	call screen_puts
	mov si, kernel_panic_msg_halted
	call screen_puts
	call kernel_dump_regs
	jmp kernel_hang

kernel_dump_regs:
	pusha
	mov si, kernel_panic_msg_ax
	call screen_puts
	call screen_print_4hex
	call screen_newline
	mov si, kernel_panic_msg_bx
	call screen_puts
	mov ax, bx
	call screen_print_4hex
	call screen_newline
	mov si, kernel_panic_msg_cx
	call screen_puts
	mov ax, cx
	call screen_print_4hex
	call screen_newline
	mov si, kernel_panic_msg_dx
	call screen_puts
	mov ax, dx
	call screen_print_4hex
	call screen_newline
	popa
	ret
	
; BOOT MESSAGES
kernel_msg_osname	 			db "The Real Mode Disk Operating System (RM-DOS)", 13, 10, 0
kernel_msg_copyright			db "Copyright (c) 2020 Johnny Stene. Some Rights Reserved.", 13, 10, 0

; PANIC MESSAGES
kernel_panic_msg				db "Kernel PANIC!", 13, 10, 0
kernel_panic_msg_halted			db "System halted.", 13, 10, 0
kernel_panic_msg_ax				db "AX: ", 0
kernel_panic_msg_bx				db "BX: ", 0
kernel_panic_msg_cx				db "CX: ", 0
kernel_panic_msg_dx				db "DX: ", 0
kernel_panic_msg_si				db "SI: ", 0
kernel_panic_msg_di				db "DI: ", 0

; DRIVERS
%include "src/kernel/drivers/floppy.asm"
%include "src/kernel/drivers/screen.asm"
%include "src/kernel/drivers/keyboard.asm"

; LIBRARIES
%include "src/kernel/libraries/string.asm"

; OTHER
%include "src/kernel/shell/shell.asm"
