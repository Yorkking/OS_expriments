extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm

extern _main:near

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT,_DATA,_BSS
       assume cs:_TEXT
   org 0C100h
start:
    mov  ax,  cs
	mov  ds,  ax           	; DS = CS
	mov  es,  ax          	; ES = CS
	mov  ss,  ax         
    mov  ah,1
    int 21h


    mov ah,2
    int 21h

    mov ah,3
    int 21h

    mov ah,4
    int 21h


    call near ptr _main

    ret

    include klib.asm

_TEXT ends
;************DATA segment*************
_DATA segment word public 'DATA'
		
_DATA ends
;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********
end start