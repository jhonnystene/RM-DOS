; I/O: None
; Carry flag set if valid
fs_validate_partition:
	pusha
	mov ax, 0
	mov bl, 1
	call floppy_read_sectors
	mov bx, floppy_buffer
	add bx, 30
	mov word ax, [bx]
	cmp ax, 0DA31h
	je .valid
	popa
	clc
	ret
.valid:
	popa
	stc
	ret
	
; I/O: None
; Floppy buffer populated with File Table
fs_load_file_table:
	pusha
	call fs_validate_partition
	jc .good
	mov si, fs_invalid_message
	call screen_puts
	popa
	ret
.good:
	mov ax, 1
	mov bl, 1
	call floppy_read_sectors
	popa
	ret

; I/O: None
; Floppy buffer populated with Allocation Table
fs_load_allocation_table:
	pusha
	call fs_validate_partition
	jc .good
	mov si, fs_invalid_message
	call screen_puts
	popa
	ret
.good:
	mov ax, 2
	mov bl, 6
	call floppy_read_sectors
	popa
	ret

; In: SI - filename
; Out: AX - First sector
fs_get_first_sector:
	pusha
	call fs_validate_partition
	jc .good
	mov si, fs_invalid_message
	call screen_puts
	popa
	ret
.good:
	call fs_load_file_table
	mov bx, floppy_buffer
	mov cx, bx
	add cx, 512
.search_loop:
	; Check to make sure filename isn't blank
	mov ax, [bx]
	cmp ax, 0
	je .search_next

	; Check to make sure filename is valid
	mov di, bx
	call string_streq
	jc .search_done
.search_next:
	add bx, 16
	cmp bx, cx
	je .search_fail
	jmp .search_loop
.search_done:
	; Save the starting sector
	add bx, 12
	mov word ax, [bx]
	mov word [.sector], ax
	popa
	mov word ax, [.sector]
	ret
.search_fail:
	popa
	mov ax, 0
	ret
.sector dw 0

; In: SI - Filename
; Out: Carry if exists
fs_file_exists:
	pusha
	call fs_get_first_sector
	cmp ax, 0
	je .no
	popa
	stc
	ret
.no:
	popa
	clc
	ret

; In: SI - Filename
; Out: file_buffer, carry set if success
fs_read_file:
	pusha
	call fs_file_exists
	jc .exists
	mov si, .file_not_found
	call screen_puts
	popa
	clc
	ret
.exists:
	call fs_get_first_sector
	mov word [.next_sector], ax
	mov word bx, file_buffer
	mov word [.target], bx
	call fs_load_allocation_table
.read_loop:
	; Read next sector
	mov word ax, [.next_sector]
	mov word bx, [.target]
	call floppy_read_sector_to

	; Get next sector index
	mov bx, floppy_buffer
	add bx, [.next_sector]
	add bx, [.next_sector]
	mov ax, [bx]
	mov word [.next_sector], ax
	cmp ax, 0FFFFh
	je .read_done
	
	add word [.target], 512
	jmp .read_loop
.read_done:
	popa
	stc
	ret
.next_sector dw 0
.target dw 0
.file_not_found db "File not found.", 13, 10, 0

fs_invalid_message db "Disk does not contain valid filesystem", 13, 10, 0

