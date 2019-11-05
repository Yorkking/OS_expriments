
extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm

public _printChar
public _getChar
public _Load
public _clear
public _read
public _readInit
public _Load_Timer

extern _FLAG_TO_JUMP:near
extern _Message:near
extern _row:near
extern _col:near
extern _GetM:near
extern _sector:near
extern _Flag:near
extern _des:near
extern _Initdes:near
extern _Timer_sector

extern _cmain:near   ;声明一个c程序函数upper
OffSetOfUserPrg1 equ 5000h
OffSetOfUserPrg2 equ 3000h
OffSetOfUserPrg3 equ 2000h
OffSetOfUserPrg4 equ 0A100h
Time_OffSet equ 1000h
INT_OffSet equ 9000h

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT
org OffSetOfUserPrg1
start:
	;cmp byte ptr _FLAG_TO_JUMP,'a'
	;je here5
	;jmp hehere5:re4
	
	mov  ax,  cs
	mov  ds,  ax           ; DS = CS
	mov  es,  ax           ; ES = CS
	mov  ss,  ax           ; SS = cs
	mov  sp, 0FFF0h   
	;mov byte[_disp_pos],0

	xor ax,ax
	mov es,ax
	cli
		mov word ptr es:[33*4],offset NewINT33
		mov word ptr es:[33*4+2],cs
	sti

	mov ax,cs
	mov es,ax

	;int 33
	call near ptr _cmain
	
	jmp $

_printChar proc
	push ds
	push es
		mov   dh, byte ptr _row	; 行号=10
		cmp dh,25
		jl here3

		mov ah,6
		mov al,1
		mov bx,007h
		mov ch,24
		mov cl,0
		mov dh,24
		mov dl,80

		int 10h

		mov dh,24
		mov byte ptr _row,dh
		
		here3:
		mov bp, offset _Message ; BP=当前串的偏移地址
		mov ax, ds		;BP = 串地址
		mov es, ax		;置ES=DS 
		mov cx, 1        	; CX = 串长（=10）
		mov  ax, 1301h	;  AH = 13h（功能号） AL = 01h（光标置于串尾）
		mov bx, 0007h	; 页号为0(BH = 0) 黑底白字(BL = 07h)	
		mov   dh, byte ptr _row	; 行号=10
		mov   dl, byte ptr _col		; 列号=10
		int 10h		; BIOS的10h功能：显示一行字符
	pop es
	pop ds
	ret
_printChar endp
	
_getChar proc
	push ds
	push es
		mov ah,0
		int 16h
		cmp ah,1ch
		jne here
		mov al,10
		here:	
		cmp ah,0eh
		jne here1
		mov byte ptr _Flag,1
		jmp here2

		here1:
		mov byte ptr _GetM,al
	here2:	
	pop es
	pop ds
	ret
_getChar endp


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


_Load_Timer proc
	push ds
	push es
		mov ax,cs                ;段地址 ; 存放数据的内存基地址
		mov es,ax                ;设置段地址（不能直接mov es,段地址）
		mov bx, Time_OffSet  ;偏移地址; 存放数据的内存偏移地址
		mov ah,2                 ; 功能号
		mov al,1                 ;扇区数
		mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,0                 ;磁头号 ; 起始编号为0
		mov ch,0                 ;柱面号 ; 起始编号为0
		mov cl, byte ptr _Timer_sector               ;起始扇区号 ; 起始编号为1
		int 13H ;                调用读磁盘BIOS的13h功能
		; 用户程序a.com已加载到指定内存区域中
		mov bx, Time_OffSet
		call bx

	pop es
	pop ds
	ret
_Load_Timer endp



_clear proc
	push ds
	push es
		mov ah,00h
		mov al,03h 
		int 10h

	pop es
	pop ds
	ret
_clear endp

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
		 mov  word ptr _des,bx
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
    ;mov es,St


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

	ret
NewINT9 endp 


NewINT33 proc
		push ad
		push ds
		push es
		push fs
			push ax

			cmp ax,3
			ja sret
			mov bx,ax
			call word ptr TABLE[bx]
			sret:
			pop ax

		pop fs
		pop es
		pop ds
		pop ad
	iret
	ret
NewINT33 endp


NewINT34 proc
	push ds
	push es
	mov byte ptr cs:[Sectors],5
	call LOAD_for_INT

	pop es
	pop ds
	iret
	ret
NewINT34 endp


NewINT35 proc
	push ds
	push es

	mov byte ptr cs:[Sectors],6
	call LOAD_for_INT

	pop es
	pop ds
	iret
	ret
NewINT35 endp


NewINT36 proc
	push ds
	push es
	mov byte ptr cs:[Sectors],7
	call LOAD_for_INT

	pop es
	pop ds
	iret
	ret
NewINT36 endp







_datas:
		stack1 dw 0,0
		TABLE dw sub1,sub2,sub3,sub4

		Stt: db 'OUCH!OUCH!'
		Smm: db '          '
		Sectors db 16


_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
		
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start
