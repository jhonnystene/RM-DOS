; Fuck I hate FAT
; Disk layout:
;	S0: 		Boot Sector
;	S1-9: 		FAT 1
;	S10-18:		FAT 2: Electric Boogaloo
;	S19-32: 	Root Directory
;	S33-End:	Data Area
;
; FAT Entries:
; 	2 per 3 bytes (12 bits each)
;	AB CD EF becomes DAB EFC
;	Entry values:
;		000: 		Free Cluster
;		002-FEF: 	Cluster in use. Value is next cluster in file.
;		FF0-FF6: 	Reserved
;		FF7: 		Bad Cluster
;		FF8-FFF: 	Cluster in use. Last cluster in file.
;
; Directory Entries:
;	ROOT DIRECTORY ENTRIES START 32 BYTES INTO THE ROOT DIRECTORY. FUCK MY ASS THAT WAS 4 HOURS OF DEBUGGING
;	Bytes	0-10:		File name (8 chars for name, 3 chars for ext.)
;	Byte	11:		File Attributes
;	Bytes	12-21: 	Reserved
;	Bytes	22-23:	Time (5/6/5 bits, for hours/minutes/doubleseconds)
;	Bytes	24-25:	Date (7/4/5 bits, for years since 1980, months, days)
;	Bytes	26-27:	Starting cluster. 0 if file is empty.
;	Bytes	28-31:	File size in bytes.
;
; File Attributes:
;	Bit	0:		Read Only
;	Bit 1:		Hidden
;	Bit 2:		System File
; 	Bit 3:		Volume Label
;	Bit 4: 		Subdirectory
;	Bit 5: 		Archive
;	Bit 6-7:	Unused

fat12_max_root_directory_entries	equ 208 ; Maximum amount of root directory entries

; IN: AX, BX - Directory Entry Number, location of buffer
; OUT: Carry set on error, Buffer filled on no error
fat12_get_filename:
	pusha
	
	cmp ax, fat12_max_root_directory_entries ; Are we trying to read past the max amount of entries?
	ja .error ; If so, skip
	
	cmp ax, 0
	je .error
	
	call fat12_read_root_directory_entry
	
	mov ax, fat12_root_directory_buffer
	mov cx, 12
	call kernel_memory_copy
	
	.success:
		popa
		clc
		ret
	
	.error:
		popa
		stc
		ret

; OUT: floppy_buffer - Root Directory
fat12_read_root_directory:
	pusha
	mov ax, 19
	mov bl, 13
	call floppy_read_sectors
	popa
	ret

; OUT: floppy_buffer - FAT
fat12_read_fat:
	pusha
	mov ax, 1
	mov bl, 8
	call floppy_read_sectors
	popa
	ret

; In: AX - Entry number
; Out: fat12_root_directory_buffer - Contents of directory entry
fat12_read_root_directory_entry:
	pusha
	call fat12_read_root_directory ; Read the root directory into the floppy buffer
	call .clear_buffer ; Clear the root directory entry buffer
	
	; TODO: Figure out how the fuck to multiply two numbers
	push ax
	push cx
	mov cx, 32
	mul cx
	mov bx, ax
	pop cx
	pop ax
	
	.begin_read_entry:
		mov dx, bx ; Store our starting point in DX for safe keeping
		mov ax, 0 ; Should already be zero but i'm fucking tired of debugging and don't want to take chances
	
	.read_entry_loop:
		mov bx, dx ; Reset BX to starting point
		add bx, ax ; Seek ahead to current position
		mov byte ch, [floppy_buffer + bx] ; Grab a byte from the floppy buffer
		mov bx, ax ; Set BX to be our position in the root directory buffer
		mov byte [fat12_root_directory_buffer + bx], ch ; Dump previous byte into root directory buffer
		
		inc ax ; Next byte
		cmp ax, 32 ; Are we at the end?
		je .done ; Pop regs and return
		jmp .read_entry_loop ; Otherwise keep going
	
	.done:
		popa
		ret
		
	.clear_buffer:
		pusha
		mov bx, 0
		
	.clear_buffer_loop:
		mov byte [fat12_root_directory_buffer + bx], 0
		inc bx
		cmp bx, 32
		je .clear_buffer_finish
		jmp .clear_buffer_loop
	
	.clear_buffer_finish:
		popa
		ret

; In: SI - Filename
; Out: Carry - Set if file exists
fat12_search_for_file:
	pusha
	
	; Clear registers
	mov ax, 0 ; Used for copying filename from root directory
	mov bx, 0 ; Used for storing position in entry we're in
	mov cx, 1 ; Used for storing entry number
	mov dx, 0 ; Used for storing position in buffer we're in
	mov di, .filename_buffer
	
	.next_entry:
		cmp cx, fat12_max_root_directory_entries ; Have we hit the end of the root directory entries?
		je .file_not_found ; If so, the file isn't on disk
		
		call .read_entry ; Read the next entry
		mov bx, 0 ; Reset position
		
	.next_byte:
		mov byte al, [fat12_root_directory_buffer + bx] ; Load a byte into AL
		
		; Don't load in a null byte
		cmp al, 0
		je .finish_byte
		
		push bx
		mov bx, dx ; We should write to the proper spot in the filename buffer
		mov [.filename_buffer + bx], al ; Write the byte to the buffer
		pop bx
		
		inc dx
		
	.finish_byte:
		inc bx
		cmp dx, 11
		je .check_filename
		jmp .next_byte
		
	.check_filename:
		mov di, .filename_buffer
		call string_streq
		jc .file_found
		
		inc cx
		jmp .next_entry
	
	.read_entry: ; Call fat12_read_root_directory_entry without harming AX
		push ax
		mov ax, cx
		call fat12_read_root_directory_entry
		pop ax
		ret
		
	.file_found:
		popa
		stc
		ret
	
	.file_not_found:
		popa
		clc
		ret
		
	.clear_buffer:
		pusha
		mov bx, 0
		
	.clear_buffer_loop:
		mov byte [.filename_buffer + bx], 0
		inc bx
		cmp bx, 11
		je .clear_buffer_finish
		jmp .clear_buffer_loop
	
	.clear_buffer_finish:
		popa
		ret

	.filename_buffer times 12 db 0
	
fat12_root_directory_buffer times 32 db 0
