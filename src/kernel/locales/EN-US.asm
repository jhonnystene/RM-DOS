; RM-DOS locale file for US English

; Used in general OS use
kernel_msg_osname	 			db "The Real Mode Disk Operating System (RM-DOS)", 13, 10, 0
kernel_msg_copyright			db "Copyright (c) 2020 Johnny Stene. Some Rights Reserved.", 13, 10, 0
kernel_msg_welcome				db "Welcome to RM-DOS!", 13, 10, 0

; Used in the kernel panic screen
; These should be 80 characters long
kernel_msg_panic				db "                                 Kernel PANIC!!                                 ", 0
kernel_msg_halted				db "                                 System halted.                                 ", 13, 10, 0
kernel_msg_unknown_error		db "                         Unknown error - System halted.                         ", 13, 10, 0
kernel_msg_divzero_error		db "                         Divide by zero - System halted                         ", 13, 10, 0
kernel_msg_boundrange_error		db "                      Bound Range Exceeded - System halted                      ", 13, 10, 0
kernel_msg_opcode_error			db "                         Invalid Opcode - System halted                         ", 13, 10, 0
kernel_msg_devicegone_error		db "                      Device Not Available - System halted                      ", 13, 10, 0
kernel_msg_TSS_error			db "                          Invalid TSS - System halted.                          ", 13, 10, 0
kernel_msg_seggone_error		db "                        Invalid Segment - System halted.                        ", 13, 10, 0
kernel_msg_stackseg_error		db "                    Stack Segmentation Fault - System halted                    ", 13, 10, 0

; Also used in the kernel panic screen
; These should not be changed for different locales
kernel_msg_ax					db "                          AX: ", 0
kernel_msg_bx					db "BX: ", 0
kernel_msg_cx					db "                          CX: ", 0
kernel_msg_dx					db "DX: ", 0
kernel_msg_si					db "                          SI: ", 0
kernel_msg_di					db "DI: ", 0
kernel_msg_reg_spacer			db "        ", 0
kernel_msg_hex					db "0x", 0

; Used for status messages
; All of these need to be the same length
kernel_msg_ok					db " OK ", 0
kernel_msg_fail					db "FAIL", 0
kernel_msg_waiting				db "....", 0

