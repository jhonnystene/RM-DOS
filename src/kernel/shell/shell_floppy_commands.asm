mov si, command_floppy_test
call string_streq
jc floppy_test

mov si, command_floppy_dump
call string_streq
jc floppy_dump

mov si, command_floppy_read
call string_streq
jc floppy_read

mov si, command_floppy_explore
call string_streq
jc floppy_explore
