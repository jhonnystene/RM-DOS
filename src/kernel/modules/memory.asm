kernel_memory_copy:
pusha
.loop:
cmp cx,0
je kernel_memory_copy_done
push bx
mov bx, ax
mov dx, [bx]
pop bx
mov [bx], dx
inc ax
inc bx
dec cx
jmp .loop
kernel_memory_copy_done:
popa
ret
kernel_memory_erase:
pusha
mov cx, bx
mov bx, ax
mov ax, 0
.loop:
cmp cx,0
je kernel_memory_erase_done
mov [bx], ax
inc bx
dec cx
jmp .loop
kernel_memory_erase_done:
popa
ret
