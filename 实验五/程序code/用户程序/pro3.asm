org 0A100h

	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,Str
	mov bp,ax
	mov ah,0x13
	mov al,1
	mov bl,00000010b
	mov bh,0
	mov cx,21
	mov dh,4
	mov dl,45
	int 10h

    mov ax,Str1
	mov bp,ax
    mov ah,0x13
    mov al,1
	mov bl,00000011b
	mov bh,0
    mov cx,13
	mov dh,8
	mov dl,49
	int 10h

    mov ax,Str2
	mov bp,ax
    mov ah,0x13
    mov al,1
	mov bl,00000001b
	mov bh,0
    
    mov cx,21
	mov dh,12
	mov dl,45
	int 10h
    
    mov dh,4
    mov dl,55

    mov cx,8
    loops:
        push cx
		mov cx,1
        mov ah,0x13
        mov al,1
        mov bl,00000110b
        mov bh,0
        inc dh
        int 10h

        pop cx
        loop loops

	ret

Str: db "WangYongkang,17341155"
Length equ ($-Str)
Str1: db "RRRRRRRRRRRRRRRR"
Length1 equ ($-Str1)
Str2: db "WWWWWWWWWWWWWWWWWWWWW"
Length2 equ ($-Str2)


times 510-($-$$) db 0
dw 0xaa55