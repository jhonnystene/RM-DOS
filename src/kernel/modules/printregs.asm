kernel_dump_regs:
pusha
mov si, kernel_panic_msg_ax
call screen_puts
call screen_print_4hex
call screen_newline
mov si, kernel_panic_msg_bx
call screen_puts
mov ax, bx
call screen_print_4hex
call screen_newline
mov si, kernel_panic_msg_cx
call screen_puts
mov ax, cx
call screen_print_4hex
call screen_newline
mov si, kernel_panic_msg_dx
call screen_puts
mov ax, dx
call screen_print_4hex
call screen_newline
popa
ret
