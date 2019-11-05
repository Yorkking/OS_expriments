;;wang yongkang,haha
	LEFT equ 40
	RIGHT equ 75
	UP equ 0
	DOWN equ 11

	DOWN_ equ 12		;一半
	delay equ 3000				; 
	ddelay equ 1000
	COUNT equ 255
	
	
org 100h
start:
	mov ax,cs	
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov sp,200h
	
	;sti

	mov ah,0x13
	mov al,1
	mov bl,00100000b
	mov dh,0
	mov dl,59

DispStr:
	mov ax,message
	mov bp,ax
	mov cx,1

	mov ah,0x13
	mov bh,0
	mov al,1

	mov bl,00100000b		;这个要跟着变化来着
	
	mov byte[col], 1
	mov byte[row], 1
	mov dl,40
	mov dh,6

	int 10h

	mov word[count],delay
        jmp LOO

    here1:;;销毁进程
		

		ret

LOO:
	inc bl
	
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
	
	;cmp bl,COUNT
	;je here1
	jmp LOO

LOOPS:
	loop1:
	dec word[count]				; 
	jnz loop1					;
	mov word[count],delay
	dec word[dcount]				; 
	  jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

	ret



Data_:	
	row db 0
	col db 7
	message db 'XRR'
	count dw delay
	dcount dw ddelay
	show_message db 'R'		

times 510-($-$$) db 0
dw 0xaa55		
