; RM-DOS Bootloader
; Version 1
;
; Progress dots:
; . Bootloader alive
; . Read file table
; . Found KERNEL.SYS
; . Loaded allocation table
; # One hash for each loaded block of kernel
; . Kernel load complete, jumping to kernel

;	pusha
;	mov al, ah
;	call screen_print_2hex
;	popa
;	call screen_print_2hex

BITS 16

jmp boot_main
times 16-($-$$) db 0

volume_label db "RM-DOS"
times 30-($-$$) db 0

magic dw 0DA31h

boot_main:
	; Setup stack for bootloader
	mov ax, 07C0h
	add ax, 544
	cli
	mov ss, ax
	mov sp, 4096
	sti
	cld

	mov ax, 07C0h
	mov ds, ax
	mov es, ax
	
	mov [boot_device], dl

	; Setup for string printing
	stosb
	
	call progress

	; Read file table
	mov ax, 1
	mov bx, disk_buffer
	mov cl, 1
	call read_sectors
	call progress

	; Find KERNEL.SYS
	mov bx, disk_buffer
.kernel_search_loop:
	; Check to make sure filename isn't blank
	mov ax, [bx]
	cmp ax, 0
	je .kernel_search_next

	; Check to make sure filename is valid
	mov di, bx
	mov si, .kernel_string
	call string_streq
	jc .kernel_search_done
.kernel_search_next:
	add bx, 16
	jmp .kernel_search_loop
.kernel_search_done:
	; We have found our kernel, prepare to load it
	call progress
	
	; Save the starting sector
	add bx, 12
	mov ax, [bx]
	mov word [.kernel_next_sector], ax

	; Load the allocation table
	mov ax, 2
	mov bx, disk_buffer
	mov cl, 2
	call read_sectors
	call progress

	; Prepare es to match our buffer
	mov ax, 2000h
	mov es, ax
.kernel_read_loop:
	; Read next sector of the kernel
	mov word ax, [.kernel_next_sector]
	mov bx, [.kernel_target]
	mov cx, 1
	call read_sectors
	call progress2

	; Get next sector index
	mov bx, disk_buffer
	add bx, [.kernel_next_sector]
	add bx, [.kernel_next_sector]
	mov ax, [bx]
	mov word [.kernel_next_sector], ax
	cmp ax, 0FFFFh
	je .kernel_read_done
	
	mov bx, [.kernel_target]
	add bx, 512
	mov [.kernel_target], bx
	jmp .kernel_read_loop
.kernel_read_done:
	call progress
	mov dl, [boot_device] ; Give this to kernel
	jmp 2000h:0000h
	
.kernel_next_sector dw 0
.kernel_string db "KERNEL.SYS", 0
.kernel_target dw 0

progress:
	pusha
	mov ah, 0Eh
	mov al, '.'
	mov bh, 0
	mov bl, 0Fh
	mov cx, 1
	int 10h
	popa
	ret
	
progress2:
	pusha
	mov ah, 0Eh
	mov al, '#'
	mov bh, 0
	mov bl, 0Fh
	mov cx, 1
	int 10h
	popa
	ret

reset_floppy:
	; First, reset floppy controller
	pusha
	mov ax, 0
	mov dl, [boot_device]
	stc
	int 13h
	
	; Check for error
	mov ah, 01h
	mov dl, [boot_device]
	int 13h
	jc .error
	popa
	ret
.error:
	mov si, .errormsg
	call screen_puts
	popa
	jmp reset_floppy
.errormsg db "RSTERR", 13, 10, 0

; In: AX - Logical Sector Number, CL - Sector Count
read_sectors:
	pusha

	call reset_floppy

	; Convert logical sector number to C,H,S
	push bx
	push ax
	mov bx, ax
	mov dx, 0
	div word [sectors_per_track]
	add dl, 01h
	mov cl, dl
	mov ax, bx
	mov dx, 0
	div word [sectors_per_track]
	mov dx, 0
	div word [sides]
	mov dh, dl
	mov ch, al
	pop ax
	pop bx

	; Finally, read the sectors
	mov ah, 02h
	mov al, cl
	mov dl, [boot_device]
	int 13h
	jc .error
	
	popa
	ret
.error:
	mov si, .errmessage
	call screen_puts
	popa
	jmp read_sectors
.errmessage db "LODERR", 13, 10, 0

sectors_per_track dw 18
sides dw 2
boot_device db 0

%include "src/bootloader/screen.asm"
%include "src/bootloader/string.asm"

times 510-($-$$) db 0
boot_signature dw 0AA55h

disk_buffer:

; Reserve space in allocation table for FS info
times 512 db 0
times 6 db 0FFh

times 1474560-($-$$) db 0
