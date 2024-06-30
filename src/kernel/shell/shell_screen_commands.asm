mov si, command_about
call string_streq
jc about

mov si, command_mode_text
call string_streq
jc mode_text

mov si, command_mode_video
call string_streq
jc mode_video

mov si, command_cls
call string_streq
jc cls
