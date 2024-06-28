; In: AX, BX, CX - Source location, dest location, byte count
kernel_memory_copy:
	; For some stupid reason, this is required to stop stack corruption.
	; I think it's a qemu problem?
	nop
	nop
	nop
	
    push ax
    push bx
    push cx
    push dx
    
.loop:
    ; Check if transfer finished
    cmp cx, 0
    je .done
    
    ; Copy a byte
    push bx
    mov bx, ax
    mov dl, [bx]  ; Load byte from source address pointed to by ax
    pop bx
    mov [bx], dl  ; Store byte to destination address pointed to by bx
    
    ; Increment pointers
    inc ax  ; Move to next byte in source
    inc bx  ; Move to next byte in destination
    dec cx  ; Decrement byte count
    
    jmp .loop
    
.done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
kernel_memory_erase:
	pusha
	mov cx, bx
	mov bx, ax
	mov ax, 0
.loop:
	cmp cx,0
	je .done
	mov [bx], ax
	inc bx
	dec cx
	jmp .loop
.done:
	popa
	ret
