shell_bottombar:
call screen_clear
mov ah, 03h
mov bh, 0
int 10h
mov [.prev_column], dl
mov [.prev_row], dh
mov dh, 24
mov dl, 0
call screen_set_cursor
mov ah, 28
mov al, '#'
call screen_repeatchar
mov al, '$'
call screen_putchar
mov si, .text
call screen_puts
mov al, '$'
call screen_putchar
mov ah, 28
mov al, '#'
call screen_repeatchar
mov dh, 0
mov dl, 0
call screen_set_cursor
jmp shell_start
.prev_column db 0
.prev_row db 0
.text db "RM-DOS BY JOHNNY STENE" , 0
command_bottombar db "BOTTOMBAR", 0
