; RM-DOS (Real Mode Disk Operating System)
; Keep it real
; Bismuth Kernel

BITS 16
ORG 2000h

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
	jmp screen_enter_video_mode			; Switch to video mode
	jmp screen_enter_text_mode			; Switch to text mode
	jmp screen_clear					; Empty the screen
	jmp screen_set_cursor				; Set the cursor position
	jmp screen_puts						; Print a string to the screen.
	jmp screen_putchar					; Print a single character to the screen.
	jmp screen_newline					; Print a newline + carriage return.
	jmp screen_print_2hex				; Print an 8-bit value to screen.
	jmp screen_print_4hex				; Print a 16-bit value to screen.
	jmp screen_repeatchar				; Print a character repeatedly.
	jmp screen_dump_floppy_sector		; Dump floppy sector to screen.
	jmp screen_repeatchar				; Repeat a character on screen.
	
	; Keyboard driver functions	
	jmp keyboard_waitkey 				; Wait for a key to be pressed, and return that key.
	
	; Floppy driver functions
	jmp floppy_reset 					; Reset the floppy controller.
	jmp floppy_check_error				; Check if an error has occurred in the floppy controller.
	jmp floppy_get_location				; Returns the needed registers for int 13h for a given logical sector.
	jmp floppy_read_sectors				; Reads any number of sectors into the disk floppy_buffer.
	jmp floppy_write_sectors			; Writes any number of sectors onto the disk from the floppy_buffer.
		
	; FAT12 functions	
	jmp fat12_get_filename				; Get a filename for a given root directory entry
	jmp fat12_read_fat					; Read FAT into memory
	jmp fat12_read_root_directory		; Read root directory into memory
	jmp fat12_read_root_directory_entry	; Read root directory entry into memory
	jmp fat12_search_for_file			; Check if file exists
	
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
	
	call screen_clear
	jmp kernel_init

kernel_init:
	; Initialize inturrupts
	call irq_init_ivt
	;call irq_init_pit ; This causes issues for some reason so I'm scrapping it for now.
	
	; Initialize high memory
	call a20_enable
	call screen_print_ram
	
	; Print kernel information
	mov si, kernel_msg_loaded_to_segment
	call screen_puts
	mov si, kernel_msg_stack_loaded
	call screen_puts
	
	; Print welcome message and start shell
	mov si, kernel_msg_welcome
	call screen_puts
	
	call shell_start
	
	; We should never get here unless the shell crashed
	jmp kernel_panic

; LOCALISATION
; Only one line should be included - the kernel needs to be built with the desired locale
%include "src/kernel/locales/EN-US.asm"

; TODO: Organize the below better

; KERNEL "MODULES"
%include "src/kernel/modules/printregs.asm"
%include "src/kernel/modules/panic.asm"
%include "src/kernel/modules/statusmessages.asm" ; TODO: Does this belong in the screen driver?
%include "src/kernel/modules/systools.asm"

; DRIVERS
%include "src/kernel/drivers/floppy.asm"
%include "src/kernel/drivers/screen.asm"
%include "src/kernel/drivers/keyboard.asm"
%include "src/kernel/drivers/memory.asm"
%include "src/kernel/drivers/irq.asm" ; TODO: This isn't *really* a driver, is it?
%include "src/kernel/drivers/a20.asm"

; LIBRARIES
%include "src/kernel/libraries/string.asm"
%include "src/kernel/libraries/fat12.asm" ; TODO: This isn't *really* a library, is it?

; OTHER
%include "src/kernel/shell/shell.asm"
