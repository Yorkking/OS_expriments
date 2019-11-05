
extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm

public _printChar
public _getChar
public _Load
public _clear
public _read
public _readInit

extern _Message:near
extern _row:near
extern _col:near
extern _GetM:near
extern _sector:near
extern _Flag:near
extern _des:near
extern _Initdes:near

extern _cmain:near   ;声明一个c程序函数upper
OffSetOfUserPrg1 equ 5000h
OffSetOfUserPrg2 equ 3000h
OffSetOfUserPrg3 equ 2000h
OffSetOfUserPrg4 equ 0A100h

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT
org OffSetOfUserPrg1
start:
	mov  ax,  cs
	mov  ds,  ax           ; DS = CS
	mov  es,  ax           ; ES = CS
	mov  ss,  ax           ; SS = cs
	mov  sp, 100h   
	;mov byte[_disp_pos],0
	
	



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
		;mov ah,07h
	
		
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
		;mov bh,0
		;mov dh,byte ptr _row
		;mov dl,byte ptr _col
		;dec dl
		;int 10h
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
		mov es,ax                ;设置段地址（不能直接mov es,段地址）
		mov bx, OffSetOfUserPrg4  ;偏移地址; 存放数据的内存偏移地址
		mov ah,2                 ; 功能号
		mov al,1                 ;扇区数
		mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,0                 ;磁头号 ; 起始编号为0
		mov ch,0                 ;柱面号 ; 起始编号为0
		mov  cl, byte ptr _sector               ;起始扇区号 ; 起始编号为1
		int 13H ;                调用读磁盘BIOS的13h功能
		; 用户程序a.com已加载到指定内存区域中
		mov bx, OffSetOfUserPrg4
		call bx
	pop es
	pop ds
	ret
_load endp


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


_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
 ;dd _disp_pos 0 

_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start
