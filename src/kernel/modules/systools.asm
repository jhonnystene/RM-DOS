; Copy boot sector to other floppy disk
systools_bootcpy:
	pusha
	mov si, .first_disk_message
	call screen_puts
	call keyboard_waitkey
	
	mov ax, 0
	mov bl, 1
	call floppy_read_sectors
	
	mov si, .second_disk_message
	call screen_puts
	call keyboard_waitkey
	
	mov ax, 0
	mov bl, 1
	call floppy_write_sectors
	
	popa
	jmp shell_start
	
	.first_disk_message db "Insert source disk and strike any key", 13, 10, 0
	.second_disk_message db "Insert target disk and strike any key", 13, 10, 0

; Install whole system to floppy
systools_install:
	jmp shell_start

systools_bootcpy_command db "BOOTCPY", 0
systools_install_command db "SYSCPY", 0
