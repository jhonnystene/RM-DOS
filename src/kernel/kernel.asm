BITS 16

callvectors:
	jmp bootstrap
	jmp os_start

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
	mov si, message_helloworld
	call printstring
	mov si, message_kernelversion
	call printstring
	
	call shell_start
	
	; Enter a shell!
	jmp hang
	
; BOOT MESSAGES
message_helloworld db "Hello, World!", 13, 10, 0
message_kernelversion db "Bismuth Kernel Version 0.1a", 13, 10, 0
message_enteringmode13 db "Entering video mode 13h...", 13, 10, 0
message_inmode13 db "Successfully entered video mode 13h!", 13, 10, 0
message_enteringmode3 db "Entering text mode...", 13, 10, 0
message_inmode3 db "Successfully dropped to text mode!", 13, 10, 0

; INCLUDES
%include "src/kernel/screen.asm"
%include "src/kernel/panic.asm"
%include "src/kernel/shell.asm"
%include "src/kernel/keyboard.asm"
