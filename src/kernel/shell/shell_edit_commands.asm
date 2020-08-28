; shell_edit_commands.asm
mov si, command_edit
call string_streq
jc shell_edit
