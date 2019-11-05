org 1000h			; 程序加载到100h，可用于生成COM
; 设置时钟中断向量（08h），初始化段寄存器
_start:

	mov ax,cs
   	mov ds,ax			; DS = CS
	mov es,ax

	xor ax,ax			; AX = 0
	mov es,ax			; ES = 0
	mov	ax,0B800h		; 文本窗口显存起始地址
	mov	gs,ax		; GS = B800h
  

	cli
    mov word [es:20h],Timer1	; 设置时钟中断向量的偏移地址
    mov word [es:22h],cs
	sti

	mov ax,cs
   	mov ds,ax			; DS = CS
	mov es,ax

    ;sti	
    
    
   ; mov word [es:20h],Timer	; 设置时钟中断向量的偏移地址
	;mov ax,cs 
	;mov word [es:22h],ax		; 设置时钟中断向量的段地址=CS
	;mov ds,ax			; DS = CS
	;mov es,ax			; ES = CS
; 在屏幕右下角显示字符‘!’	
	
	
    ret
    
    
    
    jmp $			; 死循环
; 时钟中断处理程序
Timer1:	
	jmp short Timer
Timer:
	
	push ax
	push bx
	push cx
	push dx

	push bp
	push es


    ;mov byte[cnt],0
    

	dec byte [count]		; 递减计数变量
	jnz _end			; >0：跳转

	mov al, byte[cnt]

	cmp al,0
	jne here1
	mov byte[gs:((80*15+70)*2)],'\'
	jmp here0

	here1:
	cmp al,1
	jne here2
	mov byte[gs:((80*15+70)*2)],'|'
	jmp here0

	here2:
	cmp al,2
	jne here3
	mov byte[gs:((80*15+70)*2)],'/'
	jmp here0
	
	here3:
	cmp al,3
	jne here0

    

	mov byte[gs:((80*15+70)*2)],'-'

    
	here0:
	inc byte[cnt]
	cmp byte[cnt],4
	jne here5
	mov byte[cnt],0
	here5:
	mov byte[count],2		; 重置计数变量=初值delay
    ;sti
    
_end:
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A


	pop es
	pop bp
	pop dx
	pop cx

	pop bx
	pop ax




	iret			; 从中断返回
_data:
	delay equ 4		; 计时器延迟计数
	count db delay		; 计时器计数变量，初值=delay
	cnt db 8
times 510-($-$$) db 0
dw 0xaa55	