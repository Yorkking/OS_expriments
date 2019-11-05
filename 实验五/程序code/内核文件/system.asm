
public _Load
public _read
public _readInit
public _Load_Timer
public _s_Load


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

OffSetOfUserPrg1 equ 5000h
OffSetOfUserPrg2 equ 3000h
OffSetOfUserPrg3 equ 2000h
OffSetOfUserPrg4 equ 0A100h
Time_OffSet equ 1000h
INT_OffSet equ 9000h


_s_Load proc
    push ds
		push es
    
        ;mov ax,word ptr _Seg_addr
				mov ax,cs
        mov es,ax
        mov bx,word ptr _To_des_addr
        mov ah,2
        mov al,byte ptr _Num_sector
        mov dl,0
        mov dh,0
        mov ch,0
        mov cl,byte ptr _s_sector
        int 13H

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
	


LOAD_for_INT proc
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
		mov cl,byte ptr es:[Sectors]             ;起始扇区号 ; 起始编号为1
		int 13H ;                调用读磁盘BIOS的13h功能
		; 用户程序a.com已加载到指定内存区域中
		mov bx, OffSetOfUserPrg4
		call bx
	pop es
	pop ds

	ret
LOAD_for_INT endp



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


NewINT33 proc
	push ds
	push es
		push bx
		push cx
		push bp
		push es

			cmp ax,5
			ja sret
      
      mov bp,ax
			mov ax,[TABLE1+bp]
			call ax
			sret:

		pop es
		pop bp
		pop cx
		pop bx
	pop es
	pop ds
	iret
	ret
NewINT33 endp




sub1 proc
	push ds
	push es

      mov byte ptr cs:[Sectors],4
	    call LOAD_for_INT

	pop es
	pop ds
	iret
	ret
sub1 endp


sub2 proc
	push ds
	push es
        mov byte ptr cs:[Sectors],5
	    call LOAD_for_INT


	pop es
	pop ds
	iret
	ret
sub2 endp


sub3 proc
	push ds
	push es
        mov byte ptr cs:[Sectors],6
	    call LOAD_for_INT
	pop es
	pop ds
	iret
sub3 endp


sub4 proc
	push ds
	push es
        mov byte ptr cs:[Sectors],7
	    call LOAD_for_INT

	pop es
	pop ds
	iret
sub4 endp

sub5 proc
	push ds
	push es
	push ax
			mov ax,cs
			mov ds,ax
			mov es,ax
			call _Delete_p
	pop ax
	pop es
	pop ds
sub5 endp









_Load_Timer proc
	push ds
	push es
	push ax

		call SetTimer

		xor ax,ax
		mov es,ax

		cli
			mov word [es:20h],Timer1	; 设置时钟中断向量的偏移地址
			mov word [es:22h],cs
		sti
	pop ax
	pop es
	pop ds
	ret
_Load_Timer endp

extern _Total_p:near
Timer1:
		cmp word ptr _Total_p,0
		je donothing
		cmp word ptr _Total_p,1
		je Restarts
Saves:
;;;保护进程目前情况进PCB
		push ax
		push cx
		push dx
		push bx
		push sp
		push bp
		push si
		push di
		push ds
		push es
		.386
		push fs
		push gs
		.8086
		push ss

		;;;切换数据段
		mov ax,cs
		mov ds,es
		mov es,ax

		call near ptr _Save_Process
		call _Scheduler

;;;切换堆栈为内核
		mov ax,cs
		mov ss,cs

		


;;;设置新的寄存器值，并且利用iret指令来直接切换进程；

	;;得到下一个进程的PCB的一个偏移地址；
Restarts:
	call _Get_addr
	mov bp,ax
	mov ss,[bp+0]
	mov sp,[bp+16]
	

	;;;所有寄存器的值赋值一遍
	push [bp+30]
	push [bp+28]
	push [bp+26]

	;push [bp]
	push [bp+2]
	push [bp+4]
	push [bp+6]
	push [bp+8]
	push [bp+10]
	;push [bp+12]
	push [bp+16]
	push [bp+18]
	push [bp+20]
	push [bp+24]


	pop ax
	pop cx
	pop dx
	pop bx
	;pop sp
	pop bp
	pop si
	pop di
	pop ds
	pop es
.386
	pop fs
	pop gs
.8086
	;pop ss
	;;;
donothing:
	push al
	mov al,2000h
	out 20h,al
	out 0A0h,al
	pop al
	iret

SetTimer:
	mov al,34h			; 设控制字值
	out 43h,al				; 写控制字到控制字寄存器
	mov ax,1193182/20	; 每秒20次中断（50ms一次）
	out 40h,al				; 写计数器0的低字节
	mov al,ah				; AL=AH
	out 40h,al				; 写计数器0的高字节
	ret

_datas:
		stack1 dw 0,0
		TABLE1 dw sub1,sub2,sub3,sub4,sub5
		Stt: db 'OUCH!OUCH!'
		Smm: db '          '
		Sectors db 16


