;;wang yongkang
	
org 0A100h


start:
	;push es
	;push ax

	mov ax,cs	
	mov ds,ax
	mov es,ax

	xor ax,ax
	mov es,ax

	mov ax,0B800h
	mov gs,ax
	
	mov ax,0
	mov es,ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;下面这一段是弹跳程序准备
	mov ax,cs
	mov ds,ax
	mov es,ax

	mov bp,show_message
	mov cx,14
	mov ah,0x13
	mov al,1
	mov bl,00100000b
	mov dh,12
	mov dl,40
	

	mov ax,message
	mov bp,ax
	mov cx,1

	mov ah,0x13
	mov bh,0
	mov al,1

	mov bl,10000001b		;这个要跟着变化来着
	
	mov byte[col], 1
	mov byte[row], 1
	mov dl,40
	mov dh,12

	int 10h

	mov word[count],delay
  jmp LOO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;弹跳程序准备结束
	here1:


	

  ret
	jmp $

	
	

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;弹跳程序

LOO:
	inc bl
	mov cx,1
	add dl,byte[col]
	add dh,byte[row]
	int 10h

	cmp dh,DOWN
	jne LOO1
	neg byte[row]

LOO1:	cmp dh,UP
	jne LOO2
	neg byte[row]

LOO2:	cmp dl,LEFT
	jne LOO3
	neg byte[col]
	
LOO3:	cmp dl,RIGHT
	jne LOO4
	neg byte[col]

LOO4:	
	
	call LOOPS
	
	cmp bl,COUNT
	je here1
	jmp LOO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;弹跳程序


;;;;;;延时循环：10000*6000
LOOPS:
		push cx
    mov cx,10000
sss1:
    push cx
        mov cx,6000
        sss2:
         loop sss2
    pop cx
  loop sss1
	pop cx
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;新的9号中断部分

    
LOOPSs:
		push cx
    mov cx,8000
ss1:
    push cx
        mov cx,8000
        ss2:
         loop ss2
    pop cx
  loop ss1
	pop cx
	ret


Data_:	
	stack1 dw 0,0
	row db 4
	col db 6
	message db 'wyk'
	count dw delay
	dcount dw ddelay
	show_message db 'Wang yongkang!'		

	St: db 'OUCH!OUCH!'
  Smm: db '          '


	LEFT equ 40
	RIGHT equ 79
	UP equ 0
	DOWN equ 24

	DOWN_ equ 12		;一半
	delay equ 500					; 
	ddelay equ 58	
	COUNT equ 255

	
	


times 510-($-$$) db 0
dw 0xaa55		
