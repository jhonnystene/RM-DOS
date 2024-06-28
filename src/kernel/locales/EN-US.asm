; RM-DOS locale file for US English

; Boot messages
kernel_msg_loaded_to_segment	db "Kernel loaded into segment 0x2000", 13, 10, 0
kernel_msg_stack_loaded			db "Stack loaded into 0x0FFFF", 13, 10, 0
kernel_msg_enabling_a20			db "Enabling A20 line...", 0
kernel_msg_initializing_ivt		db "Initializing IVT...", 0
kernel_msg_initializing_pit		db "Initializing PIT...", 0

; Used in general OS use
kernel_msg_osname	 			db "The Real Mode Disk Operating System (RM-DOS)", 13, 10, 0
kernel_msg_copyright			db "Copyright (c) 2020 Johnny Stene. Some Rights Reserved.", 13, 10, 0
kernel_msg_welcome				db "Welcome to RM-DOS!", 13, 10, 0

; Used for file & RAM operations
kernel_msg_high_ram_amount		db "High Memory Detected: 0x", 0
kernel_msg_low_ram_amount		db "Low Memory Detected: 0x", 0
kernel_msg_couldnt_get_ram		db "Couldn't detect memory amount (BIOS bug)", 13, 10, 0
kernel_msg_detecting_lomem		db "Detecting low memory...", 0
kernel_msg_detecting_himem		db "Detecting high memory...", 0
kernel_msg_lomem_fail			db "Failed to detect low memory.", 13, 10, 0
kernel_msg_himem_fail			db "Failed to detect high memory.", 13, 10, 0
kernel_msg_no_himem				db "No high memory detected.", 13, 10, 0

kernel_msg_kilobytes			db " Kilobytes", 0

; Used in the kernel panic screen
; These should be 80 characters long
kernel_msg_panic				db "                                 Kernel PANIC!!                                 ", 13, 10, 0
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
kernel_msg_sp					db "SP: ", 0
kernel_msg_reg_spacer			db "        ", 0
kernel_msg_hex					db "0x", 0

; Used for status messages
; All of these need to be the same length
kernel_msg_ok					db " OK ", 0
kernel_msg_fail					db "FAIL", 0
kernel_msg_waiting				db "....", 0

; Used for general errors
kernel_msg_error				db "Error!", 13, 10, 0

