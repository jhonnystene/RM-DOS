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

floppy_reset:
	pusha
	mov ax, 0
	mov dl, [BootDevice]
	stc
	int 13h
	call floppy_check_error
	popa
	ret
	
floppy_check_error:
	pusha
	mov ah, 01h
	mov dl, [BootDevice]
	int 13h
	popa
	ret
	
; IN: AX - Logical sector
; OUT: Needed params for int 13h
floppy_get_location:
	push bx
	push ax
	mov bx, ax
	mov dx, 0
	div word [SectorsPerTrack]
	add dl, 01h
	mov cl, dl
	mov ax, bx
	mov dx, 0
	div word [SectorsPerTrack]
	mov dx, 0
	div word [Sides]
	mov dh, dl
	mov ch, al
	pop ax
	pop bx
	mov dl, [BootDevice]
	ret

; In: AX - Logical Sector Number, BL - Sector Count
; Out: Buffer - Data
floppy_read_sectors:
	call floppy_reset
	pusha
	call floppy_get_location
	mov ah, 02h
	mov al, bl
	mov bx, Buffer
	int 13h
	jc .error
	popa
	ret

	.error:
		mov si, floppy_error_msg
		call printstring
		mov al, ah
		call printhex
		mov al, 13
		call printchar
		mov al, 10
		call printchar
		popa
		ret
		
; OUT: Buffer - Root Directory
floppy_read_root_directory:
	mov ax, 19
	mov bl, 13
	call floppy_read_sectors
	ret

; OUT: Buffer - FAT
floppy_read_fat:
	mov ax, 1
	mov bl, 8
	call floppy_read_sectors
	ret

floppy_error_msg	db "Floppy error ", 0

SectorsPerTrack		dw 18
Sides				dw 2
BootDevice			db 0
Buffer				equ 24576
