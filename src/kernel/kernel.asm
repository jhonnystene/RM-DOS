; RM-DOS (Real Mode Disk Operating System)
; Keep it real

BITS 16

callvectors: ; TODO: Update these
	; Core kernel functions
	jmp kernel_bootstrap				; Setup stack and segmenting, then call kernel_init.
	jmp kernel_init						; Do any needed init functions, then start the shell.
	jmp kernel_hang						; Freeze the kernel
	jmp kernel_panic					; Dump registers and hang.
	jmp kernel_dump_regs				; Dump CPU registers to screen.
	
	; Kernel memory functions	
	jmp kernel_memory_copy				; Copy memory from one location to another
	jmp kernel_memory_erase				; Erase a chunk of memory
	
	; Screen driver functions
	jmp screen_clear					; Empty the screen
	jmp screen_set_cursor				; Set the cursor position
	jmp screen_puts						; Print a string to the screen.
	jmp screen_putchar					; Print a single character to the screen.
	jmp screen_newline					; Print a newline + carriage return.
	jmp screen_print_2hex				; Print an 8-bit value to screen.
	jmp screen_print_4hex				; Print a 16-bit value to screen.
	
	; Keyboard driver functions	
	jmp keyboard_waitkey 				; Wait for a key to be pressed, and return that key.
	
	; Floppy driver functions
	jmp floppy_reset 					; Reset the floppy controller.
	jmp floppy_check_error				; Check if an error has occurred in the floppy controller.
	jmp floppy_get_location				; Returns the needed registers for int 13h for a given logical sector.
	jmp floppy_read_sectors				; Reads any number of sectors into the disk floppy_buffer.
	jmp floppy_write_sectors			; Writes any number of sectors onto the disk from the floppy_buffer.
	
	; String functions
	jmp string_streq					; Check if two strings are equal.
	jmp string_strlen					; Check the length of a string.
	jmp string_char_upper				; Return the uppercase version of a character.
	jmp string_to_int					; Convert a string to an integer.
	
	; Shell functions
	jmp shell_get_string				; Get a string as input.
	jmp shell_start						; Initialize the shell.
	
	; IRQ and PIT functions
	jmp irq_IRQ0_handler
	jmp irq_init_pit
	jmp irq_init_ivt

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
	mov gs, ax
	mov fs, ax
	mov es, ax
	
	mov [floppy_boot_device], dl
	
	call screen_clear
	jmp kernel_init

kernel_init:
	; Initialize inturrupts
	call irq_init_ivt
	;call irq_init_pit ; This causes issues for some reason so I'm scrapping it for now.
	
	; Initialize high memory
	call a20_enable
	
	; Print welcome message and start shell
	mov si, kernel_msg_version
	call screen_puts
	mov si, kernel_msg_copyright
	call screen_puts
	
	call shell_start
	
	; We should never get here unless the shell crashed
	jmp kernel_panic

; KERNEL MODULES
%include "src/kernel/modules/printregs.asm"
%include "src/kernel/modules/panic.asm"
%include "src/kernel/modules/systools.asm"
%include "src/kernel/modules/string.asm"
%include "src/kernel/modules/fs.asm"
%include "src/kernel/modules/shell.asm"

; DRIVERS
%include "src/kernel/drivers/floppy.asm"
%include "src/kernel/drivers/screen.asm"
%include "src/kernel/drivers/keyboard.asm"
%include "src/kernel/drivers/memory.asm"
%include "src/kernel/drivers/irq.asm"
%include "src/kernel/drivers/a20.asm"

kernel_msg_version				db "RM-DOS beta 0.1b", 13, 10, 0
kernel_msg_copyright			db "Copyright (c) 2024 Johnny Stene. MIT License.", 13, 10, 0
