extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm

public _printChar
public _getChar
public _clear
public _Set_Cursor

extern _FLAG_TO_JUMP:near
extern __MESSEAGE:near
extern __ROW:near
extern __COL:near
extern __GETM:near
extern _sector:near
extern __FLAG:near
extern _des:near
extern _Initdes:near



OffSetOfUserPrg2 equ 3000h
OffSetOfUserPrg3 equ 2000h
OffSetOfUserPrg4 equ 0A100h
Kl_OffSet equ 0D100h
Time_OffSet equ 1000h
INT_OffSet equ 9000h


_printChar proc
	push ds
	push es
		cli
		mov dh, byte ptr __ROW	; 行号=10
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
		mov byte ptr __ROW,dh
		
		here3:
		mov bp, offset  __MESSEAGE ; BP=当前串的偏移地址
		mov ax, ds		;BP = 串地址
		mov es, ax		;置ES=DS 
		mov cx, 1        	; CX = 串长（=10）
		mov  ax, 1301h	;  AH = 13h（功能号） AL = 01h（光标置于串尾）
		mov bx, 0007h	; 页号为0(BH = 0) 黑底白字(BL = 07h)	
		mov   dh, byte ptr __ROW	; 行号=10
		mov   dl, byte ptr __COL		; 列号=10
		sti
		int 10h		; BIOS的10h功能：显示一行字符
	pop es
	pop ds
	ret
_printChar endp
	
_getChar proc
	push ds
	push es
		cli
		mov ah,0
		sti
		int 16h

		cli
		cmp ah,1ch
		jne here
		mov al,10
		here:	
		cmp ah,0eh
		jne here1
		mov byte ptr __FLAG,1
		jmp here2

		here1:
		mov byte ptr __GETM,al
		
	here2:	
		sti
	pop es
	pop ds
	ret
_getChar endp


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


_Set_Cursor proc
	push ds
	push es
		mov bh,0

		mov dh,byte ptr __ROW

		mov dl,byte ptr __COL
		mov ah,2
		int 10h
	pop es
	pop ds
	ret
_Set_Cursor endp


