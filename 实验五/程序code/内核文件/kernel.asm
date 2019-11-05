
extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm


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
	
	mov  ax,  cs
	mov  ds,  ax           ; DS = CS
	mov  es,  ax           ; ES = CS
	mov  ss,  ax           ; SS = cs
	mov  sp, 0FFF0h   

	xor ax,ax
	mov es,ax
	cli
		mov word ptr es:[33*4],offset NewINT33
		mov word ptr es:[33*4+2],cs
	sti

	mov ax,cs
	mov es,ax

	call near ptr _cmain
	
	jmp $

	include klib.asm
	include system.asm



_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
		
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start
