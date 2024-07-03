%include "sdk/RMDOS.asm"

progmain:
	mov si, kernel_msg_version
	call screen_puts
	mov si, kernel_msg_copyright
	call screen_puts
	
	ret
