kernel_hang:
.loop:
jmp .loop
kernel_panic:
call screen_enter_text_mode
pusha
mov bl, 0x4f
mov si, kernel_panic_msg
call screen_color_puts
mov si, kernel_panic_msg_halted
call screen_color_puts
popa
call kernel_dump_regs
call kernel_hang
kernel_panic_msg db "Kernel PANIC!", 13, 10 , 0
kernel_panic_msg_halted db "System halted.", 13, 10 , 0
kernel_panic_msg_ax db "AX: " , 0
kernel_panic_msg_bx db "BX: " , 0
kernel_panic_msg_cx db "CX: " , 0
kernel_panic_msg_dx db "DX: " , 0
kernel_panic_msg_si db "SI: " , 0
kernel_panic_msg_di db "DI: " , 0
