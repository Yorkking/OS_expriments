;;wang yongkang
	LEFT equ 0
	RIGHT equ 35
	UP equ 11
	DOWN equ 24

	DOWN_ equ 12		;一半
	delay equ 5000					; 
	ddelay equ 58	
	COUNT equ 255
	
	
org 0A100h
start:
	mov ax,cs	
	mov ds,ax
	mov es,ax
	xor ax,ax
	mov es,ax

	mov ax,0B800h
	mov gs,ax

	mov word [es:24h],Ouch

	mov ax,cs
	mov word [es:26h],ax
	mov ds,ax
	mov es,ax

	mov bp,show_message
	mov cx,14
	mov ah,0x13
	mov al,1
	mov bl,10100000b
	mov dh,12
	mov dl,40
	
	int 10h
	
	call DispStr

	here1:
	ret
	jmp $

DispStr:
	mov ax,message
	mov bp,ax
	mov cx,1

	mov ah,0x13
	mov bh,0
	mov al,1

	mov bl,10100000b		;这个要跟着变化来着
	
	mov byte[col], 1
	mov byte[row], 1
	mov dl,0
	mov dh,12

	int 10h

	mov word[count],delay
        jmp LOO
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
	
	cmp bl,COUNT
	je here1
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





Ouch:
	Ouch:
    sti
    in al,60h

    mov ax,cs
    mov ds,ax
    
    mov si,St
    mov ax,0B800h

    mov es,ax
    mov di,(12*80 + 5)*2

    mov cx,10
  s:mov al,[si]
    mov [es:di],al
    inc si
    add di,2
    loop s
    
    mov cx,1000
s1:
    push cx
        mov cx,1000
        s2:
         loop s2
    pop cx
  loop s1
    mov si,Smm
    mov ax,0B800h
     mov es,ax
    mov di,(12*80 + 5)*2
 mov cx,10
  s3:mov al,[si]
    mov [es:di],al
    inc si
    add di,2
    loop s3



    mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
	iret	




Data_:	
	row db 0
	col db 7
	message db 'wyk'
	count dw delay
	dcount dw ddelay
	show_message db 'Wang yongkang!'		
	St: db 'OUCH!OUCH!'
    Smm: db '          '


times 510-($-$$) db 0
dw 0xaa55		
