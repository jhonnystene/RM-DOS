kernel_dump_regs:
pusha
push si
mov si, kernel_msg_ax
call screen_puts
mov si, kernel_msg_hex
call screen_puts
call screen_print_4hex
mov si, kernel_msg_reg_spacer
call screen_puts
mov si, kernel_msg_bx
call screen_puts
mov si, kernel_msg_hex
call screen_puts
mov ax, bx
call screen_print_4hex
call screen_newline
mov si, kernel_msg_cx
call screen_puts
mov si, kernel_msg_hex
call screen_puts
mov ax, cx
call screen_print_4hex
mov si, kernel_msg_reg_spacer
call screen_puts
mov si, kernel_msg_dx
call screen_puts
mov si, kernel_msg_hex
call screen_puts
mov ax, dx
call screen_print_4hex
call screen_newline
mov si, kernel_msg_si
call screen_puts
mov si, kernel_msg_hex
call screen_puts
pop si
mov ax, si
call screen_print_4hex
mov si, kernel_msg_reg_spacer
call screen_puts
mov si, kernel_msg_di
call screen_puts
mov si, kernel_msg_hex
call screen_puts
mov ax, di
call screen_print_4hex
call screen_newline
popa
ret
