irq_IRQ0_handler:
	mov si, .inturrupt_msg
	call screen_puts
	iretd
	
	.inturrupt_msg db "INT!", 0

; Inputs: AX, BX - Inturrupt number, Inturrupt location
irq_register:
	pusha
	mov dx, ax ; We need to use AX
	mov cx, bx ; We need to use BX
	
	; We need to swap into segment 0
	mov ax, 0000h
	mov ds, ax
	mov gs, ax
	mov fs, ax
	mov es, ax
	
	mov ax, 2000h ; Our inturrupt is likely in kernel code (Segment 2000h)
	
	; We need to figure out *where* the inturrupt is that we want to overwrite
	mov bx, 0
	
	.loop:
		cmp dx, 0
		je .finish
		
		add bx, 4
		dec dx
		jmp .loop
	
	.finish:
		; Now that we have the inturrupt location in BX, we can write our inturrupt location
		mov [bx], cx ; Location
		add bx, 2
		mov [bx], ax ; Segment
		
		; Switch back to the kernel segment and return
		mov ds, ax
		mov gs, ax
		mov fs, ax
		mov es, ax
		
		popa
		ret

irq_init_ivt:
	pusha
	mov si, kernel_msg_initializing_ivt
	mov al, kernel_status_waiting
	call kernel_print_status
	
	; Divide by zero error
	mov ax, 0
	mov bx, kernel_panic_divzero
	call irq_register
	
	; Bound Range Exceeded error
	mov ax, 5
	mov bx, kernel_panic_boundrange
	call irq_register
	
	; Invalid Opcode error
	mov ax, 6
	mov bx, kernel_panic_opcode
	call irq_register
	
	; Device Not Available error
	mov ax, 7
	mov bx, kernel_panic_devicegone
	call irq_register
	
	; Invalid TSS error
	mov ax, 10
	mov bx, kernel_panic_TSS
	call irq_register
	
	; Segment Not Present error
	mov ax, 11
	mov bx, kernel_panic_seggone
	call irq_register
	
	; Stack Segment error
	mov ax, 12
	mov bx, kernel_panic_stackseg
	call irq_register
	
	mov si, kernel_msg_initializing_ivt
	mov al, kernel_status_ok
	call kernel_print_status
	
	popa
	ret

irq_init_pit:
	pushad
	
	mov si, kernel_msg_initializing_pit
	mov al, kernel_status_waiting
	call kernel_print_status
 
    ; Do some checking
 
    mov eax,0x10000                   ;eax = reload value for slowest possible frequency (65536)
    cmp ebx,18                        ;Is the requested frequency too low?
    jbe .gotReloadValue               ; yes, use slowest possible frequency
 
    mov eax,1                         ;ax = reload value for fastest possible frequency (1)
    cmp ebx,1193181                   ;Is the requested frequency too high?
    jae .gotReloadValue               ; yes, use fastest possible frequency
 
    ; Calculate the reload value
 
    mov eax,3579545
    mov edx,0                         ;edx:eax = 3579545
    div ebx                           ;eax = 3579545 / frequency, edx = remainder
    cmp edx,3579545 / 2               ;Is the remainder more than half?
    jb .l1                            ; no, round down
    inc eax                           ; yes, round up
 .l1:
    mov ebx,3
    mov edx,0                         ;edx:eax = 3579545 * 256 / frequency
    div ebx                           ;eax = (3579545 * 256 / 3 * 256) / frequency
    cmp edx,3 / 2                     ;Is the remainder more than half?
    jb .l2                            ; no, round down
    inc eax                           ; yes, round up
 .l2:
 
 
 ; Store the reload value and calculate the actual frequency
 
 .gotReloadValue:
    push eax                          ;Store reload_value for later
    mov [irq_pit_reload_value],ax         ;Store the reload value for later
    mov ebx,eax                       ;ebx = reload value
 
    mov eax,3579545
    mov edx,0                         ;edx:eax = 3579545
    div ebx                           ;eax = 3579545 / reload_value, edx = remainder
    cmp edx,3579545 / 2               ;Is the remainder more than half?
    jb .l3                            ; no, round down
    inc eax                           ; yes, round up
 .l3:
    mov ebx,3
    mov edx,0                         ;edx:eax = 3579545 / reload_value
    div ebx                           ;eax = (3579545 / 3) / frequency
    cmp edx,3 / 2                     ;Is the remainder more than half?
    jb .l4                            ; no, round down
    inc eax                           ; yes, round up
 .l4:
    mov [irq_IRQ0_frequency],eax          ;Store the actual frequency for displaying later
 
 
 ; Calculate the amount of time between IRQs in 32.32 fixed point
 ;
 ; Note: The basic formula is:
 ;           time in ms = reload_value / (3579545 / 3) * 1000
 ;       This can be rearranged in the following way:
 ;           time in ms = reload_value * 3000 / 3579545
 ;           time in ms = reload_value * 3000 / 3579545 * (2^42)/(2^42)
 ;           time in ms = reload_value * 3000 * (2^42) / 3579545 / (2^42)
 ;           time in ms * 2^32 = reload_value * 3000 * (2^42) / 3579545 / (2^42) * (2^32)
 ;           time in ms * 2^32 = reload_value * 3000 * (2^42) / 3579545 / (2^10)
 
    pop ebx                           ;ebx = reload_value
    mov eax,0xDBB3A062                ;eax = 3000 * (2^42) / 3579545
    mul ebx                           ;edx:eax = reload_value * 3000 * (2^42) / 3579545
    shrd eax,edx,10
    shr edx,10                        ;edx:eax = reload_value * 3000 * (2^42) / 3579545 / (2^10)
 
    mov [irq_IRQ0_ms],edx                 ;Set whole ms between IRQs
    mov [irq_IRQ0_fractions],eax          ;Set fractions of 1 ms between IRQs
 
 
 ; Program the PIT channel
 
    pushfd
    cli                               ;Disabled interrupts (just in case)
 
    mov al,00110100b                  ;channel 0, lobyte/hibyte, rate generator
    out 0x43, al
 
    mov ax,[irq_pit_reload_value]         ;ax = 16 bit reload value
    out 0x40,al                       ;Set low byte of PIT reload value
    mov al,ah                         ;ax = high 8 bits of reload value
    out 0x40,al                       ;Set high byte of PIT reload value
 
    popfd
 
    popad
    
    push ax
    mov al, irq_pit_line_0
    call irq_unmask_pit_line
    pop ax
    
	mov si, kernel_msg_initializing_pit
	mov al, kernel_status_ok
	call kernel_print_status
    
    ret
	
; In: AL - PIT line
irq_unmask_pit_line:
	pusha
	mov ah, 0
	
	; FOR DEBUGGING PURPOSES
	call screen_print_4hex
	
	mov bx, ax
	in ax, 21h
	or ax, bx
	out 21h, ax
	popa
	ret
	
irq_pit_line_0			db 80h
irq_pit_line_1			db 40h
irq_pit_line_2			db 20h
irq_pit_line_3			db 10h
irq_pit_line_4			db 8h
irq_pit_line_5			db 4h
irq_pit_line_6			db 2h
irq_pit_line_7			db 1h

irq_pit_reload_value db 0
irq_IRQ0_ms db 0
irq_IRQ0_fractions db 0
irq_IRQ0_frequency db 0
