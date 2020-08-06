mov si, command_floppy_dump
call string_streq
jc shell_floppy_dump

mov si, command_floppy_read
call string_streq
jc shell_floppy_read

mov si, command_floppy_explore
call string_streq
jc shell_floppy_explore
