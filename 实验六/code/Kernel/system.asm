
public _Load
public _read
public _readInit
public _Load_Timer
public _s_Load
public _LOAD_for_INT

extern _FLAG_TO_JUMP:near
extern _Message:near
extern _sector:near
extern __Des:near
extern _Initdes:near

extern _s_sector:near
extern _Num_sector:near
extern _To_des_addr:near
extern _Seg_addr:near
extern _Timer_sector:near


extern _Save_Process:near
extern _Scheduler:near
extern _Get_addr:near
extern _Delete_p:near


OffSetOfUserPrg2 equ 3000h
OffSetOfUserPrg3 equ 2000h
OffSetOfUserPrg4 equ 0A100h
Time_OffSet equ 1000h
INT_OffSet equ 9000h


;;加载函数是对的
_s_Load proc
    push ds
		push es
		push bx
    push ax
		push dx
		push cx
        mov ax,word ptr _Seg_addr
				;mov ax,cs
        mov es,ax
        mov bx,word ptr _To_des_addr
        mov ah,2
        mov al,byte ptr _Num_sector
        mov dl,0
        mov dh,0
        mov ch,0
        mov cl,byte ptr _s_sector
        int 13H
				;mov ax,cs
				;mov ds,ax
				;mov ds:[0],bx
				;mov ds:[2],es
				;call dword ptr ds:[0]
		pop cx
		pop dx
		pop ax
		pop bx
    pop es
		pop ds
	ret
_s_Load endp

_Load proc
	push ds
	push es
		mov ax,cs                ;段地址 ; 存放数据的内存基地址
		mov es,ax
		mov bx, OffSetOfUserPrg4  ;偏移地址; 存放数据的内存偏移地址
		cmp byte ptr _sector,9
		jne heee
		mov bx,INT_OffSet
		heee:              ;设置段地址（不能直接mov es,段地址）
		
		mov ah,2                 ; 功能号
		mov al,1                 ;扇区数
		mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,0                 ;磁头号 ; 起始编号为0
		mov ch,0                 ;柱面号 ; 起始编号为0
		mov  cl, byte ptr _sector               ;起始扇区号 ; 起始编号为1
		int 13H ;                调用读磁盘BIOS的13h功能
		; 用户程序a.com已加载到指定内存区域中
		;mov bx, OffSetOfUserPrg4
		cmp byte ptr _sector,9
		je here6

		xor ax,ax
		mov es,ax
		mov ax,es:[24h]
		mov word ptr cs:[stack1],ax
		mov ax, es:[26h]
		mov word ptr cs:[stack1+2],ax


		cli
		mov word ptr es:[24h],offset NewINT9
		mov ax,cs
		mov word ptr es:[26h],ax
		sti
		
		mov ax,cs
		mov ds,ax
		mov es,ax

		here6:
		call bx

		cmp byte ptr _sector,9
		je here4

		xor ax,ax
		mov es,ax

		cli
		mov ax,cs:[stack1]
		mov word ptr es:[24h],ax

		mov ax, cs:[stack1+2]
		mov word ptr es:[26h],ax
		sti

	mov ax,cs
	mov es,ax
	mov ds,ax

    here4:
	pop es
	pop ds
	ret
_load endp





;void read(int off,char s)
_read proc
	push ds
	push es
		 mov ax,cs                ;段地址 ; 存放数据的内存基地址
      	 mov es,ax                               ;设置段地址（不能直接mov es,段地址）
		 mov bx, OffSetOfUserPrg2  ;偏移地址; 存放数据的内存偏移地址
      	 mov ah,2                 ; 功能号
     	 mov al,1                 ;扇区数
      	 mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      	 mov dh,0                 ;磁头号 ; 起始编号为0
         mov ch,0                 ;柱面号 ; 起始编号为0
         mov cl,2               ;起始扇区号 ; 起始编号为1
         int 13H;  
		 mov  word ptr __Des,bx
	pop es
	pop ds
	ret
_read endp


_readInit proc

push ds
	push es
		 mov ax,cs                ;段地址 ; 存放数据的内存基地址
      	 mov es,ax                               ;设置段地址（不能直接mov es,段地址）
		 mov bx, OffSetOfUserPrg3  ;偏移地址; 存放数据的内存偏移地址
      	 mov ah,2                 ; 功能号
     	 mov al,1                 ;扇区数
      	 mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      	 mov dh,0                 ;磁头号 ; 起始编号为0
         mov ch,0                 ;柱面号 ; 起始编号为0
         mov cl,11              ;起始扇区号 ; 起始编号为1
         int 13H;  
		 mov  word ptr _Initdes,bx
	pop es
	pop ds
	ret
_readInit endp
	


_LOAD_for_INT proc
	push ds
	push es
		mov ax,cs                ;段地址 ; 存放数据的内存基地址
		mov es,ax                ;设置段地址（不能直接mov es,段地址）
		mov bx, OffSetOfUserPrg4  ;偏移地址; 存放数据的内存偏移地址
		mov ah,2                 ; 功能号
		mov al,1                 ;扇区数
		mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,0                 ;磁头号 ; 起始编号为0
		mov ch,0                 ;柱面号 ; 起始编号为0
		mov cl,3            ;起始扇区号 ; 起始编号为1
		int 13H ;                调用读磁盘BIOS的13h功能
		; 用户程序a.com已加载到指定内存区域中
		mov bx, OffSetOfUserPrg4
		call bx
	pop es
	pop ds

	ret
_LOAD_for_INT endp



LOOPSs proc
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

LOOPSs endp

NewINT9 proc
		;保护寄存器
	  push ax
		push bx
		push cx
		push bp
		push es

    in al,60h
    mov ax,cs
    mov ds,ax
    
		;;;;;;;;;;;以下是显示OUCH
    


		mov  si, offset Stt
    mov ax,0B800h
		mov es,ax


    mov es,ax
    mov di,(12*80 + 5)*2

    mov cx,10
    
		s:mov al,[si]
    mov es:[di],al
    inc si
    add di,2
    loop s
    ;;;;;;;;;;

		;;;延迟一段时间
		call LOOPSs



		;;;;;清除OUCH
		mov si,offset Smm
    mov ax,0B800h
    mov es,ax
    mov di,(12*80 + 5)*2
	  mov cx,10
  s3:mov al,[si]
    mov es:[di],al
    inc si
    add di,2
    loop s3
    
		;;;;;;清除结束


		;;;;貌似下面是说发生到芯片端口，告诉中断结束？？？

   mov al,20h			; AL = EOI
	 out 20h,al			; 发送EOI到主8529A
   out 0A0h,al			; 发送EOI到从8529A		
	

		pop es
		pop bp
		pop cx
		pop bx
		pop ax
	iret	


NewINT9 endp 


TABLE1 dw sub0,sub1,sub2,sub3,sub4
NewINT33 proc
	push ds
	push es
		push bx
		push cx
		push bp
		push es

			cmp ah,4
			ja sret
			mov bl,ah
			mov bh,0
			add bx,bx
			jmp word ptr TABLE1[bx]


      sret:

		pop es
		pop bp
		pop cx
		pop bx
	pop es
	pop ds
	iret
NewINT33 endp


mess: db "SYSU OS! Welcome!!!!"
sub0 proc

	push ax
	push bx
		mov ax,cs
		mov ds,ax
		mov es,ax

		mov bp,offset mess
    mov ah,13h
		mov al,1
		mov bl,00000101b
		mov bh,0

		mov cx,19
		mov dh,20
		mov dl,5

		int 10h

		
	pop bx
	pop ax
	pop es
	pop bp
	pop cx
	pop bx
	pop es
	pop ds
	iret
sub0 endp

mess1: db '________OS______________'
sub1 proc
	push ax
	push bx
		mov ax,cs
		mov ds,ax
		mov es,ax

		mov bp,offset mess1
    mov ah,13h
		mov al,1
		mov bl,00000101b
		mov bh,0

		mov cx,18
		mov dh,5
		mov dl,5

		int 10h

	pop bx
	pop ax  
	pop es
	pop bp
	pop cx
	pop bx
	pop es
	pop ds
	iret
sub1 endp

mess2: db 'int 33 for work!!!'
sub2 proc
	push ax
	push bx
		mov ax,cs
		mov ds,ax
		mov es,ax

		mov bp,offset mess2
    mov ah,13h
		mov al,1
		mov bl,00000101b
		mov bh,0

		mov cx,18
		mov dh,20
		mov dl,45

		int 10h
	pop bx
	pop ax 
	pop es
	pop bp
	pop cx
	pop bx
	pop es
	pop ds
	iret
sub2 endp

mess3: db 'wyk 17341155 os is fun!!!'
sub3 proc
	push ax
	push bx
		mov ax,cs
		mov ds,ax
		mov es,ax

		mov bp,offset mess3
    mov ah,13h
		mov al,1
		mov bl,00000101b
		mov bh,0

		mov cx,25
		mov dh,8
		mov dl,45

		int 10h

	pop bx
	pop ax
	pop es
	pop bp
	pop cx
	pop bx
	pop es
	pop ds
	iret
sub3 endp

sub4 proc





	pop es
	pop bp
	pop cx
	pop bx
	pop es
	pop ds
	iret
sub4 endp








test_data: db 'ti'
_Load_Timer proc
	push ds
	push es
	push ax
	push dx
		call SetTimer

		xor ax,ax
		mov es,ax

		cli
			mov word ptr es:[20h],offset Timer1	; 设置时钟中断向量的偏移地址
			mov word ptr es:[22h],cs
		sti
		

	pop dx
	pop ax
	pop es
	pop ds
	ret
_Load_Timer endp

extern _Total_p:near
extern _P_begin:near

;extern _save_GS:near
;extern _save_FS:near
extern _save_ES:near
extern _save_DS:near
extern _save_DI:near
extern _save_SI:near
extern _save_BP:near
extern _save_SP:near
extern _save_BX:near
extern _save_DX:near
extern _save_DX:near
extern _save_CX:near
extern _save_AX:near
extern _save_SS:near
extern _save_IP:near
extern _save_CS:near
extern _save_Flags:near

Timer1:
	cli
Saves:
;;;保护进程目前情况进PCB
		
    push ds
    push cs
    pop ds
    pop word ptr _save_DS

    pop word ptr _save_IP
    pop word ptr _save_CS
    pop word ptr _save_Flags
    ;;;切换数据段
    mov word ptr _save_BX,bx
    mov word ptr _save_AX,ax
    mov word ptr _save_DI,di
    mov word ptr _save_SI,si

    mov word ptr _save_BP,bp
    mov word ptr _save_DX,dx
    mov word ptr _save_CX,cx
    mov word ptr _save_SS,ss

    mov word ptr _save_SP,sp
    mov word ptr _save_ES,es
    
    call near ptr _Save_Process
Restarts:
	
    
	call _Scheduler

    mov ss,word ptr _save_SS
    mov sp,word ptr _save_SP

    
    mov di,word ptr _save_DI
    mov si,word ptr _save_SI
    mov bp,word ptr _save_BP
    mov bx,word ptr _save_BX

    mov dx,word ptr _save_DX
    mov cx,word ptr _save_CX
    mov ax,word ptr _save_AX
    mov es,word ptr _save_ES

    push word ptr _save_Flags
    push word ptr _save_CS
    push word ptr _save_IP

    push word ptr _save_DS
    pop ds
	
	

donothing:

	push ax

	mov al,20h
	out 20h,al
	out 0A0h,al

	;call test_print

	pop ax
	sti
	iret

dosomething:

	jmp donothing


SetTimer:
	push ax
	mov al,34h			; 设控制字值
	out 43h,al				; 写控制字到控制字寄存器
	mov ax,23332	; 每秒20次中断（50ms一次）
	out 40h,al				; 写计数器0的低字节
	mov al,ah				; AL=AH
	out 40h,al				; 写计数器0的高字节
	pop ax
	ret

test_print:
	push ds
	push es
	push bp
	push bx
	push cx
	push ax

		mov ax,0B800h
		mov es,ax
		mov byte ptr es:[(80*15+70)*2],'T'

	pop ax
	pop cx
	pop bx
	pop bp
	pop es
	pop ds



	ret


_datas:
		stack1 dw 0,0
		Stt: db 'OUCH!OUCH!'
		Smm: db '          '
		Sectors db 16


