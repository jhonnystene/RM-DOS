; RM-DOS locale file for US English

; Used in general OS use
kernel_msg_osname	 			db "The Real Mode Disk Operating System (RM-DOS)", 13, 10, 0
kernel_msg_copyright			db "Copyright (c) 2020 Johnny Stene. Some Rights Reserved.", 13, 10, 0
kernel_msg_welcome				db "Welcome to RM-DOS!", 13, 10, 0

; Used in the kernel panic screen
kernel_msg_panic				db "Kernel PANIC!", 13, 10, 0
kernel_msg_halted				db "System halted.", 13, 10, 0

; Used for status messages
; All of these need to be the same length
kernel_msg_ok					db " OK ", 13, 10, 0
kernel_msg_fail					db "FAIL", 13, 10, 0
kernel_msg_waiting				db "....", 13, 10, 0
