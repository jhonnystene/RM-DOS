; RM-DOS (Real Mode Disk Operating System)
; Keep it real
; Bismuth Kernel

BITS 16

callvectors:
	jmp bootstrap
	jmp os_start
	jmp printstring
	jmp enter_video_mode
	jmp enter_text_mode
	jmp clearscreen
	jmp setcursor
	jmp printchar
	jmp floppy_reset
	jmp waitkey
	jmp hang
	jmp panic
	jmp shell_start

; Setup stack and segmenting and boot OS
bootstrap:
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
	jmp os_start

os_start:
	; Print welcome message
	call clearscreen
	mov si, bootmessage_helloworld
	call printstring
	mov si, bootmessage_copyright
	call printstring
	
	call shell_start
	
	; We should never get here unless the shell crashed
	mov ah, 0
	jmp panic
	
; BOOT MESSAGES
bootmessage_helloworld 			db "The Real Mode Disk Operating System (RM-DOS)", 13, 10, 0
bootmessage_copyright			db "Copyright (c) 2020 Johnny Stene. Some Rights Reserved.", 13, 10, 0
bootmessage_kernelversion		db "Bismuth Kernel Version 0.1a", 13, 10, 0
bootmessage_enteringmode13 		db "Entering video mode 13h...", 13, 10, 0
bootmessage_inmode13 			db "Successfully entered video mode 13h!", 13, 10, 0
bootmessage_enteringmode3 		db "Entering text mode...", 13, 10, 0
bootmessage_inmode3 			db "Successfully dropped to text mode!", 13, 10, 0

; INCLUDES
%include "src/kernel/floppy.asm"
%include "src/kernel/screen.asm"
%include "src/kernel/panic.asm"
%include "src/kernel/shell.asm"
%include "src/kernel/keyboard.asm"
%include "src/kernel/string.asm"
