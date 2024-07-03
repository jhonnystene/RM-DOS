BITS 16
ORG 32768
jmp progmain
kernel_bootstrap equ 0000h
kernel_hang equ 0003h
kernel_panic equ 0006h
kernel_dump_regs equ 0009h
kernel_memory_copy equ 000Ch
kernel_memory_erase equ 000Fh
screen_clear equ 0012h
screen_set_cursor equ 0015h
screen_puts equ 0018h
screen_putchar equ 001Bh
screen_newline equ 001Eh
screen_print_2hex equ 0021h
screen_print_4hex equ 0024h
keyboard_waitkey  equ 0027h
floppy_reset  equ 002Ah
floppy_read_sectors equ 002Dh
floppy_write_sectors equ 0030h
string_streq equ 0033h
string_strlen equ 0036h
string_char_upper equ 0039h
string_to_int equ 003Ch
fs_validate_partition equ 003Fh
fs_file_exists equ 0042h
fs_read_file equ 0045h
kernel_msg_version				db "RM-DOS beta 0.1b", 13, 10, 0
kernel_msg_copyright			db "Copyright (c) 2024 Johnny Stene. MIT License.", 13, 10, 0
