kernel_memory_copy:
	pusha
.loop:
	cmp cx,0
	je .done
	push bx
	mov bx, ax
	mov dx, [bx]
	pop bx
	mov [bx], dx
	inc ax
	inc bx
	dec cx
	jmp .loop
.done:
	popa
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
