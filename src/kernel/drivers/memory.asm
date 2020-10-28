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
kernel_enable_a20:
pusha
mov si, .enabling_msg
mov al, kernel_status_waiting
call kernel_print_status
in al, 0x92
or al, 2
out 0x92, al
mov al, kernel_status_ok
call kernel_print_status
popa
ret
.enabling_msg db "Enabling A20 line...", 0 , 0
